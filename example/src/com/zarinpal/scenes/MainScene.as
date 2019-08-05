package com.zarinpal.scenes
{
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	// import ir.metrix.sdk.Metrix;
	// import ir.metrix.sdk.MetrixCurrency;
	// import ir.metrix.sdk.MetrixEvent;

	import starling.events.Event;
	import starling.events.ResizeEvent;
	import com.zarinpal.ZarinPal;
	import com.zarinpal.PaymentRequest;
	import com.zarinpal.events.ZarinPalEvent;
	import com.zarinpal.Storage;
	import com.zarinpal.Item;
	import com.grantech.utils.Localizations;
	import com.zarinpal.PaymentVerification;

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
			ZarinPal.instance.initialize("b37e90ce-b2bc-11e9-832c-000c29344814", "zarinpal://recive");
			var dummyItem:Item = new Item("dummy", "Dummy Item", 100);
			ZarinPal.instance.storage.addItem(dummyItem);

			var button:Button = new Button();
			button.layoutData = new AnchorLayoutData(NaN,NaN,NaN,NaN,0,0);
			button.label = Localizations.instance.get("dummy_purchase");
			button.addEventListener(Event.TRIGGERED, function(e:Event):void
			{
				var request:PaymentRequest = ZarinPal.instance.getPaymentRequest("dummy");
				ZarinPal.instance.sendPaymentRequest(request);
				ZarinPal.instance.addEventListener(ZarinPalEvent.TRANSACTION_SUCCESS, zarinpal_transactionSuccessHandler);
			});
			this.addChild(button);
		}

		protected function zarinpal_transactionSuccessHandler(e:ZarinPalEvent):void
		{
			var response:Object = e.data;
			var verification:PaymentVerification = new PaymentVerification(ZarinPal.instance.merchantID, response["Authority"], 100);
			verification.addEventListener(ZarinPalEvent.VERIFICATION_SUCCESS, vs);
			verification.addEventListener(ZarinPalEvent.VERIFICATION_SUCCESS_TWICE, vs);
		}

		protected function vs(e:ZarinPalEvent):void
		{
			trace(JSON.stringify(e.data));
		}
	}
}