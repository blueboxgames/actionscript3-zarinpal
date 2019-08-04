package com.zarinpal
{
	public class PaymentRequest
	{
		public function PaymentRequest()
		{
			
		}

		private var _amount:Number = 100;
		
		public function get amount():Number
		{
			return _amount;
		}
		
		public function set amount(value:Number):void
		{
			_amount = value;
		}

		private var _description:String = "";
		
		public function get description():String
		{
			return _description;
		}
		
		public function set description(value:String):void
		{
			_description = value;
		}
	}
}