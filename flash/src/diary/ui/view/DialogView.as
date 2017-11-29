package diary.ui.view
{
	import flash.text.Font;
	import flash.utils.setTimeout;
	
	import diary.game.Tachie;
	import diary.res.RES;
	import diary.ui.font.FZArtHei;
	
	import lzm.starling.swf.display.SwfButton;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	import swallow.filters.HdrFilter;

	public class DialogView extends ViewWithTopBar implements IScreen
	{
		private var font:Font = new FZArtHei;

		public var $title:TextField;
		public var $content:TextField;
		public var $switchBg:Image;
		public var $_confirmAlert:ConfirmAlert;

		private var view:Sprite;
		private var selections:Array = [];

		private var tachieList:Object = {};
//		private var tachieList:Object = {};
		private var tachieLayer:Sprite;
		private var bgLayer:Sprite;

		public function getFront():Sprite
		{
			view = RES.get("gui/spr_dialogView");
			view.addEventListener(TouchEvent.TOUCH, touchHandler);
			view.addChildAt(tachieLayer = new Sprite, 0).name = "tachie";
			view.addChildAt(bgLayer = new Sprite, 0).name = "bg";
			//urgly hack
			view.touchable = false;
			setTimeout(function():void
			{
				view.touchable = true;
			}, 50);
			return view;
		}

		override public function loadAssets(callback:Function = null):void
		{
			super.loadAssets(callback);
			$switchBg.visible = false;
			$_confirmAlert.visible = false;
		}

		private function touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(view, TouchPhase.BEGAN);
			if (touch)
			{
				dispatchEventWith("next");
			}
		}

		public function addSelection(param0:String):void
		{
			var button:SwfButton = RES.get("gui/btn_switchButton")
			var textField:TextField = Sprite(button.skin).getChildByName("labelField") as TextField;
			textField.text = param0;
			view.addChild(button);
			selections.push(button);
			button.addEventListener(Event.TRIGGERED, selectHandler);

			button.name = selections.length + "";
		}

		private function selectHandler(event:Event):void
		{
			var button:SwfButton = event.currentTarget as SwfButton;
			dispatchEventWith("select", false, button.name)
		}

		public function layoutSelections():void
		{
			var y:int = (800 - (70 * selections.length)) / 2 - 100;
			var x:int = 38;
			for (var i:int = 0; i < selections.length; i++)
			{
				selections[i].x = x;
				selections[i].y = y;
				y += 70;
			}
		}

		public function showBg(name:String):void
		{
			if (bgLayer.getChildByName(name) != null)
				return;
			bgLayer.removeChildren(0);
			var image:Image = new Image(RES.get(name));
			bgLayer.addChild(image)
			image.scaleX = 2;
			image.scaleY = 2;
		}

		public function showTachie(actor:String, emotion:String, posRef:String):void
		{
			var tachie:Tachie = Tachie.get(actor);
			var image:Image;
			posRef ||= tachie.defaultPos;
			if (tachieList[posRef] == actor)
			{
				hightlight(actor);
				return;
			}
			if (tachieList[posRef])
			{
				image = tachieLayer.getChildByName(tachieList[posRef]) as Image;
				if (image)
				{
					image.removeFromParent(true);
				}
			}
			tachieList[posRef] = actor;
			image = tachieLayer.getChildByName(tachieList[posRef]) as Image;
			if (!image)
				image = new Image(RES.get(tachie.source));
			tachieLayer.addChild(image).name = actor;
			image.y = 150;
			hightlight(actor);
			switch (posRef)
			{
				case "左":
					image.x = (480 - image.width) / 2 - 80;
					break;
				case "中":
					image.x = (480 - image.width) / 2;
					break;
				case "右":
					image.x = (480 - image.width) / 2 + 80;
					break;
			}
		}

		private function hightlight(actor:String):void
		{
			var image:Image;
			var hit:Image;
			for (var i:int = 0; i < tachieLayer.numChildren; i++)
			{
				image = tachieLayer.getChildAt(i) as Image;
				if (image.name != actor)
				{
					image.filter = new HdrFilter
				}
				else
				{
					hit = image;
					image.filter = null;
//					image.alpha = 1;
				}
			}
			tachieLayer.setChildIndex(hit, tachieLayer.numChildren - 1);
		}

		public function finishSelection():void
		{
			for (var i:int = 0; i < selections.length; i++)
			{
				SwfButton(selections[i]).removeFromParent(true);
			}
			selections = [];
		}
	}
}
