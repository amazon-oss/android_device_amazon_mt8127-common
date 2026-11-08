#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.r_submix.default \
    audio.usb.default \
    libtinycompress \
    libtinyxml

PRODUCT_COPY_FILES += \
    frameworks/av/media/libeffects/data/audio_effects.conf:system/etc/audio_effects.conf

# Display
PRODUCT_PACKAGES += \
    libion \
    libstlport_shared

# Recovery
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/init.recovery.mt8127.rc:root/init.recovery.mt8127.rc

# Rootdir
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt8127:root/fstab.mt8127 \
    $(LOCAL_PATH)/rootdir/etc/init.mt8127.rc:root/init.mt8127.rc \
    $(LOCAL_PATH)/rootdir/etc/ueventd.mt8127.rc:root/ueventd.mt8127.rc

# Shims
PRODUCT_PACKAGES += \
    libamazonlog \
    libbinder_shim

# Inherit the proprietary files
$(call inherit-product, vendor/amazon/mt8127-common/mt8127-common-vendor.mk)
