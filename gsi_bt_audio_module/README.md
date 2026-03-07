# VGO NOTE_23 Bluetooth Audio Port for GSI

This Magisk/KernelSU module ports stock NOTE_23 audio policy XML files for Google GSI ROMs.

## Why this revision (v1.2)
Your logs showed:
- `BluetoothAudio HAL is disabled`
- repeated A2DP start/stop, then route drops back to speaker.

So this revision **keeps BluetoothAudio HAL enabled** and only applies safe compatibility properties.

## What it changes
- Overlays NOTE_23 policy XMLs into both:
  - `vendor/etc`
  - `system_ext/etc`
- Sets:
  - `persist.bluetooth.a2dp_offload.cap=sbc-aac`
  - `persist.bluetooth.bluetooth_audio_hal.disabled=false`
  - `persist.vendor.bluetooth.bluetooth_audio_hal.disabled=false`
  - `persist.bluetooth.leaudio_offload.disabled=true`
- Restarts `bluetooth_manager` once after boot to apply properties cleanly.

## Install
1. Zip contents of `gsi_bt_audio_module` (not parent folder).
2. Flash in Magisk/KernelSU.
3. Reboot.
4. Forget and re-pair the BT headset.

## Verify
```sh
getprop persist.bluetooth.bluetooth_audio_hal.disabled
getprop persist.vendor.bluetooth.bluetooth_audio_hal.disabled
logcat | grep -i "BluetoothAudio HAL"
```
Expected: HAL should **not** be disabled, and A2DP should stay connected without speaker fallback.
