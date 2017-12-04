package diary.controller
{
	import diary.ui.view.IScreenCtrl;
	import diary.ui.view.MainMenu;
	import diary.ui.view.ScreenManager;

	import starling.events.Event;

	public class MainMenuCtrl implements IScreenCtrl
	{
		private var screenMgr:ScreenManager;
		private var view:MainMenu;

		public function MainMenuCtrl(screenMgr:ScreenManager, view:MainMenu)
		{
			this.screenMgr = screenMgr;
			this.view = view;
			view.initialize();

			view.$startButton.addEventListener(Event.TRIGGERED, function():void
			{
				screenMgr.requestChange("start");
			});
		}

		public function handleStateChange(type:String):void
		{
			screenMgr.changeScreen(State.DIALOG);
//			screenMgr.changeScreen(State.MAP);
		}

		public function dispose():void
		{
			view.dispose();
		}
	}
}
