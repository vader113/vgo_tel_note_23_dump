#!/system/bin/sh
# Ensure GSI sees fingerprint capability even when vendor feature XML is skipped.
resetprop ro.hardware.fingerprint focaltech
resetprop ro.vendor.mtk_microtrust_tee_support 1
