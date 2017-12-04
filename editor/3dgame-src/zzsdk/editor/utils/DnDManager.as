package zzsdk.editor.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class DnDManager
	{
		private static var stage:Stage;
		private static var instance:DnDManager;
		private static var accepted:Array = [];

		private static var dragSource:Object;

		public static function bind(stage:Stage):void
		{
			DnDManager.stage = stage;
		}

		public static function start(obj:Sprite, dragSource):void
		{
			getInstance().start(obj);
			DnDManager.dragSource = dragSource;
		}

		public static function enableDrop(target:Sprite):void
		{
			getInstance().enableDrop(target);
		}

		private static function getInstance():DnDManager
		{
			// TODO Auto Generated method stub
			return instance ||= new DnDManager;
		}

		//
		private var dropTargetList:Array = [];
		private var dragStarted:Boolean = false;
		private var dragSnap:Sprite = new Sprite;
		private var snapBitmap:Bitmap = new Bitmap(new BitmapData(48, 48, true, 0));

		private var dragTarget:Sprite;

		protected function start(dragTarget:Sprite):void
		{
			dragTarget.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		protected function mouseMoveHandler(event:MouseEvent):void
		{
			accepted = [];
			//
			dragTarget = event.currentTarget as Sprite;
			dragTarget.removeEventListener(event.type, arguments.callee);
			dragStarted = true;
			//
			stage.addChild(dragSnap);
			dragSnap.addChild(snapBitmap);
			dragSnap.alpha = 0.4
			//

			dragSnap.startDrag(true);
			dragSnap.mouseChildren = false;
			dragSnap.mouseEnabled = false;

			var scaleX:Number = dragSnap.width / dragTarget.width;
			var scaleY:Number = dragSnap.height / dragTarget.height;
			var scale:Number = Math.min(scaleX, scaleY);
			snapBitmap.bitmapData.draw(dragTarget, new Matrix(scale, 0, 0, scale, 0, 0));

			for (var i:int = 0; i < dropTargetList.length; i++)
			{
				dropTargetList[i].addEventListener(MouseEvent.ROLL_OUT, dropTargetOutHandler);
				dropTargetList[i].addEventListener(MouseEvent.ROLL_OVER, dropTargetOverHandler);
			}
			dragTarget.dispatchEvent(new DragEvent(DragEvent.START, dragSource));
		}

		protected function mouseUpHandler(event:MouseEvent):void
		{
			for (var i:int = 0; i < dropTargetList.length; i++)
			{
				dropTargetList[i].addEventListener(MouseEvent.ROLL_OUT, dropTargetOutHandler);
				dropTargetList[i].addEventListener(MouseEvent.ROLL_OVER, dropTargetOverHandler);
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			if (dragStarted)
			{
				dragStarted = false;
				stage.removeChild(dragSnap);
				dragSnap.stopDrag();
				dragSnap.removeChildren(0);
				snapBitmap.bitmapData.fillRect(snapBitmap.bitmapData.rect, 0);
				//
				for (i = 0; i < accepted.length; i++)
				{
					var area:InteractiveObject = accepted[i];
					var bounds:Rectangle = area.getBounds(area);
					if (bounds.contains(area.mouseX, area.mouseY))
					{
						area.dispatchEvent(new DragEvent(DragEvent.DROP, dragSource));
						break;
					}
				}
			}
		}

		public function enableDrop(target:InteractiveObject):void
		{
			var index:int = dropTargetList.indexOf(target);
			if (index == -1)
			{
				dropTargetList.push(target);
			}
		}

		public function disableDrop(target:InteractiveObject):void
		{
			var index:int = dropTargetList.indexOf(target);
			if (index != -1)
			{
				dropTargetList.splice(index);
			}
		}

		protected function dropTargetOutHandler(event:MouseEvent):void
		{
			var dropTarget:InteractiveObject = event.currentTarget as InteractiveObject;
			if (dropTarget != dragTarget)
			{
				dropTarget.dispatchEvent(new DragEvent(DragEvent.OUT, dragSource));
			}
		}

		protected function dropTargetOverHandler(event:MouseEvent):void
		{
			var dropTarget:InteractiveObject = event.currentTarget as InteractiveObject;
			if (dropTarget != dragTarget)
			{
				dropTarget.dispatchEvent(new DragEvent(DragEvent.ENTER, dragSource));
			}
		}

		public static function accept(cb:*):void
		{
			if (accepted.indexOf(cb) == -1)
			{
				accepted.push(cb)
			}
		}
	}
}
