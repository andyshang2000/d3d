package diary.controller
{
	import ands.drama.scripting.Branch;
	import ands.drama.scripting.DialogContent;
	import ands.drama.scripting.EndEntry;
	import ands.drama.scripting.IResponding;
	import ands.drama.scripting.QuestRef;
	import ands.drama.scripting.Script;
	import ands.drama.scripting.ScriptEntry;

	import diary.game.Context;
	import diary.ui.view.DialogView;
	import diary.ui.view.IScreenCtrl;
	import diary.ui.view.ScreenManager;

	import starling.events.Event;

	public class DialogCtrl implements IScreenCtrl
	{
		private var screenMgr:ScreenManager;
		private var view:DialogView;
		private var script:Script;
		private var context:Context;

		public function DialogCtrl(screenMgr:ScreenManager, view:DialogView)
		{
			this.screenMgr = screenMgr;
			this.view = view;
			this.context = Context.context;
			//
			view.initialize();
			view.addEventListener("next", nextHandler);
			view.addEventListener("select", selectHandler);
			next();
		}

		private function next():void
		{
			if (context.isScriptPlaying())
				updateScript(context.nextScript());
		}

		private function updateScript(entry:ScriptEntry):void
		{
			if (entry == null)
				return;
			//根据类型执行
			if (!(entry is IResponding))
			{
				if (context.isScriptPlaying())
					updateScript(context.nextScript());
			}
			else if (entry is Branch)
			{
				showBranch(entry as Branch);
			}
			else if (entry is QuestRef)
			{
				showQuest(entry as QuestRef);
			}
			else if (entry is DialogContent)
			{
				showContent(entry as DialogContent);
			}
			else if (entry is EndEntry)
			{
				view.$title.text = "";
				view.$content.text = "尼玛！游戏结束了啊！！！";
			}
		}

		private function showContent(content:DialogContent):void
		{
			view.showBg(context.level.bg);
			view.showTachie(content.actor, null, null)
			view.$title.text = content.actor;
			view.$content.text = content.content;
		}

		private function showQuest(param0:QuestRef):void
		{
			context.setQuest(param0);
			view.$_confirmAlert.visible = true;
			view.$_confirmAlert.onConfirm = function():void
			{
				screenMgr.requestChange("confirm");
			}
			view.$_confirmAlert.onCancel = function():void
			{
				screenMgr.requestChange("cancel");
			}
			view.$switchBg.visible = true;
		}

		private function showBranch(branch:Branch):void
		{
			for (var i:int = 0; i < branch.numConditions; i++)
			{
				view.addSelection(branch.getLabel(i));
			}
			view.layoutSelections();
		}

		public function handleStateChange(type:String):void
		{
			view.$_confirmAlert.visible = false;
			view.$switchBg.visible = false;
			//
			if (type == "cancel")
			{
				context.cancelQuest();
				screenMgr.changeScreen(State.MAP);
			}
			else if (type == "confirm")
			{
				context.acceptQuest();
				screenMgr.changeScreen(State.DRESSING);
			}
		}

		public function dispose():void
		{
			view.removeEventListeners("next");
			view.removeEventListeners("select");
			view.dispose();
		}

		protected function nextHandler():void
		{
			// TODO Auto Generated method stub
			next();
		}

		protected function selectHandler(event:Event):void
		{
			// TODO Auto Generated method stub
			context.scriptSelect(int(event.data));
			view.finishSelection();
			next();
		}
	}
}
