adb wait-for-device
adb root
adb wait-for-device
adb remount

adb push chipsailing.fingerprint.default.so /vendor/lib/hw/
adb push libfp_tac.so /vendor/lib/
adb push libfp_hal.so /vendor/lib/
adb push libcs_fp_binder.so /vendor/lib/
adb push vendor.chipsailing.fingerprint@1.0.so /vendor/lib/
adb push vendor.chipsailing.fingerprint@1.0-service /vendor/bin/hw
adb push 7778c03fc30c4dd0a319ea29643d4d4b.ta /vendor/thh
pause
adb reboot

