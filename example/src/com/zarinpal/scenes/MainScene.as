package com.zarinpal.scenes
{
	import com.grantech.utils.Localizations;
	import com.zarinpal.ZarinPal;
	import com.zarinpal.ZarinpalGatewayRequest;
	import com.zarinpal.events.ZarinpalRequestEvent;

	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import starling.events.Event;
	import starling.events.ResizeEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	public class MainScene extends Screen
	{
		static public const NAME:String = "main";
		public function MainScene()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private function addedToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
		}

		override protected function initialize():void
    {
			super.initialize();
			this.name = "MainView";

			this.layout = new AnchorLayout();
			ZarinPal.instance.initialize("b37e90ce-b2bc-11e9-832c-000c29344814", "zarinpal://recieve");
			ZarinPal.instance.inventory.add("dummy", "Dummy Item", "1000", "60:Gem");
			var button:Button = new Button();
			button.layoutData = new AnchorLayoutData(NaN,NaN,NaN,NaN,0,0);
			button.label = Localizations.instance.get("dummy_purchase");
			button.addEventListener(Event.TRIGGERED, function(e:Event):void
			{
				var request:ZarinpalGatewayRequest = new ZarinpalGatewayRequest(true);
				request.setRequestFor("dummy");
				request.send();
				request.addEventListener(ZarinpalRequestEvent.PAYMENT_REQUEST_RESPONSE_RECIEVED, function(e:ZarinpalRequestEvent):void
				{
					var urlRequest:URLRequest = new URLRequest(request.getGatewayUrl(e.response["Authority"]));
					navigateToURL(urlRequest);
				});
			});
			this.addChild(button);
		}
	}
}