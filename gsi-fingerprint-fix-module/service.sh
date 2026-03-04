#!/system/bin/sh
LOG_TAG="GSI-FP-FIX"

log_print() {
  log -t "$LOG_TAG" "$1"
}

wait_for_prop() {
  local prop="$1"
  local target="$2"
  local timeout="$3"
  local i=0
  while [ "$i" -lt "$timeout" ]; do
    [ "$(getprop "$prop")" = "$target" ] && return 0
    i=$((i + 1))
    sleep 1
  done
  return 1
}

wait_for_node() {
  local node="$1"
  local timeout="$2"
  local i=0
  while [ "$i" -lt "$timeout" ]; do
    [ -e "$node" ] && return 0
    i=$((i + 1))
    sleep 1
  done
  return 1
}

is_hal_registered() {
  if command -v lshal >/dev/null 2>&1; then
    lshal 2>/dev/null | grep -q "android.hardware.biometrics.fingerprint@2.1::IBiometricsFingerprint/default"
    return $?
  fi

  # If lshal is missing, fallback to service state only.
  [ "$(getprop init.svc.vendor.fps_hal)" = "running" ]
  return $?
}

restart_fp_hal() {
  setprop ctl.stop vendor.fps_hal
  sleep 1
  setprop ctl.start vendor.fps_hal
}

# Keep runtime properties aligned in case GSI resets them after boot.
setprop vendor.fingerprint ft9362_tee
setprop persist.vendor.fingerprint ft9362_tee
setprop persist.sys.phh.fingerprint.nocleanup 1

# Wait until Android framework is mostly up, then wait for TEE/fp nodes.
wait_for_prop sys.boot_completed 1 180 || log_print "boot_completed timeout"
wait_for_prop init.svc.teei_daemon running 120 || log_print "teei_daemon not running in time"
wait_for_node /dev/teei_fp 120 || log_print "/dev/teei_fp not found in time"

if [ -e /dev/focaltech_fp ]; then
  FP_NODE=/dev/focaltech_fp
else
  FP_NODE=/dev/goodix_fp
fi
wait_for_node "$FP_NODE" 120 || log_print "$FP_NODE not found in time"

log_print "Bring-up start: fp_node=$FP_NODE svc=$(getprop init.svc.vendor.fps_hal)"

# Deterministic finite retries, then exit.
i=0
while [ "$i" -lt 20 ]; do
  if is_hal_registered; then
    log_print "HAL registered on attempt $((i + 1)) (svc=$(getprop init.svc.vendor.fps_hal))."
    exit 0
  fi

  restart_fp_hal
  sleep 3
  log_print "Retry $((i + 1))/20 (svc=$(getprop init.svc.vendor.fps_hal))."
  i=$((i + 1))
done

log_print "HAL still not registered after 20 retries; giving up for this boot."
exit 1
