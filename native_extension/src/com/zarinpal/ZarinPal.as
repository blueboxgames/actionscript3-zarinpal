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
		private var _callbackURL:String;

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

		// -------------------
		// Static Methods
		// -------------------
		static public function isSupported():Boolean
		{
			return Android;
		}

		// -------------------
		// Methods
		// -------------------
		public function dispose():void
		{
			this._context.dispose();
		}

		public function startPayment(payment:PaymentRequest):void
		{			
			this._callbackURL = payment.callbackURL;
			this._context.call("zarinpal", "startPayment", payment.merchantID, 
				payment.amount, payment.description, this._callbackURL, payment.email,
				payment.mobileNumber, payment.useSandBox);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, application_invokeHandler);
		}

		public function getRefID():String
		{
			return this._context.call("zarinpal", "getRefID") as String;
		}

		public function application_invokeHandler(event:InvokeEvent):void
		{
			if(event.arguments.length == 0)
				return;
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, application_invokeHandler);
			var callbackURL:String = event.arguments[0];
			if(callbackURL.match(this._callbackURL)[0] == this._callbackURL)
				this._context.call("zarinpal", "getPurchase");
		}

		private function context_statusHandler(event:StatusEvent):void
		{
			if(isSupported() == false)
				return;
			this.dispatchEvent(new ZarinPalEvent(event.code));
		}
	}
}