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
	protected String purchaseAuthority;
	protected String purchaseDescription;
	protected PaymentRequest payment;

	public static ZarinPalANE getInstance(){
		if(_instance == null)
			_instance = new ZarinPalANE();
		return _instance;
	}

	public void initialize(String merchantID, String callBackURL, Boolean useSandBox, String mobileNumber, String email)
	{
		if(useSandBox)
			this.payment = ZarinPal.getSandboxPaymentRequest();
		else
			this.payment = ZarinPal.getPaymentRequest();

		this.payment.setMerchantID(merchantID);
		this.payment.setCallbackURL(callBackURL);
		if(email != "")
			this.payment.setEmail(email);
		if(mobileNumber != "")
			this.payment.setMobile(mobileNumber);
	}

	public void startPayment( long amount, String description ) {
		ZarinPal purchase = ZarinPal.getPurchase(nativeContext.getActivity().getApplicationContext());
	
		this.payment.setAmount(amount);
		this.payment.setDescription(description);

		purchase.startPayment(this.payment, new OnCallbackRequestPaymentListener() {
			@Override
			public void onCallbackResultPaymentRequest(int status, String authority, Uri paymentGatewayUri, Intent intent) {
				if(status == 100) {
					purchaseAuthority = authority;
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
					purchaseDescription = paymentRequest.getDescription();
					nativeContext.dispatchStatusEventAsync("purchaseSuccess", "status");
				} else {
					nativeContext.dispatchStatusEventAsync("purchaseFailure", "status");
				}
			}
		});
	}

	public String getRefID(){
		return purchaseRefID != null ? purchaseRefID : "";
	}
	
	public String getDescription(){
		return purchaseDescription != null ? purchaseDescription : "";
	}

	public String getAuthority(){
		return purchaseAuthority != null ? purchaseAuthority : "";
	}
}
