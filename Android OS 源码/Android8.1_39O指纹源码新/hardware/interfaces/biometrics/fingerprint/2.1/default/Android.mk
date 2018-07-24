LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ifeq ($(strip $(BIRD_FINGERPRINT_OPENHAL_COMPATIBLE_SUPPORT)), yes)
LOCAL_CFLAGS += -DBIRD_FINGERPRINT_OPENHAL_COMPATIBLE_SUPPORT
endif
LOCAL_CFLAGS += -DBIRD_SUPPORT_FP_CHIP="$(BIRD_SUPPORT_FP_CHIP)"
LOCAL_CFLAGS += -DBIRD_SUPPORT_FP_SENSOR="$(BIRD_SUPPORT_FP_SENSOR)" 
$(warning "*** hardware/interfaces/biometrics/fingerprint/2.1/default/Android.mk LOCAL_CFLAGS: $(LOCAL_CFLAGS)")

LOCAL_MODULE := android.hardware.biometrics.fingerprint@2.1-service
LOCAL_INIT_RC := android.hardware.biometrics.fingerprint@2.1-service.rc
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_SRC_FILES := \
    BiometricsFingerprint.cpp \
    service.cpp \

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    liblog \
    libhidlbase \
    libhidltransport \
    libhardware \
    libutils \
    android.hardware.biometrics.fingerprint@2.1 \

include $(BUILD_EXECUTABLE)
