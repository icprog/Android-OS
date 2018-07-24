#!/bin/sh
@echo off
set echo off

echo =====================================
echo "Linux && windows shared push script"  
echo "                                   "
echo "author : Jone.Chen                 "
echo "date   : 2016.10.31                "
echo "version: v03                       " 
echo =====================================
adb root
adb wait-for-device disable-verity
adb remount


set /a a1=dir

if %a1%==0; then
goto windows
else
adb push ./system/  /system/;
adb push ./vendor/  /vendor/;
::adb shell 'chown system:system /system/vendor/sunwave/sf_ta'; \
::adb shell 'chmod +x /system/vendor/sunwave/sf_ta'; \
adb shell "pidof android.hardware.biometrics.fingerprint@2.1-service fingerprintd fpserver | xargs kill"
fi;

exit

:windows
if %a1% == 0 (adb push .\system  /system/)
if %a1% == 0 (adb push .\vendor  /vendor/)
adb shell "pidof android.hardware.biometrics.fingerprint@2.1-service fingerprintd fpserver | xargs kill"
pause


