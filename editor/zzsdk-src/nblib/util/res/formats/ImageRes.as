package nblib.util.res.formats
{
	import flash.display.BitmapData;
	import flash.events.Event;

	public class ImageRes extends LibRes
	{
		public var bitmapData:BitmapData;

		public function ImageRes(path:String)
		{
			super(path);
		}

		protected override function loader_completeHandler(event:Event):void
		{
			bitmapData = event.currentTarget.content.bitmapData;
			super.loader_completeHandler(event);
		}

		public override function dispose():Boolean
		{
			if (bitmapData != null)
			{
				bitmapData.dispose();
			}
			bitmapData = null;
			super.dispose();
			return true;
		}
	}
}
