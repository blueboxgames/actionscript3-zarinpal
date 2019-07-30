package com.zarinpal.ZarinPalANE;

import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.widget.Toast;

import com.zarinpal.ewallets.purchase.OnCallbackRequestPaymentListener;
import com.zarinpal.ewallets.purchase.OnCallbackVerificationPaymentListener;
import com.zarinpal.ewallets.purchase.PaymentRequest;
import com.zarinpal.ewallets.purchase.ZarinPal;

public class ZarinPalANE {
	public static final String TAG = "ZarinPalANE";
	public ZarinPalExtensionContext nativeContext;
	protected static ZarinPalANE _instance = null;
	protected String purchaseRefID;

	public static ZarinPalANE getInstance(){
		if(_instance == null)
			_instance = new ZarinPalANE();
		return _instance;
	}

	public void startPayment(String merchantID, long amount, String description, String callBackURL,
													 String email, String mobileNumber, Boolean useSandBox) {
		PaymentRequest payment;
		if(useSandBox)
			payment = ZarinPal.getSandboxPaymentRequest();
		else
			payment = ZarinPal.getPaymentRequest();

		ZarinPal purchase = ZarinPal.getPurchase(nativeContext.getActivity().getApplicationContext());
		payment.setMerchantID(merchantID);
		payment.setAmount(amount);
		payment.setDescription(description);
		payment.setCallbackURL(callBackURL);
		if(email != "")
			payment.setEmail(email);
		if(mobileNumber != "")
			payment.setMobile(mobileNumber);

		purchase.startPayment(payment, new OnCallbackRequestPaymentListener() {
			@Override
			public void onCallbackResultPaymentRequest(int status, String authority, Uri paymentGatewayUri, Intent intent) {
				if(status == 100) {
					nativeContext.dispatchStatusEventAsync("purchaseStart", "status");
					nativeContext.getActivity().startActivity(intent);
				}
				else
					Toast.makeText(nativeContext.getActivity().getApplicationContext(), "Payment Failure.", Toast.LENGTH_SHORT).show();
			}
		});
	}

	public void getPurchase(){
		Uri data = nativeContext.getActivity().getIntent().getData();
		ZarinPal.getPurchase(this.nativeContext.getActivity().getApplicationContext()).verificationPayment(data, new OnCallbackVerificationPaymentListener() {
			@Override
			public void onCallbackResultVerificationPayment(boolean isPaymentSuccess, String refID, PaymentRequest paymentRequest) {
				if (isPaymentSuccess) {
					purchaseRefID = refID;
					nativeContext.dispatchStatusEventAsync("purchaseSuccess", "status");
				} else {
					nativeContext.dispatchStatusEventAsync("purchaseFailure", "status");
				}
			}
		});
	}

	public String getRefID(){
		if(purchaseRefID != null)
			return purchaseRefID;
		return "";
	}
}
