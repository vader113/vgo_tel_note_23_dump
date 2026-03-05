#!/system/bin/sh

# Force NOTE_23-compatible Bluetooth audio properties early at boot.
resetprop -n persist.bluetooth.a2dp_offload.cap sbc-aac
resetprop -n persist.bluetooth.a2dp_offload.disabled true
resetprop -n persist.bluetooth.bluetooth_audio_hal.disabled true
resetprop -n persist.vendor.bluetooth.bluetooth_audio_hal.disabled true
resetprop -n persist.bluetooth.leaudio_offload.disabled true
