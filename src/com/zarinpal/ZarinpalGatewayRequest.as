package com.zarinpal
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.zarinpal.events.ZarinpalRequestEvent;
	import com.zarinpal.utils.JsonUtils;
	import com.zarinpal.inventory.ZarinpalStockItem;
	import com.zarinpal.errors.InvalidItemError;

	/**
	 * Dispatched when response is recieved from Zarinpal WebGate.
	 * <code>response</code> is an object as follows:
	 * <table>
	 * 		<tr>
	 * 			<td>Status</td>
	 * 			<td>int</td>
	 * 			<td>If status is successful returns 100 else its negative.</td>
	 *		</tr>
	 * 		<tr>
	 * 			<td>Authority</td>
	 * 			<td>String</td>
	 * 			<td>Reference ID request successful in length to 36 characters and is otherwise null.</td>
	 * 		</tr>
	 * 		<tr>
	 * 			<td>ProductID</td>
	 * 			<td>String</td>
	 * 			<td>SKU of the unit we requested authority for.</td>
	 * 		</tr>
	 * </table>
	 * 
	 * @eventType zarinpal.events.ZarinpalRequestEvent.PAYMENT_REQUEST_RESPONSE_RECIEVED
	 */
	[Event(name="paymentRequestResponseRecieved",type="zarinpal.events.ZarinpalRequestEvent")]


	public class ZarinpalGatewayRequest extends EventDispatcher
	{
		public static const ZARINPAL_STATUS_OK:int = 100;
		static protected const PAYMENT_REQUEST_URI:String = "https://www.zarinpal.com/pg/rest/WebGate/PaymentRequest.json";
		static private const ZARINPAL_GATEWAY_URL:String = "https://www.zarinpal.com/pg/StartPay/";

		private var paymentRequestLoader:URLLoader = new URLLoader();

		private var _sku:String;
		private var _amount:int;
		private var _description:String;
		private var _useZarinGate:Boolean;

		public function ZarinpalGatewayRequest(zarinGate:Boolean=false)
		{
			this._useZarinGate = zarinGate;
		}

		public function setRequestFor(sku:String):void
		{
			var item:ZarinpalStockItem = ZarinPal.instance.inventory.getItem(sku);
			if(item == null)
				return;
			this._sku = sku;
			this._description = item.description;
			if(isNaN(item.amount))
				throw new InvalidItemError("Amount is not set proparly.");
			this._amount = item.amount;
		}

		public function createRequest(itemID:String, description:String, amount:int):void
		{
			this._sku = itemID;
			this._description = description;
			this._amount = amount;
		}

		public function send():void
		{
			if(this._sku == null || this._description == null || isNaN(this._amount))
				return;
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

		public function getGatewayUrl(authority:String):String
		{
			authority = authority.replace(/^0+/, "");
			if(this._useZarinGate)
				return ZARINPAL_GATEWAY_URL + authority + "/ZarinGate";
			return ZARINPAL_GATEWAY_URL + authority;
		}

		/**
		 * @private
		 */
		protected function paymentRequestLoader_completeHandler(e:Event):void
		{
			paymentRequestLoader.removeEventListener(Event.COMPLETE, paymentRequestLoader_completeHandler);
			var response:Object = JSON.parse(paymentRequestLoader.data);
			response['ProductID'] = this._sku;
			this.dispatchEvent(new ZarinpalRequestEvent(ZarinpalRequestEvent.PAYMENT_REQUEST_RESPONSE_RECIEVED, response));
		}
	}
}