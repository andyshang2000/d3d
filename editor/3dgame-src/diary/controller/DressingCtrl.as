package diary.controller
{
	import diary.ui.view.DressingView;
	import diary.ui.view.IScreenCtrl;
	import diary.ui.view.ScreenManager;

	public class DressingCtrl implements IScreenCtrl
	{
		private var screenMgr:ScreenManager;
		private var view:DressingView;

		public function DressingCtrl(screenMgr:ScreenManager, view:DressingView)
		{
			this.screenMgr = screenMgr;
			this.view = view;
			view.initialize();
		}

		public function handleStateChange(type:String):void
		{
			if (type == "rate")
			{
				screenMgr.changeScreen(State.RATING);
			}
			else if (type == "timeout")
			{
				screenMgr.changeScreen(State.RATING);
			}
			else if (type == "giveup")
			{
				screenMgr.changeScreen(State.MAP);
			}
		}

		public function dispose():void
		{
			view.dispose();
		}
	}
}

