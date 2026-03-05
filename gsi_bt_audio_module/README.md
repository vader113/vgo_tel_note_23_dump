# VGO NOTE_23 Bluetooth Audio Port for GSI

This Magisk/KernelSU module ports the stock NOTE_23 vendor Bluetooth audio policy files to `system_ext/etc` on GSI ROMs.

## What it changes
- Overlays GSI `system_ext/etc` audio policy XMLs with NOTE_23 vendor versions:
  - `audio_policy_configuration.xml`
  - `audio_policy_configuration_bluetooth_legacy_hal.xml`
  - `a2dp_audio_policy_configuration.xml`
  - `a2dp_in_audio_policy_configuration.xml`
  - `bluetooth_audio_policy_configuration.xml`
  - `bluetooth_offload_audio_policy_configuration.xml`
  - `r_submix_audio_policy_configuration.xml`
  - `usb_audio_policy_configuration.xml`
- Forces legacy Bluetooth audio HAL path via system properties.
- Keeps A2DP offload properties aligned with stock dump.

## Install
1. Zip the `gsi_bt_audio_module` folder content (not the parent folder).
2. Flash in Magisk or KernelSU.
3. Reboot.
4. Re-pair BT headset if needed.

## Notes
- This targets NOTE_23 vendor blobs + Google GSI mismatches where media still routes to speaker.
- If call audio is fine but media is not, this module is the expected fix path.
