package sui.utils
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class DragHelper
	{
		private static var stage:Stage;
		private static var obj:DisplayObject;
		private static var bounds:Rectangle;
		private static var startPoint:Point;
		private static var startStagePoint:Point;
		private static var scale:Number;

		public static function startDrag(spr:DisplayObject, rect:Rectangle, touch:Touch, scale:Number = 1.0):void
		{
			if (spr.stage)
			{
				DragHelper.scale = scale;
				obj = spr;
				obj.touchable = true;
				stage = spr.stage;
				bounds = rect;
				startPoint = new Point(spr.x, spr.y);
				startStagePoint = new Point(touch.globalX, touch.globalY);
				spr.stage.addEventListener(TouchEvent.TOUCH, stageTouchHandler);
			}
		}

		public static function stopDrag(spr:DisplayObject):void
		{
			if (stage)
				stage.removeEventListener(TouchEvent.TOUCH, stageTouchHandler);
			obj = null;
		}

		private static function stageTouchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(event.currentTarget as DisplayObject, TouchPhase.MOVED);
			if (!touch)
				return;

			obj.x = startPoint.x + (touch.globalX - startStagePoint.x) / scale;
			obj.y = startPoint.y + (touch.globalY - startStagePoint.y) / scale;

			if (bounds)
			{
				if (obj.x > bounds.right)
					obj.x = bounds.right;
				if (obj.x < bounds.left)
					obj.x = bounds.left;

				if (obj.y > bounds.bottom)
					obj.y = bounds.bottom;
				if (obj.y < bounds.top)
					obj.y = bounds.top;
			}
		}
	}
}
