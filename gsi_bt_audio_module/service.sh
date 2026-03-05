#!/system/bin/sh
sleep 20

# Restart key services once so updated policy overlays/properties are picked up.
setprop ctl.restart audioserver
setprop ctl.restart bluetooth_manager
