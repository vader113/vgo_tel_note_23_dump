#!/system/bin/sh
sleep 20

# Restart only Bluetooth stack once so new persist props are honored.
setprop ctl.restart bluetooth_manager
