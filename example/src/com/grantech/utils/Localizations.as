package com.grantech.utils
{
	import flash.filesystem.File;

	import starling.assets.AssetManager;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * ...
	 * @author Mansour Djawadi
	 */

	[Event(name="change", type="starling.events.Event")]
	public class Localizations extends EventDispatcher
	{
		static private var _instance:Localizations;
		public var locale:String;
		public var localeDictionary:Object;
		public var assetManager:AssetManager;
		static public function get instance() : Localizations
		{
			if( _instance == null )
				_instance = new Localizations();
			return _instance;
		}

		public function changeLocale(locale:String = "en_US", assetManager:AssetManager = null) : void
		{
			if( assetManager != null )
				this.assetManager = assetManager;
			this.locale = locale;

			this.assetManager.enqueue(File.applicationDirectory.resolvePath("locale/" + locale + ".json"));
			this.assetManager.loadQueue(assetManager_localeCallback);
		}

		protected function assetManager_localeCallback(ratio:Number) : void 
		{
			if( ratio < 1 )
					return;
			localeDictionary = this.assetManager.getObject(locale);
			dispatchEventWith(Event.CHANGE, false, locale);
		}

		public function get(key:String, parameters:Array = null) : String
		{
			var loc:String = localeDictionary[key];
			if( loc == null )
				return key;
			if( parameters != null && parameters.length > 0 )
			{
				var slices:Array = loc.split("#");
				if( slices.length <= parameters.length )
					return loc;
				
				var ret:String = "";
				for( var i:int = 0; i < parameters.length; i++ )
					ret += slices[i] + parameters[i];
				if( slices[i] != "" )
					ret += slices[i];
				return ret;
			}
			return loc;
		}
	}
}