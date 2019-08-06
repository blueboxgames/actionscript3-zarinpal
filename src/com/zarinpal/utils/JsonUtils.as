package com.zarinpal.utils
{
	public class JsonUtils
	{
		public function JsonUtils(){}
		static public function getPaymentRequestJSONString(
			merchantID:String, 
			amount:int,
			description:String,
			callbackURL:String,
			email:String,
			mobile:String):String
		{
			return JSON.stringify(
			{
				MerchantID: merchantID,
				Amount: amount,
				Description: description,
				CallbackURL: callbackURL,
				Email: email,
				Mobile: mobile
			});
		}

		static public function getPaymentVerificationJSONString(
			merchantID:String,
			authority:String,
			amount:int
		):String
		{
			return JSON.stringify({
				MerchantID: merchantID,
				Authority: authority,
				Amount: amount
			});
		}

		static public function getRequestParamsToJson(request:String):Object
		{
			var ret:Object = new Object();
			var params:Array = request.split("?")[1].split("&");
			for each(var param:String in params)
			{
				ret[param.split("=")[0]] = param.split("=")[1];
			}
			return ret;
		}
	}
}