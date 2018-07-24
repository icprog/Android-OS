/*
 * Copyright (C) 2017 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#define LOG_TAG "android.hardware.biometrics.fingerprint@2.1-service"
#define LOG_VERBOSE "android.hardware.biometrics.fingerprint@2.1-service"

#include <hardware/hw_auth_token.h>

#include <hardware/hardware.h>
#include <hardware/fingerprint.h>
#include "BiometricsFingerprint.h"

#include <inttypes.h>
#include <unistd.h>

namespace android {
namespace hardware {
namespace biometrics {
namespace fingerprint {
namespace V2_1 {
namespace implementation {

// Supported fingerprint HAL version
static const uint16_t kVersion = HARDWARE_MODULE_API_VERSION(2, 1);

using RequestStatus =
        android::hardware::biometrics::fingerprint::V2_1::RequestStatus;

BiometricsFingerprint *BiometricsFingerprint::sInstance = nullptr;

BiometricsFingerprint::BiometricsFingerprint() : mClientCallback(nullptr), mDevice(nullptr) {
    sInstance = this; // keep track of the most recent instance
    mDevice = openHal();
    if (!mDevice) {
        ALOGE("Can't open HAL module");
    }
}

BiometricsFingerprint::~BiometricsFingerprint() {
    ALOGV("~BiometricsFingerprint()");
    if (mDevice == nullptr) {
        ALOGE("No valid device");
        return;
    }
    int err;
    if (0 != (err = mDevice->common.close(
            reinterpret_cast<hw_device_t*>(mDevice)))) {
        ALOGE("Can't close fingerprint module, error: %d", err);
        return;
    }
    mDevice = nullptr;
}

Return<RequestStatus> BiometricsFingerprint::ErrorFilter(int32_t error) {
    switch(error) {
        case 0: return RequestStatus::SYS_OK;
        case -2: return RequestStatus::SYS_ENOENT;
        case -4: return RequestStatus::SYS_EINTR;
        case -5: return RequestStatus::SYS_EIO;
        case -11: return RequestStatus::SYS_EAGAIN;
        case -12: return RequestStatus::SYS_ENOMEM;
        case -13: return RequestStatus::SYS_EACCES;
        case -14: return RequestStatus::SYS_EFAULT;
        case -16: return RequestStatus::SYS_EBUSY;
        case -22: return RequestStatus::SYS_EINVAL;
        case -28: return RequestStatus::SYS_ENOSPC;
        case -110: return RequestStatus::SYS_ETIMEDOUT;
        default:
            ALOGE("An unknown error returned from fingerprint vendor library: %d", error);
            return RequestStatus::SYS_UNKNOWN;
    }
}

// Translate from errors returned by traditional HAL (see fingerprint.h) to
// HIDL-compliant FingerprintError.
FingerprintError BiometricsFingerprint::VendorErrorFilter(int32_t error,
            int32_t* vendorCode) {
    *vendorCode = 0;
    switch(error) {
        case FINGERPRINT_ERROR_HW_UNAVAILABLE:
            return FingerprintError::ERROR_HW_UNAVAILABLE;
        case FINGERPRINT_ERROR_UNABLE_TO_PROCESS:
            return FingerprintError::ERROR_UNABLE_TO_PROCESS;
        case FINGERPRINT_ERROR_TIMEOUT:
            return FingerprintError::ERROR_TIMEOUT;
        case FINGERPRINT_ERROR_NO_SPACE:
            return FingerprintError::ERROR_NO_SPACE;
        case FINGERPRINT_ERROR_CANCELED:
            return FingerprintError::ERROR_CANCELED;
        case FINGERPRINT_ERROR_UNABLE_TO_REMOVE:
            return FingerprintError::ERROR_UNABLE_TO_REMOVE;
        case FINGERPRINT_ERROR_LOCKOUT:
            return FingerprintError::ERROR_LOCKOUT;
        default:
            if (error >= FINGERPRINT_ERROR_VENDOR_BASE) {
                // vendor specific code.
                *vendorCode = error - FINGERPRINT_ERROR_VENDOR_BASE;
                return FingerprintError::ERROR_VENDOR;
            }
    }
    ALOGE("Unknown error from fingerprint vendor library: %d", error);
    return FingerprintError::ERROR_UNABLE_TO_PROCESS;
}

// Translate acquired messages returned by traditional HAL (see fingerprint.h)
// to HIDL-compliant FingerprintAcquiredInfo.
FingerprintAcquiredInfo BiometricsFingerprint::VendorAcquiredFilter(
        int32_t info, int32_t* vendorCode) {
    *vendorCode = 0;
    switch(info) {
        case FINGERPRINT_ACQUIRED_GOOD:
            return FingerprintAcquiredInfo::ACQUIRED_GOOD;
        case FINGERPRINT_ACQUIRED_PARTIAL:
            return FingerprintAcquiredInfo::ACQUIRED_PARTIAL;
        case FINGERPRINT_ACQUIRED_INSUFFICIENT:
            return FingerprintAcquiredInfo::ACQUIRED_INSUFFICIENT;
        case FINGERPRINT_ACQUIRED_IMAGER_DIRTY:
            return FingerprintAcquiredInfo::ACQUIRED_IMAGER_DIRTY;
        case FINGERPRINT_ACQUIRED_TOO_SLOW:
            return FingerprintAcquiredInfo::ACQUIRED_TOO_SLOW;
        case FINGERPRINT_ACQUIRED_TOO_FAST:
            return FingerprintAcquiredInfo::ACQUIRED_TOO_FAST;
        default:
            if (info >= FINGERPRINT_ACQUIRED_VENDOR_BASE) {
                // vendor specific code.
                *vendorCode = info - FINGERPRINT_ACQUIRED_VENDOR_BASE;
                return FingerprintAcquiredInfo::ACQUIRED_VENDOR;
            }
    }
    ALOGE("Unknown acquiredmsg from fingerprint vendor library: %d", info);
    return FingerprintAcquiredInfo::ACQUIRED_INSUFFICIENT;
}

Return<uint64_t> BiometricsFingerprint::setNotify(
        const sp<IBiometricsFingerprintClientCallback>& clientCallback) {
    std::lock_guard<std::mutex> lock(mClientCallbackMutex);
    mClientCallback = clientCallback;
    // This is here because HAL 2.1 doesn't have a way to propagate a
    // unique token for its driver. Subsequent versions should send a unique
    // token for each call to setNotify(). This is fine as long as there's only
    // one fingerprint device on the platform.
    return reinterpret_cast<uint64_t>(mDevice);
}

Return<uint64_t> BiometricsFingerprint::preEnroll()  {
    return mDevice->pre_enroll(mDevice);
}

Return<RequestStatus> BiometricsFingerprint::enroll(const hidl_array<uint8_t, 69>& hat,
        uint32_t gid, uint32_t timeoutSec) {
    const hw_auth_token_t* authToken =
        reinterpret_cast<const hw_auth_token_t*>(hat.data());
    return ErrorFilter(mDevice->enroll(mDevice, authToken, gid, timeoutSec));
}

Return<RequestStatus> BiometricsFingerprint::postEnroll() {
    return ErrorFilter(mDevice->post_enroll(mDevice));
}

Return<uint64_t> BiometricsFingerprint::getAuthenticatorId() {
    return mDevice->get_authenticator_id(mDevice);
}

Return<RequestStatus> BiometricsFingerprint::cancel() {
    return ErrorFilter(mDevice->cancel(mDevice));
}

Return<RequestStatus> BiometricsFingerprint::enumerate()  {
    return ErrorFilter(mDevice->enumerate(mDevice));
}

Return<RequestStatus> BiometricsFingerprint::remove(uint32_t gid, uint32_t fid) {
    return ErrorFilter(mDevice->remove(mDevice, gid, fid));
}

Return<RequestStatus> BiometricsFingerprint::setActiveGroup(uint32_t gid,
        const hidl_string& storePath) {
    if (storePath.size() >= PATH_MAX || storePath.size() <= 0) {
        ALOGE("Bad path length: %zd", storePath.size());
        return RequestStatus::SYS_EINVAL;
    }
    if (access(storePath.c_str(), W_OK)) {
        return RequestStatus::SYS_EINVAL;
    }

    return ErrorFilter(mDevice->set_active_group(mDevice, gid,
                                                    storePath.c_str()));
}

Return<RequestStatus> BiometricsFingerprint::authenticate(uint64_t operationId,
        uint32_t gid) {
    return ErrorFilter(mDevice->authenticate(mDevice, operationId, gid));
}

IBiometricsFingerprint* BiometricsFingerprint::getInstance() {
    if (!sInstance) {
      sInstance = new BiometricsFingerprint();
    }
    return sInstance;
}

#if defined(BIRD_FINGERPRINT_OPENHAL_COMPATIBLE_SUPPORT) && defined(BIRD_SUPPORT_FP_CHIP) && defined(BIRD_SUPPORT_FP_SENSOR) 
//# bird wangdong@szba-mobile.com   add start 20180429231314  
#pragma message("BIRD_FINGERPRINT_OPENHAL_COMPATIBLE_SUPPORT BIRD_SUPPORT_FP_CHIP BIRD_SUPPORT_FP_SENSOR is defined!!!\n") 

#define BIRD_TOSTRING(value)            #value
#define BIRD_STRINGIZE(stringizedName)  BIRD_TOSTRING(stringizedName)
#define ALOGD_READER(fmt, ...)			ALOGE("[%s %d] " fmt, __func__, __LINE__, ##__VA_ARGS__) //ALOGD or ALOGE

typedef struct fingerprint_dev {
	const char *dev_name;      
	const char *hmi_id;      //dev_id;   
	const char *vendor_name; //chip_name;  
	const char *sensor_name; 
	const char *exe_env;     //Rich Execution Environment  / Trusted Execution Environment
} fingerprint_dev_t;

fingerprint_dev_t fingerprint_list[] = {
//blestech
	{
		.dev_name = "/dev/bl229x",
		.hmi_id = "blestech.fingerprint",    
		.vendor_name = "blestech",
		.sensor_name = "bl229",
		.exe_env = "REE",
	},
//chipsailing
	{
		.dev_name = "/dev/cs_spi",
		.hmi_id = "chipsailing.fingerprint",    
		.vendor_name = "chipsailing",
		.sensor_name = "CS338P_TEE",
		.exe_env = "TEE",
	},
//microarary
	{
		.dev_name = "/dev/madev0", 
		.hmi_id = "microarray", 
		.vendor_name = "microarary", 
		.sensor_name = "A118N", 
		.exe_env = "REE", 
	},
//chipone
	{
		.dev_name = "/dev/fpsensor", //chipone_fpsensor
		.hmi_id = "fpsensor_fingerprint", //?
		.vendor_name = "chipone",  //fpsensor
		.sensor_name = "icnt7152", //fpsensor_tee_icnt7152l
		.exe_env = "TEE",
	},
//cdfinger
//Goodix
//sunwave
/******* The last one config: fingerprint_vendor/fingerprint_sensor to Supportting *******/
	{
		.dev_name = "/dev/null", // /dev/zero OR /system/bin/sh ...
		.hmi_id = "fingerprint", // FINGERPRINT_HARDWARE_MODULE_ID
		.vendor_name = "fingerprint_vendor",  //BIRD_SUPPORT_FP_CHIP
		.sensor_name = "fingerprint_sensor",  //BIRD_SUPPORT_FP_SENSOR
		.exe_env = "REE",
	},
	{},
};

fingerprint_device_t* BiometricsFingerprint::openHal() {
	const int using_flag = 0; //1 --- "fingerprint" OK
    const char *pvendor_name_config  = BIRD_STRINGIZE(BIRD_SUPPORT_FP_CHIP);
    const char *psensor_name_config  = BIRD_STRINGIZE(BIRD_SUPPORT_FP_SENSOR);
	
	fingerprint_dev_t *pcurr_fingerprint = fingerprint_list;
    //int len = sizeof(fingerprint_list) / sizeof(fingerprint_dev_t);
	const char *fingerprint_hmi_id = "fingerprint";
	
    ALOGD_READER("BIRD_SUPPORT_FP_CHIP:%s  BIRD_SUPPORT_FP_SENSOR:%s ", pvendor_name_config, psensor_name_config);
	if ( (pvendor_name_config == NULL) || (psensor_name_config == NULL) )
	{
	    ALOGD_READER("Opening fingerprint hal compatible failed, ProjectConfig.mk config is NULL !!! ");
		return NULL; 
	}
	if ( (strlen(pvendor_name_config) <= 2) || (strlen(psensor_name_config) <= 2) )
	{
	    ALOGD_READER("Opening fingerprint hal compatible failed, ProjectConfig.mk config does not conform to rules!!! ");
		return NULL; 
	}
	
    ALOGD_READER("for loop start!!!");
    for( ; pcurr_fingerprint != NULL; pcurr_fingerprint++) {
    //for(int i = 0; (i < len) && (pcurr_fingerprint != NULL); i++) { 
		while ( (NULL == pcurr_fingerprint) || 
				(NULL == pcurr_fingerprint->dev_name) || 
				(NULL == pcurr_fingerprint->hmi_id) || 
				(NULL == pcurr_fingerprint->vendor_name) || 
				(NULL == pcurr_fingerprint->sensor_name) || 
				(NULL == pcurr_fingerprint->exe_env) || 
				(!strstr(pvendor_name_config, pcurr_fingerprint->vendor_name)) || 
				(!strstr(psensor_name_config, pcurr_fingerprint->sensor_name)) 
			  ) {
			ALOGD_READER("pcurr_fingerprint, It has a NULL value, OR it is not configured!!! \n");
			pcurr_fingerprint++;
		} //end---->while loop

		if (access(pcurr_fingerprint->dev_name, F_OK)) {//On  success, zero is returned
			ALOGD_READER("the file not exists, dev_name:%s\n", pcurr_fingerprint->dev_name);
	    	continue; 
		}
		
		fingerprint_hmi_id = pcurr_fingerprint->hmi_id;
		if (1 == using_flag) {
			fingerprint_hmi_id = "fingerprint";
			ALOGD_READER("force use:%s", fingerprint_hmi_id);
		}
		//property_set("sys.fingerprint.chip", pcurr_fingerprint->vendor_name);
		ALOGD_READER("Detect fingerprint hardware module id: %s, vendor_name:%s sensor_name:%s\n", 
						fingerprint_hmi_id, pcurr_fingerprint->vendor_name, pcurr_fingerprint->sensor_name);

	    int err;
	    const hw_module_t *hw_mdl = nullptr;
	    ALOGD_READER("Opening fingerprint hal library...");
		
	    if (0 != (err = hw_get_module(fingerprint_hmi_id, &hw_mdl))) {
	        perror("call hw_get_module error!!!");
	        ALOGD_READER("Can't open fingerprint HW Module, error:%s %d ", strerror(err), err);
	        continue;//return nullptr; //At the end of the cycle, the next cycle
	    }

	    if (hw_mdl == nullptr) {
	        ALOGD_READER("No valid fingerprint module");
	        continue;//return nullptr;
	    }

	    fingerprint_module_t const *module =
	        reinterpret_cast<const fingerprint_module_t*>(hw_mdl);
	    if (module->common.methods->open == nullptr) {
	        ALOGD_READER("No valid open method");
	        continue;//return nullptr;
	    }

	    hw_device_t *device = nullptr;

	    ALOGD_READER("call module common methods open");
	    if (0 != (err = module->common.methods->open(hw_mdl, nullptr, &device))) {
	        ALOGD_READER("Can't open fingerprint methods, error: %d", err);
	        continue;//return nullptr;
	    }

	    if (kVersion != device->version) {
	        // enforce version on new devices because of HIDL@2.1 translation layer
	        ALOGD_READER("Wrong fp version. Expected %d, got %d", kVersion, device->version);
	        continue;//return nullptr;
	    }

	    fingerprint_device_t* fp_device =
	        reinterpret_cast<fingerprint_device_t*>(device);

	    if (0 != (err =
	            fp_device->set_notify(fp_device, BiometricsFingerprint::notify))) { 
	        ALOGD_READER("Can't register fingerprint module callback, error: %d", err);
	        continue;//return nullptr;
	    }
        ALOGD_READER("fingerprint HAL successfully initialized, current HMI = %s", fingerprint_hmi_id);
        ALOGD_READER("BIRD_SUPPORT_FP_CHIP:%s  BIRD_SUPPORT_FP_SENSOR:%s ", pvendor_name_config, psensor_name_config);
        return fp_device; //break;
    } //end---->for loop

    ALOGD_READER("for loop out, return NULL");
    return NULL;
}
//# bird wangdong@szba-mobile.com   add end 20180429231314  
#else 
fingerprint_device_t* BiometricsFingerprint::openHal() {
    int err;
    const hw_module_t *hw_mdl = nullptr;
    ALOGD("Opening fingerprint hal library...");
    if (0 != (err = hw_get_module(FINGERPRINT_HARDWARE_MODULE_ID, &hw_mdl))) {
        ALOGE("Can't open fingerprint HW Module, error: %d", err);
        return nullptr;
    }

    if (hw_mdl == nullptr) {
        ALOGE("No valid fingerprint module");
        return nullptr;
    }

    fingerprint_module_t const *module =
        reinterpret_cast<const fingerprint_module_t*>(hw_mdl);
    if (module->common.methods->open == nullptr) {
        ALOGE("No valid open method");
        return nullptr;
    }

    hw_device_t *device = nullptr;

    if (0 != (err = module->common.methods->open(hw_mdl, nullptr, &device))) {
        ALOGE("Can't open fingerprint methods, error: %d", err);
        return nullptr;
    }

    if (kVersion != device->version) {
        // enforce version on new devices because of HIDL@2.1 translation layer
        ALOGE("Wrong fp version. Expected %d, got %d", kVersion, device->version);
        return nullptr;
    }

    fingerprint_device_t* fp_device =
        reinterpret_cast<fingerprint_device_t*>(device);

    if (0 != (err =
            fp_device->set_notify(fp_device, BiometricsFingerprint::notify))) {
        ALOGE("Can't register fingerprint module callback, error: %d", err);
        return nullptr;
    }

    return fp_device;
}
#endif // ---> #if defined(BIRD_FINGERPRINT_OPENHAL_COMPATIBLE_SUPPORT) ...

void BiometricsFingerprint::notify(const fingerprint_msg_t *msg) {
    BiometricsFingerprint* thisPtr = static_cast<BiometricsFingerprint*>(
            BiometricsFingerprint::getInstance());
    std::lock_guard<std::mutex> lock(thisPtr->mClientCallbackMutex);
    if (thisPtr == nullptr || thisPtr->mClientCallback == nullptr) {
        ALOGE("Receiving callbacks before the client callback is registered.");
        return;
    }
    const uint64_t devId = reinterpret_cast<uint64_t>(thisPtr->mDevice);
    switch (msg->type) {
        case FINGERPRINT_ERROR: {
                int32_t vendorCode = 0;
                FingerprintError result = VendorErrorFilter(msg->data.error, &vendorCode);
                ALOGD("onError(%d)", result);
                if (!thisPtr->mClientCallback->onError(devId, result, vendorCode).isOk()) {
                    ALOGE("failed to invoke fingerprint onError callback");
                }
            }
            break;
        case FINGERPRINT_ACQUIRED: {
                int32_t vendorCode = 0;
                FingerprintAcquiredInfo result =
                    VendorAcquiredFilter(msg->data.acquired.acquired_info, &vendorCode);
                ALOGD("onAcquired(%d)", result);
                if (!thisPtr->mClientCallback->onAcquired(devId, result, vendorCode).isOk()) {
                    ALOGE("failed to invoke fingerprint onAcquired callback");
                }
            }
            break;
        case FINGERPRINT_TEMPLATE_ENROLLING:
            ALOGD("onEnrollResult(fid=%d, gid=%d, rem=%d)",
                msg->data.enroll.finger.fid,
                msg->data.enroll.finger.gid,
                msg->data.enroll.samples_remaining);
            if (!thisPtr->mClientCallback->onEnrollResult(devId,
                    msg->data.enroll.finger.fid,
                    msg->data.enroll.finger.gid,
                    msg->data.enroll.samples_remaining).isOk()) {
                ALOGE("failed to invoke fingerprint onEnrollResult callback");
            }
            break;
        case FINGERPRINT_TEMPLATE_REMOVED:
            ALOGD("onRemove(fid=%d, gid=%d, rem=%d)",
                msg->data.removed.finger.fid,
                msg->data.removed.finger.gid,
                msg->data.removed.remaining_templates);
            if (!thisPtr->mClientCallback->onRemoved(devId,
                    msg->data.removed.finger.fid,
                    msg->data.removed.finger.gid,
                    msg->data.removed.remaining_templates).isOk()) {
                ALOGE("failed to invoke fingerprint onRemoved callback");
            }
            break;
        case FINGERPRINT_AUTHENTICATED:
            if (msg->data.authenticated.finger.fid != 0) {
                ALOGD("onAuthenticated(fid=%d, gid=%d)",
                    msg->data.authenticated.finger.fid,
                    msg->data.authenticated.finger.gid);
                const uint8_t* hat =
                    reinterpret_cast<const uint8_t *>(&msg->data.authenticated.hat);
                const hidl_vec<uint8_t> token(
                    std::vector<uint8_t>(hat, hat + sizeof(msg->data.authenticated.hat)));
                if (!thisPtr->mClientCallback->onAuthenticated(devId,
                        msg->data.authenticated.finger.fid,
                        msg->data.authenticated.finger.gid,
                        token).isOk()) {
                    ALOGE("failed to invoke fingerprint onAuthenticated callback");
                }
            } else {
                // Not a recognized fingerprint
                if (!thisPtr->mClientCallback->onAuthenticated(devId,
                        msg->data.authenticated.finger.fid,
                        msg->data.authenticated.finger.gid,
                        hidl_vec<uint8_t>()).isOk()) {
                    ALOGE("failed to invoke fingerprint onAuthenticated callback");
                }
            }
            break;
        case FINGERPRINT_TEMPLATE_ENUMERATING:
            ALOGD("onEnumerate(fid=%d, gid=%d, rem=%d)",
                msg->data.enumerated.finger.fid,
                msg->data.enumerated.finger.gid,
                msg->data.enumerated.remaining_templates);
            if (!thisPtr->mClientCallback->onEnumerate(devId,
                    msg->data.enumerated.finger.fid,
                    msg->data.enumerated.finger.gid,
                    msg->data.enumerated.remaining_templates).isOk()) {
                ALOGE("failed to invoke fingerprint onEnumerate callback");
            }
            break;
    }
}

} // namespace implementation
}  // namespace V2_1
}  // namespace fingerprint
}  // namespace biometrics
}  // namespace hardware
}  // namespace android
