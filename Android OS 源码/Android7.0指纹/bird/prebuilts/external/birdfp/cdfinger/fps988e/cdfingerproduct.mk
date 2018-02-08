LOCAL_PATH := bird/prebuilts/external/birdfp/cdfinger/fps988e
#$(warning  sunlin============$(LOCAL_PATH)) 

PRODUCT_COPY_FILES += $(LOCAL_PATH)/libs/cdfinger.default.so:system/lib/hw/cdfinger.default.so
PRODUCT_COPY_FILES += $(LOCAL_PATH)/libs/cdfinger.fingerprint.default.so:system/lib/hw/cdfinger.fingerprint.default.so
PRODUCT_COPY_FILES += $(LOCAL_PATH)/libs/cdfingerdaemon:system/bin/cdfingerdaemon 
#PRODUCT_COPY_FILES += $(LOCAL_PATH)/libs/fingerprint.default.so:system/lib/hw/fingerprint.default.so
PRODUCT_COPY_FILES += $(LOCAL_PATH)/libs/libcfpalgo_x56.so:system/lib/libcfpalgo_x56.so
PRODUCT_COPY_FILES += $(LOCAL_PATH)/libs/libcfpalgo_x80.so:system/lib/libcfpalgo_x80.so
PRODUCT_COPY_FILES += $(LOCAL_PATH)/libs/libcfpalgo_x98.so:system/lib/libcfpalgo_x98.so
PRODUCT_COPY_FILES += $(LOCAL_PATH)/libs/libcfp_proxy.so:system/lib/libcfp_proxy.so
PRODUCT_COPY_FILES += $(LOCAL_PATH)/libs/libcfp_factory.so:system/lib/libcfp_factory.so
PRODUCT_COPY_FILES += $(LOCAL_PATH)/libs/libcfpservice.so:system/lib/libcfpservice.so

PRODUCT_COPY_FILES += $(LOCAL_PATH)/init.cdfinger.rc:root/init.cdfinger.rc
