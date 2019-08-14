package com.zarinpal.inventory
{
	import flash.net.SharedObject;

	public class ZarinpalPurchaseActivity
	{
		public static function getPurchaseActivity(authCode:String):String
		{
			var so:SharedObject = SharedObject.getLocal("zarinpal-purchase-data");
			if( so.data[authCode] == null )
				return null;
			return so.data[authCode];
		}

		public static function setPurchaseActivity(sku:String, authCode:String):void
		{
			var so:SharedObject = SharedObject.getLocal("zarinpal-purchase-data");
			so.data[authCode] = sku;
			so.flush(100000);
		}

		public static function clearPurchase(authCode:String):void
		{
			var so:SharedObject = SharedObject.getLocal("zarinpal-purchase-data");
			if( so.data[authCode] == null )
				return;
			so.data[authCode] = null;
			so.flush(100000);
		}

		public static function clearPurchaseHistory():void
		{
			var so:SharedObject = SharedObject.getLocal("zarinpal-purchase-data");
			so.clear();
		}
	}
}