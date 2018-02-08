package com.bird.fingerprint;

/**
 * Base activity for all fingerprint enrollment steps.
 */
public class BirdFingerprintNative {

	/**
	 * @link  {FingerprintLocationAnimationView.java}
	 */
	public static native float getRoundRectCenterXFromJNI(float width);
	
	/**
	 * @link  {FingerprintLocationAnimationView.java}
	 */
	public static native float getRoundRectCenterYFromJNI(float height);
	
	static {
		System.loadLibrary("bird_fp_native");
	 }
}
