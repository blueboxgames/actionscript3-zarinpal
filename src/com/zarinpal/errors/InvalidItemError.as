package com.zarinpal.errors
{
	public class InvalidItemError extends Error
	{
		public function InvalidItemError(message:String){
			super(message);
		}
	}
}