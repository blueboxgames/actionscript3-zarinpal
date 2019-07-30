package com.zarinpal.events
{
	import flash.events.Event;

	public class ZarinPalEvent extends Event
	{
		/**
		 * Dispatched when purchase starts.
		 */
		static public const PURCHASE_START:String = "purchaseStart";
		static public const PURCHASE_SUCCESS:String = "purchaseSuccess";
		static public const PURCHASE_FAILURE:String = "purchaseFailure";

		public function ZarinPalEvent(type:String, bubbles:Boolean=false, cancleable:Boolean=false)
		{
			super(type, bubbles,cancelable);
		}
	}
}