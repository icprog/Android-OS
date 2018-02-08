package com.android.settings.fingerprint;

//import android.preference.Preference;
import android.support.v7.preference.Preference;
import android.support.v7.preference.ListPreference;
import android.support.v7.preference.Preference.OnPreferenceClickListener;
import android.support.v7.preference.Preference.OnPreferenceChangeListener;
import android.support.v7.preference.PreferenceGroup;
import android.support.v7.preference.PreferenceScreen;
import android.support.v7.preference.PreferenceViewHolder;
import android.content.Context;
import com.android.settings.R;
import android.util.AttributeSet;

public class AliFingerquickSettingsPreference extends Preference {

	@Override
	public void onBindViewHolder(PreferenceViewHolder preferenceViewHolder) {
		super.onBindViewHolder(preferenceViewHolder);
	}	

    public AliFingerquickSettingsPreference(Context context) {
        super(context);
        setLayoutResource(R.layout.ali_fingerquick_item);
    }
    public AliFingerquickSettingsPreference(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setLayoutResource(R.layout.ali_fingerquick_item);
    }
    public AliFingerquickSettingsPreference(Context context, AttributeSet attrs) {
        super(context, attrs);
        setLayoutResource(R.layout.ali_fingerquick_item);
    }
}
