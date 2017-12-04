package zzsdk.templates
{
	import starling.display.Sprite;
	import starling.events.Event;

	public class StarlingBackgroundBase extends Sprite
	{
		public function StarlingBackgroundBase()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}

		private function addedHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
//			var _maxNum:int = 1;
//
//			for (var i:int = 1; i <= _maxNum; i++)
//			{
//				var url:String = LogicConstants.BG_ROOT + "bg" + String(i) + ".png";
//				ResManager.getResAsync(url, function onComplete(res:ImageRes):void
//				{
//					var texture:Texture = Texture.fromBitmapData(res.bitmapData)
//					var img:SwfImage = new SwfImage(texture);
//					addChild(img);
//					
//					dispatchEventWith("rootCreated");
//				});
//			}
		}
	}
}
