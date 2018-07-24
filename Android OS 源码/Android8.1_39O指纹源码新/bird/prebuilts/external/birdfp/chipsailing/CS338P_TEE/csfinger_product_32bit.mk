# CS_LOCAL_PATH := device/chipsailing/AndroidO
CS_LOCAL_PATH := bird/prebuilts/external/birdfp/chipsailing/CS338P_TEE

$(warning "Note: $(CS_LOCAL_PATH) OK")

FINGERPRINT_HARDWARE_MODULE_ID := chipsailing.fingerprint
TEE_PLATFORM := isee
CHIPS_IS_COATING := false
CS_IC_SENSOR := 338

# PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/init.csfinger.rc:root/init.csfinger.rc
PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/init.csfinger.rc:$(MTK_TARGET_VENDOR_RC)/init.csfinger.rc

PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.fingerprint.xml:system/etc/permissions/android.hardware.fingerprint.xml

# Fingerprint Sensor
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.1-service \
    android.hardware.biometrics.fingerprint@2.1 \
	
DEVICE_MANIFEST_FILE += $(CS_LOCAL_PATH)/manifest_chipsailing_fingerprint.xml

PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/vendor.chipsailing.fingerprint@1.0-service:vendor/bin/hw/vendor.chipsailing.fingerprint@1.0-service

PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/libcs_fp_binder.so:vendor/lib/libcs_fp_binder.so

PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/vendor.chipsailing.fingerprint@1.0.so:vendor/lib/vendor.chipsailing.fingerprint@1.0.so

ifeq ($(FINGERPRINT_HARDWARE_MODULE_ID),chipsailing.fingerprint)
	PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/chipsailing.fingerprint.default.so:vendor/lib/hw/chipsailing.fingerprint.default.so
	PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/fingerprint.default.so:vendor/lib/hw/fingerprint.default.so
else
	PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/fingerprint.default.so:vendor/lib/hw/fingerprint.default.so
endif

PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/libfp_hal.so:vendor/lib/libfp_hal.so

ifeq ($(strip $(TEE_PLATFORM)), rsee)
	PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/rsee/libfp_tac.so:vendor/lib/libfp_tac.so
	
	ifeq ($(strip $(CHIPS_IS_COATING)), true)
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/rsee/coating/8aaaf200-2450-11e4-abe2-0002a5d5c51a.ta:system/lib/sec_modules/8aaaf200-2450-11e4-abe2-0002a5d5c51a.ta
	else 
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/rsee/glass/8aaaf200-2450-11e4-abe2-0002a5d5c51a.ta:system/lib/sec_modules/8aaaf200-2450-11e4-abe2-0002a5d5c51a.ta
	endif
endif

ifeq ($(strip $(TEE_PLATFORM)), qsee)
	PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/libfp_tac.so:vendor/lib/libfp_tac.so
	
	ifeq ($(strip $(CHIPS_IS_COATING)), true)
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/coating/fpchips32.b00:/system/etc/firmware/fpchips.b00
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/coating/fpchips32.b01:/system/etc/firmware/fpchips.b01
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/coating/fpchips32.b02:/system/etc/firmware/fpchips.b02
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/coating/fpchips32.b03:/system/etc/firmware/fpchips.b03
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/coating/fpchips32.b04:/system/etc/firmware/fpchips.b04
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/coating/fpchips32.b05:/system/etc/firmware/fpchips.b05
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/coating/fpchips32.b06:/system/etc/firmware/fpchips.b06
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/coating/fpchips32.flist:/system/etc/firmware/fpchips.flist
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/coating/fpchips32.mdt:/system/etc/firmware/fpchips.mdt
	else
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/glass/fpchips32.b00:/system/etc/firmware/fpchips.b00
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/glass/fpchips32.b01:/system/etc/firmware/fpchips.b01
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/glass/fpchips32.b02:/system/etc/firmware/fpchips.b02
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/glass/fpchips32.b03:/system/etc/firmware/fpchips.b03
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/glass/fpchips32.b04:/system/etc/firmware/fpchips.b04
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/glass/fpchips32.b05:/system/etc/firmware/fpchips.b05
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/glass/fpchips32.b06:/system/etc/firmware/fpchips.b06
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/glass/fpchips32.flist:/system/etc/firmware/fpchips.flist
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/qsee/glass/fpchips32.mdt:/system/etc/firmware/fpchips.mdt
	endif
endif

ifeq ($(strip $(TEE_PLATFORM)), isee)
	PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/isee/libfp_tac.so:vendor/lib/libfp_tac.so
	
	ifeq ($(strip $(CHIPS_IS_COATING)), true)
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/isee/coating/7778c03fc30c4dd0a319ea29643d4d4b.ta:vendor/thh/ta/7778c03fc30c4dd0a319ea29643d4d4b.ta
	else 
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/isee/glass/7778c03fc30c4dd0a319ea29643d4d4b.ta:vendor/thh/ta/7778c03fc30c4dd0a319ea29643d4d4b.ta
	endif
endif

ifeq ($(strip $(TEE_PLATFORM)), trustkernel)
	PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/trustkernel/libfp_tac.so:vendor/lib/libfp_tac.so
	
	ifeq ($(strip $(CHIPS_IS_COATING)), true)
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/trustkernel/coating/8aaaf200-2450-11e4-abe20002a5d5c51a.ta:vendor/app/t6/8aaaf200-2450-11e4-abe20002a5d5c51a.ta
	else 
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/trustkernel/glass/8aaaf200-2450-11e4-abe20002a5d5c51a.ta:vendor/app/t6/8aaaf200-2450-11e4-abe20002a5d5c51a.ta
	endif
endif

ifeq ($(strip $(TEE_PLATFORM)), trustonic)
	PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/trustonic/libfp_tac.so:vendor/lib/libfp_tac.so
	
	ifeq ($(strip $(CHIPS_IS_COATING)), true)
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/trustonic/coating/b9a09f5805815453a0dbe4ef2fda3a6d.tabin:vendor/app/mcRegistry/b9a09f5805815453a0dbe4ef2fda3a6d.tabin
	else 
		PRODUCT_COPY_FILES += $(CS_LOCAL_PATH)/32-bit/trustonic/glass/b9a09f5805815453a0dbe4ef2fda3a6d.tabin:vendor/app/mcRegistry/b9a09f5805815453a0dbe4ef2fda3a6d.tabin
	endif
endif

# PRODUCT_COPY_FILES += device/chipsailing/init.csfinger.rc:root/init.csfinger.rc


ifeq ($(strip $(CS_IC_SENSOR)), 358)
	include $(CS_LOCAL_PATH)/config/cs_cfg_358_glass.mk
endif
ifeq ($(strip $(CS_IC_SENSOR)), 3511)
	include $(CS_LOCAL_PATH)/config/cs_cfg_3511_coating.mk
endif
ifeq ($(strip $(CS_IC_SENSOR)), 3716)
	include $(CS_LOCAL_PATH)/config/cs_cfg_358_glass.mk
endif
ifeq ($(strip $(CS_IC_SENSOR)), 3711)
	include $(CS_LOCAL_PATH)/config/cs_cfg_3711_coating.mk
endif
ifeq ($(strip $(CS_IC_SENSOR)), 336)	
	include $(CS_LOCAL_PATH)/config/cs_cfg_336_glass.mk
endif
ifeq ($(strip $(CS_IC_SENSOR)), 351)
	include $(CS_LOCAL_PATH)/config/cs_cfg_351_glass.mk
endif
ifeq ($(strip $(CS_IC_SENSOR)), 3516)
	include $(CS_LOCAL_PATH)/config/cs_cfg_3516_glass.mk
endif
ifeq ($(strip $(CS_IC_SENSOR)), 356)
	include $(CS_LOCAL_PATH)/config/cs_cfg_356_glass.mk
endif
ifeq ($(strip $(CS_IC_SENSOR)), 338)
	include $(CS_LOCAL_PATH)/config/cs_cfg_338_glass.mk	
endif
ifeq ($(strip $(CS_IC_SENSOR)), 1073)
	include $(CS_LOCAL_PATH)/config/cs_cfg_1073_coating.mk	
endif
ifeq ($(strip $(CS_IC_SENSOR)), 1175)
	include $(CS_LOCAL_PATH)/config/cs_cfg_11751_coating.mk	
endif
ifeq ($(strip $(CS_IC_SENSOR)), 2516)
	include $(CS_LOCAL_PATH)/config/cs_cfg_2516_glass.mk	
endif
