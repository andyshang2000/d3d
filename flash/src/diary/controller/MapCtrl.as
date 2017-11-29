package diary.controller
{
	import diary.ui.view.IScreenCtrl;
	import diary.ui.view.MapView;
	import diary.ui.view.ScreenManager;

	public class MapCtrl implements IScreenCtrl
	{
		private var screenMgr:ScreenManager;
		private var view:MapView;

		public function MapCtrl(screenMgr:ScreenManager, view:MapView)
		{
			this.screenMgr = screenMgr;
			this.view = view;
			view.loadAssets();
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
	}
}
