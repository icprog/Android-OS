/*
 * Copyright (C) 2015 The Android Open Source Project
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
 * limitations under the License
 */

package com.android.settings.fingerprint;

import android.content.Intent;
import android.hardware.fingerprint.FingerprintManager;
import android.os.Bundle;
import android.os.UserHandle;
import android.util.Log;

import com.android.internal.logging.MetricsProto.MetricsEvent;
import com.android.settings.ChooseLockSettingsHelper;
import com.android.settings.R;
import com.android.settings.fingerprint.FingerprintEnrollSidecar.Listener;

// bird [BIRD_GET_FP_IC_FRONT] lichengfeng 20170328 begin
import android.widget.TextView;
import com.bird.settings.BirdFeatureOption;
// bird [BIRD_GET_FP_IC_FRONT] lichengfeng 20170328 end
/**
 * Activity explaining the fingerprint sensor location for fingerprint enrollment.
 */
public class FingerprintEnrollFindSensor extends FingerprintEnrollBase {

    private static final int CONFIRM_REQUEST = 1;
    private static final int ENROLLING = 2;
    public static final String EXTRA_KEY_LAUNCHED_CONFIRM = "launched_confirm_lock";

    private FingerprintFindSensorAnimation mAnimation;
    private boolean mLaunchedConfirmLock;
    private FingerprintEnrollSidecar mSidecar;
    private boolean mNextClicked;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(getContentView());
        setHeaderText(R.string.security_settings_fingerprint_enroll_find_sensor_title);
		// bird [BIRD_GET_FP_IC_FRONT] lichengfeng 20170328 begin
		android.util.Log.i("lcf_fingerprint", "BIRD_GET_FP_IC_FRONT: " + BirdFeatureOption.BIRD_GET_FP_IC_FRONT);		
		if (BirdFeatureOption.BIRD_GET_FP_IC_FRONT) {
			final TextView findSensorMessageTextView = (TextView) findViewById(R.id.find_sensor_message_id);
			android.util.Log.i("lcf_fingerprint", "(findSensorMessageTextView != null) is " + (findSensorMessageTextView != null));
			if (findSensorMessageTextView != null) {
				findSensorMessageTextView.setText(getResources().getString(R.string.security_settings_fingerprint_enroll_find_ahead_sensor_message));
			}
		}
		// bird [BIRD_GET_FP_IC_FRONT] lichengfeng 20170328 end
        if (savedInstanceState != null) {
            mLaunchedConfirmLock = savedInstanceState.getBoolean(EXTRA_KEY_LAUNCHED_CONFIRM);
            mToken = savedInstanceState.getByteArray(
                    ChooseLockSettingsHelper.EXTRA_KEY_CHALLENGE_TOKEN);
        }
        if (mToken == null && !mLaunchedConfirmLock) {
            launchConfirmLock();
        } else if (mToken != null) {
            startLookingForFingerprint(); // already confirmed, so start looking for fingerprint
        }
        mAnimation = (FingerprintFindSensorAnimation) findViewById(
                R.id.fingerprint_sensor_location_animation);
    }

    protected int getContentView() {
        return R.layout.fingerprint_enroll_find_sensor;
    }

    @Override
    protected void onStart() {
        super.onStart();
        mAnimation.startAnimation();
    }

    private void startLookingForFingerprint() {
        mSidecar = (FingerprintEnrollSidecar) getFragmentManager().findFragmentByTag(
                FingerprintEnrollEnrolling.TAG_SIDECAR);
        if (mSidecar == null) {
            mSidecar = new FingerprintEnrollSidecar();
            getFragmentManager().beginTransaction()
                    .add(mSidecar, FingerprintEnrollEnrolling.TAG_SIDECAR).commit();
        }
        mSidecar.setListener(new Listener() {
            @Override
            public void onEnrollmentProgressChange(int steps, int remaining) {
                mNextClicked = true;
                if (!mSidecar.cancelEnrollment()) {
                    proceedToEnrolling();
                }
            }

            @Override
            public void onEnrollmentHelp(CharSequence helpString) {
            }

            @Override
            public void onEnrollmentError(int errMsgId, CharSequence errString) {
                if (mNextClicked && errMsgId == FingerprintManager.FINGERPRINT_ERROR_CANCELED) {
                    mNextClicked = false;
                    proceedToEnrolling();
                }
            }
        });
    }

    @Override
    protected void onStop() {
        super.onStop();
        mAnimation.pauseAnimation();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mAnimation.stopAnimation();
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putBoolean(EXTRA_KEY_LAUNCHED_CONFIRM, mLaunchedConfirmLock);
        outState.putByteArray(ChooseLockSettingsHelper.EXTRA_KEY_CHALLENGE_TOKEN, mToken);
    }

    @Override
    protected void onNextButtonClick() {
        mNextClicked = true;
        if (mSidecar == null || (mSidecar != null && !mSidecar.cancelEnrollment())) {
            proceedToEnrolling();
        }
    }

    private void proceedToEnrolling() {
        /// M: Avoid remove null fragment cause nullponiter exception @{
        Log.e("FingerprintEnrollFindSensor", "proceedToEnrolling mSidecar " + mSidecar);
        if (mSidecar != null) {
            getFragmentManager().beginTransaction().remove(mSidecar).commit();
            mSidecar = null;
        }
        /// @}
        startActivityForResult(getEnrollingIntent(), ENROLLING);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		android.util.Log.i("lcf_finger","FingerprintEnrollFindSensor onActivityResult requestCode:"+requestCode);
		android.util.Log.i("lcf_finger","FingerprintEnrollFindSensor onActivityResult resultCode:"+resultCode);
		android.util.Log.i("lcf_finger","FingerprintEnrollFindSensor onActivityResult data:"+data);
        if (requestCode == CONFIRM_REQUEST) {
            if (resultCode == RESULT_OK) {
                mToken = data.getByteArrayExtra(ChooseLockSettingsHelper.EXTRA_KEY_CHALLENGE_TOKEN);
                overridePendingTransition(R.anim.suw_slide_next_in, R.anim.suw_slide_next_out);
                getIntent().putExtra(ChooseLockSettingsHelper.EXTRA_KEY_CHALLENGE_TOKEN, mToken);
                startLookingForFingerprint();
            } else {
                finish();
            }
        } else if (requestCode == ENROLLING) {
            if (resultCode == RESULT_FINISHED) {
                //removed by lichengfeng from google setResult(RESULT_FINISHED);
				if (data == null) {
					data = new Intent();
					data.putExtra(ChooseLockSettingsHelper.EXTRA_KEY_CHALLENGE_TOKEN, mToken);
				}
				setResult(RESULT_FINISHED, data);
				/*add by lichengfeng for fingerprint 20160728 begin*/
				android.util.Log.i("lcf_finger","FingerprintEnrollFindSensor mToken: "+mToken);
				android.util.Log.i("lcf_finger","FingerprintEnrollFindSensor mIntentName: "+mIntentName);
				if (mIntentName != null && mIntentName.equals(com.android.settings.SecuritySettings.class.getName())) {
					final Intent intent = getFingerprintSettingsIntent();
					intent.addFlags(Intent.FLAG_ACTIVITY_FORWARD_RESULT);
					startActivity(intent);
				}
				/*add by lichengfeng for fingerprint 20160728 end*/		
                finish();
            } else if (resultCode == RESULT_SKIP) {
                setResult(RESULT_SKIP);
                finish();
            } else if (resultCode == RESULT_TIMEOUT) {
                setResult(RESULT_TIMEOUT);
                finish();
            } else {
                FingerprintManager fpm = getSystemService(FingerprintManager.class);
                int enrolled = fpm.getEnrolledFingerprints().size();
                int max = getResources().getInteger(
                        com.android.internal.R.integer.config_fingerprintMaxTemplatesPerUser);
                if (enrolled >= max) {
                    finish();
                } else {
                    // We came back from enrolling but it wasn't completed, start again.
                    startLookingForFingerprint();
                }
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    private void launchConfirmLock() {
        long challenge = getSystemService(FingerprintManager.class).preEnroll();
        ChooseLockSettingsHelper helper = new ChooseLockSettingsHelper(this);
        boolean launchedConfirmationActivity = false;
        if (mUserId == UserHandle.USER_NULL) {
            launchedConfirmationActivity = helper.launchConfirmationActivity(CONFIRM_REQUEST,
                getString(R.string.security_settings_fingerprint_preference_title),
                null, null, challenge);
        } else {
            launchedConfirmationActivity = helper.launchConfirmationActivity(CONFIRM_REQUEST,
                    getString(R.string.security_settings_fingerprint_preference_title),
                    null, null, challenge, mUserId);
        }
        if (!launchedConfirmationActivity) {
            // This shouldn't happen, as we should only end up at this step if a lock thingy is
            // already set.
            finish();
        } else {
            mLaunchedConfirmLock = true;
        }
    }

    @Override
    protected int getMetricsCategory() {
        return MetricsEvent.FINGERPRINT_FIND_SENSOR;
    }
}
