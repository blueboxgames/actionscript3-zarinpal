package com.zarinpal
{
	public class Item
	{
		private var _sku:String;
		private var _description:String;
		private var _outcome:int;

		public function Item(sku:String, description:String, outcome:int)
		{
			this._sku = sku;
			this._outcome = outcome;
			this._description = description;
		}

		public function get sku():String
		{
			return this._sku;
		}

		public function get description():String
		{
			return this._description;
		}

		public function get outcome():int
		{
			return this._outcome;
		}
	}
}