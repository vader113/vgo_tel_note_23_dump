#!/system/bin/sh
sleep 15

# Restart audio/bluetooth userspace after properties are forced.
# This helps apply policy changes after dirty flash / first boot.
killall audioserver 2>/dev/null
killall vendor.audio-hal 2>/dev/null
killall com.android.bluetooth 2>/dev/null
