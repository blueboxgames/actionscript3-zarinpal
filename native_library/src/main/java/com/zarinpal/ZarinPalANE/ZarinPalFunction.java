package com.zarinpal.ZarinPalANE;

import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.widget.Toast;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.zarinpal.ewallets.purchase.OnCallbackRequestPaymentListener;
import com.zarinpal.ewallets.purchase.PaymentRequest;
import com.zarinpal.ewallets.purchase.ZarinPal;

public class ZarinPalFunction implements FREFunction {

	@Override
	public FREObject call(FREContext freContext, FREObject[] args) {
		if(freContext == null) {
			Log.i(ZarinPalANE.TAG, "No context received");
			return null;
		}
		
		ZarinPalANE.getInstance().nativeContext = (ZarinPalExtensionContext) freContext;

		try {
			String command = args[0].getAsString();

			if(command.equalsIgnoreCase("initialize"))
			{
				String merchantID = args[1].getAsString();
				String callBackURL = args[2].getAsString();
				Boolean useSandBox = args[3].getAsBool();
				String mobileNumber = args[4].getAsString();
				String email = args[5].getAsString();
				ZarinPalANE.getInstance().initialize(merchantID, callBackURL, useSandBox, mobileNumber, email);
				return null;
			}

			if(command.equalsIgnoreCase("startPayment"))
			{
				long amount = (long) args[1].getAsDouble();
				String description = args[2].getAsString();
				ZarinPalANE.getInstance().startPayment(amount, description);
				return null;
			}

			if(command.equalsIgnoreCase("getPurchase"))
			{
				ZarinPalANE.getInstance().getPurchase();
				return null;
			}

			if(command.equalsIgnoreCase("getRefID"))
			{
				return FREObject.newObject(ZarinPalANE.getInstance().getRefID());
			}
			
			if(command.equalsIgnoreCase("getDescription"))
			{
				return FREObject.newObject(ZarinPalANE.getInstance().getDescription());
			}

			if(command.equalsIgnoreCase("getAuthority"))
			{
				return FREObject.newObject(ZarinPalANE.getInstance().getAuthority());
			}
		}
		catch (Exception error)
		{
			error.printStackTrace();
		}

		return null;
	}
}
