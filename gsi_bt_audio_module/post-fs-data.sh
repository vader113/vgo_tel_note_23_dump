#!/system/bin/sh

# Apply NOTE_23-compatible Bluetooth properties at boot without disabling bt-audio HAL.
resetprop -n persist.bluetooth.a2dp_offload.cap sbc-aac
resetprop -n persist.bluetooth.bluetooth_audio_hal.disabled false
resetprop -n persist.vendor.bluetooth.bluetooth_audio_hal.disabled false
resetprop -n persist.bluetooth.leaudio_offload.disabled true
