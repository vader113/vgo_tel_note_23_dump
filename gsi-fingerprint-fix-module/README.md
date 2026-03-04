# VGO NOTE 23 GSI Fingerprint Fix (Magisk/KernelSU module)

This revision simplifies the module and removes noisy/fragile behavior.

## What changed in this revision

1. Removed SELinux rule injection from this module.
2. Removed the infinite watchdog loop.
3. Switched to a finite, deterministic startup routine:
   - wait for `boot_completed`
   - wait for `teei_daemon`, `/dev/teei_fp`, and fp node
   - retry `vendor.fps_hal` startup up to 20 times
   - stop with clear logs if registration still fails
4. Keeps focaltech properties set both in `post-fs-data.sh` and runtime service phase.

## Why

The previous approach was too broad and could be unstable. This version focuses only on reliable bring-up of the existing vendor fingerprint HAL (`vendor.fps_hal`) without long-running control loops.

## Install

1. Zip the `gsi-fingerprint-fix-module` folder contents (not parent folder).
2. Flash in Magisk or KernelSU.
3. Reboot.

## Verify

- `logcat -s GSI-FP-FIX`
- `getprop init.svc.vendor.fps_hal`
- `lshal | grep -i IBiometricsFingerprint`

If logs still show HAL never registers after retries, the remaining failure is in vendor/TEE side and cannot be fully fixed from userspace module scripts.
