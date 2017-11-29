package diary.controller
{
	import diary.game.Context;
	import diary.game.Level;
	import diary.ui.view.IScreenCtrl;
	import diary.ui.view.ScreenManager;
	import diary.ui.view.Worldmap;

	import starling.events.Event;

	public class WorldMapCtrl implements IScreenCtrl
	{
		private var screenMgr:ScreenManager;
		private var view:Worldmap;

		public function WorldMapCtrl(screenMgr:ScreenManager, view:Worldmap)
		{
			this.screenMgr = screenMgr;
			this.view = view;
			view.loadAssets();
			view.addEventListener("enterLevel", enterLevel);
			view.addEventListener("buyEvent", buyEvent);
		}

		public function handleStateChange(type:String):void
		{
			if (type == "quest")
			{
				screenMgr.changeScreen(State.DIALOG);
			}
			else if (type == "free")
			{
				screenMgr.changeScreen(State.DRESSING)
			}
			else if (type == "shop")
			{
				screenMgr.changeScreen(State.SHOP);
			}
		}

		public function dispose():void
		{
			view.dispose();
		}

		protected function enterLevel(event:Event):void
		{
			// TODO Auto Generated method stub
			var level:Level = Level.getData(event.data);
			Context.context.setLevel(level);
			if (!Context.context.passed(level))
			{
				screenMgr.requestChange("quest");
			}
			else
			{
				screenMgr.requestChange("free");
			}
		}

		private function buyEvent():void
		{
			screenMgr.requestChange("shop");
		}
	}
}

