package com.zarinpal
{
	import com.zarinpal.events.ZarinpalRequestEvent;

	import flash.desktop.NativeApplication;
	import flash.events.EventDispatcher;
	import flash.events.InvokeEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	import com.zarinpal.inventory.ZarinpalInventory;

	public class ZarinPal extends EventDispatcher
	{
		static private var _instance:ZarinPal;

		private var _inventory:ZarinpalInventory;
		private var _isInitialized:Boolean;

		private var _merchantID:String;
		public function get merchantID():String { return this._merchantID; }
		private var _callbackURL:String;
		public function get callbackURL():String { return this._callbackURL; }
		private var _email:String;
		public function get email():String { return this._email; }
		public function set email(value:String):void { this._email = value; }
		private var _mobileNumber:String;
		public function get mobileNumber():String { return this._mobileNumber; }
		public function set mobileNumber(value:String):void { this._mobileNumber = value; }

		static public function get instance():ZarinPal
		{
			if (_instance == null)
				_instance = new ZarinPal();
			return _instance;
		}

		public function get inventory():ZarinpalInventory
		{
			return this._inventory;
		}

		public function ZarinPal()
		{
			super();
			this._inventory = new ZarinpalInventory();
			this._isInitialized = false;
		}

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
			this.dispatchEvent(new ZarinpalRequestEvent(ZarinpalRequestEvent.INITIALIZE_FINISHED));
		}

		/**
		 * Disposes Zarinpal purchase.
		 */
		public function dispose():void
		{
			if(!this._isInitialized)
				return;

			this._inventory = null;
			this._isInitialized = false;
			_instance = null;
		}
	}
}