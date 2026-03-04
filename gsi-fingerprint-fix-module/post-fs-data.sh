#!/system/bin/sh
# Make GSI expose fingerprint capability and keep vendor-side fp config values.
resetprop ro.hardware.fingerprint focaltech
resetprop ro.vendor.mtk_microtrust_tee_support 1
resetprop ro.odm.fingerprint ft9362_tee
resetprop ro.odm.fingerprint_module 1

# Focaltech HAL logs show it reads property key: vendor.fingerprint
resetprop vendor.fingerprint ft9362_tee
resetprop persist.vendor.fingerprint ft9362_tee
