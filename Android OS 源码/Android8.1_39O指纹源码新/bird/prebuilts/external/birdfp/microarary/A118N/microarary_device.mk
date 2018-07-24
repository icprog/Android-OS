LOCAL_PATH := bird/prebuilts/external/birdfp/microarary/A118N
$(warning "Note: $(LOCAL_PATH) OK")

PRODUCT_COPY_FILES += $(LOCAL_PATH)/lib/hw/fingerprint.default.so:vendor/lib/hw/fingerprint.default.so
PRODUCT_COPY_FILES += $(LOCAL_PATH)/lib/hw/microarray.default.so:vendor/lib/hw/microarray.default.so
# PRODUCT_COPY_FILES += $(LOCAL_PATH)/lib/hw/microarray.fingerprint.default.so:vendor/lib/hw/microarray.fingerprint.default.so

PRODUCT_COPY_FILES += $(LOCAL_PATH)/lib/libfprint-x32.so:vendor/lib/libfprint-x32.so
PRODUCT_COPY_FILES += $(LOCAL_PATH)/lib/libma-fpservice.so:vendor/lib/libma-fpservice.so
PRODUCT_COPY_FILES += $(LOCAL_PATH)/app/t6/edcf9395-3518-9067-614cafae2909775b.ta:vendor/app/t6/edcf9395-3518-9067-614cafae2909775b.ta

PRODUCT_COPY_FILES += $(LOCAL_PATH)/init.microarary.rc:$(MTK_TARGET_VENDOR_RC)/init.microarary.rc


