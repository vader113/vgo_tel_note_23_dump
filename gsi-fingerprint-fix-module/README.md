# VGO NOTE 23 GSI Fingerprint Fix (Magisk/KernelSU module)

This module targets NOTE 23 on GSIs where fingerprint HAL loads but framework still loses the daemon.

## What was fixed in this revision

Based on your logs, this revision focuses on two practical issues:

1. The HAL can start but not stay discoverable/registered for framework calls.
2. Focaltech config uses `vendor.fingerprint` (seen in logs as `common.property_key : vendor.fingerprint`), but GSIs may not provide matching values.

## What it does

1. Exposes `android.hardware.fingerprint` on the system side for Settings/UI.
2. Forces fingerprint-related props early:
   - `ro.odm.fingerprint=ft9362_tee`
   - `ro.odm.fingerprint_module=1`
   - `vendor.fingerprint=ft9362_tee`
   - `persist.vendor.fingerprint=ft9362_tee`
3. Waits for boot completion, `teei_daemon`, `/dev/teei_fp`, and fp node.
4. Repeatedly starts `vendor.fps_hal` until service state and HAL registration look healthy.
5. Keeps a watchdog loop to recover from later HAL death/unregistration.
6. Applies `sepolicy.rule` to allow THP sysfs reads for fp HAL domains.

## Install

1. Zip the `gsi-fingerprint-fix-module` folder contents (not parent folder).
2. Flash in Magisk or KernelSU.
3. Reboot.
4. Verify:
   - `logcat -s GSI-FP-FIX`
   - `getprop init.svc.vendor.fps_hal`
   - `lshal | grep -i IBiometricsFingerprint`

## Notes

- `vendor.oppo/oplus` manifest warnings from PHH/adapter probes are usually unrelated noise for this MTK focaltech path.
- If `/dev/focaltech_fp` and `/dev/teei_fp` never appear, this cannot be fixed in userspace alone.
