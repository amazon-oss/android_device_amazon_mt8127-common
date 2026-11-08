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

# Media
PRODUCT_PACKAGES += \
    libgui_ext \
    libui_ext

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml

# Recovery
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/init.recovery.mt8127.rc:root/init.recovery.mt8127.rc

# Rootdir
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.enableswap:system/vendor/etc/fstab.enableswap \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt8127:root/fstab.mt8127 \
    $(LOCAL_PATH)/rootdir/etc/init.mt8127.rc:root/init.mt8127.rc \
    $(LOCAL_PATH)/rootdir/etc/ueventd.mt8127.rc:root/ueventd.mt8127.rc

# Shims
PRODUCT_PACKAGES += \
    libamazonlog \
    libbinder_shim \
    libui_shim

# Wi-Fi
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml

PRODUCT_PACKAGES += \
    hostapd \
    wpa_supplicant

# Inherit the proprietary files
$(call inherit-product, vendor/amazon/mt8127-common/mt8127-common-vendor.mk)
