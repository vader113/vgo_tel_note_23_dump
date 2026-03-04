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

  # Fallback when lshal is not available.
  service list 2>/dev/null | grep -qi fingerprint
  return $?
}

restart_fp_hal() {
  setprop ctl.stop vendor.fps_hal
  sleep 1
  setprop ctl.start vendor.fps_hal
}

# Let Android boot enough that framework-side fingerprint service is alive.
wait_for_prop sys.boot_completed 1 180 || log_print "boot_completed timeout, continuing"

# Wait for secure world + fp node before touching HAL.
wait_for_prop init.svc.teei_daemon running 120 || true
wait_for_node /dev/teei_fp 120 || true

if [ -e /dev/focaltech_fp ]; then
  FP_NODE=/dev/focaltech_fp
else
  FP_NODE=/dev/goodix_fp
fi
wait_for_node "$FP_NODE" 120 || true

log_print "Starting stabilization loop (fp_node=$FP_NODE state=$(getprop init.svc.vendor.fps_hal))."

# Aggressive first bring-up window.
i=0
while [ "$i" -lt 12 ]; do
  STATE="$(getprop init.svc.vendor.fps_hal)"

  if [ "$STATE" != "running" ]; then
    restart_fp_hal
    sleep 2
    STATE="$(getprop init.svc.vendor.fps_hal)"
  fi

  if is_hal_registered; then
    log_print "HAL registered and service state=$STATE on attempt $((i + 1))."
    break
  fi

  log_print "HAL not registered yet (state=$STATE), retry $((i + 1))/12."
  restart_fp_hal
  sleep 4
  i=$((i + 1))
done

# Keepalive watchdog (some GSIs kill/restart vendor HAL).
while true; do
  STATE="$(getprop init.svc.vendor.fps_hal)"
  if [ "$STATE" != "running" ] || ! is_hal_registered; then
    log_print "Watchdog restart (state=$STATE)."
    restart_fp_hal
  fi
  setprop persist.sys.phh.fingerprint.nocleanup 1
  sleep 30
done
