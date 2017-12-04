package qd3d.gui.views
{
	import diary.ui.view.ViewWithTopBar;

	import lzm.starling.swf.display.SwfImage;
	import lzm.starling.swf.display.SwfMovieClip;

	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class BottomPanel extends ViewWithTopBar
	{
		public var $ctrlBtn:SwfMovieClip;
		public var $photoBtn:SwfMovieClip;
		public var $msicBtn:SwfMovieClip;
		public var $bottombg:SwfImage;

		private var btns:Array;
		private var _miscIsOpen:Boolean = true;
		private var _touchCtrl:Boolean = true;

		override protected function _fieldInit():void
		{
			$msicBtn.gotoAndStop(0);
			$ctrlBtn.gotoAndStop(1);
			btns = [$ctrlBtn, $photoBtn, $msicBtn];
			for each (var btn:SwfMovieClip in btns)
			{
				btn.gotoAndStop(0);
				btn.addEventListener(TouchEvent.TOUCH, btnClkHandler);
			}
		}

		private function btnClkHandler(e:TouchEvent):void
		{
			var btn:SwfMovieClip = e.currentTarget as SwfMovieClip;
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject, TouchPhase.ENDED);

			if (!touch)
				return;
			if (btn.name == "msicBtn")
			{
				_miscIsOpen = !_miscIsOpen;
				if (_miscIsOpen)
				{
					btn.gotoAndStop(0);
				}
				else
				{
					btn.gotoAndStop(1);
				}
			}
			else if (btn.name == "ctrlBtn")
			{
				_touchCtrl = !_touchCtrl;
				if (_touchCtrl)
				{
					btn.gotoAndStop(0);
					dispatchEventWith("moveModeChange", false, "move");
				}
				else
				{
					btn.gotoAndStop(1);
					dispatchEventWith("moveModeChange", false, "rotate");
				}
			}
			else if (btn.name == "photoBtn")
			{
				dispatchEventWith("photo", false);
			}
		}

		public function openMusic():void
		{
			_miscIsOpen = true;
			$msicBtn.gotoAndStop(0);
		}
	}
}
