LOCAL_PATH := $(call my-dir)
##############################32位系统库for 32 bit system lib########################################
PRODUCT_COPY_FILES +=bird/prebuilts/external/birdfp/blestech/lib/libBtlFpHal.so:vendor/lib/libBtlFpHal.so 
#PRODUCT_COPY_FILES +=bird/prebuilts/external/birdfp/blestech/lib/libBtlFpJni.so:vendor/lib/libBtlFpJni.so   #for factory test 工程测试库
PRODUCT_COPY_FILES +=bird/prebuilts/external/birdfp/blestech/lib/libxuFPAlg.so:vendor/lib/libxuFPAlg.so 
PRODUCT_COPY_FILES +=bird/prebuilts/external/birdfp/blestech/lib/libBtlAlgo.so:vendor/lib/libBtlAlgo.so 
#PRODUCT_COPY_FILES +=bird/prebuilts/external/birdfp/blestech/lib/blestech.fingerprint.default.so:vendor/lib/hw/blestech.fingerprint.default.so  #for compatible others fingerprint 多家指纹兼容default库
PRODUCT_COPY_FILES +=bird/prebuilts/external/birdfp/blestech/lib/fingerprint.default.so:vendor/lib/hw/fingerprint.default.so# 不兼容其他指纹default库
############################64位系统库for 64 bit system lib###########################################
#PRODUCT_COPY_FILES +=vendor/btlfp/lib64/libBtlFpHal.so:vendor/lib64/libBtlFpHal.so 
#PRODUCT_COPY_FILES +=vendor/btlfp/lib64/libBtlAlgo.so:vendor/lib64/libBtlAlgo.so 
#PRODUCT_COPY_FILES +=vendor/btlfp/lib64/libxuFPAlg.so:vendor/lib64/libxuFPAlg.so 
#PRODUCT_COPY_FILES +=vendor/btlfp/lib64/blestech.fingerprint.default.so:vendor/lib64/hw/blestech.fingerprint.default.so #for compatible others fingerprint 多家指纹兼容default库
#PRODUCT_COPY_FILES +=vendor/btlfp/lib64/fingerprint.default.so:vendor/lib64/hw/fingerprint.default.so # 不兼容其他指纹default库


PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.fingerprint.xml:system/etc/permissions/android.hardware.fingerprint.xml


