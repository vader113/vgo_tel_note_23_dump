# VGO NOTE 23 GSI Fingerprint Fix (Magisk/KernelSU module)

This module is built from the NOTE 23 vendor dump and targets GSI builds where fingerprint is missing or where logs show:

- `Spi's loading is not finished`
- `Fingerprint HAL not available`
- `ctl.interface_start ... error code: 0x20`
- `Could not find 'android.hardware.biometrics.fingerprint@2.1::IBiometricsFingerprint/default'`

## What it does

1. Exposes `android.hardware.fingerprint` on the system side so the Settings UI can show fingerprint enrollment on GSIs.
2. Forces relevant fingerprint/TEE props early in boot.
3. Overlays `android.hardware.biometrics.fingerprint@2.1-service.rc` and adds an explicit `interface ... IBiometricsFingerprint default` line so lazy HAL startup can work.
4. Waits for `teei_daemon` and `/dev/teei_fp` + fingerprint device nodes, then restarts/starts fingerprint HAL (`vendor.fps_hal` / `vendor.fingerprint_hal`) to avoid early-init SPI races.
5. Sets `persist.sys.phh.fingerprint.nocleanup=1` (useful on PHH-based GSIs to avoid template cleanups causing repeated enrollment breaks).

## Install

1. Zip the `gsi-fingerprint-fix-module` folder contents (not the parent folder).
2. Flash in Magisk or KernelSU.
3. Reboot.
4. Check logs:
   - `logcat -s GSI-FP-FIX`
   - `logcat | grep -i -e Fingerprint21 -e hwservicemanager -e vendor.fps_hal`

## Notes

- This module cannot repair a fully broken TrustZone/TEE firmware stack.
- If `/dev/focaltech_fp` and `/dev/teei_fp` never appear, the issue is kernel/vendor-side and cannot be fixed only from Android userspace.
