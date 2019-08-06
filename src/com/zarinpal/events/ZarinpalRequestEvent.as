package com.zarinpal.events
{
	import flash.events.Event;

	public class ZarinpalRequestEvent extends Event
	{
		static public const INITIALIZE_FINISHED:String = "initializeFinished";
		
		static public const PAYMENT_REQUEST_RESPONSE_RECIEVED:String = "paymentRequestResponseRecieved";
		
		static public const TRANSACTION_CANCEL:String = "transactionCancel";
		static public const TRANSACTION_SUCCESS:String = "transactionSuccess";
		static public const TRANSACTION_NONE:String = "transactionNone";


		public var response:Object;

		public function ZarinpalRequestEvent(type:String, response:Object=null, bubbles:Boolean=false, cancleable:Boolean=false)
		{
			this.response = response;
			super(type, bubbles,cancelable);
		}
	}
}