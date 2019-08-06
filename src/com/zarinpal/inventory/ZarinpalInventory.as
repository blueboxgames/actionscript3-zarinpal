package com.zarinpal.inventory
{
	import flash.utils.Dictionary;

	/**
	 * ZarinpalInventory is the inventory of the user session which
	 * contains a dictionary of SKU->Item for the user.
	 */
	public class ZarinpalInventory
	{
		/**
		 * @private
		 */
		private var _items:Dictionary;
		
		/**
		 * Constructor.
		 */
		public function ZarinpalInventory()
		{
			this._items = new Dictionary();
		}
		
		/**
		 * Creates a new item and add it to inventory.
		 * 
		 * @throws InvalidItemError: item with sku exists.
		 */
		public function add(sku:String, description:String, requirments:String, outcomes:String):void
		{
			if(this._items.hasOwnProperty(sku))
				return;
			else
				this._items[sku] = new ZarinpalStockItem(sku, description, requirments, outcomes);
		}

		/**
		 * Add an already defined item to inventory.
		 * 
		 * @throws InvalidItemError: item with sku exists.
		 */
		public function addItem(item:ZarinpalStockItem):void
		{
			if(this._items.hasOwnProperty(item.sku))
				return;
			this._items[item.sku] = item;
		}

		/**
		 * Lookup for item by their sku.
		 * returns null if it does not exist.
		 */
		public function getItem(sku:String):ZarinpalStockItem
		{
			if(!this._items.hasOwnProperty(sku))
				return null;
			return this._items[sku] as ZarinpalStockItem;
		}

		public function get items():Dictionary
		{
			return this._items;
		}
	}
}