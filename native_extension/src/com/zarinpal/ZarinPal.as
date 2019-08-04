package com.zarinpal
{
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	import flash.external.ExtensionContext;
	import flash.events.StatusEvent;
	import flash.events.Event;
	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;
	import com.zarinpal.events.ZarinPalEvent;

	public class ZarinPal extends EventDispatcher
	{
		static private const Android:Boolean = Capabilities.manufacturer.indexOf( "Android" ) > -1;
		static private var _instance:ZarinPal;
		static private var _callbackURL:String;
		static private var _merchantID:String;
		static private var _useSandBox:Boolean;
		static private var _email:String;
		static private var _mobileNumber:String;
		private var _authority:String;

		private var _context:ExtensionContext;

		static public function get instance():ZarinPal
		{
			if (_instance == null)
				_instance = new ZarinPal();
			return _instance;
		}

		public function ZarinPal()
		{
			super();
			this._context = ExtensionContext.createExtensionContext('com.zarinpal.ZarinPalANE', null);

			if(this._context == null)
				trace("com.zarinpal.ZarinPalANE: Failed to initialize native extension context.");

			this._context.addEventListener( StatusEvent.STATUS, context_statusHandler);
		}

		public function get authority():String
		{
			if(this._authority == null)
				return "";
			return this._authority;
		}

		// -------------------
		// Static Methods
		// -------------------
		static public function isSupported():Boolean
		{
			return Android;
		}

		static public function set merchantID(value:String):void
		{
			if(_merchantID == value)
				return;
			_merchantID = value;
		}

		static public function set callbackURL(value:String):void
		{
			if(_callbackURL == value)
				return;
			_callbackURL = value;
		}

		static public function set useSandBox(value:Boolean):void
		{
			if(_useSandBox == value)
				return;
			_useSandBox = value;
		}

		// -------------------
		// Methods
		// -------------------
		public function dispose():void
		{
			this._context.dispose();
		}

		public function initialize():void
		{
			if(isSupported() == false)
				return;
			if(_merchantID != null && _callbackURL != null)
			{
				if(_mobileNumber == null)
					_mobileNumber = "";
				if(_email == null)
					_email = "";
				if(_useSandBox == null)
					_useSandBox = false;
				this._context.call("zarinpal", "initialize", _merchantID, _callbackURL, _useSandBox, _mobileNumber, _email);
			}
			else
			{
				trace("ZarinPalANE: merchantID and callbackURL must be set.");
				return;
			}
		}

		public function startPayment(payment:PaymentRequest):void
		{
			if(isSupported() == false)
				return;
			this._context.call("zarinpal", "startPayment", payment.amount, payment.description);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, application_invokeHandler);
		}

		public function getRefID():String
		{
			if(isSupported() == false)
				return "";
			return this._context.call("zarinpal", "getRefID") as String;
		}

		private function application_invokeHandler(event:InvokeEvent):void
		{
			if(event.arguments.length == 0)
				return;
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, application_invokeHandler);
			var callbackURL:String = event.arguments[0];
			if(callbackURL.match(_callbackURL)[0] == _callbackURL)
				this._context.call("zarinpal", "getPurchase");
		}

		private function context_statusHandler(event:StatusEvent):void
		{
			if(isSupported() == false)
				return;
			if(event.code == ZarinPalEvent.PURCHASE_START)
				this._authority = this._context.call("zarinpal", "getAuthority") as String;
			this.dispatchEvent(new ZarinPalEvent(event.code));
		}
	}
}