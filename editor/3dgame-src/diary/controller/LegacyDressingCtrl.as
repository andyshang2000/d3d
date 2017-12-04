package diary.controller
{
	import diary.avatar.AvatarView;
	import diary.avatar.RotationComponent;
	import diary.avatar.ZoomMoveComponent;
	import diary.game.Context;
	import diary.game.Item;
	import diary.ui.view.IScreenCtrl;
	import diary.ui.view.LegacyDressingView;
	import diary.ui.view.ScreenManager;
	import diary.ui.view.dressing.EmbedMgr;

	import flare.core.IComponent;

	import starling.core.Starling;
	import starling.events.Event;

	public class LegacyDressingCtrl implements IScreenCtrl
	{
		private var screenMgr:ScreenManager;
		private var view:LegacyDressingView;

		private var moveComp:IComponent;

		public function LegacyDressingCtrl(screenMgr:ScreenManager, view:LegacyDressingView)
		{
			this.screenMgr = screenMgr;
			this.view = view;
			EmbedMgr.Instance().onLoaded(function():void
			{
				view.initialize(function():void
				{
					updateRightPanel("hair");
					view.$_rightPanel.addEventListener("change", changePartHandler);
					view.$_leftPanel.addEventListener("change", changeCatHandler);
					//
					view.$_bottomPanel.addEventListener("moveModeChange", modeModeChange);
					view.$_bottomPanel.addEventListener("photo", photoHandler);
					//
					view.avatar.setAvatar(Context.context.avatar);
					setMoveMode("move");
				});
			});
		}

		private function photoHandler(event:Event):void
		{
			screenMgr.requestChange("rate");
		}

		private function modeModeChange(event:Event):void
		{
			setMoveMode(event.data + "")
		}

		public function setMoveMode(mode:String):void
		{
			if (moveComp)
				view.avatar.removeComponent(moveComp);

			if (mode == "move")
				view.avatar.addComponent(moveComp = new ZoomMoveComponent(Starling.current.stage));
			else if (mode == "rotate")
				view.avatar.addComponent(moveComp = new RotationComponent);
		}

		private function changeCatHandler():void
		{
			updateRightPanel(view.$_leftPanel.partType);
//			view.$_rightPanel.update(conf.game[view.$_leftPanel.partType]);
		}

		private function updateRightPanel(cat:String):void
		{
			var owned:Array = Context.context.inventory.owned;
			view.$_rightPanel.update(owned.filter(function(item:Item, ... args):Boolean
			{
				switch (cat)
				{
					case "hair":
						return item.type == 1;
					case "shirt":
						return item.type == 2;
					case "pants":
						return item.type == 3;
					case "shoes":
						return item.type == 4;
					case "dress":
						return item.type == 9;
					default:
						return false;
				}
			}));
//			view.$_rightPanel.update(conf.game["pants"]);
		}

		private function changePartHandler(event:Event):void
		{
			view.showDressEff();
			Context.context.avatar.updatePart(event.data as Item);
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
			var avatar:AvatarView = view.avatar;
			while (avatar.components.length > 0)
			{
				avatar.removeComponent(avatar.components[0])
			}
			avatar.stop(true);
			avatar.parent = null;
			Context.context.put("avatar", avatar);
			view.dispose();
		}
	}
}

