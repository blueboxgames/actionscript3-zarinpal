package com.zarinpal.ZarinPalANE;

import android.content.Intent;
import android.net.Uri;
import android.widget.Toast;

import com.zarinpal.ewallets.purchase.OnCallbackRequestPaymentListener;
import com.zarinpal.ewallets.purchase.PaymentRequest;
import com.zarinpal.ewallets.purchase.ZarinPal;

public class ZarinPalANE {
	public static final String TAG = "ZarinPalANE";
	public ZarinPalExtensionContext nativeContext;
	protected static ZarinPalANE _instance = null;

	public static ZarinPalANE getInstance(){
		if(_instance == null)
			_instance = new ZarinPalANE();
		return _instance;
	}

	public void startPayment(String merchantID, long amount, String description, String callBackURL, String email, String mobileNumber) {
		ZarinPal purchase = ZarinPal.getPurchase(nativeContext.getActivity().getApplicationContext());
		PaymentRequest payment = ZarinPal.getPaymentRequest();
		payment.setMerchantID(merchantID);
		payment.setAmount(amount);
		payment.setDescription(description);
		payment.setCallbackURL(callBackURL);
		if(email != null)
			payment.setEmail(email);
		if(mobileNumber != null)
			payment.setMobile(mobileNumber);

		purchase.startPayment(payment, new OnCallbackRequestPaymentListener() {
			@Override
			public void onCallbackResultPaymentRequest(int status, String authority, Uri paymentGatewayUri, Intent intent) {
				if(status == 100)
					nativeContext.getActivity().startActivity(intent);
				else
					Toast.makeText(nativeContext.getActivity().getApplicationContext(), "Payment Failure.", Toast.LENGTH_SHORT).show();
			}
		});
	}
}
