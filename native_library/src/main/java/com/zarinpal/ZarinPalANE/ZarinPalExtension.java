package com.zarinpal.ZarinPalANE;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class ZarinPalExtension implements FREExtension
{
	@Override
	public FREContext createContext(String arguments)
	{
		Log.i("com.zarinpal.ZarinPalANE", "ANE context created.");
		return new ZarinPalExtensionContext();
	}

	@Override
	public void dispose() {

	}

	@Override
	public void initialize() {

	}
}