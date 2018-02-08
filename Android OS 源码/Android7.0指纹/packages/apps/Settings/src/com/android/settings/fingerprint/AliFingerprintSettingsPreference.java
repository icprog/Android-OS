package com.android.settings.fingerprint;

import java.util.ArrayList;
import java.util.List;
import android.os.Bundle;
//import android.preference.Preference;
import android.support.v7.preference.Preference;
import android.support.v7.preference.ListPreference;
import android.support.v7.preference.Preference.OnPreferenceClickListener;
import android.support.v7.preference.Preference.OnPreferenceChangeListener;
import android.support.v7.preference.PreferenceGroup;
import android.support.v7.preference.PreferenceScreen;
import android.support.v7.preference.PreferenceViewHolder;
import android.content.Context;
import android.content.Intent;
import android.hardware.fingerprint.Fingerprint;
import android.hardware.fingerprint.FingerprintManager;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;
import android.util.Log;
import com.android.settings.R;

import com.android.settings.ChooseLockSettingsHelper;

public class AliFingerprintSettingsPreference extends Preference {

    private static int FINGERPRINT_SIZE = 5;
    public static final String FINGERPRINT = "fingerprint";
    private Context mContext;
    private AliFingerprintUser mUser;
    private ArrayList<String> mNameList;
	private View mView;
	private int mUserId;
	
    public AliFingerprintSettingsPreference(Context context, AliFingerprintUser user, ArrayList<String> list, int userId) {
        super(context);
        setLayoutResource(R.layout.ali_fingerprint_item);
        mContext = context;
        mUser = user;
        mNameList = list;
		mUserId = userId;
    }	

    public AliFingerprintSettingsPreference(Context context, AliFingerprintUser user, ArrayList<String> list) {
        super(context);
        setLayoutResource(R.layout.ali_fingerprint_item);
        mContext = context;
        mUser = user;
        mNameList=list;
    }
	
	public AliFingerprintUser getUser() {
		return mUser;
	}
	
	public boolean isUserEqualsNull() {
		return mUser == null;
	}

    @Override
    protected void onClick() {
    }
	
	public View getView() { return mView; }	

	@Override
	public void onBindViewHolder(PreferenceViewHolder preferenceViewHolder) {
		super.onBindViewHolder(preferenceViewHolder);
		View view = preferenceViewHolder.itemView;
		android.util.Log.i("lcf_finger", "AliFingerprintSettingsPreference mUser == null is : " + (mUser == null));
        if(null == mUser) {
            final TextView textview_title = (TextView) view.findViewById(R.id.textView_title);
            textview_title.setText(mContext.getString(R.string.fingerprint_settings_addtext));
            final TextView textview_tip = (TextView) view.findViewById(R.id.textView_tip);
			textview_tip.setText("");
			mView = view;
            return;
        }
        final TextView textview_title = (TextView) view.findViewById(R.id.textView_title);
        textview_title.setText(mUser.getFingerPrint().getName());
        final TextView textview_tip = (TextView) view.findViewById(R.id.textView_tip);
        int operation = mUser.getFingerQuickOperation();
        String target = mUser.getFingerQuickTarget();
        String data = mUser.getFingerQuickTargetData();
        if(operation == AliFingerprintUtils.FINGERQUICK_TYPE_DIALOUT) {
            if(target == null || target.isEmpty()) {
                textview_tip.setText(mContext.getString(R.string.fingerprint_click_setting));
            } else {
                String displayName = AliFingerprintUtils.getContactNameByPhoneNumber(mContext, target);
                if(displayName != null && !displayName.isEmpty()) {
                    textview_tip.setText(displayName + "(" + target + ")");
                } else {
                    textview_tip.setText(target);
                }
            }
        } else if(operation == AliFingerprintUtils.FINGERQUICK_TYPE_STARTAPP) {
            String appName = AliFingerprintUtils.getApplicationName(mContext, target, data);
            if(appName == null || appName.isEmpty()) {
                textview_tip.setText(mContext.getString(R.string.fingerprint_click_setting));
            } else {
                textview_tip.setText(appName);
            }
        } else {
            textview_tip.setText(mContext.getString(R.string.fingerprint_click_setting));
        }
		mView = view;
    }

}
