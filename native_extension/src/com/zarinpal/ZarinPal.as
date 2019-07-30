package com.zarinpal
{
	import flash.events.EventDispatcher;
	import flash.system.Capabilities;
	import flash.external.ExtensionContext;
	import flash.events.StatusEvent;

	public class ZarinPal extends EventDispatcher
	{
		static private const Android:Boolean = Capabilities.manufacturer.indexOf( "Android" ) > -1;
		static private var _instance:ZarinPal;

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

			// this._context.addEventListener( StatusEvent.STATUS, context_statusHandler);
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
			var method:String;
			if(payment.useSandBox)
				method = "startSandBoxPayment";
			else
				method = "startPayment";
			
			this._context.call("zarinpal", method, payment.merchantID, payment.amount, payment.description, payment.callbackURL, payment.email, payment.mobileNumber);
		}
	}
}