#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Recovery
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/init.recovery.mt8127.rc:root/init.recovery.mt8127.rc

# Rootdir
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt8127:root/fstab.mt8127

# Inherit the proprietary files
$(call inherit-product, vendor/amazon/mt8127-common/mt8127-common-vendor.mk)
