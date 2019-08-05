package com.zarinpal
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.zarinpal.events.ZarinPalEvent;
	import com.zarinpal.utils.JsonUtils;

	public class PaymentRequest extends EventDispatcher
	{
		public static const ZARINPAL_STATUS_OK:int = 100;
		protected static const PAYMENT_REQUEST_URI:String = 
			"https://www.zarinpal.com/pg/rest/WebGate/PaymentRequest.json";

		private var paymentRequestLoader:URLLoader = new URLLoader();

		private var _authority:String;
		
		public function get authority():String
		{
			return _authority;
		}

		private var _status:int;
		
		public function get status():int
		{
			return _status;
		}

		private var _amount:int;
		private var _description:String;

		public function PaymentRequest(){}

		public function requestFor(sku:String):void
		{
			var item:Item = ZarinPal.instance.storage.getItem(sku);
			if(item == null)
				return;
			this._description = item.description;
			this._amount = item.outcome;
		}

		public function send():void
		{
			var urlRequest:URLRequest = new URLRequest(PAYMENT_REQUEST_URI);
			urlRequest.cacheResponse = false;
			urlRequest.manageCookies = false; 
			urlRequest.useCache = false;
			urlRequest.userAgent = "ZarinPal REST";
			urlRequest.contentType = "application/json";
			urlRequest.data = JsonUtils.getPaymentRequestJSONString(
				ZarinPal.instance.merchantID, 
				this._amount,
				this._description,
				ZarinPal.instance.callbackURL,
				ZarinPal.instance.email,
				ZarinPal.instance.mobileNumber);
			urlRequest.method = URLRequestMethod.POST;
			this.paymentRequestLoader.addEventListener(Event.COMPLETE,
				paymentRequestLoader_completeHandler);
			this.paymentRequestLoader.load(urlRequest);
		}

		protected function paymentRequestLoader_completeHandler(e:Event):void
		{
			paymentRequestLoader.removeEventListener(Event.COMPLETE,
				paymentRequestLoader_completeHandler);
			var response:Object = JSON.parse(paymentRequestLoader.data);
			this.dispatchEvent(new ZarinPalEvent(
				ZarinPalEvent.PAYMENT_START, false, false, response));
		}
	}
}