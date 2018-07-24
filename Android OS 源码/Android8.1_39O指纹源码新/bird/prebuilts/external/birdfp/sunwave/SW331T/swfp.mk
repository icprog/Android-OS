#
# Copyright (C) 2011 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# device path
MY_DEVICE_ROOTDIR := bird/prebuilts/external/birdfp/sunwave/SW331T

ifeq ($(strip $(TARGET_COPY_OUT_VENDOR)),)	
TARGET_COPY_OUT_VENDOR := vendor
endif

#sunwave start
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1-service
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.fingerprint.xml:vendor/etc/permissions/android.hardware.fingerprint.xml			   

PRODUCT_COPY_FILES += $(MY_DEVICE_ROOTDIR)/vendor/lib/vendor.sw.swfingerprint@1.0.so:vendor/lib/vendor.sw.swfingerprint@1.0.so
PRODUCT_COPY_FILES += $(MY_DEVICE_ROOTDIR)/vendor/lib/hw/fingerprint.default.so:vendor/lib/hw/fingerprint.default.so
PRODUCT_COPY_FILES += $(MY_DEVICE_ROOTDIR)/vendor/lib/hw/vendor.sw.swfingerprint@1.0-impl.so:vendor/lib/hw/vendor.sw.swfingerprint@1.0-impl.so

PRODUCT_COPY_FILES += $(MY_DEVICE_ROOTDIR)/vendor/bin/hw/vendor.sw.swfingerprint@1.0-service:vendor/bin/hw/vendor.sw.swfingerprint@1.0-service
PRODUCT_COPY_FILES += $(MY_DEVICE_ROOTDIR)/vendor/etc/init/vendor.sw.swfingerprint@1.0-service.rc:vendor/etc/init/vendor.sw.swfingerprint@1.0-service.rc

PRODUCT_COPY_FILES += $(MY_DEVICE_ROOTDIR)/vendor/thh/ta/7778c03fc30c4dd0a319ea29643d4d4b.ta:vendor/thh/ta/7778c03fc30c4dd0a319ea29643d4d4b.ta
PRODUCT_COPY_FILES += $(MY_DEVICE_ROOTDIR)/vendor/lib64/hw/fingerprint.default.so:vendor/lib64/hw/fingerprint.default.so


#sunwave end 

# sunwave sepolicy
BOARD_SEPOLICY_DIRS += $(MY_DEVICE_ROOTDIR)/AndroidO_sepolicy_hidl

# sunwave manifest.xml
#DEVICE_MANIFEST_FILE += $(MY_DEVICE_ROOTDIR)/manifest.xml