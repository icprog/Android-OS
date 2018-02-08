
package com.bird.settings;

import android.os.SystemProperties;
import android.text.TextUtils;

/** This Class is generated by Bird */

public final class BirdFeatureOption {
    public static final boolean BIRD_SHOW_HARDWARE_INFO = SystemProperties.getBoolean("ro.bdui.show_hardware_info",false);//add by liuqipeng @2017.04.14
    public static final boolean BIRD_SHOW_KERNEL_VERSION = SystemProperties.getBoolean("ro.bdui.show_kernel_version",false);//add by liuqipeng @2017.04.14			
    public static final boolean BIRD_PROXIMITY_CALIBRATION = SystemProperties.getBoolean("ro.bdfun.psensor_calibrate", false);
    public static final boolean BIRD_GSENSOR_CALIBRATION = SystemProperties.getBoolean("ro.bdfun.gsensor_calibrate", false);
    public static final boolean BIRD_BACKUP_SENSOR = SystemProperties.getBoolean("ro.bdfun.backup_sensor", false);
    //add by mapengcheng 20170111
    public static final boolean BIRD_SETTING_MORE_RINGTONES = SystemProperties.getBoolean("ro.bdmisc.setting_more_ringtone", true);
    //bird:move by xiongjian @20161216{
	public static final boolean BIRD_SIMTOOLKIT_INSETINGS = SystemProperties.getBoolean("ro.bdfun.simtoolinsettings", true);//add by liuzhiling 20170317
	//@}
	
    /// bird: BUG #15235, BIRD_USB_MODE_DATA_UNLOCK, chengting,@20160811 {
    public static final boolean BIRD_USB_MODE_DATA_UNLOCK = SystemProperties.getBoolean("ro.bdfun.usb_data_unlock",false);
	//bird:move by xiongjian @20161216{
	public static final boolean BIRD_DEFAULT_LATIN_IME_LANGUAGES = !TextUtils.isEmpty(SystemProperties.get("ro.bdfun.latin_ime_def_lang"));
    /// @}

    public static final boolean BIRD_SHOW_SHULIAN_FOTA = SystemProperties.getBoolean("ro.bdfun.shulian_fota", false);//add by lvhuaiyi for shulian fota
    //bird: BUG #19378 ,add by gaokaidong @20110112 begin
    public static final boolean BIRD_WIRELESS_CHARGER_SUPPORT = SystemProperties.getBoolean("ro.bdfun.wireless_changer", false);
    //bird: BUG #19378 ,add by gaokaidong @20110112 end

    //bird:double sim ringtone add by gaokaidong @20170221 begin
    public static final boolean BIRD_GEMINI_VOICECALL_RINGTONE = SystemProperties.getBoolean("ro.bdfun.gemini_ringtone", false);
    //bird:double sim ringtone add by gaokaidong @20170221 end

		public static final boolean BIRD_BATTERY_PERCENTAGE = SystemProperties.getBoolean("ro.bdfun.bird_battery_percent", false);//add by liuzhiling 20170309

    public static final boolean BIRD_FILES_PRESET = (SystemProperties.get("ro.bdfun.files_preset_loc").length() > 0);//bird:WangBiyao 20170309
    public static final boolean BIRD_SHOW_WALLPAPER = SystemProperties.getBoolean("ro.bdfun.show_wallpaper", true);//add by bird zhaobaoming #21392
	
	//BIRD [BIRD_GET_FP_IC_FRONT] add by lichengfeng 20170328 begin
	public static final boolean BIRD_GET_FP_IC_FRONT = SystemProperties.getBoolean("ro.bdfun.get_fp_ic_front", false);
    //BIRD [BIRD_GET_FP_IC_FRONT] add by lichengfeng 20170328 end

    /// bird:show total size at Settings and FileManager,gaolei,@20170405 {
    public static final boolean BIRD_SHOW_TOTAL_SPACE = SystemProperties.getBoolean("ro.bdfun.show_total_space", false);
    /// @}
	public static final boolean BIRD_CAN_DELETE_ALL_APN = SystemProperties.getBoolean("ro.bdfun.del_all_apn", false);//bird:BUG #22245,xiongjian,@20170407

    ///bird:BUG #21419,phone encrypt,gaolei, @20170410 {
    public static final boolean BIRD_ENABLE_ENCRYPTION = SystemProperties.getBoolean("ro.bdfun.encryption", false);
    /// @}

	//@ {bird: add by fanglongxiang BIRD_ROCK_GOTA_ENABLE}
	public static final boolean BIRD_ROCK_GOTA_ENABLE = SystemProperties.getBoolean("ro.bdfun.rock_gota_enable", false);
	
    ///bird:BUG #22535,total and system memory in storage,gaolei,@20170420 {
    public static final boolean BIRD_SYSTEM_SPACE_USED = SystemProperties.getBoolean("ro.bdfun.system_space_used", false);
    /// @}
	public static final boolean BIRD_ANTI_MISTAKE_TOUCH = SystemProperties.getInt("ro.bdfun.anti_mistake_touch",1) != 0; //bird:add for mistake touch mode feature,liuchaofei @20160928
	///bird:BUG #24467 6116SQ_V51,remove USB MIDI menu,gaolei @20170511 {
    public static final boolean BIRD_REMOVE_USB_MIDI_MENU = SystemProperties.getBoolean("ro.bdmisc.rm_usb_midi_menu", false);
    /// @}

	
	//bird:The function of the fingers,xiongjian,@20170511{
	public static final boolean BIRD_MULTI_TOUCH = SystemProperties.getBoolean("ro.bdfun.multi_touch", false);
    public static final boolean BIRD_2POINT_TOUCH_VK = SystemProperties.getBoolean("ro.bdfun.2p_touch_vk", false);
    public static final boolean BIRD_3POINT_TOUCH_SCREENSHOT = SystemProperties.getBoolean("ro.bdfun.3p_touch_screenshot", false);
	public static final boolean BIRD_2POINT_TOUCH_CHANGE_WALLPAPER = SystemProperties.getBoolean("ro.bdfun.2p_touch_CW", false); 
	public static final boolean BIRD_3POINT_TOUCH_TURN_ON_CAMERA = SystemProperties.getBoolean("ro.bdfun.3p_touch_camera", false); 
	//@}

    ///bird:BUG #25993,data default off,gaolei @20170621 {
    public static final boolean BIRD_GEMINI_DEFAULT_DATA_ON = SystemProperties.getBoolean("ro.bdfun.auto_cellular_data", false);
    public static final boolean BIRD_GEMINI_DEFAULT_DATA_ON_ALWAYS = SystemProperties.getBoolean("ro.bdfun.always_cellular_data", false);
    public static final boolean BIRD_DATA_CONNECT_BY_SUBID = SystemProperties.getBoolean("ro.bdmisc.data_conn_by_subid", false);
    /// @}

    public static final boolean BIRD_FINGERPRINT_HIDE_SPACE_APP_LOCK = SystemProperties.getBoolean("ro.bdfun.fp_hide_app_lock", false);
}
