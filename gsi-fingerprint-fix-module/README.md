# VGO NOTE 23 GSI Fingerprint Fix (Magisk/KernelSU module)

This module targets NOTE 23 on GSIs where fingerprint is missing or unstable.

## Why this revision exists

Your logs show:

- `Control message: Could not find 'android.hardware.biometrics.fingerprint@2.1::IBiometricsFingerprint/default' for ctl.interface_start`
- `Control message: Could not find 'vendor.fingerprint_hal' for ctl.start`
- SELinux denials for `hal_fingerprint_default` / `hal_fingerprint_oppo_compat` reading `sysfs_thp_enabled`

A Magisk module is mounted after early init service parsing, so adding init `interface` mappings from a module is not reliable for `ctl.interface_start` requests. This revision avoids that path.

## What it does

1. Exposes `android.hardware.fingerprint` on the system side so the Settings UI can show enrollment on GSIs.
2. Forces relevant fingerprint/TEE props early in boot.
3. Waits for `teei_daemon`, `/dev/teei_fp`, and fingerprint device node, then directly restarts `vendor.fps_hal`.
4. Retries restarting `vendor.fps_hal` and logs service state to help diagnose crash loops.
5. Applies a small `sepolicy.rule` to allow fingerprint HAL domains to read THP sysfs node (`sysfs_thp_enabled`).
6. Sets `persist.sys.phh.fingerprint.nocleanup=1`.

## Install

1. Zip the `gsi-fingerprint-fix-module` folder contents (not parent folder).
2. Flash in Magisk or KernelSU.
3. Reboot.
4. Check logs:
   - `logcat -s GSI-FP-FIX`
   - `dmesg | grep -i -e fingerprint -e ctl.start -e ctl.interface_start`

## Notes

- This module cannot repair a fully broken TrustZone/TEE firmware stack.
- If `/dev/focaltech_fp` and `/dev/teei_fp` never appear, the issue is kernel/vendor-side.
