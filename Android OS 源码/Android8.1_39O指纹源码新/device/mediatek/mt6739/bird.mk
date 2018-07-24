# Copyright Statement:
# BIRD Inc. (C) 2010. All rights reserved.
# SunQi add
########################### BIRD ADD BEGAIN ###########################
#MTK PATCH VERSION
PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.mtk_patch_version=alps-mp-o1.mp1-V1

ifneq ($(strip $(BIRD_WITH_DEXPREOPT)),no)
ifneq ($(strip $(TARGET_BUILD_VARIANT)),eng)
WITH_DEXPREOPT:=true
endif
endif

#ifeq ($(strip $(BIRD_DEX2OAT_WHITE_LIST_ENABLE)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk.dex2oat_white_list=com.facebook.katana
#endif

#ningzhiyu LCD density
ifneq ($(strip $(BIRD_LCD_DENSITY)),)
  PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=$(BIRD_LCD_DENSITY)
else
#default  240
  ifeq (720,$(strip $(LCM_WIDTH)))
  PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=320
  else
    ifeq (1080,$(strip $(LCM_WIDTH)))
      PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=480
    else
      PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=240
    endif
  endif
 
endif

#add by lvhuaiyi for SHULIANSHIDAI FOTA
ifeq ($(strip $(BIRD_SHOW_SHULIAN_FOTA_SETTING)), yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.shulian_fota=true
endif
ifeq ($(strip $(BIRD_SHOW_SHULIAN_FOTA)), yes)
	DIGI_FOTA_SUPPORT = true
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.shulian_fota_add=true
	PRODUCT_PACKAGES +=ShuLianFota libkey
endif

#@ {bird:add by fanglongxiang 20170628 begin
ifneq ($(strip $(BIRD_YIYU_SMART)), no)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.yiyu_smart = true
endif 
#@ }

ifneq ($(strip $(BIRD_BOOT_ANIMATION)), )
  PRODUCT_COPY_FILES += \
    bird/logo/boot_animation/$(BIRD_BOOT_ANIMATION).zip:system/media/bootanimation.zip
endif
ifneq ($(strip $(BIRD_SHUTDOWN_ANIMATION)), )
  PRODUCT_COPY_FILES += \
    bird/logo/shut_animation/$(BIRD_SHUTDOWN_ANIMATION).zip:system/media/shutanimation.zip
#ningzhiyu ,add property    
	PRODUCT_PROPERTY_OVERRIDES += \
	ro.bdmisc.shutdown_anim=true
endif
ifneq ($(strip $(BIRD_BOOT_RING)), )
  PRODUCT_COPY_FILES += \
    bird/sounds/boot/$(BIRD_BOOT_RING).mp3:system/media/bootaudio.mp3
endif
ifneq ($(strip $(BIRD_SHUTDOWN_RING)), )
  PRODUCT_COPY_FILES += \
    bird/sounds/shutdown/$(BIRD_SHUTDOWN_RING).mp3:system/media/shutaudio.mp3
endif

ifeq ($(strip $(BIRD_HAS_FLIP_CLAM)), yes)
  PRODUCT_PACKAGES += LeatherLockScreen
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hall_flip_clam=true 
  
  ifeq ($(strip $(BIRD_HALL_WINDOW_SETTINGS)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hall_setting=1
  endif
  
  ifeq ($(strip $(BIRD_HALL_NO_WINDOW)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hall_window_count=0
  endif  
  
  ifeq ($(strip $(BIRD_HALL_WINDOW_BACKGROUND)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hall_ui_bg=1
  endif
  
  #see alps\frameworks\base\core\java\com\bird\hallwindow\BirdHallFeature.java for details
  
  ifneq ($(strip $(BIRD_HALL_TIME_UI)), )
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hall_time_ui=$(strip $(BIRD_HALL_TIME_UI))
    ifeq ($(strip $(BIRD_HALL_TIME_NO_STATUSBAR)), yes)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hall_time_status=false
    endif
  endif
  
  #alarm code is invisible for us
  ifneq ($(strip $(BIRD_HALL_ALARM_UI)), )
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hall_alarm_ui=$(strip $(BIRD_HALL_ALARM_UI))
    ifeq ($(strip $(BIRD_HALL_ALARM_NO_STATUSBAR)), yes)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hall_alarm_status=false
    endif
  endif
  
  ifneq ($(strip $(BIRD_HALL_CALL_UI)), )
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hall_call_ui=$(strip $(BIRD_HALL_CALL_UI))
    ifeq ($(strip $(BIRD_HALL_CALLSCREEN_NO_STATUSBAR)), yes)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hall_call_status=false
    endif
  endif
  
  ifneq ($(strip $(BIRD_HALL_MUSIC_UI)), )
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hall_music_ui=$(strip $(BIRD_HALL_MUSIC_UI))
    ifeq ($(strip $(BIRD_HALL_MUSIC_NO_STATUSBAR)), yes)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hall_music_status=false
    endif
  endif
endif


#bird framework lib
PRODUCT_PACKAGES += \
    libmmitest_jni \
    libengineerproximityjni \
    libfactorytest_jni \
    libproximityjni \
    libgsensor_jni
     

ifdef BIRD_CUSTOM_SW_VERSION
	PRODUCT_PROPERTY_OVERRIDES += \
	ro.bird.custom.sw.version=$(BIRD_CUSTOM_SW_VERSION)
endif

#ningzhiyu 20160411, add test green led in mmitest, factory test
ifeq ($(strip $(BIRD_TEST_GREEN_LED)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.greenled=true
endif
#ningzhiyu 20160411 end

ifeq ($(strip $(BIRD_MMI_AUTO_TEST)), yes)
	PRODUCT_PACKAGES += MMITest
 	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_enable=true
    	PRODUCT_PROPERTY_OVERRIDES += ro.factorytest.headset.ctrl=true
	
	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_OTG)), yes)
		PRODUCT_PACKAGES += OTG_host_permission
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_otg=true  
	endif
	    
	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_GPS)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_gps=true
	endif
#ningzhiyu 20160421
	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_GPS_MANUAL_CHECK)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_gps_man_check=true
	endif	    
	    
	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_SENSOR)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_sensor=true
	endif    
	
	#add by liuchaofei 20170328
	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_SENSOR_NO_ANIM)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_sensor_no_anim=true
	endif

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_LIGHT_SENSOR)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_l_sensor=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_SENSOR_Z)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_z_sensor=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_LED)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_led=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_WIFI)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_wifi=true
	endif    


	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_FLASHLIGHT)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_flashlight=true
	endif    
	  
	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_SUB_CAMERA)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_sub_camera=true
	endif    
	  
	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_ACCELERATION)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_g_sensor=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_FM)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_fm=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_PROXIMITY)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_ps=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_BT)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_bt=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_MAIN_CAMERA)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_main_camera=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_TOUCH)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_touch=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_HEADSET)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_headset=true
	    	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_hs_ctrl=true	
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_HALL)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_hall=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_NFC)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_nfc=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_COMPASS)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_m_sensor=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_GYROSCOPE)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_gyroscope=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_KEYBOARDLED)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_m_kb_led=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_LCD_TAP)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_lcd_tap=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_TIPLAMP)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_tiplamp=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_FINGERPRINT)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_fingerprint=true
	endif    
	
	#add by lichengfeng 2015/10/27 ,finger print test with picture  begin 
	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_FINGERPRINT_WITH_PICTURE)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_fp_picture=true
	endif  
	#add by lichengfeng 2015/10/27 ,finger print test with picture  end 	

	ifeq ($(strip $(BIRD_MMITEST_TPDRAW_FWVGA)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_tpdraw_fwvga=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_DIAL112)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_dial112=true
	endif    

	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_BATTERY_ID)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_bat_id=true
	endif
    
        ifeq ($(strip $(BIRD_MMI_TEST_KEYBOARD_SAMSUNG)), yes)
                PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_samsung=true
        endif
	
	#bird:factory Test for backupCamera,liuchaofei@20170219{
	ifdef BIRD_MMI_BACKUPCAMERA
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmi_backup_camera=$(strip $(BIRD_MMI_BACKUPCAMERA))
	endif
	
	ifeq ($(strip $(BIRD_MMI_BACKUPCAMERA_FD)),yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmi_backupcamera_fd = true
	endif
	#@}
endif

ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST)), yes)
  PRODUCT_PACKAGES += FactoryTest
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_enable=true

	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_OTG)), yes)
		PRODUCT_PACKAGES += FactoryOTG_host_permission
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_otg=true
	endif

	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_PRODUCT_LINE)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_product_line=true
	endif

	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_FM)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_fm=true
	endif

	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_CAM)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_main_camera=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_PRODUCT_LINE)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_product_line=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_SUBCAM)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_sub_camera=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_BATTERY_TEM)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_battery_tem=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_KEY)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_key=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_KEY_HOME)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_key_home=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_KEY_MENU)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_key_menu=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_KEY_BACK)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_key_back=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_KEY_SEARCH)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_key_search=true
	endif

	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_KEY_CAMERA)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_key_camera=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_KEY_FUN1)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_key_fun1=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_KEY_MUTE)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_key_mute=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_TIPLAMP)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_tiplamp=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_FINGERPRINT)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_fingerprint=true
	endif
	
	#add by lichengfeng 2015/11/10 ,finger print test with picture in FactoryTest begin 
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_FINGERPRINT_WITH_PICTURE)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_fp_picture=true
	endif  
	#add by lichengfeng 2015/10/27 ,finger print test with picture in FactoryTest end	
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_GSENSOR)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_g_sensor=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_MSENSOR)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_m_sensor=true
	endif

	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_BT)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_bt=true
	endif

	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_WIFI)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_wifi=true
	endif

	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_GPS)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_gps=true
	endif

	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_ALSPS)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_alsps=true
	endif

	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_HALL)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_hall=true
	endif

	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_NFC)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_nfc=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_GYROSCOPE)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_gyroscope=true
	endif
	  
	ifeq ($(strip $(BIRD_FACTORY_POWERON_TEST_KEYBOARDLED)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_kb_led=true
	endif
      
        ifeq ($(strip $(BIRD_MMI_TEST_KEYBOARD_SAMSUNG)), yes)
                PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_samsung=true
        endif
	  
	ifeq ($(strip $(BIRD_FACTORY_AUTO_TEST_HEADSET)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_headset=true
	endif
	
	ifeq ($(strip $(BIRD_FACTORY_AUTO_TEST_MMI_KEY)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_mmi_keyboard=true
	endif
	
	ifeq ($(strip $(BIRD_MMI_AUTO_TEST_SENSOR_Z)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_z_sensor=true
	endif    

	ifeq ($(strip $(BIRD_FACTORY_GSENSOR_FD)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_gsensor_fd=true
	endif 

	ifeq ($(strip $(BIRD_FACTORY_BATTERY_FD)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_battery_fd=true
	endif 
	
	#bird:factory Test for backupCamera,liuchaofei@20170219{
	ifdef BIRD_FACTORY_TEST_BACKUPCAMERA
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_backup_camera=$(strip $(BIRD_FACTORY_TEST_BACKUPCAMERA))
	endif
	
	ifeq ($(strip $(BIRD_FACTORY_BACKUPCAMERA_FD)), yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ft_backupcamera_fd=true
	endif
	#@}
  
endif

ifeq ($(strip $(MTK_DUAL_MIC_SUPPORT)), yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.dual_mic=true
endif

# turn off screen by timer  in call screen, ningzhiyu 20150506
ifeq ($(strip $(BIRD_TURN_OFF_SCREEN_BY_TIMER)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.scr_off_by_timer=true
endif

# lightsensor , proximity setting menu/quick settings. bird ningzhiyu 20150513
ifeq ($(strip $(BIRD_NO_PROXIMITY_SENSOR)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.no_proximity=true
endif
ifeq ($(strip $(BIRD_NO_LIGHT_SENSOR)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.no_lightsensor=true
endif

#ningzhiyu 20150528
ifeq ($(strip $(BIRD_MORE_APP)), yes)
PRODUCT_PACKAGES += MoreAppBird
ifeq ($(strip $(BIRD_MORE_APP_DISABLE_RESTRICTMODE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.strict_moreapp=false
endif
endif

# @ { BIRD jiali 20160727, Lunar Calendar for zh-cn begin
PRODUCT_PACKAGES += com.mediatek.calendar.ext
PRODUCT_PACKAGES += LunarPlugin
# @ }

#bird: chengting,@20180123 {
ifneq ($(strip $(BIRD_WRITE_IMEI)), no)
  PRODUCT_PACKAGES += WriteIMEIWithRecovery
endif
#@}
# set default fontsize by meifangting 20150530 
#value:small normal large extralarge
ifneq ($(strip $(BIRD_DEFAULT_FONT_SIZE)), )
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.font_size_def=$(BIRD_DEFAULT_FONT_SIZE)
endif


#[BIRD_DIRECT_WITH_PROXIMITY][20150119],chengting
#0 means no
#1 means yes,and default unchecked
#2 means yes,and default checked
#except BIRD_DIRECT_ANSWER_CALL_WITH_SPEAKER_OFF,2 means speaker off when direct answer call,otherwise speaker will auto on when direct answer call
ifneq ($(strip $(BIRD_DIRECT_WITH_PROXIMITY)), )
ifneq ($(strip $(BIRD_DIRECT_WITH_PROXIMITY)), 0)
    PRODUCT_PACKAGES += Direct
    
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct= $(strip $(BIRD_DIRECT_WITH_PROXIMITY))
    
    ifneq ($(strip $(BIRD_DIRECT_SEND_CALL)),)
    ifneq ($(strip $(BIRD_DIRECT_SEND_CALL)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_mms_call=$(strip $(BIRD_DIRECT_SEND_CALL))
    endif
    endif
    
    ifneq ($(strip $(BIRD_DIRECT_CONTACT_CALL)),)
    ifneq ($(strip $(BIRD_DIRECT_CONTACT_CALL)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_contact_call=$(strip $(BIRD_DIRECT_CONTACT_CALL))
    endif
    endif
    
    ifneq ($(strip $(BIRD_DIRECT_ANSWER_CALL)),)
    ifneq ($(strip $(BIRD_DIRECT_ANSWER_CALL)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_answer_call=$(strip $(BIRD_DIRECT_ANSWER_CALL))
    endif
    endif
    
    ifneq ($(strip $(BIRD_DIRECT_ANSWER_CALL_WITH_SPEAKER_OFF)),)
    ifneq ($(strip $(BIRD_DIRECT_ANSWER_CALL_WITH_SPEAKER_OFF)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_speaker_off=$(strip $(BIRD_DIRECT_ANSWER_CALL_WITH_SPEAKER_OFF))
    endif
    endif
    
    ifneq ($(strip $(BIRD_DIRECT_SHAKE_TO_ANSWER)),)
    ifneq ($(strip $(BIRD_DIRECT_SHAKE_TO_ANSWER)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_shake_answer=$(strip $(BIRD_DIRECT_SHAKE_TO_ANSWER))
    endif
    endif
    
    ifneq ($(strip $(BIRD_GESTURE_UNLOCK)),)
    ifneq ($(strip $(BIRD_GESTURE_UNLOCK)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_unlock=$(strip $(BIRD_GESTURE_UNLOCK))
    endif
    endif
    
    ifneq ($(strip $(BIRD_SHAKE_CHANGE_WALLPAPER)),)
    ifneq ($(strip $(BIRD_SHAKE_CHANGE_WALLPAPER)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_shake_wallpaper=$(strip $(BIRD_SHAKE_CHANGE_WALLPAPER))
    endif
    endif
    
    ifneq ($(strip $(BIRD_SHAKE_CHANGE_WALLPAPER_SOUND)),)
    ifneq ($(strip $(BIRD_SHAKE_CHANGE_WALLPAPER_SOUND)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_wallpaper_sound=$(strip $(BIRD_SHAKE_CHANGE_WALLPAPER_SOUND))
    endif
    endif
    
    ifneq ($(strip $(BIRD_LAUNCHER3_SERSOR_SNAP)),)
    ifneq ($(strip $(BIRD_LAUNCHER3_SERSOR_SNAP)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_launcher3_snap=$(strip $(BIRD_LAUNCHER3_SERSOR_SNAP))
    endif
    endif
    
    ifneq ($(strip $(BIRD_CAMERA_SERSOR_SNAP)),)
    ifneq ($(strip $(BIRD_CAMERA_SERSOR_SNAP)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_camera_snap=$(strip $(BIRD_CAMERA_SERSOR_SNAP))
    endif
    endif
    
    ifneq ($(strip $(BIRD_MUSIC_SERSOR_SNAP)),)
    ifneq ($(strip $(BIRD_MUSIC_SERSOR_SNAP)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_music_snap=$(strip $(BIRD_MUSIC_SERSOR_SNAP))
    endif
    endif
    
    ifneq ($(strip $(BIRD_GALLERY_SERSOR_SNAP)),)
    ifneq ($(strip $(BIRD_GALLERY_SERSOR_SNAP)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_gallery_snap=$(strip $(BIRD_GALLERY_SERSOR_SNAP))
    endif
    endif
endif
endif

#BIRD_DEFAULT_TIME_FORMAT_24 add by peibaosheng @20120713 begin
ifeq ($(strip $(BIRD_DEFAULT_TIME_FORMAT_24)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.timeformat_24=true
endif
#BIRD_DEFAULT_TIME_FORMAT_24 add by peibaosheng @20120713 end

#BIRD_TP_SMART_WAKE:wangfei 20131227 begin
#0 means no
#1 means yes,and default unchecked
#2 means yes,and default checked
#except BIRD_TP_SMART_WAKE_QUICK_GESTURE,0 means default type(by wangfei),1 means apps can be customed by user(by chengting)
ifneq ($(strip $(BIRD_TP_SMART_WAKE)), )
ifneq ($(strip $(BIRD_TP_SMART_WAKE)), 0)
  PRODUCT_PACKAGES += MotionRecognition
  
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake= $(strip $(BIRD_TP_SMART_WAKE))
  
  SMART_WAKE_PIC_PATH_PREFIX := bird/smartwake/
  ifeq ($(strip $(BIRD_TP_SMART_WAKE_ANIMA_SMALL)),yes)
      SMART_WAKE_PIC_PATH := $(addprefix $(SMART_WAKE_PIC_PATH_PREFIX),small)
  else ifeq ($(strip $(LCM_HEIGHT)),1920)
      SMART_WAKE_PIC_PATH := $(addprefix $(SMART_WAKE_PIC_PATH_PREFIX),fhd)
  else ifeq ($(strip $(LCM_HEIGHT)),1280)
      SMART_WAKE_PIC_PATH := $(addprefix $(SMART_WAKE_PIC_PATH_PREFIX),hd)
  else ifeq ($(strip $(LCM_HEIGHT)),960)
      SMART_WAKE_PIC_PATH := $(addprefix $(SMART_WAKE_PIC_PATH_PREFIX),qhd)
  else
      SMART_WAKE_PIC_PATH := $(addprefix $(SMART_WAKE_PIC_PATH_PREFIX),hdpi)
  endif

  define copy-all-png-files
  $(strip \
    $(if $(shell ls $(SMART_WAKE_PIC_PATH)), \
        $(foreach pic, $(shell ls $(SMART_WAKE_PIC_PATH)/$(strip $(1)) | grep -i '.png'), \
            $(SMART_WAKE_PIC_PATH)/$(strip $(1))/$(pic):system/usr/sw/$(strip $(1))/$(pic)) \
        , \
        $(error $(SMART_WAKE_PIC_PATH) doesn't exist) ) \
  )
  endef
  
  ifneq ($(strip $(BIRD_TP_SMART_WAKE_QUICK_GESTURE)),)
  ifneq ($(strip $(BIRD_TP_SMART_WAKE_QUICK_GESTURE)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_setting=$(strip $(BIRD_TP_SMART_WAKE_QUICK_GESTURE))
  endif
  endif
  
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_DOUBLETAP)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_DOUBLETAP)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_2tap=$(strip $(BIRD_TP_SMART_GESTURE_DOUBLETAP))
  endif
  endif
  
# bird: screen off by double tap, peibaosheng @20170418 {
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_DOUBLETAP_OFF)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_DOUBLETAP_OFF)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_2tap_off=$(strip $(BIRD_TP_SMART_GESTURE_DOUBLETAP_OFF))
  endif
  endif
# @}
  
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_SLIDE_LEFT)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_SLIDE_LEFT)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_left=$(strip $(BIRD_TP_SMART_GESTURE_SLIDE_LEFT))
    PRODUCT_COPY_FILES += $(call copy-all-png-files, slide_left)
  endif
  endif
  
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_SLIDE_RIGHT)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_SLIDE_RIGHT)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_right=$(strip $(BIRD_TP_SMART_GESTURE_SLIDE_RIGHT))
    PRODUCT_COPY_FILES += $(call copy-all-png-files, slide_right)
  endif
  endif
  
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_SLIDE_UP)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_SLIDE_UP)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_up=$(strip $(BIRD_TP_SMART_GESTURE_SLIDE_UP))
    PRODUCT_COPY_FILES += $(call copy-all-png-files, slide_up)
  endif
  endif

  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_SLIDE_DOWN)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_SLIDE_DOWN)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_down=$(strip $(BIRD_TP_SMART_GESTURE_SLIDE_DOWN))
    PRODUCT_COPY_FILES += $(call copy-all-png-files, slide_down)
  endif
  endif
  
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_C)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_C)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_c=$(strip $(BIRD_TP_SMART_GESTURE_C))
    PRODUCT_COPY_FILES += $(call copy-all-png-files, gesture_c)
  endif
  endif

  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_E)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_E)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_e=$(strip $(BIRD_TP_SMART_GESTURE_E))
    PRODUCT_COPY_FILES += $(call copy-all-png-files, gesture_e)
  endif
  endif
  
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_M)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_M)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_m=$(strip $(BIRD_TP_SMART_GESTURE_M))
    PRODUCT_COPY_FILES += $(call copy-all-png-files, gesture_m)
  endif
  endif
  
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_O)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_O)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_o=$(strip $(BIRD_TP_SMART_GESTURE_O))
    PRODUCT_COPY_FILES += $(call copy-all-png-files, gesture_o)
  endif
  endif
  
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_S)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_S)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_s=$(strip $(BIRD_TP_SMART_GESTURE_S))
    PRODUCT_COPY_FILES += $(call copy-all-png-files, gesture_s)
  endif
  endif
  
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_V)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_V)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_v=$(strip $(BIRD_TP_SMART_GESTURE_V))
    PRODUCT_COPY_FILES += $(call copy-all-png-files, gesture_v)
  endif
  endif
  
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_W)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_W)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_w=$(strip $(BIRD_TP_SMART_GESTURE_W))
    PRODUCT_COPY_FILES += $(call copy-all-png-files, gesture_w)
  endif
  endif
  
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_Z)),)
  ifneq ($(strip $(BIRD_TP_SMART_GESTURE_Z)),0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.tpwake_z=$(strip $(BIRD_TP_SMART_GESTURE_Z))
    PRODUCT_COPY_FILES += $(call copy-all-png-files, gesture_z)
  endif
  endif
endif
endif
#BIRD_TP_SMART_WAKE:wangfei 20131227 end

#ningzhiyu ro.bdfun.tpwake_unlock
ifeq ($(strip $(BIRD_TP_WAKE_UNLOCK)),yes)
   PRODUCT_PROPERTY_OVERRIDES += \
				ro.bdfun.tpwake_unlock=true
endif

# torch app
ifeq ($(strip $(BIRD_TORCH)), yes)
  PRODUCT_PACKAGES += Torch
endif

#shenzhiwang
#ifeq ($(strip $(BIRD_SIGNAL_TYPE)), tdd)
#    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.bird_signal_type=tdd
#else
#    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.bird_signal_type=fdd
#endif

ifeq ($(strip $(BIRD_HARDWARE)),yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.bird_hardware = true
endif

ifeq ($(strip $(BIRD_GEMINI_DEFAULT_DATA_ON)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.auto_cellular_data=true
endif
ifeq ($(strip $(BIRD_GEMINI_DEFAULT_DATA_ON_ALWAYS)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.always_cellular_data=true
endif

#handle special char add by meifangting 20150604
PRODUCT_PACKAGES += BirdSpecialCharMgr


#add by meifangting 
ifeq ($(strip $(BIRD_VIBRATE_WHEN_RINGING)),yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.vibrate_when_ringing=true
endif
#default timezone,chengting
ifneq ($(strip $(BIRD_DEFAULT_TIMEZONE)), )
    PRODUCT_PROPERTY_OVERRIDES += persist.sys.timezone=$(BIRD_DEFAULT_TIMEZONE)
endif
#add by liuzhiling 20160707 begin
ifeq ($(strip $(BIRD_TWO_TAB_SETTINGS)),yes) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.two_tab_settings = true
endif
#add by liuzhiling 20160707 end
#lockscreen_weather_anim default on
ifeq ($(strip $(BIRD_LOCKWEATHER_ANIM_DEFAULT_ON)),yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sptqdh_default_on=true
endif

#psensor & gsensor calibration,chengting,@20150404
ifeq ($(strip $(BIRD_PROXIMITY_CALIBRATION)),yes)
  PRODUCT_PACKAGES += libproximityjni
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.psensor_calibrate=true
endif

ifeq ($(strip $(BIRD_GSENSOR_CALIBRATION)),yes)
  PRODUCT_PACKAGES += libgsensor_jni
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gsensor_calibrate=true
endif

#remove aged settings add by meifangting 20140629
ifeq ($(strip $(BIRD_REMOVE_AGEDMODE)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.remove_agedmode=true
endif

ifeq ($(strip $(BIRD_MULTI_TOUCH)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.multi_touch=true
endif
ifeq ($(strip $(BIRD_2POINT_TOUCH_VK)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.2p_touch_vk=true
endif
ifeq ($(strip $(BIRD_3POINT_TOUCH_SCREENSHOT)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.3p_touch_screenshot=true
endif

ifeq ($(strip $(BIRD_BATTERY_PERCENTAGE)),yes)
    ##PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.battery_percentage=2
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.bird_battery_percent=true
endif
#hide highcontrast
ifeq ($(strip $(BIRD_HIDE_HIGHCONTRAST)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.hide_hightcontrast=true
endif

ifeq ($(strip $(BIRD_TOTAL2USED)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.total2used=true
endif

#bwrite, add by shenzhiwang
  PRODUCT_PACKAGES += bwrite
#bwrite

#add by shenzhiwnag, 20150507
#PRODUCT_COPY_FILES += device/mediatek/mt6735/bird.prop:cache/recovery/last_bird.prop

ifeq ($(strip $(BIRD_CUSTOM_ROAM)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.custom_roam=true
endif
ifeq ($(strip $(BIRD_CUSTOM_ROAM_NEW)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.custom_roam_new=true
endif

ifneq ($(strip $(BIRD_FAKE_ADDING_RAM_SIZE)),) 
    PRODUCT_PROPERTY_OVERRIDES +=ro.bdfun.adding_ram_size=$(BIRD_FAKE_ADDING_RAM_SIZE)
endif
ifneq ($(strip $(BIRD_FAKE_INTERNAL_ROM_SIZE)),) 
    PRODUCT_PROPERTY_OVERRIDES +=ro.bdfun.internal_rom_size=$(BIRD_FAKE_INTERNAL_ROM_SIZE)
endif
ifneq ($(strip $(BIRD_FAKE_PHONE_ROM_SIZE)),) 
    PRODUCT_PROPERTY_OVERRIDES +=ro.bdfun.phone_rom_size=$(BIRD_FAKE_PHONE_ROM_SIZE)
endif
#add by liuchaofei ,BIRD_FAKE_SYSTEM_ROM_SIZE 20160822 begin 
ifneq ($(strip $(BIRD_FAKE_SYSTEM_ROM_SIZE)),) 
    PRODUCT_PROPERTY_OVERRIDES +=ro.bdfun.system_rom_size=$(BIRD_FAKE_SYSTEM_ROM_SIZE)
endif
#add by liuchaofei ,BIRD_FAKE_SYSTEM_ROM_SIZE 20160822 begin 
ifeq ($(strip $(BIRD_TOTAL_SYSTEM_MEMORY)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.total_system_memory=true
endif

ifeq ($(strip $(BIRD_NO_INSTALL_LOCATION)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.no_install_location=true
endif

ifeq ($(strip $(BIRD_APP_INSTALL_LOCATION)),auto)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.app_install_location=0
else ifeq ($(strip $(BIRD_APP_INSTALL_LOCATION)),internal)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.app_install_location=1
else ifeq ($(strip $(BIRD_APP_INSTALL_LOCATION)),external)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.app_install_location=2
endif

#BIRD_RENAME_ALI_EXPERIENCE add by qinzhifeng 20151225 begin
ifeq ($(strip $(BIRD_RENAME_ALI_EXPERIENCE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.rename_ali_experience=true
endif
#BIRD_RENAME_ALI_EXPERIENCE add by qinzhifeng 20151225 end

#BIRD_SURPORT_SHUTDOWN_ANIMATION add by qinzhifeng 20151228 begin
ifeq ($(strip $(BIRD_SURPORT_SHUTDOWN_ANIMATION)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.surport_shut_anima=true
endif
#BIRD_SURPORT_SHUTDOWN_ANIMATION add by qinzhifeng 20151228 end

#hardware info, add start by shenzhiwang, @ 20151225
ifneq ($(strip $(BIRD_HARDWARE_INFO)),no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hardware_info=true
    PRODUCT_PACKAGES += HardwareInfo
endif
#hardware info, add end by shenzhiwang, @ 20151225

#BIRD_ADD_HOTKNOT add by qinzhifeng 20151231 begin
ifeq ($(strip $(BIRD_ADD_HOTKNOT)), no)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.add_hotknot=false
endif
#BIRD_ADD_HOTKNOT add by qinzhifeng 20151231 end

#add by zhouleigang
ifeq ($(strip $(BIRD_SLIDE_NAVIGATIONBAR)),yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.slide_navigationbar = true 
endif

#add by fangbin 20151015
ifeq ($(strip $(BIRD_STATUSBAR_AMPM_TYPE)), normal)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.statusbar_ampm_style=0
else ifeq ($(strip $(BIRD_STATUSBAR_AMPM_TYPE)), small)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.statusbar_ampm_style=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.statusbar_ampm_style=2
endif


#BIRD_STATUS_DATA_CONNECTION_SWITCH add by qinzhifeng 20151020 begin
ifeq ($(BIRD_STATUS_DATA_CONNECTION_SWITCH), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdui.status_data_connection=true
endif
#BIRD_STATUS_DATA_CONNECTION_SWITCH add by qinzhifeng 20151020 end
#add by hanyang begin 20151015


#BIRD_DOOV_WALLPAPER_NOBG add by lichengfeng 2016/01/06 for fix bug #9427 begin
ifeq ($(strip $(BIRD_DOOV_WALLPAPER_NOBG)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.doov_wallpaper_nobg=true
endif
#BIRD_DOOV_WALLPAPER_NOBG add by lichengfeng 2016/01/06 for fix bug #9427 end

#BIRD_ALIXIAOYUN_NAME_CHANGED add by lichengfeng 2016/01/06 change AliXiaoYun DeskTop name begin
ifeq ($(strip $(BIRD_ALIXIAOYUN_NAME_CHANGED)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.alixiaoyun_name=true
endif
#BIRD_ALIXIAOYUN_NAME_CHANGED add by lichengfeng 2016/01/06 change AliXiaoYun DeskTop name end

########################### CAMERA ADD BEGAIN ###########################
ifneq ($(strip $(BIRD_CAM_FACEBEAUTY)), ) 
PRODUCT_PROPERTY_OVERRIDES += persist.FfaceBeauty.valuse=$(BIRD_CAM_FACEBEAUTY) 
endif

#[BIRD_SWITCH_FOR_CAMERA][20150909],zhumingjun begin
ifeq ($(strip $(BIRD_CAMERA_SCAN)),yes) 
PRODUCT_PROPERTY_OVERRIDES +=persist.scan=true
else
PRODUCT_PROPERTY_OVERRIDES +=persist.scan=false
endif

ifeq ($(strip $(BIRD_CAMERA_FAKEFOCUS)),yes) 
PRODUCT_PROPERTY_OVERRIDES +=persist.FakeFocus=true
else
PRODUCT_PROPERTY_OVERRIDES +=persist.FakeFocus=false
endif
#[BIRD_SWITCH_FOR_CAMERA][20150909],zhumingjun end

ifeq ($(strip $(BIRD_PREFERRED_NETWORKS_MENU)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.pref_networks_menu=true
  ifneq ($(strip $(BIRD_PREFERRED_NETWORKS_MENU_CONFIG)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.network_menu_cfg=$(BIRD_PREFERRED_NETWORKS_MENU_CONFIG)
  endif
endif

ifeq ($(strip $(BIRD_CAMERA_NO_SIZE)),yes) 
PRODUCT_PROPERTY_OVERRIDES +=persist.ratio=true
else
PRODUCT_PROPERTY_OVERRIDES +=persist.ratio=false
endif
########################### CAMERA ADD END ###########################
#BIRD_ADD_HOTKNOT_NOTIFICATION_ICON add by caizhaohui 20160108 begin
ifeq ($(strip $(BIRD_ADD_HOTKNOT_NOTIFICATION_ICON)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hotknot_notice_icon=true
endif
#BIRD_ADD_HOTKNOT_NOTIFICATION_ICON add by caizhaohui 20160108 end
#BIRD_ADD_HOTKNOT_QUICK_SETTING add by caizhaohui 20160108 begin
ifeq ($(strip $(BIRD_ADD_HOTKNOT_QUICK_SETTING)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hotknot_quick_set=true
endif
#BIRD_ADD_HOTKNOT_QUICK_SETTING add by caizhaohui 20160108 end

ifeq ($(strip $(BIRD_BACKUP_IMEI)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.backup_imei=true
endif

#BIRD_RM_CAMERA_SCAN add by qinzhifeng 20160114 begin
ifeq ($(strip $(BIRD_RM_CAMERA_SCAN)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.rm_camera_scan=true
endif
#BIRD_RM_CAMERA_SCAN add by qinzhifeng 20160114 end

#BIRD_RM_FACE_UNLOCK add by qinzhifeng 20160115 begin
ifeq ($(strip $(BIRD_RM_FACE_UNLOCK)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.rm_face_unlock=true
endif
#BIRD_RM_FACE_UNLOCK add by qinzhifeng 20160115 end

#BIRD_RM_POWER_SWITCH_MUSIC add by qinzhifeng 20160115 begin
ifeq ($(strip $(BIRD_RM_POWER_SWITCH_MUSIC)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.rm_power_switch_music=true
  PRODUCT_PROPERTY_OVERRIDES += persist.sys.bootmusic=0
endif
#BIRD_RM_POWER_SWITCH_MUSIC add by qinzhifeng 20160115 end

#BIRD_NEW_NOTIFICATION_STYLE add by qinzhifeng 20160111 begin
ifneq ($(strip $(BIRD_NEW_NOTIFICATION_STYLE)), no)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.new_notification_style=true
  BIRD_NEW_NOTIFICATION_STYLE = yes
endif
#BIRD_NEW_NOTIFICATION_STYLE add by qinzhifeng 20160111 end

#BIRD_DEFAULT_POWER_SWITCH_MUSIC add by qinzhifeng 20160115 begin
ifeq ($(strip $(BIRD_DEFAULT_POWER_SWITCH_MUSIC)), yes)
  PRODUCT_PROPERTY_OVERRIDES += persist.sys.bootmusic=1
else
  PRODUCT_PROPERTY_OVERRIDES += persist.sys.bootmusic=0
endif
#BIRD_DEFAULT_POWER_SWITCH_MUSIC add by qinzhifeng 20160115 end
#BIRD_3POINT_TOUCH_SCREENSHOT_DEFAULT_OFF add by caizhaohui 20160125 begin
ifeq ($(strip $(BIRD_3POINT_TOUCH_SCREENSHOT_DEFAULT_OFF)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.3p_screenshot_off=true
endif
#BIRD_3POINT_TOUCH_SCREENSHOT_DEFAULT_OFF add by caizhaohui 20160125 end

#BIRD_FREE2USED, add by shenzhiwang, 20160125
ifeq ($(strip $(BIRD_FREE2USED)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.free2used=true
endif

#BIRD_DOOV_WIDGET add by qinzhifeng 20160120 begin
ifeq ($(strip $(BIRD_DOOV_WIDGET)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.bird_doov_widget=true
endif
#BIRD_DOOV_WIDGET add by qinzhifeng 20160120 end

#ifeq ($(strip $(BIRD_FILES_PRESET)),phone)
#    ifeq ($(strip $(BIRD_DOOV_FILES_PRESET)),yes)
#       PRODUCT_COPY_FILES += bird/doov_resource/DOOV.mp4:system/custom/DOOV.mp4
#       PRODUCT_COPY_FILES += bird/doov_resource/Yidali_Wuyucun.jpg:system/custom/Yidali_Wuyucun.jpg
#       PRODUCT_COPY_FILES += bird/doov_resource/BingFengShuiGuo.jpg:system/custom/BingFengShuiGuo.jpg
#       PRODUCT_COPY_FILES += bird/doov_resource/DieNianHua.jpg:system/custom/DieNianHua.jpg
#   endif
#endif
#BIRD_DOOV_LAUNCHER_STYLE add by qinzhifeng 20160201 begin
ifeq ($(strip $(BIRD_DOOV_LAUNCHER_STYLE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.doov_launcher_style=true
endif
#BIRD_DOOV_LAUNCHER_STYLE add by qinzhifeng 20160201 end

#ningzhiyu 20160201. begin
ifneq ($(strip $(BIRD_FORBID_MO_CALL_BATTERY_LEVEL)), )
PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.call_bat_level = $(BIRD_FORBID_MO_CALL_BATTERY_LEVEL)
endif
#ningzhiyu 20160201. end

#add by fangbin begin
ifeq ($(strip $(BIRD_CAMERA_LOW_POWER_WARNING)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.low_power_warning = true
endif
ifeq ($(strip $(BIRD_LOW_BATTERY_REMINDER_LEVEL)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.battery_reminder_lv = true
endif
ifneq ($(strip $(BIRD_SHUTDOWN_BATTERY_VOL)), )
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.shutdown_battery_vol = $(BIRD_SHUTDOWN_BATTERY_VOL)
endif

ifneq ($(strip $(BIRD_FILES_PRESET)), )
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.files_preset_loc = $(BIRD_FILES_PRESET)
endif

#add by fangbin end
#BIRD_LOCKSCREEN_SUNSHINE_MODE_SHOW add by caizhaohui 20160217 begin
ifeq ($(strip $(BIRD_LOCKSCREEN_SUNSHINE_MODE_SHOW)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ls_sunshine_show=true
endif
#BIRD_LOCKSCREEN_SUNSHINE_MODE_SHOW add by caizhaohui 20160217 end

#BIRD_ANSWER_CALL_WITHOUT_UNLOCK_SOUND add by lichengfeng for fix BUG #10182 begin
ifeq ($(strip $(BIRD_ANSWER_CALL_WITHOUT_UNLOCK_SOUND)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.a_call_w_u_sound=true
endif
#BIRD_ANSWER_CALL_WITHOUT_UNLOCK_SOUND add by lichengfeng for fix BUG #10182 end

#add by lichengfeng change the way to show hideseat from long press fingerprint to click @20160219 begin
ifeq ($(strip $(BIRD_OPEN_HIDESEAT_BY_CLICK_FINGERPRINT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.o_hs_by_click_fp=true
endif
#add by lichengfeng change the way to show hideseat from long press fingerprint to click @20160219 end
#BIRD_REMOVE_SIP_CALL_MENU add by caizhaohui 20160225 begin
ifeq ($(strip $(BIRD_REMOVE_SIP_CALL_MENU)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.rm_sip_call_menu=true
endif
#BIRD_REMOVE_SIP_CALL_MENU add by caizhaohui 20160225 end

#bird ningzhiyu 20160225
ifeq ($(strip $(BIRD_ENABLE_DOUBLE_TAP_STATUSBAR_GOTO_SLEEP)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.2tap_stat_sleep=true
endif

#add by lichengfeng doov mms flyeggs open @20160227 begin
ifeq ($(strip $(BIRD_DOOV_MMS_FLYEGGS_OPEN)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.d_m_flyeggs_open=true
endif
#add by lichengfeng doov mms flyeggs open @20160227 end

#add by fangbin for doov mmitest begin
ifeq ($(strip $(BIRD_MMITEST_BLUETOOTH_FD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmitest_bluetooth_fd=true
endif
ifeq ($(strip $(BIRD_MMITEST_GPS_FD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmitest_gps_fd=true
endif
ifeq ($(strip $(BIRD_MMITEST_KEYBOARD_FD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmitest_keyboard_fd=true
endif
ifeq ($(strip $(BIRD_MMITEST_DOOV_TEST_SENSOR)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.doov_test_sensor=true
endif
ifeq ($(strip $(BIRD_MMITEST_DOOV_MIC_TEST)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.doov_mic_test=true
endif

ifeq ($(strip $(BIRD_MMITEST_DOOV_SMT_BT_FT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.doov_smt_bt_ft=true
endif

ifeq ($(strip $(BIRD_MMITEST_OTG_FD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmitest_otg_fd=true
endif

ifeq ($(strip $(BIRD_MMITEST_HALL_FD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmitest_hall_fd=true
endif

ifeq ($(strip $(BIRD_MMITEST_FINGERPRINT_FD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmit_fingerprint_fd=true
endif

ifeq ($(strip $(BIRD_MMITEST_MP3_RES)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmitest_mp3_res=true
endif

ifeq ($(strip $(BIRD_MMI_TFLASH_FD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmi_tflash_fd=true
endif

ifeq ($(strip $(BIRD_MMI_PSENSOR_FD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmi_psensor_fd=true
endif

ifeq ($(strip $(BIRD_MMI_BACKLIGHT_FD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmi_backlight_fd=true
endif

ifeq ($(strip $(BIRD_MMI_MIC_FD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmi_mic_fd=true
endif

ifeq ($(strip $(BIRD_MMI_HEADSETKEY_FD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmi_headsetkey_fd=true
endif

ifeq ($(strip $(BIRD_SINGLE_SIM_ONLY)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.single_sim=true
endif

#add by fangbin for doov mmitest end
#BIRD_SHARE_SDCARD_SHOW_INTERNAL_STORAGE add by caizhaohui 20160301 begin
ifeq ($(strip $(BIRD_SHARE_SDCARD_SHOW_INTERNAL_STORAGE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_interal_storused=true
endif
#BIRD_SHARE_SDCARD_SHOW_INTERNAL_STORAGE add by caizhaohui 20160301 end

#BIRD_DOOV_SOUND add by qinzhifeng 20160304 begin
ifeq ($(strip $(BIRD_DOOV_SOUND)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.doov_sound=true
endif
#BIRD_DOOV_SOUND add by qinzhifeng 20160304 end

#add by lichengfeng for fix TASK #7676 Silent model call remainder @20160321 begin
ifeq ($(strip $(BIRD_NO_MUTE_REPEATED_CALL_ON)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.no_mute_repeatcall=true
endif
#add by lichengfeng for fix TASK #7676 Silent model call remainder @20160321 end

#BIRD_REPO_DATA_AFTER_WIFI, add by shenzhiwang, 20160325
ifeq ($(strip $(BIRD_REPO_DATA_AFTER_WIFI)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.reop_data_after_wifi=true
endif
#BIRD_REPO_DATA_AFTER_WIFI, add by shenzhiwang, 20160325

#BIRD_BACKUP_SENSOR, add start by shenzhiwang, 20160406
ifeq ($(strip $(BIRD_BACKUP_SENSOR)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.backup_sensor=true
endif
ifneq ($(strip $(BIRD_GSENSOR_TYPE)), )
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gsensor_type=$(BIRD_GSENSOR_TYPE)
endif
ifneq ($(strip $(BIRD_PSENSOR_TYPE)), )
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.psensor_type=$(BIRD_PSENSOR_TYPE)
endif
#BIRD_BACKUP_SENSOR, add end by shenzhiwang, 20160406

#BIRD_TWO_IMEI_EQUALS_SHOW_ONE_OPEN, add by lichengfeng two imei equals just show one @20160413
ifeq ($(strip $(BIRD_TWO_IMEI_EQUALS_SHOW_ONE_OPEN)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.two_imei_show_one=true
endif
#BIRD_TWO_IMEI_EQUALS_SHOW_ONE_OPEN, add by lichengfeng two imei equals just show one @20160413

#/*add by liuzhenting 20160413 for Bird_BATTERY_PERCENTAGE_DEFAULT_ON begin*/
ifeq ($(strip $(BIRD_BATTERY_PERCENTAGE_DEFAULT_ON)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bird.battery_percentage = true
endif
#/*add by liuzhenting 20160413 for Bird_BATTERY_PERCENTAGE_DEFAULT_ON end*/

#BIRD_SYSTEM_SPACE, add start by shenzhiwang, 20160414
ifeq ($(strip $(BIRD_SYSTEM_SPACE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.bird_system_space=true
endif
#BIRD_SYSTEM_SPACE, add end by shenzhiwang, 20160414

#BIRD_SETTING_DEVICE_INFO, add by fangbin, 20160408 begin
ifneq ($(strip $(BIRD_SETTING_DEVICE_INFO)), )
  ifneq ($(strip $(BIRD_SETTING_DEVICE_INFO)),no)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.setting_device_info=true
  endif
endif
#BIRD_SETTING_DEVICE_INFO, add by fangbin, 20160408 end

#BIRD_DOOV_BREATHLED add by qinzhifeng 20160425 begin
ifeq ($(strip $(BIRD_DOOV_BREATHLED)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.doov_breathled=true
endif
#BIRD_DOOV_BREATHLED add by qinzhifeng 20160425 end

#BIRD_ABOUT_PHONE_REMOVE_INFO, add by fangbin, 20160505 begin
ifeq ($(strip $(BIRD_ABOUT_PHONE_REMOVE_INFO)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.doov_setting_rm_info=true
endif
#BIRD_ABOUT_PHONE_REMOVE_INFO, add by fangbin, 20160505 end


# add by fangbin 20160506   
ifneq ($(strip $(BIRD_MINIMUM_SCREEN_OFF_TIMEOUT)), )
  PRODUCT_PROPERTY_OVERRIDES += ro.bird.screen_timeout= $(strip $(BIRD_MINIMUM_SCREEN_OFF_TIMEOUT))
endif
ifneq ($(strip $(BIRD_SCREEN_DIM_DURATION)),  )
  PRODUCT_PROPERTY_OVERRIDES += ro.bird.dim_screen_timeout= $(strip $(BIRD_SCREEN_DIM_DURATION))
endif

#BIRD_NO_LIGHT_SENSOR add by fangbin 20160506
ifeq ($(strip $(BIRD_NO_LIGHT_SENSOR)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.no_lightsensor=true
endif

#BIRD_NO_PROXIMITY_SENSOR add by fangbin 20160506
ifeq ($(strip $(BIRD_NO_PROXIMITY_SENSOR)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.no_proximity=true
endif
#BIRD_CUSTOM_BROWSER add by luxiaogang
ifeq ($(strip $(BIRD_CUSTOM_BROWSER)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.browser_custom=true
endif
#BIRD_SORT_STRING_CONTACTS add by luxiaogang
ifeq ($(strip $(BIRD_SORT_STRING_CONTACTS)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.string_contacts=true
endif

#BIRD_CONTACT_SHOW_COUNT add by luxiaogang
ifeq ($(strip $(BIRD_CONTACT_SHOW_COUNT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.contact_show_count=true
endif

#BIRD_MENU_SHOW_RECENTAPP add by luxiaogang
ifeq ($(strip $(BIRD_MENU_SHOW_RECENTAPP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.menu_show_recentapp=true
endif

#BIRD_LOAD_CUSTOM_CONTACTS add by luxiaogang
ifeq ($(strip $(BIRD_LOAD_CUSTOM_CONTACTS)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.default_contacts=true
endif


#BIRD_AUTO_CALL_RECORDER add by luxiaogang
ifeq ($(strip $(BIRD_AUTO_CALL_RECORDER)),no) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.auto_call_recorder = 0
else ifeq ($(strip $(BIRD_AUTO_CALL_RECORDER)),off) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.auto_call_recorder = 1
else ifeq ($(strip $(BIRD_AUTO_CALL_RECORDER)),on) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.auto_call_recorder = 2
endif
ifeq ($(strip $(BIRD_AUTO_CALL_RECORDER_NAME_FOLDER)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.auto_call_name=true
endif

#BIRD_DIAL_CMD_THL,chengting,@20160622
ifeq ($(strip $(BIRD_DIAL_CMD_THL)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.dial_cmd_thl=true
endif
########################### BIRD ADD END ###########################
ifeq ($(strip $(BIRD_MMS_DRAFT_TAG_SHOW)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.mms_draft_tag_show=true 
endif
#BIRD_ALARM_SET_SAMETIME add by tianjianwei 2016/06/13
ifeq ($(strip $(BIRD_ALARM_SET_SAMETIME)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.alarm_set_sametime=true
endif
#BIRD_CAMERA_STORAGE_PATH add by tianjianwei 2016/06/13
ifeq ($(strip $(BIRD_CAMERA_STORAGE_PATH)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.camera_storagepath=true
endif
#BIRD_MTK_BLACKLIST add by tianjianwei 2016/06/13
ifeq ($(strip $(BIRD_MTK_BLACKLIST)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.bird_mtk_blacklist=true
endif
#BIRD_MMX_SALES_TRACK add by tianjianwei 2016/06/13
ifeq ($(strip $(BIRD_MMX_SALES_TRACK)), yes)
  PRODUCT_PACKAGES += MMXSalesTrack
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmsic.mmx_sales_sms=true
ifneq ($(strip $(BIRD_MMX_DEVICE_ID)), )
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.mmx_deviceid=$(BIRD_MMX_DEVICE_ID)
else
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.mmx_deviceid=MSQ414BLU
endif   
endif
#BIRD_SHOW_OUTDOORICON_IN_STAURSBAR add by tianjianwei 2016/06/13
ifeq ($(strip $(BIRD_SHOW_OUTDOORICON_IN_STAURSBAR)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_outdoor_icon=true
endif
#BIRD_SHOW_WHERE_SIM_CALL add by tianjianwei 2016/06/13
ifeq ($(strip $(BIRD_SHOW_WHERE_SIM_CALL)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.where_sim_call=true
endif
#BIRD_SHOW_WHERE_SIM_CALL add by tianjianwei 2016/06/13
#BIRD_SHOW_OUTDOORICON_IN_STAURSBAR add by tianjianwei 2016/06/13

#wifi direct name
#BIRD_WLAN_DIRECT_NAME=xxx(use __ instead of space )
ifneq ($(strip $(BIRD_WLAN_DIRECT_NAME)), )
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.wlan_direct_name = $(BIRD_WLAN_DIRECT_NAME)
endif

#wifi ap ssid name
#BIRD_WLAN_SSID_STRING=xxx(use __ instead of space )
ifneq ($(strip $(BIRD_WLAN_SSID_STRING)), )
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.wlan_ssid_name = $(BIRD_WLAN_SSID_STRING)
endif

#tianjianwei 20151026 begin
ifeq ($(strip $(BIRD_SETTING_HOTSPOT_PASSWORD)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hotspot_password=true
endif
#tianjianwei 20151026 end 

ifeq ($(strip $(BIRD_SETTING_MORE_RINGTONES)),no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.setting_more_ringtone=false
endif

ifneq ($(strip $(BIRD_PROJ_PROP_CUSTOM)),)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.proj_prop_custom=$(strip $(BIRD_PROJ_PROP_CUSTOM))
endif

ifeq ($(strip $(BIRD_CUSTOM_D45_PROPERTIES)), yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.d45_cmd_reset=true
endif

ifeq ($(strip $(BIRD_CUSTOM_S37_PROPERTIES)), yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.s37_cmd_reset=true
endif
#BIRD_MMX_DESKTIME_WIDGET add by huhongqing begin 20160606
ifeq ($(strip $(BIRD_MMX_DESKTIME_WIDGET)),yes)
  PRODUCT_PACKAGES += MMXDeskTimeWidget
endif
#BIRD_MMX_DESKTIME_WIDGET end
#BIRD_SHOW_WIDGET_MUSIC add by huhongqing begin 20160613
ifeq ($(strip $(BIRD_SHOW_WIDGET_MUSIC)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_widget_music=true
endif
#BIRD_SHOW_WIDGET_MUSIC add by huhongqing end
#BIRD_MUSIC_SERRKBAR_VOLUMN add by huhongqing begin 
ifeq ($(BIRD_MUSIC_SERRKBAR_VOLUMN),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.music_seekbar_volumn = true
endif
#BIRD_MUSIC_SERRKBAR_VOLUMN add by huhongqing end
#BIRD_EMAIL_SIGNATURE add by huhongqing begin 20160606
#BIRD_EMAIL_SIGNATURE_CONFIG=mmx
ifeq ($(strip $(BIRD_EMAIL_SIGNATURE)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.email_signature=true
endif
#BIRD_EMAIL_SIGNATURE end

#add by wangye 20160719begin
ifeq ($(strip $(BIRD_CHARGED_DIALOG)),yes) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.charged_dialog = true
endif
#add by wangye 20160719 end

#add by wangye 20160715 begin
ifeq ($(strip $(BIRD_SHOW_SCREEN_SAVER_VIDEO)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.view_screen_saver=true
endif
#add by wangye 20160715 end
#-----------------------------ThemeApkManager start -----------------
PRODUCT_PACKAGES += ThemeApkManager
ifeq ($(strip $(BIRD_THEME_APK_MANAGER)),yes) 
  PRODUCT_PROPERTY_OVERRIDES += \
	ro.bdfun.themeapk_manager = true
endif
ifneq ($(strip $(THEME_DEFAULT_PACKAGE_NAME)), )
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.default_theme_pkgname=$(THEME_DEFAULT_PACKAGE_NAME)
	PRODUCT_PROPERTY_OVERRIDES += \
	ro.bdfun.themeapk_manager = true
endif
ifeq ($(strip $(BIRD_SIMPLE_WALLP_PREVIEW)),yes) 
  PRODUCT_PROPERTY_OVERRIDES += \
	ro.bdfun.simple_wallp_preview = true
endif
ifeq ($(strip $(BIRD_WALLPAPER_SCREENS_SPAN_1)),yes) 
  PRODUCT_PROPERTY_OVERRIDES += \
	ro.bdfun.wallp_screens_span1 = true
endif
ifeq ($(strip $(BIRD_THEME_NO_LOCKSCREEN_SETTING)),yes)
  PRODUCT_PROPERTY_OVERRIDES += \
	ro.bdfun.no_lockscreen_setting = true
endif
#BIRD_THEME_ONLY_CHANGEICON,wanqian @20150424 start
ifeq ($(strip $(BIRD_THEME_ONLY_CHANGEICON)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.only_change_icon = true
endif
#BIRD_THEME_ONLY_CHANGEICON,wanqian @20150424 end
#################===========add Theme begin==============##########
ifeq ($(strip $(BIRD_THEME_MMX)),yes)
  PRODUCT_PACKAGES += ThemeMMX
endif
ifeq ($(strip $(BIRD_THEME_ELEPHONE)),yes)
  PRODUCT_PACKAGES += ThemeElephone
endif
ifeq ($(strip $(BIRD_THEME_LANDVO)),yes)
  PRODUCT_PACKAGES += ThemeLandvo
endif

ifeq ($(strip $(BIRD_THEME_BLUBOO)),yes)
  PRODUCT_PACKAGES += ThemeBluboo
endif

ifeq ($(strip $(BIRD_THEME_BINFEN)),yes)
  PRODUCT_PACKAGES += ThemeBinfen
endif

ifeq ($(strip $(BIRD_THEMECLASSICS)),yes)
  PRODUCT_PACKAGES += ThemeClassics
endif

ifeq ($(strip $(BIRD_THEMECOOKIE)),yes)
  PRODUCT_PACKAGES += ThemeCookie
endif

ifeq ($(strip $(BIRD_THEME_CRYSTAL)),yes)
  PRODUCT_PACKAGES += ThemeCrystal
endif

ifeq ($(strip $(BIRD_THEME_HALO)),yes)
  PRODUCT_PACKAGES += ThemeHalo
endif

ifeq ($(strip $(BIRD_THEME_PURE)),yes)
  PRODUCT_PACKAGES += ThemePure
endif

ifeq ($(strip $(BIRD_THEME_TASTE)),yes)
  PRODUCT_PACKAGES += ThemeTaste
endif

ifeq ($(strip $(BIRD_THEMERICE2)),yes)
  PRODUCT_PACKAGES += ThemeRice2
endif

ifeq ($(strip $(BIRD_THEME_FATE)),yes)
  PRODUCT_PACKAGES += ThemeFate
endif

ifeq ($(strip $(BIRD_THEME_ELEGANT)),yes)
  PRODUCT_PACKAGES += ThemeElegant
endif

ifeq ($(strip $(BIRD_THEMEDEFAULT)),yes)
  PRODUCT_PACKAGES += ThemeDefault
endif

ifeq ($(strip $(BIRD_THEME_NOVELTY)),yes)
	PRODUCT_PACKAGES += ThemeNovelty
endif
ifeq ($(strip $(BIRD_THEME_GOOGLE)),yes)
	PRODUCT_PACKAGES += ThemeGoogle
endif

ifeq ($(strip $(BIRD_THEME_MTKREALSEICON)),yes)
	PRODUCT_PACKAGES += ThemeMTKRelease
endif

ifeq ($(strip $(BIRD_THEME_MTKREALSEICON)),yes)
   PRODUCT_PACKAGES += ThemeMTKRelease
endif

ifeq ($(strip $(BIRD_THEME_SKK)),yes)
	PRODUCT_PACKAGES += ThemeSkk
endif
ifeq ($(strip $(BIRD_THEME_BEAUTIFUL)),yes)
  PRODUCT_PACKAGES += ThemeBeautiful
endif
ifeq ($(strip $(BIRD_THEME_BRIGHT)),yes)
  PRODUCT_PACKAGES += ThemeBright
endif
ifeq ($(strip $(BIRD_THEME_GXQ)),yes)
  PRODUCT_PACKAGES += ThemeGXQ
endif
ifeq ($(strip $(BIRD_THEME_VIVO)),yes)
  PRODUCT_PACKAGES += ThemeVivo
endif
ifeq ($(strip $(BIRD_THEME_SAMSUNG)),yes)
  PRODUCT_PACKAGES += ThemeSAMSUNG
endif
ifeq ($(strip $(BIRD_THEME_ICON1)),yes)
  PRODUCT_PACKAGES += ThemeICON1
endif
ifeq ($(strip $(BIRD_THEME_LJFH)),yes)
  PRODUCT_PACKAGES += ThemeLJFH
endif

ifeq ($(strip $(BIRD_THEME_DANCAI)),yes)
  PRODUCT_PACKAGES += ThemeDanCai
endif

ifeq ($(strip $(BIRD_THEME_ENERGY)),yes)
  PRODUCT_PACKAGES += ThemeENERGY
endif

ifeq ($(strip $(BIRD_THEME_OPPO)),yes)
  PRODUCT_PACKAGES += ThemeOPPO
endif

ifeq ($(strip $(BIRD_THEMELOVELY)),yes)
  PRODUCT_PACKAGES += ThemeLovely
endif

ifeq ($(strip $(BIRD_THEMEPAPER)),yes)
  PRODUCT_PACKAGES += ThemePaper
endif

ifeq ($(strip $(BIRD_THEME_TIANGUANG)),yes)
  PRODUCT_PACKAGES += ThemeTianguang
endif

ifeq ($(strip $(BIRD_THEME_XPERIA)),yes)
  PRODUCT_PACKAGES += ThemeXperia
endif
ifeq ($(strip $(BIRD_THEME_BUSINESS)),yes)
  PRODUCT_PACKAGES += ThemeBUSINESS
endif


ifeq ($(strip $(BIRD_THEME_YW)),yes)
  PRODUCT_PACKAGES += ThemeYW
endif

ifeq ($(strip $(BIRD_THEME_CY)),yes)
  PRODUCT_PACKAGES += ThemeCY
endif

ifeq ($(strip $(BIRD_THEME_QG)),yes)
  PRODUCT_PACKAGES += ThemeQG
endif


ifeq ($(strip $(BIRD_THEME_DUSK)),yes)
  PRODUCT_PACKAGES += ThemeDusk
endif

ifeq ($(strip $(BIRD_THEME_THL)),yes)
  PRODUCT_PACKAGES += ThemeTHL
endif

ifeq ($(strip $(BIRD_THEME_THL2)),yes)
  PRODUCT_PACKAGES += ThemeTHL2
endif

ifeq ($(strip $(BIRD_THEME_S550)),yes)
  PRODUCT_PACKAGES += ThemeS550
endif

ifeq ($(strip $(BIRD_THL_STYLE)),yes)
  PRODUCT_PACKAGES += ThemeTHL
endif

ifeq ($(strip $(BIRD_THEME_BEAUTY)),yes)
  PRODUCT_PACKAGES += ThemeBeauty
endif

ifeq ($(strip $(BIRD_THEME_CHRYSALIS)),yes)
  PRODUCT_PACKAGES += ThemeChrysalis
endif

ifeq ($(strip $(BIRD_THEME_FEMALE)),yes)
  PRODUCT_PACKAGES += ThemeFemale
endif

ifeq ($(strip $(BIRD_THEME_NIGHT)),yes)
  PRODUCT_PACKAGES += ThemeNight
endif

ifeq ($(strip $(BIRD_THEME_PUDDING)),yes)
  PRODUCT_PACKAGES += ThemePudding
endif
ifeq ($(strip $(BIRD_THEME_COLORFUL)),yes)
  PRODUCT_PACKAGES += ThemeColorful
endif
ifeq ($(strip $(BIRD_THEME_QING)),yes)
  PRODUCT_PACKAGES += ThemeQing
endif
ifeq ($(strip $(BIRD_THEME_LIFE)),yes)
  PRODUCT_PACKAGES += ThemeLife
endif
ifeq ($(strip $(BIRD_THEME_LUORI)),yes)
  PRODUCT_PACKAGES += ThemeLuoRi
endif
ifeq ($(strip $(BIRD_THEME_XIANCHENG)),yes)
  PRODUCT_PACKAGES += ThemeXianCheng
  PRODUCT_PACKAGES := $(filter-out ThemeLJFH%, $(PRODUCT_PACKAGES))
  PRODUCT_PACKAGES := $(filter-out ThemeDanCai%, $(PRODUCT_PACKAGES))
  PRODUCT_PACKAGES := $(filter-out ThemeOPPO%, $(PRODUCT_PACKAGES))
  PRODUCT_PACKAGES := $(filter-out ThemeRice2%, $(PRODUCT_PACKAGES))
  PRODUCT_PACKAGES := $(filter-out ThemeENERGY%, $(PRODUCT_PACKAGES))
  PRODUCT_PACKAGES := $(filter-out ThemeVivo%, $(PRODUCT_PACKAGES))

endif
ifeq ($(strip $(BIRD_THEME_FANGZHENG)),yes)
  PRODUCT_PACKAGES += ThemeFangZheng
endif
ifeq ($(strip $(BIRD_THEME_HUANGZU)),yes)
  PRODUCT_PACKAGES += ThemeHuangZu
endif
ifeq ($(strip $(BIRD_THEME_ERUANSHI)),yes)
  PRODUCT_PACKAGES += ThemeERuanShi
endif

ifeq ($(strip $(BIRD_THEME_GOLDEN)),yes)
  PRODUCT_PACKAGES += ThemeGolden
endif

#add by ludaxu begin

ifeq ($(strip $(BIRD_THEME_K54HO)),yes)
  PRODUCT_PACKAGES += ThemeK54HO
endif

ifeq ($(strip $(BIRD_THEME_HAIER)),yes)
  PRODUCT_PACKAGES += ThemeHaier
endif

ifeq ($(strip $(BIRD_THEME_ELEGANT)),yes)
  PRODUCT_PACKAGES += ThemeElegant
endif

ifeq ($(strip $(BIRD_THEME_LUXURY)),yes)
  PRODUCT_PACKAGES += ThemeLuxury
endif

ifeq ($(strip $(BIRD_THEME_GOLDENBLOCKS)),yes)
  PRODUCT_PACKAGES += ThemeGoldenBlocks
endif

ifeq ($(strip $(BIRD_SAMSUNG_LAUNCHER_DEFAULT)),yes) 
  PRODUCT_PACKAGES := $(filter-out Launcher%, $(PRODUCT_PACKAGES))
  PRODUCT_PACKAGES := $(filter-out %Launcher, $(PRODUCT_PACKAGES))
  PRODUCT_PACKAGES += SamsungLauncher
endif

#add by ludaxu end

ifeq ($(strip $(BIRD_WEB_SHORTCUT_FOR_CGames)),yes)
  PRODUCT_PACKAGES += WebShortcutForCGames
endif

ifeq ($(strip $(BIRD_WEB_SHORTCUT_FOR_Clive)),yes)
  PRODUCT_PACKAGES += WebShortcutForClive
endif
#add by qinzhifeng begin
ifeq ($(strip $(BIRD_THEME_LIGHTLUXURY)),yes)
  PRODUCT_PACKAGES += ThemeLightLuxury
endif
ifeq ($(strip $(BIRD_THEME_FLEXIBLE)),yes)
  PRODUCT_PACKAGES += ThemeFlexible
endif
ifeq ($(strip $(BIRD_THEME_ELEGANT)),yes)
  PRODUCT_PACKAGES += ThemeElegant
endif
ifeq ($(strip $(BIRD_THEME_LUXURY)),yes)
  PRODUCT_PACKAGES += ThemeLuxury
endif
ifeq ($(strip $(BIRD_THEME_GOLDENBLOCKS)),yes)
  PRODUCT_PACKAGES += ThemeGoldenBlocks
endif
#add by qinzhifeng end
#################===========add Theme end==============##########
#-----------------------------ThemeApkManager end -----------------

#add by liangyun start
ifeq ($(strip $(BIRD_SAVE_ORIGIN)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.save_origin = true
endif
#add by liangyun end

#bird: BIRD_SHUTTER_SOUND,chengting,@20180418 {
ifeq ($(strip $(BIRD_SHUTTER_SOUND)),on)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.shutter_sound = on
else ifeq ($(strip $(BIRD_SHUTTER_SOUND)),off)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.shutter_sound = off
endif
#@}

#add by liangyun start
ifeq ($(strip $(BIRD_HIDE_IP_DIAL)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hide_ip_dial = true
endif
#add by liangyun end


#add by lihan for gms
PRODUCT_PROPERTY_OVERRIDES += ro.product.first_api_level=24

#lihan GAPPS 7r4
ifeq ($(strip $(BIRD_GAPPS_7R4)), yes)
$(call inherit-product-if-exists, vendor/google/GAPPS_7R4/products/gms.mk)

#copy from mtk BUILD_GMS  in device/mediatek/common/device.mk
PRODUCT_PROPERTY_OVERRIDES += \
      ro.com.google.clientidbase=alps-$(TARGET_PRODUCT)-{country} \
      ro.com.google.clientidbase.ms=alps-$(TARGET_PRODUCT)-{country} \
      ro.com.google.clientidbase.yt=alps-$(TARGET_PRODUCT)-{country} \
      ro.com.google.clientidbase.am=alps-$(TARGET_PRODUCT)-{country} \
      ro.com.google.clientidbase.gmm=alps-$(TARGET_PRODUCT)-{country}
endif

#remove search bar on launcher,chengting,20160624
ifeq ($(strip $(BIRD_LAUNCHER3_HIDE_SEARCHBAR)), yes)
  # hide search bar in launcher3's allapps & workspace
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.laun_hide_searchBar = true
else ifeq ($(strip $(BIRD_LAUNCHER3_ALLAPP_SEARCHBAR)), no)
  # hide search bar in launcher3's allapps
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.home_allapp_sb = false
else ifeq ($(strip $(BIRD_LAUNCHER3_WORKSPACE_SEARCHBAR)), no)
  # hide search bar in launcher3's workspace
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.home_workspace_sb = false
endif

#MiKeyboard add begin
ifneq ($(strip $(BIRD_FUN_MIKEYBOARD)), no)
    PRODUCT_PACKAGES += MiKeyboard
endif
#MiKeyboard add end

#Launcher3 AllApps bg transparent instead of white,chengting,@20160624
ifeq ($(strip $(BIRD_LAUNCHER_ALLAPP_BG_TRANSPARENT)), no)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.home_allapp_bg_trans = false
endif

#one key clear all recent tasks,lliuzhuangzhuang 20150813 start#  
ifeq ($(BIRD_HOMEKEY_ONEKEY_CLEAR), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.onekeyclear_enable=true
endif
#one key clear all recent tasks,lliuzhuangzhuang 20150813 end# 
#liangyun
ifeq ($(strip $(BIRD_ADD_CUSTOM_CBMESSAGE)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.add_custom_cbmessage = true
endif
#liangyun
ifneq ($(strip $(BIRD_CUSTOM_CBMESSAGE)),)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.custom_cbmessage = $(BIRD_CUSTOM_CBMESSAGE)
endif

#BIRD_A200_CUSTOM add by meifangting 20160331 begin
ifeq ($(strip $(BIRD_A200_CUSTOM)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.a200_custom = true
endif
#BIRD_A200_CUSTOM add by meifangting 20160331 end
 
#BIRD_A200_SYSTEMUI_STATUSBAR add by zhangbi 20160331 begin
ifeq ($(strip $(BIRD_A200_SYSTEMUI_STATUSBAR)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.a200_statusbar = true
endif
#BIRD_A200_SYSTEMUI_STATUSBAR add by zhangbi 20160331 end

#add by fanglongxiang #20160413 begin  BIRD_A200_CAMERA {
ifeq ($(strip $(BIRD_A200_CAMERA)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.a200_camera = true
endif
#add by fanglongxiang #20160413 end BIRD_A200_CAMERA }

#BIRD_POWER_SAVING add by ludaxu 20160618 begin
ifeq ($(strip $(BIRD_POWER_SAVING)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.power_saving = true
endif
#BIRD_POWER_SAVING add by ludaxu 20160618 end

#in settings,About phone,baseband
#BIRD_BASEBAND_VERSION=xxx(use __ instead of space )
ifdef BIRD_BASEBAND_VERSION
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.baseband_version = $(BIRD_BASEBAND_VERSION)
endif

#in settings,About phone,kernel version
#BIRD_KERNEL_VERSION=xxx(use __ instead of space )
ifdef BIRD_KERNEL_VERSION
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.kernel_version = $(BIRD_KERNEL_VERSION)
endif

#in settings,About phone,build number
#BIRD_BUILD_NUMBER=xxx(use __ instead of space )
ifdef BIRD_BUILD_NUMBER
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.build_number = $(BIRD_BUILD_NUMBER)
endif

#build version, overlay Build.DISPLAY
#show in settings,About phone,build number, if BIRD_BUILD_NUMBER not defined
#also used for write tool by yangbinjie
ifdef BIRD_BUILD_VERNO
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.bdmisc.software_version=$(BIRD_BUILD_VERNO)
endif

#wangfei 20150504,add for guangsheng fota,define with ADUPS_FOTA_SUPPORT
ifdef BIRD_EM_VERNO
  PRODUCT_PROPERTY_OVERRIDES += \
    bird_em_verno=$(BIRD_EM_VERNO)
endif

#add by ludaxu 20160629 for SamsungLauncher begin
ifeq ($(strip $(MTK_LAUNCHER_UNREAD_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.launcher_unread=true
endif
ifeq ($(strip $(MTK_SMARTBOOK_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.smartbook=true
endif
ifeq ($(strip $(MTK_ONLY_OWNER_SIM_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.only_own_sim=true
endif
ifeq ($(strip $(BIRD_SAMSUNG_KEYPAD_NUMBER_START_DIAL)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.num_start_dial=true
endif
ifeq ($(BIRD_APK_YUMMIWEATHER),yes)
  PRODUCT_COPY_FILES += packages/apps/Bird_APK/YunMiWeatherWidget/WeatherWidget.apk:system/app/WeatherWidget.apk
  PRODUCT_COPY_FILES += packages/apps/Bird_APK/YunMiWeatherWidget/liblocSDK3.so:system/lib/liblocSDK3.so
endif
ifeq ($(BIRD_APK_YUNMIWEATHER_WITHVIVOSTYLE),system)
PRODUCT_COPY_FILES += packages/apps/Bird_APK/YunMiWeather_withVivoStyle/yunmiWeather_with_vivostyle.apk:system/app/yunmiWeather_with_vivostyle.apk
PRODUCT_COPY_FILES += packages/apps/Bird_APK/YunMiWeather_withVivoStyle/liblocSDK3.so:system/lib/liblocSDK3.so
endif
#add by ludaxu 20160629 for SamsungLauncher end

#BIRD_DEFAULT_DATE_FORMAT, add by peibaosheng @20160630 begin
ifneq ($(strip $(BIRD_DEFAULT_DATE_FORMAT)),)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.default_date_format=$(BIRD_DEFAULT_DATE_FORMAT)
endif
#BIRD_DEFAULT_DATE_FORMAT, add by peibaosheng @20160630 end

#for ringtone pick list,the 'more' menu.
#The release code don't support 'more' menu in alarm & contact ringtone pick,now we support it default.Add this macro in case of someone want the release feature.
#value:alarm,contact,setting,all
#alarm & contact can be set at the same time with , to split.ex:BIRD_RINGTONES_PICK_NO_MENU_MORE=alarm,contact
#all means no 'more' menu in alarm & contact
ifneq ($(strip $(BIRD_RINGTONES_PICK_NO_MENU_MORE)),)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.no_ringtone_more=$(strip $(BIRD_RINGTONES_PICK_NO_MENU_MORE))
endif

#calculators_layout_change add by liugenggeng 20160413 begin 
ifeq ($(strip $(BIRD_A200_CALCUIATORS)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.change_calc_layout=true
endif
#calculators_layout_change add by liugenggeng 20160413 end

ifdef BIRD_SCREEN_BRIGHTNESS
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.bird.brightness=$(BIRD_SCREEN_BRIGHTNESS)
endif

#BIRD_CAMERA_VOLUME_BUTTON_SETTINGS add by peibaosheng @20160704 begin
ifeq ($(strip $(BIRD_CAMERA_VOLUME_BUTTON_SETTINGS)),photo)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.volume_button_set = 1
else ifeq ($(strip $(BIRD_CAMERA_VOLUME_BUTTON_SETTINGS)),volume)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.volume_button_set = 2
else ifeq ($(strip $(BIRD_CAMERA_VOLUME_BUTTON_SETTINGS)),zoom)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.volume_button_set = 3
endif
#BIRD_CAMERA_VOLUME_BUTTON_SETTINGS add by peibaosheng @20160704 end


#add by lihan for 175A begin
ifneq ($(strip $(BIRD_APK_Google_Pinyin)), no)
    PRODUCT_PACKAGES += Google_Pinyin
endif   
ifneq ($(strip $(BIRD_APK_Google_Zhuyin)), no)
	PRODUCT_PACKAGES += Google_Zhuyin
endif
#add by lihan for 175A end

#@ { imei by adb, add by shenzhiwang @20160705
ifeq ($(strip $(BIRD_IMEI_BY_ABD)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.imei_by_adb=true
endif
#@ }

#@ { BIRD_LOW_STORAGE_WARNING, add by shenzhiwang @20160706
ifeq ($(strip $(BIRD_LOW_STORAGE_WARNING)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.low_storage_warning=true
endif
#@ }

#@ { BIRD_LOW_BATTERY_WARNING, add by shenzhiwang @20160706
ifeq ($(strip $(BIRD_LOW_BATTERY_WARNING)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.low_battery_warning=true
endif
#@ }

#@ { BIRD_LAND_GOOGLE_HALF_SCREEN_BRIGHTNESS, add by shenzhiwang @20160706
ifeq ($(strip $(BIRD_LAND_GOOGLE_HALF_SCREEN_BRIGHTNESS)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.land_gg_half_sb=true
endif
#@ }

#@ { BIRD_HEIGHT_SCREEN_BRIGHTNESS_WARNING, add by shenzhiwang @20160706
ifeq ($(strip $(BIRD_HEIGHT_SCREEN_BRIGHTNESS_WARNING)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.height_sb_warning=true
endif
#@ }

#bird camera default radio & size, add by peibaosheng @20160706 begin
ifdef BIRD_CAMERA_DEFAULT_PICTURE_RATIO
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.camera_picture_ratio = $(BIRD_CAMERA_DEFAULT_PICTURE_RATIO)
endif

ifdef BIRD_CAMERA_SUB_DEFAULT_CAPTURE_SIZE
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.camera_sub_psize = $(BIRD_CAMERA_SUB_DEFAULT_CAPTURE_SIZE)
endif

ifdef BIRD_CAMERA_MAIN_DEFAULT_CAPTURE_SIZE
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.camera_main_psize = $(BIRD_CAMERA_MAIN_DEFAULT_CAPTURE_SIZE)
endif
#bird camera default radio & size, add by peibaosheng @20160706 end

#@ { BIRD_FILEMANAGER_INTERNAL_SIZE, add by shenzhiwang @20160706
ifeq ($(strip $(BIRD_FILEMANAGER_INTERNAL_SIZE)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fm_internal_size=true
endif
#@ }
#add by WangBiyao 20160707 begin
ifeq ($(strip $(BIRD_REMOVE_TURBO_DOWNLOAD)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.remove_turbo_download=true
endif
#add by WangBiyao 20160707 end

#add by bird ningzhiyu 20160713
ifeq ($(strip $(BIRD_CHANGE_LANGUAGE_BY_SIM)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.lang_by_sim = true
endif
#add by bird ningzhiyu 20160713 end

#ningzhiyu 20160901
ifneq ($(strip $(BIRD_MTP_LABEL)), )
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.mtp_label = $(BIRD_MTP_LABEL)
endif
ifneq ($(strip $(BIRD_MTP_MANUFACTURER)), )
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.mtp_manufacturer = $(BIRD_MTP_MANUFACTURER)
endif
ifneq ($(strip $(BIRD_MTP_MODEL)), )
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.mtp_model = $(BIRD_MTP_MODEL)
endif

#add by liangyun @2016.7.8 start
ifeq ($(strip $(BIRD_CLIEND_ID)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.cliend_id = true
endif
#add by liangyun @2016.7.8 end

#add by tianjianwei 2016/07/09 start
ifeq ($(strip $(BIRD_AUTO_ADD_ZERO)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.add_zero = true
endif
#add by tianjianwei 2016/07/09 end

#ningzhiyu BIRD_DEFAULT_INPUT_METHOD
ifdef BIRD_DEFAULT_INPUT_METHOD
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.def_ime=$(strip $(BIRD_DEFAULT_INPUT_METHOD))
endif

#BUG #7471,BUG #14053,chengting
ifeq ($(strip $(BIRD_INPUT_METHOD_BY_LANGUAGE)), no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ime_by_local=false
else
    ifdef BIRD_INPUTMETHOD_CN
        PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ime_local_cn = $(BIRD_INPUTMETHOD_CN)
    endif
    ifdef BIRD_INPUTMETHOD_TW
        PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ime_local_tw = $(BIRD_INPUTMETHOD_TW)
    endif
    ifdef BIRD_INPUTMETHOD_OTHER
        PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ime_local_other = $(BIRD_INPUTMETHOD_OTHER)
    endif
endif

#ningzhiyu , remove screen pinning
ifeq ($(strip $(BIRD_HIDE_SCREEN_PINNING)), yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hide_scr_pinning=true
endif

#bird: BUG #14107,phone encrypt,chengting,@20170711
ifeq ($(strip $(BIRD_ENABLE_ENCRYPTION)), yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.encryption=true
endif

#Contacts storage status add by peibaosheng @20160711 begin
ifeq ($(strip $(BIRD_CONTACTS_STATUS)),no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.contacts_status=false
endif
#Contacts storage status add by peibaosheng @20160711 end

#@ {  BIRD_CALENDAR_START_VIEW, custom default view type,chengting,@20141220,begin
ifneq ($(strip $(BIRD_CALENDAR_START_VIEW)),)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.calendar_start_view=$(strip $(BIRD_CALENDAR_START_VIEW))
endif
#@ }  BIRD_CALENDAR_START_VIEW, custom default view type,chengting,@20141220,end

#@ {  bird BIRD_DEVELOP_OPTION_OFF, add by siyiping 20150505 begin
ifeq ($(strip $(BIRD_DEVELOP_OPTION_OFF)), yes)
        PRODUCT_PROPERTY_OVERRIDES += ro.bdfu_develop_option_off=true
endif
#@ }  bird BIRD_DEVELOP_OPTION_OFF, add by siyiping 20150505 end 

ifeq ($(strip $(ADUPS_FOTA_SUPPORT)), yes)
PRODUCT_PACKAGES += AdupsFota \
                    AdupsFotaReboot
endif

#bird:BUG #17469,remove USB storage menu, wangjuncheng, @20161031
ifeq ($(strip $(BIRD_REMOVE_USB_STORAGE_MENU)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.rm_usb_storage_menu=true
endif

#bird:BUG #17469,remove USB CD-ROM menu, wangjuncheng, @20161031
ifeq ($(strip $(BIRD_REMOVE_USB_CDROM_MENU)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.rm_usb_cdrom_menu=true
endif

#bird:BUG #14125,remove USB MIDI menu,chengting,@20160713
ifeq ($(strip $(BIRD_REMOVE_USB_MIDI_MENU)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.rm_usb_midi_menu=true
endif
#add PowerManager by kelinxi begin 20150428
ifeq ($(strip $(BIRD_POWER_MANAGER)), yes)
  PRODUCT_PACKAGES += PowerManager
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.powermanager = true
endif
#add PowerManager by kelinxi end 20150428
 #add by liuzhiling 20160712 begin
ifeq ($(strip $(BIRD_RECORDER_DISPLAY_TIME_HOUR)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui_recorder_display_hour = true
endif
#add by liuzhiling 20160712 end
#added by WangBiyao 20160629 begin
ifeq ($(strip $(BIRD_SAVE_ONE_PICTURE_ON_FACEBEAUTY_MODE)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun_save_one_picture=true
endif
#added by WangBiyao 20160629 end
#add by liuzhiling 20160712 begin
ifeq ($(strip $(BIRD_GALLER_FACE_DETECTION)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun_face_dete_gallery=true
endif

#add by wutingying 2016/03/29 begin
ifeq ($(BIRD_SIMPLE_STYLE_UNLOCK),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdui.simple_style_unlock=true 
endif
#add by wutingying 2016/03/29 end

#add by liangyun @2016.3.9 begin
ifeq ($(strip $(BIRD_HIDE_NOTIFICATION)),yes) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hide_notification = true
endif
#add by liangyun @2016.3.9 end

#wutingying 20151117 begin
ifeq ($(strip (BIRD_KEYGUARD_SHOW_LAUNCH_STATUSBAR)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_launch_bar=true
endif
#wutingying 20151117 end

#hanyang 20160420 begin
ifeq ($(strip $(BIRD_NO_DRAG_DOWN_STATUS_BAR)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.no_down_statusbar=true
endif
#hanyang 20160420 end

#BIRD_MULTI_TOUCH 20160715 begin
ifeq ($(strip $(BIRD_MULTI_TOUCH)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.multi_touch=true
endif
#BIRD_MULTI_TOUCH 20160715 end

#BIRD_3POINT_TOUCH_SCREENSHOT 20160715 begin
ifeq ($(strip $(BIRD_3POINT_TOUCH_SCREENSHOT)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.3p_touch_screenshot=true
endif
#BIRD_3POINT_TOUCH_SCREENSHOT 20160715 end

#BIRD_STATUSBAR_DROP_DOWN_NO_SCREENSHORT add by liuchaofei 20160712 for screenshot begin
ifeq ($(strip $(BIRD_STATUSBAR_DROP_DOWN_SCREENSHORT)),no)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.status_screenshort=false  
endif
#BIRD_STATUSBAR_DROP_DOWN_NO_SCREENSHORT add by liuchaofei 20160712 for screenshot end

#+0033602530579 / 0602530579,combine to one in mms
ifeq ($(BIRD_NUMBER_PLUS0033TO0),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.number_plus0033to0=true
endif

#operator name upper to normal
ifeq ($(BIRD_OPERATOR_NORMAL_NAME),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.operator_normal_name=true
endif

#flip screen off & flip ring mute add by peibaosheng @20160714 begin
#BIRD_FLIP_SCREEN_OFF  BIRD_FLIP_RING_MUTE
#0:function off, 1:default off, 2:default on

#BIRD_FLIP_SCREEN_OFF_MENU
#0:menu in settings--display, 2:menu in settings--accessibility
#4:menu in settings--system motion

#BIRD_FLIP_RING_MUTE_MENU
#0:menu in settings--display, 1:menu in dialer--call settings,
#2:menu in settings--accessibility, 3:menu in dialer--sounds and vibration
#4:menu in settings--system motion

ifneq ($(strip $(BIRD_FLIP_SCREEN_OFF)), )
ifneq ($(strip $(BIRD_FLIP_SCREEN_OFF)), 0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.flip_screen_off = $(BIRD_FLIP_SCREEN_OFF)
    ifdef BIRD_FLIP_SCREEN_OFF_MENU
      PRODUCT_PROPERTY_OVERRIDES += \
        ro.bdfun.flip_screen_off_menu=$(BIRD_FLIP_SCREEN_OFF_MENU)
    endif
endif
endif

ifneq ($(strip $(BIRD_FLIP_RING_MUTE)), )
ifneq ($(strip $(BIRD_FLIP_RING_MUTE)), 0)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.flip_ring_mute = $(BIRD_FLIP_RING_MUTE)
    ifdef BIRD_FLIP_RING_MUTE_MENU
      PRODUCT_PROPERTY_OVERRIDES += \
        ro.bdfun.flip_ring_mute_menu=$(BIRD_FLIP_RING_MUTE_MENU)
    endif
endif
endif
#flip screen off & flip ring mute add by peibaosheng @20160714 end

# bird BIRD_LOCKSCREEN_WALLPAPER add by qinzhifeng 20160715
ifeq ($(strip $(BIRD_LOCKSCREEN_WALLPAPER)),yes) 
  PRODUCT_PROPERTY_OVERRIDES += \
	ro.bdfun.lock_screen_wallpaper = true
endif
# bird BIRD_LOCKSCREEN_WALLPAPER end

#bird: music widget previous button, add by peibaosheng @20160715 begin
ifeq ($(strip $(BIRD_MUSIC_WIDGET_PREVIOUS_BUTTON)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.music_widget_prev_btn=true
endif
#bird: music widget previous button, add by peibaosheng @20160715 end

#bird: music share, add by peibaosheng @20160715 begin
ifeq ($(strip $(BIRD_MUSIC_SHARE)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.music_share=true
endif
#bird: music share, add by peibaosheng @20160715 end

#BIRD_SHOW_ECC_BUTTON_NO_SECURE add by liuchaofei to control ECC_BUTTON show in on secure 20160717 begin 
ifeq ($(strip $(BIRD_SHOW_ECC_BUTTON_NO_SECURE)),no)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_ecc_btn_nosecure=false  
endif
#BIRD_SHOW_ECC_BUTTON_NO_SECURE add by liuchaofei to control ECC_BUTTON show in on secure 20160717 end 

#BIRD_PLMN_CASE_SENSITIVE add by liuchaofei  20160716 begin
ifeq ($(strip $(BIRD_PLMN_CASE_SENSITIVE)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.plmn_case_sensitive=true
endif
#BIRD_PLMN_CASE_SENSITIVE add by liuchaofei  20160716 end
#wutingying 20151209 begin
ifeq ($(strip $(BIRD_AMPM_LEFT_DATE_DESKCLOCK_WIDGET)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdui.clock_ampm_left=true
endif
#wutingying 20151209 end
#add by wangye 20160714 begin
ifeq ($(strip $(BIRD_ABOUT_ANDROIDVER_LOGO_NEW)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.androidver_logo_new=true
endif
#add by wangye 20160714 end
#add by liuzhiling 20160713 begin
ifeq ($(BIRD_BATTERY_PERCENTAGE_IN_LOCKSCREEN),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.bird_battery_lock=true 
endif
#add by liuzhiling 20160713 end

#bird: BUG #13735,default enter system Settings app instead of Launcher SettingsActivity when clicking "SETTINGS" button,@20160718 {
ifeq ($(strip $(BIRD_LAUNCHER_SETTINGS)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.launcher_settings=true
endif
#[103061], add start by shenzhiwang, 20140603
ifeq ($(strip $(BIRD_DEVICE_INFO_CPU_MODEL)),yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.cpu_model = true
endif 
ifeq ($(strip $(BIRD_DEVICE_INFO_CPU_CORE)),yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.cpu_core = true
endif
ifeq ($(strip $(BIRD_DEVICE_INFO_CPU_FREQUENCY)),yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.cpu_frequency = true
endif
ifeq ($(strip $(BIRD_DEVICE_INFO_PHONE_MEMORY)),yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.phone_memory = true
endif
ifeq ($(strip $(BIRD_DEVICE_INFO_SYSTEM_MEMORY)),yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.system_memory = true
endif
#[103061], add end by shenzhiwang, 20140603

#BIRD_CALLER_ID_SEARCH
ifeq ($(strip $(BIRD_CALLER_ID_SEARCH)),yes)
  PRODUCT_PACKAGES += CallerIdSearch
endif

#[BIRD_DIRECT_WITH_PROXIMITY][20150119],chengting
#0 means no
#1 means yes,and default unchecked
#2 means yes,and default checked
#except BIRD_DIRECT_ANSWER_CALL_WITH_SPEAKER_OFF,2 means speaker off when direct answer call,otherwise speaker will auto on when direct answer call
PRODUCT_PACKAGES += libeminent_sensor_jni      
ifneq ($(strip $(BIRD_DIRECT_WITH_PROXIMITY)), )
ifneq ($(strip $(BIRD_DIRECT_WITH_PROXIMITY)), 0)
  #BUG #5451,chengting,@201506225
  ifneq ($(strip $(BIRD_CALL_SETTINGS_MENU)), 1)    
    PRODUCT_PACKAGES += Direct
  endif
    
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct= $(strip $(BIRD_DIRECT_WITH_PROXIMITY))
    
    ifeq ($(strip $(BIRD_PROXIMITY_SIX_DIRECTIONS)),1)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.proxi_6_direct=1
    endif    
    
    ifneq ($(strip $(BIRD_DIRECT_SEND_CALL)),)
    ifneq ($(strip $(BIRD_DIRECT_SEND_CALL)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_mms_call=$(strip $(BIRD_DIRECT_SEND_CALL))
    endif
    endif
    
    ifneq ($(strip $(BIRD_DIRECT_CONTACT_CALL)),)
    ifneq ($(strip $(BIRD_DIRECT_CONTACT_CALL)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_contact_call=$(strip $(BIRD_DIRECT_CONTACT_CALL))
    endif
    endif
    
    ifneq ($(strip $(BIRD_DIRECT_ANSWER_CALL)),)
    ifneq ($(strip $(BIRD_DIRECT_ANSWER_CALL)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_answer_call=$(strip $(BIRD_DIRECT_ANSWER_CALL))
    endif
    endif
    
    ifneq ($(strip $(BIRD_DIRECT_ANSWER_CALL_WITH_SPEAKER_OFF)),)
    ifneq ($(strip $(BIRD_DIRECT_ANSWER_CALL_WITH_SPEAKER_OFF)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_speaker_off=$(strip $(BIRD_DIRECT_ANSWER_CALL_WITH_SPEAKER_OFF))
    endif
    endif
    
    ifneq ($(strip $(BIRD_DIRECT_SHAKE_TO_ANSWER)),)
    ifneq ($(strip $(BIRD_DIRECT_SHAKE_TO_ANSWER)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_shake_answer=$(strip $(BIRD_DIRECT_SHAKE_TO_ANSWER))
    endif
    endif
    
    ifneq ($(strip $(BIRD_GESTURE_UNLOCK)),)
    ifneq ($(strip $(BIRD_GESTURE_UNLOCK)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_unlock=$(strip $(BIRD_GESTURE_UNLOCK))
    endif
    endif
    
    ifneq ($(strip $(BIRD_SHAKE_CHANGE_WALLPAPER)),)
    ifneq ($(strip $(BIRD_SHAKE_CHANGE_WALLPAPER)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_shake_wallpaper=$(strip $(BIRD_SHAKE_CHANGE_WALLPAPER))
    endif
    endif
    
    ifneq ($(strip $(BIRD_SHAKE_CHANGE_WALLPAPER_SOUND)),)
    ifneq ($(strip $(BIRD_SHAKE_CHANGE_WALLPAPER_SOUND)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_wallpaper_sound=$(strip $(BIRD_SHAKE_CHANGE_WALLPAPER_SOUND))
    endif
    endif
    
    ifneq ($(strip $(BIRD_LAUNCHER3_SERSOR_SNAP)),)
    ifneq ($(strip $(BIRD_LAUNCHER3_SERSOR_SNAP)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_launcher3_snap=$(strip $(BIRD_LAUNCHER3_SERSOR_SNAP))
    endif
    endif
    
    ifneq ($(strip $(BIRD_CAMERA_SERSOR_SNAP)),)
    ifneq ($(strip $(BIRD_CAMERA_SERSOR_SNAP)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_camera_snap=$(strip $(BIRD_CAMERA_SERSOR_SNAP))
    endif
    endif
    
    ifneq ($(strip $(BIRD_MUSIC_SERSOR_SNAP)),)
    ifneq ($(strip $(BIRD_MUSIC_SERSOR_SNAP)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_music_snap=$(strip $(BIRD_MUSIC_SERSOR_SNAP))
    endif
    endif
    
    ifneq ($(strip $(BIRD_GALLERY_SERSOR_SNAP)),)
    ifneq ($(strip $(BIRD_GALLERY_SERSOR_SNAP)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_gallery_snap=$(strip $(BIRD_GALLERY_SERSOR_SNAP))
    endif
    endif
    
    ifneq ($(strip $(BIRD_BROWSER_SERSOR_SNAP)),)
    ifneq ($(strip $(BIRD_BROWSER_SERSOR_SNAP)),0)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.direct_browser_snap=$(strip $(BIRD_BROWSER_SERSOR_SNAP))
    endif
    endif
endif
endif

#bird: BUG #14307, BIRD_SD_CARD_FORMAT_AS_INTERNAL_MENU=no, chengting, @20160721 {
ifeq ($(BIRD_SD_CARD_FORMAT_AS_INTERNAL_MENU),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sd_as_internal_menu=true  
endif
#}@

# @ { BIRD zhouleigang 20141020, BIRD_AUDIO_CLAM_RING begin
ifeq ($(strip $(BIRD_AUDIO_CLAM_RING)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.clam_ring=true
endif
# @ }
#liuzhiling 20160712 begin
ifeq ($(strip $(BIRD_WHITE_NAME_LIST)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.white_name_list=true
  PRODUCT_PACKAGES += WhiteName
endif
#add by WangBiyao 20160706 begin
ifeq ($(strip $(BIRD_OPEN_MOBILE_DATA_WORK_LEAGOO)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.bird_open_mobile_data=true
endif
#add by WangBiyao 20160706 end
#add by WangBiyao 20160711 begin
ifeq ($(strip $(BIRD_SCTIME_OUT_NEVER)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.sctimeout_never=true 
endif
#add by WangBiyao 20160711 end

#add by zhaotingting 2016063 begin
ifeq ($(BIRD_APK_SogouInputOem),yes)
PRODUCT_PACKAGES += SogouInput
endif
#add by zhaotingting 20160613 end

#bird: show thunbnail in file recent,chengting,@20160801 {
ifeq ($(BIRD_FILE_RECENT_PICTURE_THUMBNAIL),no)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdui.recent_pic_thumbnail=false  
endif
#}@

#add by liuzhenting 20160801 begin
ifneq ($(strip $(MTK_VIDEO_PLAYER_SUPPORT)),no)
  PRODUCT_PACKAGES += Mtk_Videos
endif
#add by liuzhenting 20160801 end

#Launcher3 apps display two lines, add by peibaosheng @20160802 begin
ifeq ($(strip $(BIRD_LAUNCHER3_TWO_LINES)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.launcher3_two_lines = true
endif
#Launcher3 apps display two lines, add by peibaosheng @20160802 end
ifeq ($(strip $(BIRD_HAIER_APK)), yes)
  include packages/apps/Bird_APK/Haier/Haier.mk
endif
ifeq ($(strip $(BIRD_LONGPRESS_RECENT_SHOW_MENU)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.lprecent_show_menu=true
endif
#BIRD_LONGPRESS_RECENT_SHOW_MENU add by meifangting 20160713 end

#20160808 add by wuchenchen begin
ifeq ($(strip $(BIRD_SHOW_BATTERY_AVERAGE_CURRENT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_battery_average = true
endif
#20160808 add by wuchenchen end

#device name, add by peibaosheng @20160809 begin
ifneq ($(strip $(BIRD_DEVICE_NAME)), )
   PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.device_name = $(BIRD_DEVICE_NAME)
endif
#device name, add by peibaosheng @20160809 end

#bird: BUG #15174, remove accessibility -- global gesture menu, chengting, @20160810 {
ifeq ($(strip $(BIRD_GLOBAL_GESTURE_MENU)),no)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.global_ges_menu=false  
endif
#}@

#bird: for L508,change usb mode chooser notification icon as usb icon,default is adb icon,chengting,@20160810 {
ifeq ($(strip $(BIRD_USB_MODE_CHOOSER_STATUSBAR_ICON)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdui.usb_mode_status_icon=true  
endif
#}@

#bird: show/hide Voice Messages menu,chengting,@20160812 {
ifeq ($(strip $(BIRD_VOICE_MESSAGES_MENU)),no)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.voice_msg_menu=false  
endif
#}@

# bird: turn on screen when receive new message, add by peibaosheng @20160815 {
ifeq ($(strip $(BIRD_MMS_TURN_ON_SCREEN)), no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mms_turn_on_screen = false
endif
# @}

# bird: BUG #15235, BIRD_USB_MODE_DATA_UNLOCK, chengting,@20160811 {
ifeq ($(strip $(BIRD_USB_MODE_DATA_UNLOCK)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.usb_data_unlock = true
endif
# @}

# bird: BUG #15483, BIRD_SINGNAL_NETWORK_TYPE_ICON, show network type icon before signal icon, chengting, @20160615 {
ifeq ($(strip $(BIRD_SINGNAL_NETWORK_TYPE_ICON)), no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.signal_net_type_icon = false
endif
# @}

#bird add by liuzhenting 20160815 begin
ifeq ($(BIRD_NEW_STORAGE),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.new_storage=true 
endif
#bird add by liuzhenting 20160815 end

# @ { BIRD jiali 20160815, BIRD_FLIP_ANSWER_CALL_MENU begin
ifeq ($(strip $(BIRD_FLIP_ANSWER_CALL_MENU)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.flip_answer_call_menu=true
endif
# @ }
#bird:BIRD_3P_TOUCH_SCREENSHOT_INACCESSIBILITY,liuchaofei @20160816{
ifeq ($(strip $(BIRD_3P_TOUCH_SCREENSHOT_INACCESSIBILITY)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.3p_scr_shot_in_access=true  
endif
#}@
#bird:BIRD_SMART_MOT_IN_SETTING,liuchaofei @20160816{
ifeq ($(strip $(BIRD_SMART_MOT_IN_SETTING)),no)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.smart_mot_in_Setting=false  
endif
#}@

# @ { BIRD jiali 20160817, BIRD_DOUBLECLICK_DIALRECENT begin
ifeq ($(strip $(BIRD_DOUBLECLICK_DIALRECENT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.doubleclick_dialrecent=true
endif
# @ }

# @ { bird jiali 20160823, BIRD_SEARCH_CONTACT_SIM
ifeq ($(strip $(BIRD_SEARCH_CONTACT_SIM)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.search_contact_sim=true
endif
# @ }

# @ { BIRD jiali 20160823, no bg picture for single sim statusbar
ifeq ($(strip $(BIRD_SINGLESIMSTATE_NO_BG)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.singlesimnobg=true
endif
# @ }


# @ { bird jiali 20160826, BIRD_HEADSETHOOK_SHOWINCALLSCREEN
ifeq ($(strip $(BIRD_HEADSETHOOK_SHOWINCALLSCREEN)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.headset_incallscn=true
endif
# @ }
#20160718 add by wuchenchen begin
ifeq ($(strip $(BIRD_STATUS_BAR_LEAGOO)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdui.status_ber_leagoo=true
endif
#20160718 add by wuchenchen end
#20160718 add by wuchenchen begin
ifeq ($(strip $(BIRD_ADD_NETWORK_TYPE_ICON_CANCEL_DIALOG)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hide_dialog=true
endif
#20160718 add by wuchenchen end
ifeq ($(strip $(BIRD_MODIFY_MENU_PRESS)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun_modify_menu_press=true
endif 
#add by zhanglixian 20160830 end

# bird: long press Home to show menu, peibaosheng @20161026 {
ifeq ($(strip $(BIRD_LONGPRESS_HOME_SHOW_MENU)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.lp_home_show_menu = true
endif
# @}

# bird: customize recent button function, add by peibaosheng @20160909 {
ifeq ($(strip $(BIRD_CUSTOMIZE_RECENT_BUTTON)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.custom_recent_btn = true
endif
# @}

#20160831 add by wuchenchen begin
ifeq ($(strip $(BIRD_NETWORK_SIGNAL_2G_3G_4G)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sg_2g_3g_4g = true
endif
#20160831 add by wuchenchen end
#20160716 add by wuchenchen begin

#BIRD_PQ_PICTURE_MODE  0-->Standard  1-->Vivid  2-->User mode
ifdef BIRD_PQ_PICTURE_MODE
PRODUCT_PROPERTY_OVERRIDES += \
        persist.sys.pq.picmode=$(BIRD_PQ_PICTURE_MODE)
endif
#BIRD_PQ_PICTURE_MODE
ifeq ($(strip $(BIRD_SIGNAL_NETWORK_G_TO_E_AND_H_TO_3G)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun_sg_nw_style_hto3g_gtoe = true
endif
#add by hanyang 20160308 begin
ifeq ($(BIRD_VIBRATOR_PHONE_IDEL),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun_vib_phone_incoming = true
endif
#add by hanyang 20160308 end
#20160902 add by wuchenchen begin
ifeq ($(strip $(BIRD_PERMISSION_NOTIFIER_HIDE)),yes)
       PRODUCT_PROPERTY_OVERRIDES += ro.bdui.perm_noti_hide=true
endif
#20160902 add by wuchenchen begin
#add by liuzhiling 20160902 begin
ifeq ($(strip $(BIRD_SUPER_POSERSAVE_APP)),yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.super_paversave_app = true 
   PRODUCT_PACKAGES += PSMmode
endif
#add by liuzhiling 20160902 end

#add by WangBiyao 20160713 begin
ifeq ($(BIRD_SHOW_REGULATORY_INFO),yes)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_regulatory_info=true
endif
#add by WangBiyao 20160713 end
#add by liuzhiling 20160716 begin
ifeq ($(strip $(BIRD_MMITEST_VIEW_HARDWAREINFO)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdview_hardwareinfo_mmi = true
endif
#add by liuzhiling 20160716 end
#add by zhanglixian 20160901 begin
ifeq ($(strip $(BIRD_FROSTED_GLASS_UI_POWER_OFF)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdui.frosted_poweroff=true
endif 
#add by zhanglixian 20160901 end
#add by wangye 20160906 begin
ifeq ($(strip $(BIRD_DEVICE_INFO_LOGO_LEAGOO)),yes)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.add_logo_leagoo = true
endif
#add by wangye 20160906 end
#add by WangBiyao 20160905 begin
ifeq ($(strip $(BIRD_FAKE_FOCUS_WITHFLASH)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fakefocus_witchflash=true
endif
ifneq ($(strip $(BIRD_FAKE_FOCUS)), )
  ifeq ($(strip $(BIRD_FAKE_FOCUS)), front)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fakefocus=2
  else ifeq ($(strip $(BIRD_FAKE_FOCUS)), back)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fakefocus=1
  else ifeq ($(strip $(BIRD_FAKE_FOCUS)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fakefocus=0
  endif
endif
#add by WangBiyao 20160905 end
#add by WangBiyao 20160708 begin
ifeq ($(strip $(BIRD_CAMERA_NEW_UI)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun_camera_new_ui=true
endif
#add by WangBiyao 20160708 end

#bird:set SIM as the default sms save location,liuchaofei,@20160906{ 
ifeq ($(strip $(BIRD_DEF_SMS_SAVE_LOCATION_SIM)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.def_sms_location_sim=true
endif
#@}

# bird: status bar expand,quick settings,show data connection menu,chengting @20160907 {
ifeq ($(strip $(BIRD_QS_DATA_CONNECTION)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.qs_data_conn = true
endif
# @}
#bird:BIRD_SHOW_MMS_LEN_ALWAYS add for show sms characters always by xufangfang 20160907 start
ifeq ($(strip $(BIRD_SHOW_MMS_LEN_ALWAYS)),yes)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.show_mms_len_always=true
endif
#bird:BIRD_SHOW_MMS_LEN_ALWAYS add for show sms characters always by xufangfang 20160907 end

#BIRD_MCCMNC_LOCK_DEFAULT
ifneq ($(strip $(BIRD_MCCMNC_LOCK_DEFAULT)),no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mccmnc_lock_default=true
endif

#BIRD_MCCMNC_LOCK_COMMON
ifeq ($(strip $(BIRD_MCCMNC_LOCK_COMMON)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mccmnc_lock_common=true
endif

#BIRD_LAUNCHER_LOOP_SCROLL add by qinzhifeng 20160909 begin
ifeq ($(strip $(BIRD_LAUNCHER_LOOP_SCROLL)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.launcher_loop=true
endif
#BIRD_LAUNCHER_LOOP_SCROLL add by qinzhifeng 20160909 end

# @ { bird jiali 20160902, BIRD_SUBCAMERA_HIDEFLASH
ifeq ($(strip $(BIRD_SUBCAMERA_HIDEFLASH)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.subcam_noflash=true
endif
# @ }

#@{bird, sunqi 20160908, BIRD_EXIF_STRING_MAKE BIRD_EXIF_STRING_MODEL
ifneq ($(strip $(BIRD_EXIF_STRING_MAKER)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.exif_string_maker=$(BIRD_EXIF_STRING_MAKER)
endif
ifneq ($(strip $(BIRD_EXIF_STRING_MODEL)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.exif_string_model=$(BIRD_EXIF_STRING_MODEL)
endif
#@}
#20160913 add by wuchenchen begin
ifeq ($(strip $(BIRD_WIFI_HOTSPOT_ALWAYS_KEEP)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.wifi_hotspot_keep=true
endif
#20160913 add by wuchenchen begin

#add by zhanglixian 20160919 begin
ifeq ($(BIRD_SIM_EMERGENCY_CALL),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sim_emergency_call = true
endif
#add by zhanglixian 20160919 nd

#add by zhanglixian 20160914 begin
ifeq ($(strip $(BIRD_USB_CONNECT_EFFECT)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.usb_connect_effect = true
	PRODUCT_COPY_FILES += bird/sounds/usb_effect/usb_connected_effect.ogg:system/media/ui/notifications/usb_connected_effect.ogg
	PRODUCT_COPY_FILES += bird/sounds/usb_effect/usb_failed_effect.ogg:system/media/ui/notifications/usb_failed_effect.ogg
endif
#add by zhanglixian 20160914 begin

#bird:PREFERENCE_ALL_CALL_ACCOUNTS,control the proference of phone_accounts_all_calling_accounts,liuchaofei,@20160920{
ifeq ($(strip $(PREFERENCE_ALL_CALL_ACCOUNTS)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.pref_allcall_accounts=true
endif
#@}

# bird: set low battery warning level, add by peibaosheng @20160924 {
ifdef BIRD_LOW_BATTERY_WARNING_LEVEL
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.low_battery_warn_lv = $(BIRD_LOW_BATTERY_WARNING_LEVEL)
endif
# @}

# bird: set auto open battery saver level, add by peibaosheng @20160926 {
ifdef BIRD_AUTO_OPEN_SAVER_LEVEL
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.auto_open_saver_lv = $(BIRD_AUTO_OPEN_SAVER_LEVEL)
endif
# @}

#bird:BIRD_CALENDAR_HIGHLIGHT_SELECTED_DAY, high light the Background of selected day ,liuchaofei,@20160927{
ifeq ($(strip $(BIRD_CALENDAR_HIGHLIGHT_SELECTED_DAY)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.highlight_selected_day=true
endif
#
#bird:control qs DndTile,liuchaofei,@20160924{
ifeq ($(strip $(BIRD_STATUSBAR_DROP_DOWN_DND)), no)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.statu_drop_dnd=false
endif
#@}

#bird:add qs ClearTile ,liuchaofei,@20160924{
ifeq ($(strip $(BIRD_STATUSBAR_DROP_DOWN_CLEAN)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.statu_drop_clean=true
endif
#@}

#BIRD_REMOVE_POINTER_SETTINGS, add by mapengcheng 20160926
ifeq ($(strip $(BIRD_REMOVE_POINTER_SETTINGS)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.rm_pointer_settings=true
endif
#BIRD_REMOVE_POINTER_SETTINGS, add by mapengcheng 20160926

#BIRD_VIDEO_QUALITY_VALUE, add by shenzhiwang 20160927
ifneq ($(strip $(BIRD_VIDEO_QUALITY_VALUE)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.video_quality=$(BIRD_VIDEO_QUALITY_VALUE)
endif
#BIRD_VIDEO_QUALITY_VALUE

#BIRD_SMS_WITHOUT_MMS add by huguangchao 20160927 it's function is whether sms has mms
ifeq ($(strip $(BIRD_SMS_WITHOUT_MMS)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sms_without_mms=true
endif

#BIRD_WIFI_NO_SOUND add by huguangchao 20160927 it's function is whether wifi has sound
ifeq ($(strip $(BIRD_WIFI_NO_SOUND)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.wifi_no_sound=true
endif

#BIRD_NO_USSDTONE, add by gaokaidong @20160926 {
ifeq ($(strip $(BIRD_NO_USSDTONE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.no_ussdtone=true
endif
#@}

#bird:add qs EnergySavingTile ,liuchaofei,@20160924{
ifeq ($(strip $(BIRD_STATUSBAR_DROP_DOWN_ENERGYSAVING)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.statu_drop_energysave=true
endif
#@}

#bird:add for mistake touch mode feature,liuchaofei @20160928{
ifdef BIRD_ANTI_MISTAKE_TOUCH
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.anti_mistake_touch=$(BIRD_ANTI_MISTAKE_TOUCH)
endif
#@}

#BIRD_LAUNCHER3_CHANGE_CALENDAR_ICON_DYNAMICALLY add by lichengfeng 20161006 begin
ifeq ($(strip $(BIRD_LAUNCHER3_CHANGE_CALENDAR_ICON_DYNAMICALLY)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.calendar_icon_c_d=true
endif
#BIRD_LAUNCHER3_CHANGE_CALENDAR_ICON_DYNAMICALLY add by lichengfeng 20161006 end

#BIRD_LAUNCHER3_LAUNCHER_MENU_INTEX_FUN_OPEN add by lichengfeng 20161006 begin
ifeq ($(strip $(BIRD_LAUNCHER3_LAUNCHER_MENU_INTEX_FUN_OPEN)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.menu_intex_fun=true
endif
#BIRD_LAUNCHER3_LAUNCHER_MENU_INTEX_FUN_OPEN add by lichengfeng 20161006 end

#add by liuzhenting 20161010 begin
ifeq ($(strip $(BIRD_MAX_DIGITS_ALERT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.max_digits_alert=true
endif
#add by liuzhenting 20161010 end


# bird,BUG #16931,chengting,for Launcher3_L,@20161010 {
ifneq ($(strip $(BIRD_LAUN3_MENU_ROW)), )
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.laun_menu_row = $(BIRD_LAUN3_MENU_ROW)
endif
ifneq ($(strip $(BIRD_LAUN3_MENU_COL)), )
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.laun_menu_col = $(BIRD_LAUN3_MENU_COL)
endif
# @}

# bird,TASK #7762,chengting,for Launcher3_L,@20161121 {
ifneq ($(strip $(BIRD_LAUN3_MENU_BACKGROUD_ALPHA)), )
  	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.laun_menu_alpha = $(BIRD_LAUN3_MENU_BACKGROUD_ALPHA)
endif
# @}

#bird : lock screen left icon, remove voice icon , use phone icon by xufangfang 20161010
ifeq ($(strip $(BIRD_KEYGUARD_REMOVE_VOICE_ICON)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.keygd_rem_voice_icon = true
endif

#Gsm Mode ischecked add by gaokaidong @20161010{
#------------------begin-----------------------
ifeq ($(strip $(BIRD_GSM_ISCHECKED)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gsm_ischecked=true
endif
ifeq ($(strip $(BIRD_GSM_EGSM900_CHECKED)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gsm_egsm900_checked=true
endif
ifeq ($(strip $(BIRD_GSM_DCS1800_CHECKED)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gsm_dcs1800_checked=true
endif
ifeq ($(strip $(BIRD_GSM_PCS1900_CHECKED)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gsm_pcs1900_checked=false
endif
ifeq ($(strip $(BIRD_GSM_GSM850_CHECKED)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gsm_gsm850_checked=false
endif
ifeq ($(strip $(BIRD_GSM_SIM1)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gsm_sim1=true
endif
ifeq ($(strip $(BIRD_GSM_SIM2)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gsm_sim2=true
endif
#------------------------end--------------------@}

# bird: show battery percent icon, peibaosheng @20161013 {
ifeq ($(strip $(BIRD_SHOW_BATTERY_PERCENT_ICON)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.battery_percent_icon = 1
endif
# @}

#@ {bird:add by fanglongxiang #20161017    
ifeq ($(strip $(BIRD_SHOW_DEVELOPMENT)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bird.show_dev = true
endif
#@ }bird:add by fanglongxiang #20161017 
ifeq ($(strip $(BIRD_RESTORE_SETTINGS)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.restore_settings=true 
endif

#BIRD_FAKE_SCREEN_SIZE, add start by shenzhiwang, 20161019 {@
ifeq ($(strip $(BIRD_FAKE_SCREEN_SIZE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fake_screen_size=true 
endif
#@}

#BIRD_WHTESCRREN_FRONTCAMERA_FLASHON, add start by meifangting, 20161020 {@
ifeq ($(strip $(BIRD_WHTESCRREN_FRONTCAMERA_FLASHON)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.white_front_flash=true 
endif
#@}


# bird: add by gaokaidong, @20161019 {
ifeq ($(BIRD_NUMBER_PLUS7TO8),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.number_plus7to8=true
endif
#@}
ifeq ($(strip $(BIRD_CAMERA_TIMESTAMP)),no) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.timestamp = 0
else ifeq ($(strip $(BIRD_CAMERA_TIMESTAMP)),off) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.timestamp = 1
else ifeq ($(strip $(BIRD_CAMERA_TIMESTAMP)),on) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.timestamp = 2
endif

#bird:BIRD_SINGNAL_MOBILETYPE_ICON,show mobile type in the top left hand corner of signal strength,liuchaofei,@20161020{
ifeq ($(strip $(BIRD_SINGNAL_MOBILETYPE_ICON)), no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.signal_mobiletype_icon = false
endif
# @}

# BIRD_MCCMNC_LOCK_FOR_CLARO
ifeq ($(BIRD_MCCMNC_LOCK_FOR_CLARO),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.mccmnc_lock_claro=true
endif
# @}

# bird: voice mail config,liuchaofei,@20161021 {
ifeq ($(strip $(BIRD_LOAD_CUSTOM_VOICE_MAIL)),yes)
  PRODUCT_COPY_FILES += \
      bird/voicemail/$(BIRD_LOAD_CUSTOM_VOICE_MAIL_CONFIG).xml:system/etc/voicemail-conf.xml
endif
# @}

#BIRD_DATA_CONNECT_BY_SUBID,shenzhiwang,@20160322
ifeq ($(strip $(BIRD_DATA_CONNECT_BY_SUBID)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.data_conn_by_subid = true
endif

# bird: remove browser homepage picker preference, peibaosheng @20161025 {
ifeq ($(strip $(BIRD_CUSTOM_BROWSER_REMOVE_HOMEPAGE)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.browser_rm_home = true
endif
# @}

# { @ BIRD_LOAD_DEFAULT_LAUNCHER port by ningzhiyu from 6753 L
ifdef BIRD_LOAD_DEFAULT_LAUNCHER
  PRODUCT_PROPERTY_OVERRIDES += \
        bird_default_start_launcher=$(BIRD_LOAD_DEFAULT_LAUNCHER)
endif
# @}

#BIRD_SETTINGLOCKWALL,zhangbi,@20161025
ifeq ($(strip $(BIRD_SETTINGLOCKWALL)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bird.lockwall = true
endif
#BIRD_SETTINGLOCKWALL,zhangbi,@20161025

# bird:BUG #16957,BIRD_CUSTOM_DATA_ROAMING_MODE,chengting,@20161025 {
ifeq ($(strip $(BIRD_CUSTOM_DATA_ROAMING_MODE)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.data_roam_mode = true
    ifneq ($(strip $(BIRD_CUSTOM_DATA_ROAMING_MODE_DEF)),)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.data_roam_mode_def = $(BIRD_CUSTOM_DATA_ROAMING_MODE_DEF)
    endif
endif
# @}

# bird: show data activity icon, peibaosheng @20161028 {
ifeq ($(strip $(BIRD_DATA_ACTIVITY_ICON)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.data_activity_icon = true
endif
# @}

#bird: low storage notice (800M),xiongjian, @20161031 {
ifeq ($(strip $(BIRD_LOW_STORAGE_NOTICE)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.low_storage_notice=true
endif
#@}

# bird: long press home to toggle torch, peibaosheng @20161101 {
ifeq ($(strip $(BIRD_HOME_TORCH_SUPPORT)), no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.home_torch_support = false
endif
# @}

#bird:display sim toolkit in settings,gaolei,@20161102 begin
ifeq ($(strip $(BIRD_SIMTOOLKIT_INSETINGS)),no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.simtoolinsettings=false
endif
#bird:display sim toolkit in settings,gaolei,@20161102 end
#bird: BUG #17570, remove dataprotect menu , xiongjian, @20161102 {
ifeq ($(strip $(BIRD_REMOVE_DATA_PROTECTION_MENU)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.re_dataprotect_menu=true 
endif
#@}
#BIRD_CAMERA_FOCUS_SOUND_OFFON zhangbi 2016/1105 
ifeq ($(strip $(BIRD_CAMERA_FOCUS_SOUND_OFFON)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdcamera.focus_sound=true 
endif
#BIRD_CAMERA_FOCUS_SOUND_OFFON zhangbi 2016/1105

#BIRD_THEME_MANAGER add by qinzhifeng 20161105 begin
ifeq ($(strip $(BIRD_THEME_MANAGER)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.theme_manager=true
	PRODUCT_PACKAGES += ThemeManager
endif
#BIRD_THEME_MANAGER add by qinzhifeng 20161105 end

# BIRD_CAMERA_FLASH_DEFAULT auto off on zhangbi 20161105
ifneq ($(strip $(BIRD_CAMERA_FLASH_DEFAULT)),) 
    PRODUCT_PROPERTY_OVERRIDES +=ro.bdcamera.flashdefault=$(BIRD_CAMERA_FLASH_DEFAULT)
endif
# BIRD_CAMERA_FLASH_DEFAULT auto off on zhangbi 20161105

#Latin ime defalt selected languages
#BIRD_DEFAULT_LATIN_IME_LANGUAGES = yes
#DEFAULT_LATIN_IME_LANGUAGES = en_US,hi
ifeq ($(strip $(BIRD_DEFAULT_LATIN_IME_LANGUAGES)),yes)
    ifdef DEFAULT_LATIN_IME_LANGUAGES
        PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.latin_ime_def_lang = $(DEFAULT_LATIN_IME_LANGUAGES)
    endif
endif

#bird:storage statistical adaptation by system or other,liuchaofei,@20161109{
ifdef BIRD_STORAGE_STATISTICAL_ADAPTATION
	PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.storage_stats_adapt = $(BIRD_STORAGE_STATISTICAL_ADAPTATION)
endif
#@}

#bird:control the defult apn editable,liuchaofei,@20161114{
ifeq ($(strip $(BIRD_DEFAULT_APN_EDITABLE)),no)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.def_apn_editable=false
endif
#@}

# bird: set gallery scale limit, peibaosheng @20161115 {
ifdef BIRD_GALLERY_MAX_SCALE_PERCENTAGE
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gallery_max_pct = $(BIRD_GALLERY_MAX_SCALE_PERCENTAGE)
endif
ifdef BIRD_GALLERY_DOUBLE_TAP_PERCENTAGE
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gallery_tap_pct = $(BIRD_GALLERY_DOUBLE_TAP_PERCENTAGE)
endif
# @}

# bird @ { add by lichengfeng 20161115 begin sunwave config
ifneq ($(strip $(SUWNAVE_VDD)), )
	PRODUCT_PROPERTY_OVERRIDES += persist.sw.fp.vdd=$(strip $(SUWNAVE_VDD))
endif

ifneq ($(strip $(SUWNAVE_LOG_ENABLE)), )
	PRODUCT_PROPERTY_OVERRIDES += persist.sw.fp.dbg.log=$(strip $(SUWNAVE_LOG_ENABLE))
endif

ifneq ($(strip $(SUWNAVE_9395_TOUCH_SENSIBILITY_R)), )
	PRODUCT_PROPERTY_OVERRIDES += persist.sw.fp.touch.para.r=$(strip $(SUWNAVE_9395_TOUCH_SENSIBILITY_R))
endif

ifneq ($(strip $(SUWNAVE_9395_TOUCH_SENSIBILITY_C)), )
	PRODUCT_PROPERTY_OVERRIDES += persist.sw.fp.touch.para.c=$(strip $(SUWNAVE_9395_TOUCH_SENSIBILITY_C))
endif

ifneq ($(strip $(SUWNAVE_92_TOUCH_SENSIBILITY_LEVEL)), )
	PRODUCT_PROPERTY_OVERRIDES += persist.sw.fp.sensitivity.level=$(strip $(SUWNAVE_92_TOUCH_SENSIBILITY_LEVEL))
endif

# check duplicate finger while enroll 0, 1 or 100
# 0: do not check duplicate finger.
# 1: check duplicate just in the first enroll.
# 100: check everytimes.
ifneq ($(strip $(SUWNAVE_IS_ALWAYS_CHECK_ENROLL)), )
	PRODUCT_PROPERTY_OVERRIDES += persist.sw.enroll.dblfinger=$(strip $(SUWNAVE_IS_ALWAYS_CHECK_ENROLL))
endif

# effect area while enroll.
# 40<=area<=70  default 60 
ifneq ($(strip $(SUWNAVE_EFFECTIVE_PIC_AREA)), )
	PRODUCT_PROPERTY_OVERRIDES += persist.sw.fp.pix.area=$(strip $(SUWNAVE_EFFECTIVE_PIC_AREA))
endif

# auto calculate times while enroll 0,1
# 0: auto calculate.
# 1: just 15.
ifneq ($(strip $(SUWNAVE_AUTO_CALCULATE_PIC_NUM)), )
	PRODUCT_PROPERTY_OVERRIDES += persist.sw.enroll.const.finge=$(strip $(SUWNAVE_AUTO_CALCULATE_PIC_NUM))
endif

# screenoff report KEY 0,1 default :1
# 0: do not report KEY while screen off.
# 1: report KEY.
ifneq ($(strip $(SUWNAVE_IS_UPLOAD_KEY_IN_SCREENOFF)), )
	PRODUCT_PROPERTY_OVERRIDES += persist.sw.key.screenoff=$(strip $(SUWNAVE_IS_UPLOAD_KEY_IN_SCREENOFF))
endif
# bird @ { add by lichengfeng 20161115 end sunwave config

# bird: click camera key to open app, add by peibaosheng @20161119 {
ifeq ($(strip $(BIRD_CAMERA_KEY_OPEN_APP)), no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.camera_key_open_app = false
endif
# @}

# bird: factory reset required min battery level, peibaosheng @20161119 {
ifdef BIRD_FACTORY_RESET_BATTERY_LEVEL
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.factory_reset_lv = $(BIRD_FACTORY_RESET_BATTERY_LEVEL)
endif
# @}

# bird: set sub and main camera's default picture ratio, peibaosheng @20161121 {
ifdef BIRD_CAMERA_SUB_DEFAULT_PICTURE_RATIO
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.camera_sub_pratio = $(BIRD_CAMERA_SUB_DEFAULT_PICTURE_RATIO)
endif
ifdef BIRD_CAMERA_MAIN_DEFAULT_PICTURE_RATIO
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.camera_main_pratio = $(BIRD_CAMERA_MAIN_DEFAULT_PICTURE_RATIO)
endif
# @}

# bird: TASK #7782,remove heads up for incomming call,chengting,@20161121 {
ifeq ($(strip $(BIRD_FULLSCREEN_INCOMING_CALL)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.full_scr_new_call = true
endif
# @}

# bird,intex launcher,TASK #7786,chengting,@20161123 {
ifneq ($(strip $(BIRD_LQ_LAUNCHER3_CONFIG)),)
  config := $(strip $(BIRD_LQ_LAUNCHER3_CONFIG))
  src_files := $(shell ls  packages/apps/Bird_APK/LQLauncher3/uiconfig/$(config)/config)
  PRODUCT_COPY_FILES += $(foreach file, $(src_files),packages/apps/Bird_APK/LQLauncher3/uiconfig/$(config)/config/$(file):system/media/config/$(file))
endif
ifeq ($(strip $(BIRD_LQ_LAUNCHERINTEX)),yes)
  PRODUCT_PACKAGES += LauncherIntex
endif
ifeq ($(strip $(BIRD_THEME_INTEX)),yes)
  PRODUCT_PACKAGES += ThemeIntex
endif
# @}

#bird:quickly press power button for three times,generate an emergency call to 112,gaolei,@20161122 begin
ifeq ($(strip $(BIRD_THREE_TIME_TO_CALL_112)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.to_call_112 = true
endif
#bird:quickly press power button for three times,generate an emergency call to 112,gaolei,@20161122 end

#bird:TASK #7770,Emergency Resuce,gaolei,@20161122 begin
ifeq ($(strip $(BIRD_MMITEST_RTC_TIMER)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun_mmi_rtc_time=true
endif
#bird:TASK #7770,Emergency Resuce,gaolei,@20161122 end

#bird:TASK #7770,Emergency Resuce,gaolei,@20161122 begin
ifeq ($(strip $(BIRD_SET_EMERGENCY_CONTACT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun_set_emerg_contact=true
endif
#bird:TASK #7770,Emergency Resuce,gaolei,@20161122 end

#bird: Captured Image and Video name should be displayed as format,gaolei @20161122 begin
ifeq ($(strip $(TNTEX_CHANGE_IMG_AND_VID_NAME)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.intex_change_img_name=true
endif
#bird: Captured Image and Video name should be displayed as format,gaolei @20161122 end
#bird:TASK#7774,def_tether_ipv6_intex,xiongjian,@20161123 {
ifeq ($(strip $(BIRD_TETHER_IPV6_DEF)), yes) 
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_tether_ipv6_def=true
endif
#@}

#bird:Sales Tracker should be implemented properly for India,,gaolei @20161124 begin
ifeq ($(strip $(BIRD_MODIFY_MMS_FORMAT)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mms_format=true
endif
#bird:Sales Tracker should be implemented properly for India,,gaolei @20161124 end

#bird:Sales Tracker should be implemented properly for India,,gaolei @20161124 begin
ifeq ($(strip $(BIRD_CUSTOM_EWC)),yes) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.custom_ewc = true
endif
#bird:Sales Tracker should be implemented properly for India,,gaolei @20161124 end

#bird:Sales Tracker should be implemented properly for India,,gaolei @20161124 begin
ifeq ($(strip $(BIRD_INDEX_SET_TIME)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ewc_set_time=true
endif
#bird:Sales Tracker should be implemented properly for India,,gaolei @20161124 end

#bird:add by gaokaidong @20161129 for add music pause Imageview begin
ifeq ($(strip $(BIRD_ADD_MUSIC_PAUSE)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.add_music_pause = true
endif
#bird:add by gaokaidong @20161129 for add music pause Imageview end
# bird:BIRD_SYSTEM_SPACE, change get total memory by build.prop ,liuchaofei, @201608029
ifdef BIRD_PHONE_TOTAL_MEMORY_SIZE
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.phone_total_memory = $(BIRD_PHONE_TOTAL_MEMORY_SIZE)
endif
# @}

#bird:BIRD_SYSTEM_SPACE, change get rom memory by build.prop, @201608029{
ifdef BIRD_SYSTEM_ROM_MEMORY_SIZE
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.system_rom_memory = $(BIRD_SYSTEM_ROM_MEMORY_SIZE)
endif
# @}

#bird:hidden the button of ECT menu when dialer,gaolei @20161203 begin
ifeq ($(strip $(BIRD_HIDDEN_BUTTON_ECT)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hidden_button_ect=true
endif
#bird:hidden the button of ECT menu when dialer,gaolei @20161203 end

# bird: atomized ui about global actions, peibaosheng @20161203 {
ifeq ($(strip $(BIRD_ATOMIZED_UI_GLOBAL_ACTIONS)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.atomized_global_action=true
endif
# @}
#bird:BUG #18645 6118SQF7_L509,remove *#*#3646633#*#* cmd.xiongjian,@20161208{
ifeq ($(strip $(BIRD_REMOVE_MTKLOG_CMD)), yes) 
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.re_mtklog_cmd=true
endif
#@}
#BIRD:add by wangye 20161209 begin
ifeq ($(strip $(BIRD_SETTINGS_LOGO_VORTEX)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.settings_logo_vortex = true
endif
#BIRD:add by wangye 20161209 end

# bird: TASK #7811, show h+ instead of h for data connection,chengting,@20161128 {
ifeq ($(strip $(BIRD_SIGNAL_NETWORK_STYLE_H_TO_HPLUS)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.signal_h_to_hplus=true
endif
# @}

#bird:regulary clean memory,liuchaofei,@20161205{
ifdef BIRD_REGULAY_CLEAN_MEMORY
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.regulay_clean_memory=$(BIRD_REGULAY_CLEAN_MEMORY)
endif
#@}
#bird: BIRD_DIAL_CMD_INTEX_SAR_DISPLAY add by xufangfang 20161214 start
ifeq ($(strip $(BIRD_DIAL_CMD_INTEX_SAR_DISPLAY)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.intex_sar_display = true
endif
#bird: BIRD_DIAL_CMD_INTEX_SAR_DISPLAY add by xufangfang 20161214 end

# bird: set alarm timeout and snooze, peibaosheng @20161222 {
ifdef BIRD_ALARM_TIMEOUT
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.bdfun.alarm_timeout=$(BIRD_ALARM_TIMEOUT)
endif
ifdef BIRD_ALARM_SNOOZE
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.bdfun.alarm_snooze=$(BIRD_ALARM_SNOOZE)
endif
# @}
#bird:move by xiongjian,@20161223{
#EWC, ningzhiyu 20150507 porting  EWC IMEI
ifeq ($(strip $(BIRD_EWC_IMEI)), yes)
  PRODUCT_PACKAGES += EWC_IMEI
endif
#EWC, ningzhiyu 20150829 mmx sales track
ifeq ($(strip $(BIRD_MMX_SALES_TRACK)), yes)
  PRODUCT_PACKAGES += MMXSalesTrack
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmsic.mmx_sales_sms=true
ifneq ($(strip $(BIRD_MMX_DEVICE_ID)), )
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.mmx_deviceid=$(BIRD_MMX_DEVICE_ID)
else
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.mmx_deviceid=MSQ414BLU
endif
endif

#MMX config End add by lihan Begin on20161229

ifeq ($(BIRD_APK_MMX_ActivationGeneric),system)
PRODUCT_PACKAGES += MMX_ActivationGeneric
PRODUCT_PROPERTY_OVERRIDES += ro.mmx.country=India
PRODUCT_PROPERTY_OVERRIDES += ro.mmx.hardware.version=V1.0.0
PRODUCT_PROPERTY_OVERRIDES += ro.mmx.sku.name=MSQ424WHI
endif

ifeq ($(BIRD_APK_MMX_ActivationGeneric),data)
PRODUCT_PACKAGES += MMX_ActivationGeneric
endif


ifeq ($(BIRD_APK_MMX_BackupRestore),system)
PRODUCT_PACKAGES += MMX_BackupRestore
endif


ifeq ($(BIRD_APK_MMX_MonsterTruckSaga),data)
PRODUCT_PACKAGES += MMX_MonsterTruckSaga
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_MonsterTruckSaga/libmain.so:system/lib/libmain.so
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_MonsterTruckSaga/libmono.so:system/lib/libmono.so
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_MonsterTruckSaga/libunity.so:system/lib/libunity.so
endif


ifeq ($(BIRD_APK_MMX_BackupRestore),data)
PRODUCT_PACKAGES += MMX_BackupRestore
endif


ifeq ($(BIRD_APK_MMX_MiGallery),system)
PRODUCT_PACKAGES += MMX_MiGallery
endif

ifeq ($(BIRD_APK_MMX_MiGallery),data)
PRODUCT_PACKAGES += MMX_MiGallery
endif


ifeq ($(BIRD_APK_MMX_SetupWizard),system)
PRODUCT_PACKAGES += MMX_SetupWizard
endif

ifeq ($(BIRD_APK_MMX_SetupWizard),data)
PRODUCT_PACKAGES += MMX_SetupWizard
endif

ifeq ($(BIRD_APK_MMX_SingleSignOn),system)
PRODUCT_PACKAGES += MMX_SingleSignOn
endif

ifeq ($(BIRD_APK_MMX_SingleSignOn),data)
PRODUCT_PACKAGES += MMX_SingleSignOn
endif


ifeq ($(BIRD_APK_MMX_Diag_Usagev),system)
PRODUCT_PACKAGES += MMX_Diag_Usagev
endif

ifeq ($(BIRD_APK_MMX_Diag_Usagev),data)
PRODUCT_PACKAGES += MMX_Diag_Usagev
endif


ifeq ($(BIRD_APK_MMX_RA),system)
PRODUCT_PACKAGES += MMX_RA
endif

ifeq ($(BIRD_APK_MMX_RA),data)
PRODUCT_PACKAGES += MMX_RA
endif



ifeq ($(BIRD_APK_MMX_Operamini),data)
PRODUCT_PACKAGES += MMX_Operamini
endif


ifeq ($(BIRD_APK_MMX_OperaBranding),system)
PRODUCT_PACKAGES += MMX_OperaBranding
endif


ifeq ($(BIRD_APK_MMX_SkypeRaider),system)
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_SkypeRaider/skype_raider_stub-2.4.536.12207.apk:system/app/skype_raider_stub-2.4.536.12207.apk
endif


ifeq ($(BIRD_APK_MMX_Skype),data)
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_Skype/market-5.4.0.4165.apk:data/app/market-5.4.0.4165.apk
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_Skype/market-5.4.0.4165.apk:system/vendor/operator/app/market-5.4.0.4165.apk
#PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_Skype/libBreakpadIntegration.so:system/lib/libBreakpadIntegration.so
#PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_Skype/libcodecs.so:system/lib/libcodecs.so
#PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_Skype/libRtmMediaManagerDyn.so:system/lib/libRtmMediaManagerDyn.so
#PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_Skype/libSkyLib-Version-2015-03-01-482.so:system/lib/libSkyLib-Version-2015-03-01-482.so
#PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_Skype/libSkypeAndroid.so:system/lib/libSkypeAndroid.so
endif


ifeq ($(BIRD_APK_MMX_Scandid),data)
PRODUCT_PACKAGES += MMX_Scandid
endif


ifeq ($(BIRD_APK_MMX_UDIO),data)
PRODUCT_PACKAGES += MMX_UDIO
endif


ifeq ($(BIRD_APK_MMX_Snapdeal),data)
PRODUCT_PACKAGES += MMX_Snapdeal
endif


ifeq ($(BIRD_APK_MMX_Amazon),data)
PRODUCT_PACKAGES += MMX_Amazon
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_Amazon/amzn.mshop.properties:system/etc/amzn.mshop.properties
endif


ifeq ($(BIRD_APK_MMX_VuLiv),data)
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_VuLiv/MMX_VuLiv.apk:system/vendor/operator/app/MMX_VuLiv/MMX_VuLiv.apk
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_VuLiv/libanw.18.so:system/lib/libanw.18.so
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_VuLiv/libanw.21.so:system/lib/libanw.21.so
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_VuLiv/libblasV8.so:system/lib/libblasV8.so
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_VuLiv/librsjni.so:system/lib/librsjni.so
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_VuLiv/libRSSupport.so:system/lib/libRSSupport.so
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/MMX_VuLiv/libvlcjni.so:system/lib/libvlcjni.so
endif

ifeq ($(BIRD_APK_MMX_IxidoCab),data)
PRODUCT_PACKAGES += MMX_IxidoCab
endif


ifeq ($(BIRD_APK_MMX_IxidoTravel),data)
PRODUCT_PACKAGES += MMX_IxidoTravel
endif

ifeq ($(BIRD_APK_MMX_Gaana),system)
PRODUCT_PACKAGES += MMX_Gaana
endif


ifeq ($(BIRD_APK_MMX_CMS),data)
PRODUCT_PACKAGES += MMX_CMS
endif


ifeq ($(BIRD_APK_MMX_CleanMaster),data)
PRODUCT_PACKAGES += MMX_CleanMaster
endif


ifeq ($(BIRD_APK_MMX_CMLocker),data)
PRODUCT_PACKAGES += MMX_CMLocker
endif

ifeq ($(BIRD_APK_MMX_TrendingApp),system)
PRODUCT_PACKAGES += MMX_TrendingApp
endif

ifeq ($(BIRD_APK_MMX_Cm_skey),system)
PRODUCT_COPY_FILES += packages/apps/Bird_APK/MMX_APK/skey/skey-signed.apk:system/priv-app/skey/skey-signed.apk
endif
#MMX config End add by lihan





#, ningzhiyu 20151106  sales track
ifeq ($(strip $(BIRD_SALES_TRACK)), yes)
  PRODUCT_PACKAGES += SalesTrack
endif
#@}

# bird: BUG #18861, peibaosheng @20161223 {
ifeq ($(strip $(BIRD_SHOW_ANDROID_SECURITY_PATCH_MENU)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.security_patch_menu=true
endif
ifeq ($(strip $(BIRD_SHOW_WHOLE_KERNEL_VERSION_MENU)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.whole_kernel_menu=true
endif
ifeq ($(strip $(BIRD_SHOW_CUSTOM_BUILD_VERSION_MENU)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.custom_build_menu=true
endif
# @}

#bird: BUG #19378 ,add by gaokaidong @20110112 begin
ifeq ($(strip $(BIRD_WIRELESS_CHARGER_SUPPORT)), no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.wireless_changer=true
endif
#bird: BUG #19378 ,add by gaokaidong @20110112 end

# bird: BUG #19423, lichengfeng @20170112 {
ifeq ($(strip $(BIRD_FINGERPRINT_ENROLL_NOT_RESPONSE_KEYHOME)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fp_enroll_n_r_khome=true
endif
# @}

# bird : lichengfeng fingerprint as key back, @20170414 {
ifeq ($(strip $(BIRD_FINGERPRINT_FUNC_KEYBACK_OPEN)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fp_func_keyback_op=true
PRODUCT_PROPERTY_OVERRIDES += persist.sys.sw.key.mod=1
endif
# @}

# bird : lichengfeng fingerprint as key home, @20170414 {
ifeq ($(strip $(BIRD_FINGERPRINT_FUNC_KEYHOME_OPEN)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fp_func_keyhome_op=true
PRODUCT_PROPERTY_OVERRIDES += persist.sys.sw.key.mod=1
endif
# @}

#Live Wall Paper, sunqi add 170116
PRODUCT_PACKAGES += \
    BasicWallpaper \
    Galaxy4Wallpaper \
    HoloSpiralWallpaper \
    NoiseFieldWallpaper \
    PhaseBeamWallpaper
#Live Wall Paper, sunqi add 170116

# bird : lichengfeng single launcher, @20161223 {
ifeq ($(strip $(BIRD_SINGLE_LAUNCHER_OPEN)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.single_launcher_open=true
endif
# @}

#bird: [BIRD_SINGLE_LAUNCHER3_HIDE_STATUSBAR_ONPRESSED] add by lichengfeng hide statusbar while press apps @20170309 begin
ifeq ($(strip $(BIRD_SINGLE_LAUNCHER3_HIDE_STATUSBAR_ONPRESSED)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.s_l_h_statusbar_o=true
endif


#bird: double sim ringtone add by gaokaidong @20170221 begin
ifeq ($(strip $(BIRD_GEMINI_VOICECALL_RINGTONE)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gemini_ringtone=true
endif
#bird: double sim ringtone add by gaokaidong @20170221 end

# bird: sms center number readonly,chengting,@20170303 {
ifeq ($(strip $(BIRD_SMS_CENTER_NUM_READONLY)),yes)
       PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sms_center_num_ro=true
endif
# @}

# bird: always show mms text counter,chenting,@20170306 {
ifeq ($(strip $(BIRD_SHOW_MMS_TEXT_COUNT_ALWASY)),yes)
       PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mms_txt_count_always=true
endif
# @}

#bird: remove ip call,gaolei,@20170306 begin
ifeq ($(strip $(BIRD_REMOVE_IP_MENU)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.remove_ip_menu=true
endif
#bird: remove ip call,gaolei,@20170306 end

#bird: call geo info,gaolei,@20170307 begin
ifeq ($(strip $(BIRD_CALL_NO_GEO_INFO)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.call_no_geo=true
endif
#bird: call geo info,gaolei,@20170307 end

#BIRD #20994 add by zhanglixian 20170307 begin
ifeq ($(strip $(BIRD_FAKE_CPU_MESSAGES)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fake_cpu_msg=true
endif
#BIRD #20994 add by zhanglixian 20170307 end

#bird:WangBiyao 20170309 begin
ifneq ($(strip $(BIRD_FILES_PRESET)),)
   PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.files_preset_loc=$(BIRD_FILES_PRESET)
endif 
ifeq ($(strip $(BIRD_CUSTOM_FILES_PRESET)),yes)
       PRODUCT_COPY_FILES += bird/media/fangsheng.mp3:system/custom/fangsheng.mp3
endif 
#bird:WangBiyao 20170309 end
#add by bird liuzhiling 20170308 for seatel
ifeq ($(strip $(BIRD_DEFAULT_WORKSPACE_SEATEL)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.def_wrokspace_seatel = true
endif 

#BIRD add by liuzhiling 20170309 begin
ifeq ($(strip $(BIRD_SIMLOCK_RETRY_COUNT)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.simlock_retry_count=true
endif
#BIRD add by liuzhiling 20170309 end

#bird:add by wangye  20170228 begin
ifeq ($(strip $(BIRD_SEATEL_4G_LOGO)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.seatel_4g_logo = true
endif
#bird:add by wangye  20170228 end
#bird:add by wangye  20170227 begin
ifeq ($(strip $(BIRD_DEFAULT_NETWORKTYPE_2G)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.def_nwtype_2g = true
endif
#bird:add by wangye  20170227 end
#BIRD add by liuzhiling 20170309 begin
ifeq ($(strip $(BIRD_SIMLOCK_IMEI_PASSWORD)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.simlock_imei_password=true
endif
#BIRD add by liuzhiling 20170309 end
#BIRD #20994 add by zhanglixian 20170316 begin
ifeq ($(strip $(BIRD_FAKE_CPU_FREQUENCY)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fake_cpu_rate=true
endif
#BIRD #20994 add by zhanglixian 20170316 end
#show simtoolkit in launcher and settings 20170317 begin
ifeq ($(strip $(BIRD_SIMTOOLKIT_IN_LAUNCHER)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.simtoolinsettings=false
endif
#show simtoolkit in launcher and settings 20170317 end
#bird:BUG #19277,xiongjian,@20170320{
ifeq ($(strip $(BIRD_MTK_SPEEDDIAL)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mtk_speeddial=true
endif
#@}
#BIRD add by zhaobaoming 20170317 begin
ifeq ($(strip $(BIRD_LAUNCHER_SETTINGS)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.launcher_settings=true
endif
ifeq ($(strip $(BIRD_SHOW_WALLPAPER)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_wallpaper=true
endif
#BIRD add by zhaobaoming 20170317 end

#BIRD add by lichengfeng 20170328 begin
ifeq ($(strip $(BIRD_GET_FP_IC_FRONT)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.get_fp_ic_front=true
endif
#BIRD add by lichengfeng 20170328 end

#BIRD add by lichengfeng 20170329 begin
ifeq ($(strip $(BIRD_FINGERPRINT_UNLOCK_ONLY_SCREENON)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fp_unlock_o_son=true
endif
#BIRD add by lichengfeng 20170329 end

#BIRD:add by wangye for bug#21679 20170327 begin
ifeq ($(strip $(BIRD_HIDE_SIMCARD_PREF)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hide_sim_pref=true
endif
#BIRD:add by wangye for bug#21679 20170327 end

# bird: BUG #22162,chengting,@20170331 {
ifeq ($(strip $(BIRD_SETTINGS_SUGGEST_REMOVE_FINGERPRINT)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.set_suggest_rm_fp=true
endif
# @}

#bird #10997:WangBiyao 20170330 begin
ifeq ($(strip $(BIRD_TEST_EWC)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.test_ewc=true
endif
ifeq ($(strip $(BIRD_CUSTOM_EWC)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.custom_ewc=true
endif
#bird #10997:WangBiyao 20170330 end
#bird:charge reminder notification when battery status full,gaolei,@20170331 begin
ifeq ($(strip $(BIRD_NOTIFY_WITH_CHARGE_STATUS)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.notify_charge_status=true
endif
#bird:charge reminder notification when battery status full,gaolei,@20170331 end

#bird:show total size at Settings and FileManager,gaolei,@20170405 begin
ifeq ($(strip $(BIRD_SHOW_TOTAL_SPACE)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_total_space=true
endif
#bird:show total size at Settings and FileManager,gaolei,@20170405 end
#BUG #22245,xiongjian,@20170407{
ifeq ($(strip $(BIRD_CAN_DELETE_ALL_APN)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.del_all_apn=true
endif
#@}
#BIRD #6669 add by zhanglixian 20170406 begin
ifeq ($(strip $(BIRD_CHANGE_ALL_CLEAR_BUTTON)),yes)
PRODUCT_PROPERTY_OVERRIDES += bd_fun_all_clear_button=true
endif
#BIRD #6669 add by zhanglixian 20170406 end
#bird:cutom preferred networks menu for tigo,xiongjian,@20170411{
ifeq ($(strip $(BIRD_PREFERRED_NETWORKS_MENU_TIGO)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.pref_net_menu_tigo=true
endif
#@}
#BIRD:add by wangye  20170408 begin
ifeq ($(strip $(BIRD_FACTORYRESET_PWD)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.facreset_pwd=true
endif
#BIRD:add by wangye  20170408 end
# bird: long press Home to show menu, peibaosheng @20161026 {
ifeq ($(strip $(BIRD_LONGPRESS_HOME_SHOW_MENU)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.lp_home_show_menu = true
endif
# @}

#bird:WangBiyao for gangyun tech beauty 20170411 begin
ifeq ($(strip $(GANGYUN_CAMERA_BEAUTY)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.gangyun_camera_beauty=1
  #PRODUCT_PACKAGES +=gyBeautySnap
endif
#bird:WangBiyao for gangyun tech beauty 20170411 end
#BIRD:add by wangye 20170412 begin
ifeq ($(strip $(BIRD_SHOW_FINGERPRINT_BUTTON)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_fp_button=true
endif
#BIRD:add by wangye 20170412 end

#bird:BUG #21796 6116SQ_V51 auto answer,gaolei, @20170413 begin
ifeq ($(strip $(BIRD_AUTO_ANSWER_MENU)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.auto_answer_menu=true
endif
#bird:BUG #21796 6116SQ_V51 auto answer,gaolei, @20170413 end

# bird: BUG #22983,chengting,@20170414 {
ifeq ($(strip $(BIRD_ALARM_VOLUME_KEY_ENABLE)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.alarm_vol_enable=true
endif

ifeq ($(strip $(BIRD_ALARM_POWER_KEY_SNOOZE)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.alarm_power_snooze=true
endif
# @}
#BIRD:add by liuqipeng for bug#22947 20170414 begin
ifeq ($(strip $(BIRD_SHOW_KERNEL_VERSION)), yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdui.show_kernel_version=true
endif
#BIRD:liuqipeng  end
#BIRD:add by liuqipeng for bug#22947 20170414 begin
ifeq ($(strip $(BIRD_SHOW_HARDWARE_INFO)), yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdui.show_hardware_info=true
endif
#BIRD:liuqipeng  end

# @ { BIRD_TRANSPARENT_SYSTEM_BAR, bird ningzhiyu, keep transparent system bar when low_ram is true
ifeq ($(strip $(BIRD_TRANSPARENT_SYSTEM_BAR)), no)
    PRODUCT_PROPERTY_OVERRIDES += ro.config.trans_bar=false
endif
# @ }

#@ {bird:add by fanglongxiang BIRD_ROCK_GOTA_ENABLE
ifeq ($(strip $(BIRD_ROCK_GOTA_ENABLE)), yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.rock_gota_enable=true
endif
#@ }

#BIRD_PHONENUMBER_MATCH, add by shenzhiwang, @20170522
ifneq ($(strip $(BIRD_PHONENUMBER_MATCH)), )
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.min_match=$(BIRD_PHONENUMBER_MATCH)
endif
#bird ningzhiyu show tempversion
ifeq ($(strip $(BIRD_TEMP_VERSION)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.temp_ver=true
endif
#end tempversion

#bird:BUG #22535,total and system memory in storage,gaolei,@20170420 begin
ifeq ($(strip $(BIRD_SYSTEM_SPACE_USED)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.system_space_used=true
endif
#bird:BUG #22535,total and system memory in storage,gaolei,@20170420 end
#add by bird tianjianwei 2017/04/20 begin
ifeq ($(strip $(BIRD_APN_DEFAULT_SORT_BY_FILE_LIST)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sort_by_file_list=true
endif
#add by bird tianjianwei 2017/04/20 end
#add by bird liuzhiling 2017/04/22 begin
ifeq ($(strip $(BIRD_MOBILETYPE_3G_TO_4G_TO_LTE)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mobile_type_4g_lte=true
endif
#add by bird liuzhiling 2017/04/22 end

#@ {bird: add by fanglongxiang 20161109 NO_INTERNET_PROMPT_CANCEL
ifeq ($(strip $(NO_INTERNET_PROMPT_CANCEL)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.no_int_pro_canc=false
endif
#@ }bird: add by fanglongxiang 20161109

#bird:TASK #7919 STK icon and title ,gaolei,@20170420 begin
ifeq ($(strip $(BIRD_STK_SIM_CLARO)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.stk_sim_claro=true
endif
#bird:TASK #7919 STK icon and title ,gaolei,@20170420 end

#bird:BUG #23121,remove "!" icon on status bar,gaolei, @20170425 begin
ifeq ($(strip $(BIRD_TELEPHONY_SIGNAL_ICON)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.telephony_signal_icon=true
endif
#bird:BUG #23121,remove "!" icon on status bar,gaolei, @20170425 end

# bird: BIRD_SMS_INPUT_MODE_MENU,force 7bit,chengting,@20170425 {
ifeq ($(strip $(BIRD_SMS_INPUT_MODE_MENU)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sms_input_mode_menu=true
endif
ifeq ($(strip $(BIRD_SMS_GSM_ALPHABET_FORCE_7BIT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sms_gsm_force_7bit=true
endif
# @}

#bird BUG #23517:WangBiyao 20170426 begin
ifeq ($(strip $(BIRD_NEW_FOTA_OEM)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.new_fota_oem=true
endif
#bird BUG #23517:WangBiyao 20170426 end
#BIRD:add by wangye 20170422 begin
ifeq ($(strip $(BIRD_NETWORK_4G_ONLY)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.network_4g_only=true
endif
#BIRD:add by wangye 20170422 end

#@ {bird: add by wucheng 20170425 OPPO_SIP_SUPPORT
ifeq ($(OPPO_SIP_SUPPORT),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.sip.xml:system/etc/permissions/android.software.sip.xml
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml
endif
#@ }bird: add by wucheng 20170425
#add by bird zhanglixian BIRD_CUSTOM_SIGNAL_STYLE 2017/04/11 start
ifeq ($(strip $(BIRD_CUSTOM_SIGNAL_STYLE)),DOOV)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.bird_signal_style=doov
else ifeq ($(strip $(BIRD_CUSTOM_SIGNAL_STYLE)),LOVEME)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.bird_signal_style=loveme
else ifeq ($(strip $(BIRD_CUSTOM_SIGNAL_STYLE)),L509)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.bird_signal_style=l509
endif 
#add by bird zhanglixian BIRD_CUSTOM_SIGNAL_STYLE 2017/04/11 end
#add by bird zhanglixian BIRD_SIGNAL_DROP_DELAY 2017/04/11 begin
ifeq ($(strip $(BIRD_SIGNAL_DROP_DELAY)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.signal_drop_delay=true
endif
#add by bird zhanglixian BIRD_SIGNAL_DROP_DELAY 2017/04/11 end

#add #22474 by bird zhanglixian BIRD_KEYGUARD_DESKCLOCK_SHOW_AMPM, 2017/04/25 begin
ifeq ($(strip $(BIRD_KEYGUARD_DESKCLOCK_SHOW_AMPM)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_ampm=true
endif
#add #22474 by bird zhanglixian BIRD_KEYGUARD_DESKCLOCK_SHOW_AMPM, 2017/04/25 end
#liuqipeng,@20170428, begin
ifeq ($(strip $(BIRD_DONT_CG_LAN_BYSIM)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.dont_cg_lan_bysim=true
endif
#liuqipeng,@20170428, end
#BIRD:add by wangye for bug#23740 20170429 begin
ifeq ($(strip $(BIRD_DISABLED_ENCRYPTION)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.disabled_encryption=true
endif
#BIRD:add by wangye for bug#23740 20170429 end

#BIRD_REMOVE_ZSD_SWITCH_MENU add by tianjianwei 2016/06/13
ifeq ($(strip $(BIRD_REMOVE_ZSD_SWITCH_MENU)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.remove_zsd_menu=true
endif
#BIRD_REMOVE_ZSD_SWITCH_MENU add by tianjianwei 2016/06/13

#bird BUG #23517:WangBiyao 20170426 begin
ifeq ($(strip $(BIRD_HIDE_STATUS_BAR_NETWORK_TYPE_ICON)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdui.hide_network_icon=true
endif
#bird BUG #23517:WangBiyao 20170426 end

#bird:BUG #24024,wifi_password,wucheng, 20170502 begin
ifneq ($(strip $(BIRD_SETTING_HOTSPOT_PASSWORD)), )  
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hotspot_password = $(BIRD_SETTING_HOTSPOT_PASSWORD)
endif 
#bird:BUG #24024,wifi_password,wucheng, 20170502 end
#add by bird liuzhiling 20170504 begin
ifneq ($(strip $(BIRD_LAUNCHER3_MENU_COL)), )
		PRODUCT_PROPERTY_OVERRIDES += ro.bird.laun_menu_col=$(BIRD_LAUNCHER3_MENU_COL)
endif 
#add by bird liuzhiling 20170504 end
#bird:WangBiyao 20161223 begin
# 0 --
# 1 -- MM-dd-yyyy
# 2 -- dd-MM-yyyy
# 3 -- yyyy-MM-dd
# 4 -- EE-MMM-d-yyyy
# 5 -- EE-d-MMM-yyyy
# 6 -- yyyy-MMM-d-E
ifneq ($(strip $(BIRD_DEFAULT_DATE_FORMAT)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.cust.default.date.format=$(BIRD_DEFAULT_DATE_FORMAT)
endif 
#bird:WangBiyao 20161223 end 

# bird:BIRD_BACKGROUND_APP_PROTECT,kill unprotected 3rd app when screen off,chengting,@20170111 {
ifeq ($(strip $(BIRD_BACKGROUND_APP_PROTECT)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.bg_app_protect = true
    
    config := bird/background_app_config/bg_app_config.xml
    ifneq ($(strip $(BIRD_BACKGROUND_APP_CONFIG)),)
        config := bird/background_app_config/$(strip $(BIRD_BACKGROUND_APP_CONFIG))/bg_app_config.xml
    endif
    $(warning bg app config is $(config))
    PRODUCT_COPY_FILES += $(config):/system/etc/bg_app_config.xml
    
endif

#BIRD:add by chenting for bug#24020 20170503 begin
ifeq ($(strip $(BIRD_REMOVE_LOCK_SCREEN)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.remove_lock_screen=true
endif
#BIRD:add by chenting for bug#24020 20170503 end

# @}
#bird:remove emergency button on keyguard screen,wucheng,@20170504,bug #24021 begin
ifeq ($(strip $(BIRD_REMOVE_ECC_BUTTON_NO_SECURE)), yes)  
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.remove_ecc_btn=true
endif 
#bird:remove emergency button on keyguard screen,wucheng,@20170504,bug #24021 end
#@ {bird:add by liuzhiling bug#24026 20170505
ifeq ($(strip $(BIRD_STATUSBAR_DROP_DOWN_BATTERYSAVING)), yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.statu_dp_batterysave=true
endif
#BIRD:add by wangye 20170504 begin
ifeq ($(strip $(BIRD_RESTORE_SETTINGS)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.restore_settings=true 
endif
#BIRD:add by wangye 20170504 end
#add by bird liuzhiling 20170506 begin
ifeq ($(strip $(BIRD_DATA_DISCONNECTED_ICON)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.data_disconnected_ic=true
endif 
#add by bird liuzhiling 20170506 end

#bird BUG #22955:WangBiyao 20170506 begin
ifeq ($(strip $(BIRD_EWC_IMEI_NO_SHOW_SMS)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.no_show_sms=true 
endif 

#BIRD add by chenting 20170504 begin
ifeq ($(strip $(BIRD_DATA_USAGE_TAB_MOBILE)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.usage_sim_visible = true
endif
#BIRD add by chenting 20170504 end

#bird BUG #24006:WangBiyao 20170509 begin
ifeq ($(strip $(BIRD_DATE_FIRST_LETTER_CAPS)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.date_first_letter_caps=true
endif
#bird BUG #24006:WangBiyao 20170509 end

#bird #10655:WangBiyao 20170509 begin
ifeq ($(strip $(BIRD_SHOW_MEW_PIXELS)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_new_pixels=true
endif
#bird #10655:WangBiyao 20170509 end

#bird BUG #24519:WangBiyao 20170511 begin
ifeq ($(strip $(BIRD_FRONT_VIDEO_SNAPSHOT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.front_video_snapshot=true
endif
#bird BUG #24519:WangBiyao 20170511 end
ifneq ($(strip $(BIRD_DEFAULT_INPUT_METHOD)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_default_ime=$(BIRD_DEFAULT_INPUT_METHOD)
endif 
#bird:WangBiyao 20161227 end 

#bird:BUG #24114 6116SQ_V51,remove phone all call accounts menu,gaolei @20170511 begin
ifeq ($(strip $(BIRD_REMOVE_ALL_CALL_ACCOUNTS)), yes)  
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.remove_call_accounts=true
endif 
#bird:BUG #24114 6116SQ_V51,remove phone all call accounts menu,gaolei @20170511 end

# bird: BUG #24474, peibaosheng @20170511 {
ifeq ($(strip $(BIRD_CAMERA_VIDEO_MODE_ADD_FLASH_ICON)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.cam_video_flash_icon = true
endif
ifeq ($(strip $(BIRD_SUB_FLASH_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sub_flash_support = true
endif
# @}

#bird:BUG #21123,not display clock icon on status bar,gaolei @20170512 begin
ifeq ($(strip $(BIRD_REMOVE_CLOCK_ICON)), yes)  
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.remove_clock_icon=true
endif 
#bird:BUG #21123,not display clock icon on status bar,gaolei @20170512 end

#liuqipeng add 20170515
ifeq ($(strip $(BIRD_HIDE_VIDEO_CALL)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hide_video_call=true
endif
#liuqipeng end 20170515
#liuqipeng add 20170516 TASK #7961
ifeq ($(strip $(BIRD_DATA_ROAMING_DEFAULT_ON)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.com.android.dataroaming=true
endif
#liuqipeng end 20170515

#BIRD add by wucheng 20170519 bug 24783 begin
ifeq ($(strip $(BIRD_DOUBLE_RINGS_CONSISTENT)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.same_ringstone = true
endif
#BIRD add by wucheng 20170519 bug 24783 end
#bird BUG #24796:liuqipeng 20170518 begin
ifeq ($(strip $(BIRD_DIAL_RECORD_TIMER)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.record_timer=true
endif
#bird BUG #24796:liuqipeng 20170518 end

#bird BUG #24781:WangBiyao 20170519 begin
ifeq ($(strip $(BIRD_REMOVE_FACE_BEAUTY)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.rm_face_beauty=true
endif
#bird BUG #24781:WangBiyao 20170519 end

#BIRD:#24984 add by chenting 20170522 begin
ifeq ($(strip $(BIRD_MODIFY_CMD_SAR_DISPLAY)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.modify_sar_display=true
endif
#BIRD:#24984 add by chenting 20170522 end
#BIRD:add by liuzhiling 20170524 begin
ifeq ($(strip $(BIRD_DATA_ACTIVITY_ICON)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.data_activity_icon=true 
endif
#BIRD:add by liuzhiling 20170524 end
#BIRD:add by wangye for bug#24406 20170524 begin
ifeq ($(strip $(BIRD_MMI_TFLASH_FAKE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mmi_tflash_fake=true 
endif
#BIRD:add by wangye for bug#24406 20170524 end

#bird:BUG #24586,quickly press power button for three times,can call 112,gaolei,@20170525 begin
ifeq ($(strip $(BIRD_THREE_TIME_TO_CALL_112)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.to_call_112 = true
endif
#bird:BUG #24586,quickly press power button for three times,can call 112,gaolei,@20170525 end

#BIRD:add by huangyaosheng for devSetting default off 20170524 begin
ifeq ($(strip $(BIRD_DEV_DEFAULT_OFF)), yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.dev_def_off=true
endif
#BIRD:add by huangyaosheng for devSetting default off 20170524 end

#BIRD:add by huangyaosheng for adb enable default off 20170525 begin
ifeq ($(strip $(BIRD_ADB_DEFAULT_OFF)), yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.adb_def_off=true
endif
#BIRD:add by huangyaosheng for adb enable default off 20170525 end
#BIRD add by chenting 20170525 bug 25149 begin
ifeq ($(strip $(BIRD_LONG_PRESS_ON_HOME_OPEN_GOOGLE)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.press_home_google = true
endif
#BIRD add by chenting 20170525 bug 25149 end
#BIRD add by chenting 20170526 begin
ifeq ($(strip $(BIRD_NUMBER_PLUS7TO8)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.number_plus7to8=true
endif
#BIRD add by chenting20170526 end
#bird: BUG #25200 ,add by huangyaosheng for show regulatory info  @20170527 begin
ifeq ($(BIRD_SHOW_REGULATORY_INFO),yes)
      PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_regulatory_info=true
endif
#bird: BUG #25200 ,add by huangyaosheng for show regulatory info @20170527 end

# bird: BIRD_INNER_SW_VERSION, peibaosheng @20170531 {
ifdef BIRD_INNER_SW_VERSION
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.inner_sw_version=$(BIRD_INNER_SW_VERSION)
endif
# @}
#add by bird zhanglixian 20170531 begin
ifneq ($(strip $(BIRD_CALENDAR_START_VIEW)),)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.calendar_start_view=$(strip $(BIRD_CALENDAR_START_VIEW))
endif
#add by bird zhanglixian 20170531 end
#bird BUG #24781:WangBiyao 20170531 begin
ifeq ($(strip $(BIRD_REMOVE_FACEART)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.rm_faceart=true
endif
#bird BUG #24781:WangBiyao 20170531 end
# bird: atomized ui about global actions, peibaosheng @20161203 {
ifeq ($(strip $(BIRD_ATOMIZED_UI_GLOBAL_ACTIONS)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.atomized_global_action=true
endif
# @}

#BIRD add by zhanglixian 20170603 end
ifeq ($(strip $(BIRD_NO_HOME_IN_FILEMANAGER)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.no_home_filemanaher=true
endif 
#BIRD add by zhanglixian 20170603 end

#bird BUG #24299:WangBiyao 20170605 begin
ifeq ($(strip $(BIRD_YOUTUBE_VIDEO_ERROR)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.youtube_video_err=true
endif
#bird BUG #24299:WangBiyao 20170605 end
#BIRD:add by wangye for BUG #22576 20170527 begin
ifeq ($(strip $(BIRD_VIBRATE_DEFAULT_ON)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.vibrate_default_on=true
endif
#BIRD:add by wangye for BUG #22576 20170527 end

# bird: add by meifangting 20170607  {
ifdef BIRD_PCBA_NAME
    PRODUCT_PROPERTY_OVERRIDES += ro.bird.pcba_name=$(BIRD_PCBA_NAME)
endif
ifdef BIRD_MAK_NAME
    PRODUCT_PROPERTY_OVERRIDES += ro.bird.mak_name=$(BIRD_MAK_NAME)
endif
# @}
# bird: add by liuqipeng 20170608  {
ifeq ($(strip $(BIRD_L509_STATUSBAR_ICON)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.l509_statusbar_icon=true
endif
ifeq ($(strip $(BIRD_REMOVE_SERVICE_TILES)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdui.remove_service_tiles=true
endif
# @}
#BIRD:add by huangtingzhen 20170617 begin
ifeq ($(strip $(BIRD_CUSTOMIZED_NEEDS_MK)), yes)
  include packages/apps/Bird_APK/Bird_customized_needs.mk
endif 
#BIRD:add by huangtingzhen 20170617 end

#bird BUG #26006:liuqipeng 20170617 begin
ifeq ($(strip $(BIRD_CUSTOM_LATIN_KEYBOARD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.custom_latin_keyboard=true
endif 
#bird BUG #26006:liuqipeng 20170617 end
#bird BUG #26006:liuqipeng 20170619 begin
ifeq ($(strip $(BIRD_SHOW_AUTO_BRIGHT_SWITCH)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_auto_bright=true
endif 
#bird BUG #26006:liuqipeng 20170619 end

#bird:BUG #25530,remove homepage with bookmarks and history,gaolei @20170622 begin
ifeq ($(strip $(BIRD_REMOVE_HOMEPAGE)), yes)  
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.remove_homepage=true
endif 
#bird:BUG #25530,remove homepage with bookmarks and history,gaolei @20170622 end

#bird,add gsensor test with tip direction ,liuchaofei@20170622{

ifeq ($(strip $(BIRD_MMI_AUTO_TEST_SENSOR_TIP_DIRECTION)), yes)  
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_sensor_tip_direct=true
endif

ifeq ($(strip $(BIRD_MMI_AUTO_TEST_GSENSOR_FD)), yes)  
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mt_gsensor_fd=true
endif 
#@20170622}

#bird:add DTS tile on quick settings,gaolei,@20170626 begin
ifeq ($(strip $(BIRD_STATUS_DTS_SWITCH)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.status_dts_switch=true
endif
#bird:add DTS tile on quick settings,gaolei,@20170626 end

# bird:BUG #22032,chengting,@20170329 {
ifeq ($(strip $(BIRD_MTK_COLP_FEATURE_DISABLE)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bd.mtk_colp_feature_disable=true
endif
# @}

# bird,skip setupwizard by code,liuchaofei@20170630{
ifeq ($(strip $(BIRD_SKIP_SETUPWIZARD)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.skip_setupwizard=true
endif
# @20170630}


#bird:BUG #26857 add dialog with two sim,gaolei @20170704 begin
ifeq ($(strip $(BIRD_DATA_CONNECTION_2_SIM)), yes)  
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.data_connection_2_sim=true
endif 
#bird:BUG #26857 add dialog with two sim,gaolei @20170704 end

# bird: BIRD_FM_MEDIA_KEY,short press to play/pause,long press to play next station,chengting,@20170110 {
ifeq ($(strip $(BIRD_FM_MEDIA_KEY)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fm_media_key = true
endif
# @}

# bird: add by jiali 20170621 {
ifeq ($(strip $(BIRD_COMPATIBLE_MARK_CHECK_APK)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.compat_mark_check=true
  PRODUCT_PACKAGES += CompatibleMarkCheck
endif
# @}

#bird:BUG #25613,show all audio,gaolei @20170717 begin
ifeq ($(strip $(BIRD_SHOW_ALL_RECORDINGS)), no)  
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.show_all_recordings=false
endif 
#bird:BUG #25613,show all audio,gaolei @20170717 end


#bird:system ui status bar blur,gaolei @20170718 begin
ifeq ($(strip $(BIRD_STATUS_BAR_BLUR)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.status_bar_blur = true
endif
#bird:system ui status bar blur,gaolei @20170718 end

#bird:add ro.multilaser.model in build.prop,gaolei @20170727 begin
ifdef BIRD_MULTILASER_MODEL
    PRODUCT_PROPERTY_OVERRIDES += ro.multilaser.model=$(BIRD_MULTILASER_MODEL)
endif
#bird:add ro.multilaser.model in build.prop,gaolei @20170727 end

#bird: BIRD_FINGERPRINT_HIDE_SPACE_APP_LOCK for control menu for fingerprint app lock,liuchaofei@20170803{
ifeq ($(strip $(BIRD_FINGERPRINT_HIDE_SPACE_APP_LOCK)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fp_hide_app_lock = true
endif
#@20170803}

#bird: BIRD_FINGERPRINT_HIDE_QUICK_SETTINGS for control menu for fingerprint quick settings,liuchaofei@20170803{
ifeq ($(strip $(BIRD_FINGERPRINT_HIDE_QUICK_SETTINGS)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.fp_hide_quick_settings = true
endif
#@20170803}

# [BIRD][cmcc smartsms]
ifeq ($(strip $(BIRD_CMCC_SMARTSMS_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.cmcc_smartsms=1
endif
# [BIRD][cmcc smartsms] end

# bird: grayscale function, peibaosheng @20161230 {
ifeq ($(strip $(BIRD_GRAYSCALE_FUNCTION)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gray_scale=true
endif
# @}

#bird:BUG #29519,show percentage in icon,gaolei @20170906 begin
ifeq ($(strip $(BIRD_PERCENTAGE_BATTERY_ICON)), yes)  
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.pcg_battery_icon=true
endif 
#bird:BUG #29519,show percentage in icon,gaolei @20170906 end

ifeq ($(strip $(BIRD_CAMERA_TIMESTAMP)),no) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.timestamp = 0
else ifeq ($(strip $(BIRD_CAMERA_TIMESTAMP)),off) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.timestamp = 1
else ifeq ($(strip $(BIRD_CAMERA_TIMESTAMP)),on) 
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.timestamp = 2
endif
#EMA_SEARCH_BOX add by ShiCuiliang, 20171020.
ifeq ($(strip $(EMA_SEARCH_BOX)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.ema_searchbox=0
endif
#EMA_SEARCH_BOX
#wuganzhi add by maoyufeng 20171020 begin
ifneq ($(strip $(BIRD_REMOVE_MOSILENT)),yes)
   PRODUCT_PROPERTY_OVERRIDES +=  ro.bdfun.mosilent=true
endif
#device info add by maoyufeng 20171027
ifneq ($(strip $(BIRD_SCREEN_SIZE)),)
  PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.screen_size=$(BIRD_SCREEN_SIZE)
endif
ifneq ($(strip $(BIRD_THEME_DUOWEI_REMOVE)),yes)
 PRODUCT_PACKAGES += ThemeDuowei
endif

#bird,add customer Engine command list by engineer.xml{
#ifeq ($(strip $(BIRD_LOAD_CUSTOM_ENGINEER_COMMAND)),yes)
  PRODUCT_COPY_FILES += \
      bird/engineer/engineer.xml:system/etc/custom/engineer.xml
#endif
# @}
ifeq ($(strip $(CY_DYNAMIC_CALENDAR)),yes)
    PRODUCT_PROPERTY_OVERRIDES +=ro.fun.dynamic_calendar=true
endif

#@ {bird: For set default usb mode MTP, add by ShiCuiliang 20180313.
ifeq ($(strip $(BIRD_DEFAULT_CONNECTION_MTP)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.default_connection_mtp=true
endif
#@ }
#bug #35398 add by maoyufeng 20180316 begin
ifeq ($(strip $(CY_REMOVE_CALL_RECORD)),yes)
    PRODUCT_PROPERTY_OVERRIDES +=ro.bdfun.remove_call_record=true
endif
#bug #35398 add by maoyufeng 20180316 end

#@ {bird: add by meifangting@szba-mobile.com 2018/4/2 .
ifeq ($(strip $(BIRD_PHONEINFO_SECRET_CODE)), yes)
	PRODUCT_PACKAGES += PhoneInfo
endif
#@ }

#@ {bird: For fix bug#35395, for add SoundRecorder, add by shicuiliang@szba-mobile.com 2018/3/20 .
ifeq ($(strip $(BIRD_PKG_SOUND_RECORDER)),yes)
	PRODUCT_PACKAGES += SoundRecorder2
endif
#@ }

#@ {bird: For fix bug#35399, add by shicuiliang@szba-mobile.com 2018/3/27 .
ifeq ($(strip $(BIRD_SIM_DUAL_DEFAULT_DIALOG)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sim_dual_default_dlg=true
endif
#@ }
#add by bird wucheng 20180419 begin
ifneq ($(strip $(MICROTRUST_TEE_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.googlekey_tee=false
endif
#add by bird wucheng 20180419 end

#add by meifangting 20180525
ifeq ($(strip $(BIRD_REMOVE_GOOGLEKEY_TEE)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.googlekey_tee=false
endif

#@ {bird: For fix bug#35563, add by shicuiliang@szba-mobile.com 2018/3/30 .
ifeq ($(strip $(BIRD_USB_CHOOSE_MIDI_HIDE)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.usb_choose_midi_hide=true
endif
#@ }

# bird: tigo dialer cmd for mtk logger,chengting,@20180410 {
ifeq ($(strip $(BIRD_DIALER_CMD_TIGO)),yes)
    PRODUCT_PROPERTY_OVERRIDES +=ro.bdfun.dialer_cmd_tigo=true
endif
# @}

# bird: hide geocode,chengting,@20180411 {
ifeq ($(strip $(BIRD_HIDE_CALL_GEOCODE)),yes)
    PRODUCT_PROPERTY_OVERRIDES +=ro.bdfun.hide_call_geo=true
endif
# @}

# bird: hide "x" icon when data is not connected,chengting,@20180417 {
ifeq ($(strip $(BIRD_HIDE_STATUS_BAR_DATA_DISABLED_ICON)),yes)
    PRODUCT_PROPERTY_OVERRIDES +=ro.bdui.hide_data_disconn_icon=true
endif
# @}

#bird:add by meifangting 20180315  begin
ifeq ($(strip $(BIRD_STATUSBAR_CLOCK_NOT_SHOW_AMPM)),yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ro.bdui.statusbar_showampm=false
endif

# bird:BUG #36701  lihan,@20180421 {
ifeq (yes,$(strip $(BIRD_HAS_NAVBAR)))
    PRODUCT_PROPERTY_OVERRIDES +=qemu.hw.mainkeys=0
else
    PRODUCT_PROPERTY_OVERRIDES +=qemu.hw.mainkeys=1
endif
# @}

#@ {bird: For set data saver default off, add by ShiCuiliang 20180313.
ifeq ($(strip $(BIRD_RESTRICT_DATA_ON)),yes)
        PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.restrict_data_on=true
endif
#@ }

#bird:add by meifangting 20180315  begin
ifeq ($(strip $(BIRD_ACCELEROMETER_ROTATION_DEFAULT_ON)),yes)
		PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.rotation_def_on=true
endif
#bird:add by meifangting 20180315 end

# BIRD_FLASH_DEFAULT_VALUE auto off on meifangting 20180224
ifneq ($(strip $(BIRD_FLASH_DEFAULT_VALUE)),) 
    PRODUCT_PROPERTY_OVERRIDES +=ro.bdmisc.flash_default=$(BIRD_FLASH_DEFAULT_VALUE)
endif
# @}

# bird: chengting,@20180424 {
ifeq ($(strip $(BIRD_TIGO_APP_IGNITE)),yes)
    PRODUCT_PACKAGES += Ignite
endif
# @}

# bird: show am/pm when time 12 format,chengting,@20180424 {
ifeq ($(strip $(BIRD_KEYGUARD_CLOCK_SHOW_AMPM)),no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdui.keyguard_showampm=false
endif
# @}

# bird:BIRD_REMOVE_VIDEO_CALL_MENU,chengting,@20180424 {
ifeq ($(strip $(BIRD_REMOVE_VIDEO_CALL_MENU)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.remove_vt_menu=true
endif
# @}


# bird:BIRD_PICTURESIZE_ADD_18_9,meifangting,@20180427 {
ifeq ($(strip $(BIRD_PICTURESIZE_ADD_18_9)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdmisc.picturesize_18_9=true
endif
# @}

#@ {bird: For fix bug#36753, add by shicuiliang@szba-mobile.com 2018/4/25 .
ifeq ($(strip $(BIRD_VIBRATE_FOR_CALL_OFF)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.vibrate_for_call_off=true
endif
#@ }

#@ {bird: For fix bug#36758, add by shicuiliang@szba-mobile.com 2018/4/25 .
ifneq ($(strip $(BIRD_GALLERY_TAP_ZOOM)),)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gallery_tap_zoom = $(strip $(BIRD_GALLERY_TAP_ZOOM))
endif
#@ }

# bird:BUG #36821,chengting,@20180427 {
ifeq ($(strip $(BIRD_HIDE_AUTO_BRIGHT_MENU)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.hide_auto_bright_menu=true
endif
# @}

#@ {bird: For fix bug#36978, add by shicuiliang@szba-mobile.com 2018/4/28.
ifeq ($(strip $(BIRD_DEFAULT_STORAGE_OPEN)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.mtk_default_write_disk=1
endif
#@ }

#@ {bird: For fix bug#36758, add by shicuiliang@szba-mobile.com 2018/5/2.
ifneq ($(strip $(BIRD_GALLERY_TAP_SCALE)),)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.gallery_tap_scale = $(strip $(BIRD_GALLERY_TAP_SCALE)))
endif
#@ }
#BUG #37211  add by maoyufeng 20180504 begin
ifeq ($(strip $(BIRD_MMI_RESTORE_FACTORY)),yes)
    PRODUCT_PROPERTY_OVERRIDES +=ro.bdfun.mmitest_restore_factory=true
endif
#BUG #37211  add by maoyufeng 20180504 end
#BUG #37096 add by meifangting 20180525 begin
ifeq ($(strip $(BIRD_KEYBOARD_SPEEDDIAL)),yes)
    PRODUCT_PROPERTY_OVERRIDES +=ro.bdfun.speeddial=true
endif
#BUG #37096 add by meifangting 20180525 begin

# bird: BIRD_LAUNCHER_UNREAD_SUPPORT,chengting,@20180420 {
ifeq ($(strip $(BIRD_LAUNCHER_UNREAD_SUPPORT)),no)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.launcher_unread=false
endif
# @}

#@ {bird: For fix bug#37379, add by shicuiliang@szba-mobile.com 2018/5/9.
ifeq ($(strip $(BIRD_RIL_CLIENT_ID_SHOW)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.ril_client_id_show = true
endif
#@ }

#@ {bird: For fix bug#37449, add by shicuiliang@szba-mobile.com 2018/5/11.
ifeq ($(strip $(BIRD_SIM_TOOLKIT_CUSTOM)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sim_toolkit_custom = true
endif
#@ }

#@ {bird: For fix bug#37449, add by shicuiliang@szba-mobile.com 2018/5/11.
ifneq ($(strip $(BIRD_SIM_TOOLKIT_TITLE)),)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.sim_toolkit_title = $(strip $(BIRD_SIM_TOOLKIT_TITLE))
endif
#@ }

#@ {bird: For fix bug#36983, add by shicuiliang@szba-mobile.com 2018/5/14.
ifeq ($(strip $(BIRD_LAUNCHER_SETTING_SYSTEM)),yes)
	PRODUCT_PROPERTY_OVERRIDES +=  ro.bdfun.launcher_settings = true
endif
#@ }

#@ {bird: For fix bug#37280, add by shicuiliang@szba-mobile.com 2018/5/15.
ifeq ($(strip $(BIRD_MARK_AS_EMERGENCY_OPEN)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mark_as_emergency_open = true
endif
#@ }

#@ {bird: For fix bug#37280, add by shicuiliang@szba-mobile.com 2018/5/15.
ifeq ($(strip $(BIRD_CALL_LOG_EMERGENCY)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.call_log_emergency = true
endif
#@ }

# bird:BUG #37099 for remove phone account,lizhenye,@20180518 {
ifeq ($(strip $(BIRD_REMOVE_PHONE_ACCOUNT)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.remove_phone_account=true
endif
# @}

#@ {bird: For fix bug#37946, add by shicuiliang@szba-mobile.com 5/28/2018.
ifneq ($(strip $(BIRD_CAMERA_EXIF_MODEL)),)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.camera_exif_model = $(strip $(BIRD_CAMERA_EXIF_MODEL))
endif
#@ }
# bug 37951 add by maoyufeng 20180529 begin
ifeq ($(strip $(CY_ADD_DEVICEIDlE_WHITE_LIST)),yes)
	 PRODUCT_COPY_FILES += \
    bird/deviceidle/deviceidle.xml:/data/system/deviceidle.xml
endif
# bug 37951 add by maoyufeng 20180529 end

#@ {bird: For fix bug#37868, add by shicuiliang@szba-mobile.com 6/2/2018.
ifeq ($(strip $(BIRD_BATTERY_OPTION_DUP_HIDE)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdui.battery_option_dup_hide = true
endif
#@ }

#@ {bird: For fix bug#37884, add by shicuiliang@szba-mobile.com 6/4/2018.
ifeq ($(strip $(BIRD_SAFE_UPDATE_DUP_HIDE)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdui.safe_update_dup_hide = true
endif
#@ }

#bird,[BUG #36816] for TIGO mccmnc lock by sunqi 180602
ifeq ($(strip $(BIRD_MCCMNC_LOCK_FOR_TIGO)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.mccmnc_lock_for_tigo=true
endif
#bird,[BUG #36816] for TIGO mccmnc lock by sunqi 180602

#@ {bird: For fix bug#38192, add by shicuiliang@szba-mobile.com 6/6/2018.
ifeq ($(strip $(BIRD_TASK_PERSIST_OPEN)),yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.task_persist_open = true
endif
#@ }
#BUG #38236 add by maoyufeng 20180608 begin
ifeq ($(strip $(BIRD_REMOVE_APP_LIST)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.bdfun.remove_applist=true
endif
#BUG #38236 add by maoyufeng 20180608 end