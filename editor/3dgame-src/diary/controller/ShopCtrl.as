package diary.controller
{
	import diary.game.Context;
	import diary.game.Item;
	import diary.ui.view.IScreenCtrl;
	import diary.ui.view.ScreenManager;
	import diary.ui.view.ShopView;

	import starling.events.Event;

	public class ShopCtrl implements IScreenCtrl
	{
		private var screenMgr:ScreenManager;
		private var view:ShopView;
		private var selectedItem:Item;

		public function ShopCtrl(screenMgr:ScreenManager, view:ShopView)
		{
			this.screenMgr = screenMgr;
			this.view = view;
			view.initialize();
			view.updateList("hair");
			view.$backButton.addEventListener(Event.TRIGGERED, backButtonHandler);
			view.addEventListener("catChange", catChange);
			view.addEventListener("selectChange", selectChange);
			view.$buyButton.addEventListener(Event.TRIGGERED, buyHandler);
		}

		private function buyHandler(event:Event):void
		{
			if (Context.context.afford(selectedItem))
			{
			}
		}

		private function selectChange(event:Event):void
		{
			view.updatePreview(selectedItem = event.data as Item)
		}

		private function catChange(event:Event):void
		{
			switch (event.data)
			{
				case "hairButton":
					view.updateList("hair");
					break;
				case "upButton":
					view.updateList("shirt");
					break;
				case "downButton":
					view.updateList("pants");
					break;
				case "dressButton":
					view.updateList("dress");
					break;
				case "shoesButton":
					view.updateList("shoes");
					break;
				case "specialButton":
					view.updateList("special");
					break;
			}
		}

		private function backButtonHandler():void
		{
			screenMgr.requestChange("cancel");
		}

		public function handleStateChange(type:String):void
		{
			switch (type)
			{
				case "cancel":
				{
					screenMgr.changeScreen(State.MAP);
					break;
				}
				default:
				{
					break;
				}
			}
		}

		public function dispose():void
		{
			view.dispose();
		}
	}
}
