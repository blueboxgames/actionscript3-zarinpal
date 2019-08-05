package com.zarinpal.events
{
	import flash.events.Event;

	public class ZarinPalEvent extends Event
	{
		/**
		 * Dispatched when purchase starts.
		 */
		static public const PAYMENT_START:String = "paymentStart";
		static public const TRANSACTION_CANCEL:String = "transactionCancel";
		static public const TRANSACTION_SUCCESS:String = "transactionSuccess";
		static public const TRANSACTION_NONE:String = "transactionNone";
		static public const VERIFICATION_SUCCESS:String = "verificationSuccess";
		static public const VERIFICATION_SUCCESS_TWICE:String = "verificationSuccessTwice";
		static public const VERIFICATION_FAIL:String = "verificationFail";


		public var data:Object;

		public function ZarinPalEvent(type:String, bubbles:Boolean=false, cancleable:Boolean=false, data:Object=null)
		{
			this.data = data;
			super(type, bubbles,cancelable);
		}
	}
}