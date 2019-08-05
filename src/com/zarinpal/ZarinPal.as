package com.zarinpal
{
	import com.zarinpal.events.ZarinPalEvent;

	import flash.desktop.NativeApplication;
	import flash.events.EventDispatcher;
	import flash.events.InvokeEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class ZarinPal extends EventDispatcher
	{
		/**
		 * @private
		 */
		static private const ZARINGATE_GATEWAY_URL:Array = ["https://www.zarinpal.com/pg/StartPay/" , "/ZarinGate"];

		static private var _instance:ZarinPal;

		private var _storage:Storage;
		private var _isInitialized:Boolean;
		private var _purchaseQueue:Vector.<String>;

		private var _merchantID:String;
		public function get merchantID():String { return this._merchantID; }
		private var _callbackURL:String;
		public function get callbackURL():String { return this._callbackURL; }
		private var _email:String;
		public function get email():String { return this._email; }
		private var _mobileNumber:String;
		public function get mobileNumber():String { return this._mobileNumber; }

		static public function get instance():ZarinPal
		{
			if (_instance == null)
				_instance = new ZarinPal();
			return _instance;
		}

		public function get storage():Storage
		{
			return this._storage;
		}

		public function ZarinPal()
		{
			super();
			this._storage = new Storage();
			this._purchaseQueue = new Vector.<String>();
			this._isInitialized = false;
		}

		// -------------------
		// Methods
		// -------------------
		public function initialize(merchantID:String, callbackURL:String,
			email:String=null, mobileNumber:String=null):void
		{
			this._merchantID = merchantID;
			this._callbackURL = callbackURL;
			if(mobileNumber != null)
				this._mobileNumber = mobileNumber;
			else
				this._mobileNumber = "";
			if(email != null)
				this._email = email;
			else
				this._email = "";
			this._isInitialized = true;
		}

		public function getPaymentRequest(sku:String):PaymentRequest
		{
			if(!this._isInitialized)
				return null;
			var mPaymentRequest:PaymentRequest = new PaymentRequest();
			mPaymentRequest.requestFor(sku);
			return mPaymentRequest;
		}

		public function sendPaymentRequest(request:PaymentRequest):void
		{
			if(request==null)
				return;
			request.addEventListener(ZarinPalEvent.PAYMENT_START, request_paymentStartHandler);
			request.send();
		}

		public function startPayment(url:String):void
		{
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, application_invokeHandler);
			var urlRequest:URLRequest = new URLRequest(url);
			navigateToURL(urlRequest);
		}

		private function application_invokeHandler(event:InvokeEvent):void
		{
			if(event.arguments.length == 0)
				return;
			if(event.arguments[0].match(this.callbackURL)[0] == this.callbackURL)
			{
				var queryString:String = event.arguments[0].split("?")[1];
				verifyTransaction(queryString);
			}
		}

		protected function verifyTransaction(queryString:String):void
		{
			var query:Object = queryStringToJsonObject(queryString);
			// Remove authority from queue.
			if(query.hasOwnProperty("Authority"))
			{
				var indexToRemove:Number = this._purchaseQueue.indexOf(query["Authority"]);
				if (indexToRemove != -1)
					this._purchaseQueue.removeAt(indexToRemove);
			}

			if(query.hasOwnProperty("Status"))
			{
				if(query["Status"] == "OK")
				{
					dispatchEvent(new ZarinPalEvent(ZarinPalEvent.TRANSACTION_SUCCESS, false, false, query));
				}
				else if (query["Status"] == "NOK")
				{
					dispatchEvent(new ZarinPalEvent(ZarinPalEvent.TRANSACTION_CANCEL, false, false, query));
				}
				else
				{
					dispatchEvent(new ZarinPalEvent(ZarinPalEvent.TRANSACTION_NONE));
				}
			}
			else
			{
				dispatchEvent(new ZarinPalEvent(ZarinPalEvent.TRANSACTION_NONE));
			}
		}

		// TODO: Must go to jsonutils.
		protected function queryStringToJsonObject(queryString:String):Object
		{
			var jsonObject:Object = new Object();
			var keyValues:Array = queryString.split("&");
			for each(var keyValue:String in keyValues)
			{
				jsonObject[keyValue.split("=")[0]] = keyValue.split("=")[1];
			}
			return jsonObject;
		}

		protected function request_paymentStartHandler(e:ZarinPalEvent):void
		{
			var authority:String = null;
			if(e.data["Authority"])
				authority = e.data["Authority"] as String;
			if(authority!=null)
			{
				this._purchaseQueue.push(authority);
				this.startPayment(ZARINGATE_GATEWAY_URL[0] + authority + ZARINGATE_GATEWAY_URL[1]);
			}
		}

		/**
		 * Disposes Zarinpal purchase.
		 */
		public function dispose():void
		{
			if(!this._isInitialized)
				return;
			if(this._purchaseQueue.length == 0)
				NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, application_invokeHandler);
			else
				throw new Error("Zarinpal: there are some purchase request in queue.");

			this._storage = null;
			this._isInitialized = false;
			_instance = null;
		}
	}
}