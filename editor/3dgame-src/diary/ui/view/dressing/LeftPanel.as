package diary.ui.view.dressing
{

	import diary.ui.view.ViewBase;
	
	import lzm.starling.swf.display.SwfMovieClip;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class LeftPanel extends ViewBase
	{
		public var $hairBtn:SwfMovieClip;
		public var $shoesBtn:SwfMovieClip;
		public var $pantsBtn:SwfMovieClip;
		public var $defaultBtn:SwfMovieClip;
		public var $coatBtn:SwfMovieClip;
		public var $suitBtn:SwfMovieClip;

		public var partType:String = "hair";

		private var btns:Array;
		private var currentBtnName:String = "hairBtn";
		private var clkEff:MovieClip;

		override protected function _fieldInit():void
		{
			addClkListener();
			$defaultBtn.visible = false;
		}

		override public function initialize(callback:Function = null):void
		{
			super.initialize();
			if (!clkEff)
			{
				clkEff = new MovieClip(EmbedMgr.Instance().getTextures("blackhole"), 40);
				Starling.juggler.add(clkEff);
				clkEff.loop = false;
				clkEff.stop();
			}
		}

		private function addClkListener():void
		{
			btns = [$hairBtn, $shoesBtn, $coatBtn, $suitBtn, $defaultBtn, $pantsBtn];
			for each (var btn:SwfMovieClip in btns)
			{
				btn.gotoAndStop(0);
				btn.addEventListener(TouchEvent.TOUCH, btnClkHandler);
			}
			$hairBtn.gotoAndStop(1);
		}

		private function btnClkHandler(e:TouchEvent):void
		{
			var btn:SwfMovieClip = e.currentTarget as SwfMovieClip;
			var touch:Touch = e.getTouch(e.target as DisplayObject, TouchPhase.ENDED);
			var btnName:String = btn.name;
			if (!touch || currentBtnName == btnName)
			{
				return;
			}
			currentBtnName = btnName;
			switch (currentBtnName)
			{
				case "shoesBtn":
					partType = "shoes";
					break;
				case "hairBtn":
					partType = "hair";
					break;
				case "suitBtn":
					partType = "dress";
					break;
				case "coatBtn":
					partType = "shirt";
					break;
				case "defaultBtn":
					partType = "default";
					break;
				case "pantsBtn":
					partType = "pants";
					break;
			}
			dispatchEventWith("change");

			Starling.juggler.tween(btn, 0.1, {transition: Transitions.EASE_IN, //
					scaleX: 0.31, scaleY: 0.31, //
					x: btn.x + btn.width / 4, y: btn.y + btn.height / 4, //
					onComplete: function removeEffect2():void
					{
						Starling.juggler.tween(btn, 0.2, {transition: Transitions.EASE_OUT, //
								scaleX: .62, scaleY: .62, //
								x: btn.x - btn.width / 2, y: btn.y - btn.height / 2, //
								onComplete: function():void
								{
									setSelectBtn(btn);
								}});
					}});

			view.addChild(clkEff);
			clkEff.scaleX = clkEff.scaleY = 0.75;
			clkEff.x = btn.x - 27;
			clkEff.y = btn.y - 22;
			clkEff.currentFrame = 0;
			clkEff.play();
			clkEff.addEventListener(Event.COMPLETE, function():void
			{
				clkEff.stop();
				view.removeChild(clkEff);
			});
		}

		private function setSelectBtn(btn:SwfMovieClip):void
		{
			for each (var i:SwfMovieClip in btns)
			{
				if (i == btn)
				{
					i.gotoAndStop(1);
				}
				else
				{
					i.gotoAndStop(0);
				}
			}
		}
	}
}
