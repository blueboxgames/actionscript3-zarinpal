package com.zarinpal.inventory
{
	public class ZarinpalStockItem
	{
		private var _sku:String;
		private var _description:String;
		private var _requirments:String;
		private var _outcomes:String;
		private var _requirementToAmountFactory:Function;

		public function ZarinpalStockItem(sku:String, description:String, requirments:String, outcomes:String)
		{
			this._sku = sku;
			this._description = description;
			this._requirments = requirments;
			this._outcomes = outcomes;
		}

		public function get sku():String
		{
			return this._sku;
		}

		public function get description():String
		{
			return this._description;
		}

		public function get requirments():String
		{
			return this._requirments;
		}

		public function get outcomes():String
		{
			return this._outcomes;
		}

		public function get amount():int
		{
			var factory:Function;
			factory = this.requirementToAmountFactory == null ? this.defaultRequirementToAmountFactory : this.requirementToAmountFactory;
			if(!( factory() is int))
				return NaN;
			return factory();
		}

		public function defaultRequirementToAmountFactory():int
		{
			return int(this._requirments);
		}

		public function get requirementToAmountFactory():Function
		{
			return this._requirementToAmountFactory;
		}
		public function set requirementToAmountFactory(value:Function):void
		{
			this._requirementToAmountFactory = value;
		}
	}
}