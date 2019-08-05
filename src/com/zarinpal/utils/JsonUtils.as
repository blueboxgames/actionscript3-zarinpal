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
	}
}