# VGO NOTE 23 GSI Fingerprint Fix (Magisk/KernelSU module)

This module is built from the NOTE 23 vendor dump and targets GSI builds where fingerprint is missing or where logs show:

- `Spi's loading is not finished`

## What it does

1. Exposes `android.hardware.fingerprint` on the system side so the Settings UI can show fingerprint enrollment on GSIs.
2. Forces relevant fingerprint/TEE props early in boot.
3. Waits for `teei_daemon` and `/dev/teei_fp` + fingerprint device nodes, then restarts `vendor.fps_hal` to avoid early-init SPI races.
4. Sets `persist.sys.phh.fingerprint.nocleanup=1` (useful on PHH-based GSIs to avoid template cleanups causing repeated enrollment breaks).

## Install

1. Zip the `gsi-fingerprint-fix-module` folder contents (not the parent folder).
2. Flash in Magisk or KernelSU.
3. Reboot.
4. Check logs:
   - `logcat -s GSI-FP-FIX`
   - `logcat | grep -i fingerprint`

## Notes

- This module cannot repair a fully broken TrustZone/TEE firmware stack.
- If `/dev/focaltech_fp` and `/dev/teei_fp` never appear, the issue is kernel/vendor-side and cannot be fixed only from Android userspace.
