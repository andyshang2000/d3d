package zzsdk.ad
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.utils.StringUtil;

	public class AdMC extends AdManager
	{
		private var hPosition:String;
		private var vPosition:String;
		private var adReady:Boolean = true;

		public function AdMC()
		{
			super(GameInfo.managedID);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(GET_DATA_SUCCESS, onAdConfigReady);

			graphics.beginFill(0, 0.2);
			graphics.drawRect(0, 0, 380, 50);
			stop();
			this.visible=false;
		}

		protected function onAdConfigReady(event:Event):void
		{
			adReady = true;
			runBanner(hPosition, vPosition);
		}

		private function onAddedToStage(event:Event):void
		{
			parseText();

			var rect:Rectangle = getBounds(this);
			var direct:String = "h";
			if (rect.width < rect.height)
				direct = "v";

			if (y < 5)
				vPosition = TOP;
			else if (y < 400 && direct == "v")
				vPosition = CENTER;
			else
				vPosition = BOTTOM;

			if (x < 5)
				hPosition = LEFT;
			else if (x < 700 && direct == "h")
				hPosition = CENTER;
			else
				hPosition = RIGHT;

			if (adReady)
			{
				runBanner(hPosition, vPosition);
			}
		}

		private function parseText():void
		{
			var str:String = "";
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				if (child.hasOwnProperty("text"))
				{
					str += child["text"];
				}
			}
			var seg:Array = StringUtil.trimArrayElements(str, "\r").split("\r");
			var result:Array = [];
			for (i = 0; i < seg.length; i++)
			{
				if (seg[i].length == 0 || seg[i].indexOf("#") == 0)
				{
					continue;
				}
				result = result.concat(StringUtil.trimArrayElements(seg[i], ",").split(","))
			}
			for (i = 0; i < result.length; i++)
			{
//				create(result[i]);
			}
		}
	}
}
