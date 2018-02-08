#add for fingerprint
$(info inherit product device/mediatek/mt6739/fingerprint.mk)
BIRD_SUPPORT_FP_CHIP ?= NONE

PRODUCT_COPY_FILES += device/mediatek/mt6739/init.fingerprint.rc:root/init.fingerprint.rc
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.fingerprint.xml:system/etc/permissions/android.hardware.fingerprint.xml
  
ifneq ($(strip $(BIRD_SUPPORT_FP_CHIP)),NONE)
PRODUCT_PACKAGES += fingerprintd

####### add by lichengfeng 20160311 for fingerprint shortcut begin ######
#ifeq ($(strip $(BIRD_FINGERPRINTSHORTCUT_OPEN)), yes)
#	PRODUCT_PACKAGES+=FingerPrintShortCut
#endif
####### add by lichengfeng 20160311 for fingerprint shortcut end ######	
#PRODUCT_PACKAGES += libbird_fp_native
#PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.fingerprint.xml:system/etc/permissions/android.hardware.fingerprint.xml
endif


ifneq ($(filter $(BIRD_SUPPORT_FP_CHIP), microarary),)
$(info BIRD_SUPPORT_FP_CHIP contain microarary)
	PRODUCT_PACKAGES += libfprint-x32
	PRODUCT_PACKAGES += libma-fpservice
	PRODUCT_PACKAGES += microarray.fingerprint.default
	#PRODUCT_COPY_FILES += ### bird/prebuilts/external/birdfp/microarary/XXX
	#PRODUCT_PROPERTY_OVERRIDES += ro.csfinger=true
endif

ifneq ($(filter $(BIRD_SUPPORT_FP_CHIP), blestech),)
#	#blestech fingerprint for android
#	PRODUCT_PACKAGES += blestech.fingerprint.default
#	PRODUCT_PACKAGES += libxuFPAlg
#	PRODUCT_PACKAGES += libBtlFpHal
#	PRODUCT_PACKAGES += libBtlAlgo
endif

# add for fps988e start
ifneq ($(filter $(BIRD_SUPPORT_FP_CHIP), cdfinger),)
ifneq ($(filter $(BIRD_SUPPORT_FP_SENSOR), fps988e),)
$(call inherit-product, bird/prebuilts/external/birdfp/cdfinger/fps988e/cdfingerproduct.mk)
endif
endif
# add for fps988e end

