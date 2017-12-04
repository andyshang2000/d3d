package zzsdk.editor.gui
{
	import flash.display.Sprite;
	import flash.events.Event;

	import zzsdk.editor.utils.DragDropUtils;

	public class DragArea extends Sprite
	{
		public function DragArea(... args)
		{
			if (args[0] is Array)
			{
				args = args[0]
			}
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			DragDropUtils.setAcceptedExtension.apply(null, args)
		}

		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(event.type, addedToStageHandler);

			stage.addEventListener(Event.RESIZE, resizeHandler);

			DragDropUtils.setStage(stage);
			DragDropUtils.enable(this);

			graphics.beginFill(0, 0.1);
//			graphics.drawRect(0, 0, gDimenssion.width, gDimenssion.height);
		}

		protected function resizeHandler(event:Event):void
		{
			graphics.clear();
			graphics.beginFill(0, 0);
//			graphics.drawRect(0, 0, gDimenssion.width, gDimenssion.height);
		}
	}
}
