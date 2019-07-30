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
			Log.i(ZarinPalANE.TAG, "No context recieved");
			return null;
		}
		
		ZarinPalANE.getInstance().nativeContext = (ZarinPalExtensionContext) freContext;

		try {
			String command = args[0].getAsString();

			if(command.equalsIgnoreCase("startPayment"))
			{
				String merchantID = args[1].getAsString();
				long amount = (long) args[2].getAsDouble();
				String description = args[3].getAsString();
				String callBackURL = args[4].getAsString();
				String email = args[5].getAsString();
				String mobileNumber = args[6].getAsString();
				ZarinPalANE.getInstance().startPayment(merchantID, amount, description, callBackURL, email, mobileNumber);
			}
		}
		catch (Exception error)
		{
			error.printStackTrace();
		}

		return null;
	}
}
