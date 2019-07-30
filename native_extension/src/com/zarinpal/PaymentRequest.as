package com.zarinpal
{
	public class PaymentRequest
	{
		public function PaymentRequest()
		{
			
		}

		private var _merchantID:String;
		
		public function get merchantID():String
		{
			return _merchantID;
		}
		
		public function set merchantID(value:String):void
		{
			_merchantID = value;
		}

		private var _amount:Number;
		
		public function get amount():Number
		{
			return _amount;
		}
		
		public function set amount(value:Number):void
		{
			_amount = value;
		}

		private var _description:String;
		
		public function get description():String
		{
			return _description;
		}
		
		public function set description(value:String):void
		{
			_description = value;
		}

		private var _callbackURL:String;
		
		public function get callbackURL():String
		{
			return _callbackURL;
		}
		
		public function set callbackURL(value:String):void
		{
			_callbackURL = value;
		}

		private var _mobileNumber:String;
		
		public function get mobileNumber():String
		{
			return _mobileNumber;
		}
		
		public function set mobileNumber(value:String):void
		{
			_mobileNumber = value;
		}

		private var _email:String;
		
		public function get email():String
		{
			return _email;
		}
		
		public function set email(value:String):void
		{
			_email = value;
		}

		private var _useSandBox:Boolean;
		
		public function get useSandBox():Boolean
		{
			return _useSandBox;
		}
		
		public function set useSandBox(value:Boolean):void
		{
			_useSandBox = value;
		}
	}
}