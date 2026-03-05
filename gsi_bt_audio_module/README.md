# VGO NOTE_23 Bluetooth Audio Port for GSI

This Magisk/KernelSU module ports the stock NOTE_23 vendor Bluetooth audio policy files for Google GSI ROMs.

## Why this revision
On GSI, **vendor stays the same** (same MTK blobs / HAL). Routing failures usually come from policy mismatch between GSI framework configs and vendor audio stack.

So this module now overlays policy in **both** locations:
- `vendor/etc` (primary target for vendor audio HAL policy loading)
- `system_ext/etc` (framework-side policy include compatibility)

## What it changes
- Overlays these policy XMLs to both `vendor/etc` and `system_ext/etc`:
  - `audio_policy_configuration.xml`
  - `audio_policy_configuration_bluetooth_legacy_hal.xml`
  - `a2dp_audio_policy_configuration.xml`
  - `a2dp_in_audio_policy_configuration.xml`
  - `bluetooth_audio_policy_configuration.xml`
  - `bluetooth_offload_audio_policy_configuration.xml`
  - `r_submix_audio_policy_configuration.xml`
  - `usb_audio_policy_configuration.xml`
- Forces legacy Bluetooth audio HAL path via persist properties.
- Keeps A2DP offload props aligned with stock dump defaults.

## Install
1. Zip the content of `gsi_bt_audio_module` (not the parent folder).
2. Flash in Magisk or KernelSU.
3. Reboot.
4. Forget/re-pair the Bluetooth headset.

## Verify after boot
- `getprop persist.bluetooth.bluetooth_audio_hal.disabled` should be `true`
- `getprop persist.vendor.bluetooth.bluetooth_audio_hal.disabled` should be `true`
- BT media route should switch to the headset (not phone speaker)
