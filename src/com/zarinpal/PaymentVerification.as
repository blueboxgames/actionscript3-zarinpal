package com.zarinpal
{
	import com.zarinpal.events.ZarinPalEvent;
	import com.zarinpal.utils.JsonUtils;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class PaymentVerification extends EventDispatcher
	{
		protected static const PAYMENT_VERIFICATION_URI:String = 
			"https://www.zarinpal.com/pg/rest/WebGate/PaymentVerification.json";
	
		private var _merchantID:String
		private var _authority:String;
		private var _amount:int;
		private var _verificationRequestLoader:URLLoader = new URLLoader();
	
		public function PaymentVerification(merchantID:String, authority:String, amount:int){
			this._merchantID = merchantID;
			this._authority = authority;
			this._amount = amount;
		}

		public function send():void
		{
			var urlRequest:URLRequest = new URLRequest(PAYMENT_VERIFICATION_URI);
			urlRequest.cacheResponse = false;
			urlRequest.manageCookies = false; 
			urlRequest.useCache = false;
			urlRequest.userAgent = "ZarinPal REST";
			urlRequest.contentType = "application/json";
			urlRequest.data = JsonUtils.getPaymentVerificationJSONString(
				this._merchantID, 
				this._authority,
				this._amount);
			urlRequest.method = URLRequestMethod.POST;
			this._verificationRequestLoader.addEventListener(Event.COMPLETE, verificationRequestLoader_completeHandler);
			this._verificationRequestLoader.load(urlRequest);
		}

		public function verificationRequestLoader_completeHandler(e:Event):void
		{
			this._verificationRequestLoader.removeEventListener(Event.COMPLETE, verificationRequestLoader_completeHandler);
			var response:Object = JSON.parse(this._verificationRequestLoader.data);
			if(response.hasOwnProperty("Status"))
			{
				if(response["Status"] == 100)
					this.dispatchEvent(new ZarinPalEvent(ZarinPalEvent.VERIFICATION_SUCCESS, false, false, response));
				else if (response["Status"] == 101)
					this.dispatchEvent(new ZarinPalEvent(ZarinPalEvent.VERIFICATION_SUCCESS_TWICE, false, false, response));
				else
					this.dispatchEvent(new ZarinPalEvent(ZarinPalEvent.VERIFICATION_FAIL));
			}
			else
				this.dispatchEvent(new ZarinPalEvent(ZarinPalEvent.VERIFICATION_FAIL));
		}
	}
}