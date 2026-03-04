#!/system/bin/sh
MODDIR=${0%/*}
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
    if [ "$(getprop "$prop")" = "$target" ]; then
      return 0
    fi
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
    if [ -e "$node" ]; then
      return 0
    fi
    i=$((i + 1))
    sleep 1
  done

  return 1
}

# Let Android settle, then wait for secure world + fp device exposure.
sleep 15

wait_for_prop init.svc.teei_daemon running 90
TEE_STATUS=$?
wait_for_node /dev/teei_fp 90
TEE_NODE_STATUS=$?

if [ -e /dev/focaltech_fp ]; then
  FP_NODE=/dev/focaltech_fp
else
  FP_NODE=/dev/goodix_fp
fi

wait_for_node "$FP_NODE" 90
FP_NODE_STATUS=$?

if [ "$TEE_STATUS" -ne 0 ] || [ "$TEE_NODE_STATUS" -ne 0 ] || [ "$FP_NODE_STATUS" -ne 0 ]; then
  log_print "TEE/SPI readiness timeout (tee=$TEE_STATUS teei_fp=$TEE_NODE_STATUS fp_node=$FP_NODE_STATUS)."
else
  log_print "TEE and fingerprint nodes are ready; restarting vendor.fps_hal."
fi

# Restart HAL anyway (covers 'Spi\'s loading is not finished' race on first boot).
setprop ctl.stop vendor.fps_hal
sleep 2
setprop ctl.start vendor.fps_hal

# Some GSIs only expose UI toggles once this property is present.
setprop persist.sys.phh.fingerprint.nocleanup 1
log_print "Fingerprint HAL restart sequence complete."
