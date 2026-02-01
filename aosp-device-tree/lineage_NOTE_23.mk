#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from NOTE_23 device
$(call inherit-product, device/ssh/NOTE_23/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_DEVICE := NOTE_23
PRODUCT_NAME := lineage_NOTE_23
PRODUCT_BRAND := VGO_TEL
PRODUCT_MODEL := NOTE 23
PRODUCT_MANUFACTURER := ssh

PRODUCT_GMS_CLIENTID_BASE := android-coosea

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="NOTE_23_V02-user 14 UP1A.231005.007 1730361790 release-keys" \
    BuildFingerprint := VGO_TEL/NOTE_23_V02/NOTE_23:14/UP1A.231005.007/1730358553:user/release-keys