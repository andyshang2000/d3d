package diary.controller
{
	import ands.drama.scripting.DialogContent;

	import diary.game.Context;
	import diary.game.Rate;
	import diary.ui.view.IScreenCtrl;
	import diary.ui.view.RateView;
	import diary.ui.view.ScreenManager;

	public class RateCtrl implements IScreenCtrl
	{
		private var screenMgr:ScreenManager;
		private var view:RateView;
		private var bonus:Array;

		public function RateCtrl(screenMgr:ScreenManager, view:RateView)
		{
			this.screenMgr = screenMgr;
			this.view = view;
			view.loadAssets();
			view.addEventListener("next", next);

			Context.context.rate();
			bonus = Context.context.bonus();
			showRating();
		}

		private function next():void
		{
			if (bonus.length == 0)
			{
				screenMgr.requestChange("quit");
				return;
			}

			view.$_rewardPanel.show(bonus.shift());

		}

		private function showRating():void
		{
			switch (Context.context.rating.rank)
			{
				case "S":
					view.$content.text = "挖！S！";
					break;
				case "A":
					view.$content.text = "挖！A！";
					break;
				case "B":
					view.$content.text = "挖！B！";
					break;
				case "C":
					view.$content.text = "挖！C！";
					break;
				default:
					view.$content.text = "哦漏！F！";
					break;
			}
		}

		public function handleStateChange(type:String):void
		{
			if (type == "quit")
			{
				if (Context.context.nextScript() is DialogContent)
				{
					Context.context.pushbackScript();
					screenMgr.changeScreen(State.DIALOG);
				}
				else
				{
					screenMgr.changeScreen(State.MAP);
				}
			}
		}

		public function dispose():void
		{
			view.dispose();
		}
	}
}
