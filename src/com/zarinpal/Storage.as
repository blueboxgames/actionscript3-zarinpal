package com.zarinpal
{
	import flash.utils.Dictionary;

	public class Storage
	{
		private var items:Dictionary;
		public function Storage(){
			this.items = new Dictionary();
		}

		public function addItem(item:Item):void
		{
			this.items[item.sku] = item;
		}

		public function getItem(sku:String):Item
		{
			if(!this.items.hasOwnProperty(sku))
				return null;
			return this.items[sku] as Item;
		}
	}
}