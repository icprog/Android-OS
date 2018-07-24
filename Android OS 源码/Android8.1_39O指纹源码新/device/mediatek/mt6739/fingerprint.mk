#add for fingerprint
BIRD_SUPPORT_FP_CHIP ?= NONE
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.fingerprint.xml:vendor/etc/permissions/android.hardware.fingerprint.xml

$(warning $(shell echo "BIRD_SUPPORT_FP_CHIP is $(BIRD_SUPPORT_FP_CHIP)")) 
$(warning $(shell echo "BIRD_SUPPORT_FP_SENSOR is $(BIRD_SUPPORT_FP_SENSOR)")) 

# add for fpsensor start
ifneq ($(filter $(BIRD_SUPPORT_FP_CHIP), fpsensor),)
ifneq ($(filter $(BIRD_SUPPORT_FP_SENSOR), icnt7152l),)
#fpsensor
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1-service

#fp  chipone
#ta lib
PRODUCT_COPY_FILES += bird/prebuilts/external/birdfp/fpsensor/fpsensor_tee_icnt7152l/ta_lib/fp_server:vendor/thh/fp_server   

#ca lib
PRODUCT_COPY_FILES += bird/prebuilts/external/birdfp/fpsensor/fpsensor_tee_icnt7152l/ca_lib/lib/hw/fingerprint.default.so:vendor/lib/hw/fingerprint.default.so
endif
endif
# add for fpsensor end

ifneq ($(filter $(BIRD_SUPPORT_FP_CHIP), microarary),)

ifneq ($(filter $(BIRD_SUPPORT_FP_SENSOR), A118N),)
$(warning BIRD_SUPPORT_FP_CHIP contain A118N)
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1-etservice
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1-service

$(call inherit-product, bird/prebuilts/external/birdfp/microarary/A118N/microarary_device.mk)
endif

endif


ifneq ($(filter $(BIRD_SUPPORT_FP_CHIP), chipsailing),)

ifneq ($(filter $(BIRD_SUPPORT_FP_SENSOR), CS338P_TEE),)
$(warning BIRD_SUPPORT_FP_CHIP contain CS338P_TEE)
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1-etservice
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1-service
$(call inherit-product, bird/prebuilts/external/birdfp/chipsailing/CS338P_TEE/csfinger_product_32bit.mk)
endif

endif

#add for blestech start
ifneq ($(filter $(BIRD_SUPPORT_FP_CHIP), blestech),)

ifneq ($(filter $(BIRD_SUPPORT_FP_SENSOR), BF3390),)
$(warning BIRD_SUPPORT_FP_CHIP contain BF3390)
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1-etservice
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1-service
$(call inherit-product, bird/prebuilts/external/birdfp/blestech/btlproduct.mk)
endif

endif
#add for blestech end
#add for sunwave start
ifneq ($(filter $(BIRD_SUPPORT_FP_CHIP), sunwave),)

ifneq ($(filter $(BIRD_SUPPORT_FP_SENSOR), SW331T),)
$(warning BIRD_SUPPORT_FP_CHIP contain SW331T)
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1-etservice
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1
PRODUCT_PACKAGES += android.hardware.biometrics.fingerprint@2.1-service
$(call inherit-product, bird/prebuilts/external/birdfp/sunwave/SW331T/swfp.mk)
endif

endif
#add for sunwave end
