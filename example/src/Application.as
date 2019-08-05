package
{
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import starling.core.Starling;
	import flash.system.Capabilities;

	public class Application extends Sprite
	{
		private var _window:NativeWindow;
		private var _starling:Starling;
		private var _viewPort:Rectangle;

		public function Application()
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.frameRate = 60;
			
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		}

		private function loaderInfo_completeHandler(e:Event):void
		{
			this.loaderInfo.removeEventListener(Event.COMPLETE, loaderInfo_completeHandler);
			this._viewPort = new Rectangle(0,0, this.stage.fullScreenWidth, this.stage.fullScreenHeight);
			this._starling = new Starling(Main, this.stage, this._viewPort);
			this._starling.stage.stageWidth = 320;
			this._starling.stage.stageHeight = 480;
			this._starling.addEventListener("rootCreated", display_rootCreatedHandler);
			this._starling.supportHighResolutions = true;
			this._starling.skipUnchangedFrames = true;
			this._starling.start();
		}

		private function display_rootCreatedHandler(evnet:*):void
		{
			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
		}

		private function stage_deactivateHandler(event:*):void
		{
			this._starling.stop(true);
			this.stage.frameRate = 0;
			this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}

		private function stage_activateHandler(event:Event):void
    {
      this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
      this.stage.frameRate = 60;
      this._starling.start();
    }
	}
}