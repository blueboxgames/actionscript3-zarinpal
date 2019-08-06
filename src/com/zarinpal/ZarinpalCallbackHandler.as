package com.zarinpal
{
	import com.zarinpal.utils.JsonUtils;

	public class ZarinpalCallbackHandler
	{
		private var _callback:String;

		public function ZarinpalCallbackHandler(callback:String){
			this._callback = callback;
		}

		private function get isZarinpalRequest():Boolean
		{
			if(!ZarinPal.instance.callbackURL)
				return false;
			if(this._callback.replace(/\?.*/, "") == ZarinPal.instance.callbackURL)
				return true;
			return false;
		}

		public function getResponse():Object
		{
			if(!isZarinpalRequest)
				return null;
			return JsonUtils.getRequestParamsToJson(this._callback);
		}
	}
}