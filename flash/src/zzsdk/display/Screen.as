package zzsdk.display
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import fairygui.GObject;
	import fairygui.GRoot;
	
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	public class Screen
	{
		public static var designW:int = 480;
		public static var designH:int = 800;

		public static var STAGE_WIDTH:int = 1;
		public static var STAGE_HEIGHT:int = 1;

		public static var H_QUOTA:int;

		public static var n2aScaleFactor:Number;
		public static var a2nScaleFactor:Number;

		public static var showAllPort:Rectangle;
		public static var noBorderPort:Rectangle;
		public static var fullscreenPort:Rectangle;

		public static var fitLarge:Boolean = true;

		public static var nbWidth:int = 1;
		public static var nbHeight:int = 1;
		public static var saWidth:int = 1;
		public static var saHeight:int = 1;
		public static var exactWidth:int = 1;
		public static var exactHeight:int = 1;

		public static var aspectRatio:Number = 9 / 16;

		private static var initialized:Boolean = false;
		
		
		public static function getFitRect(obj:GObject):Rectangle
		{
			var rect:Rectangle = new Rectangle(0, 0, GRoot.inst.width, GRoot.inst.height);
			var port:Rectangle = new Rectangle(0, 0, obj.width, obj.height);
			var result:Rectangle = RectangleUtil.fit(port, rect, ScaleMode.NO_BORDER);
			return result;
		}

		public static function fitView(port:Rectangle, mode:String):Rectangle
		{
			return RectangleUtil.fit(port, //
				new Rectangle(0, 0, designW, designH), // 
				mode);
		}

		public static function fitBackground(bg:*, scaleFactor:Number, rootX:Number, rootY:Number, isScroll:Boolean = false):void
		{
			var viewport:Rectangle = RectangleUtil.fit(bg.getBounds(bg), //
				new Rectangle(0, 0, //
				STAGE_WIDTH / scaleFactor * n2aScaleFactor, // 
				STAGE_HEIGHT / scaleFactor * n2aScaleFactor), // 
				ScaleMode.NO_BORDER);
			bg.x = -rootX * n2aScaleFactor;
			bg.y = -rootY * n2aScaleFactor;
			bg.width = viewport.width;
			bg.height = viewport.height;

			if (!isScroll)
			{
				if (Screen.STAGE_WIDTH / Screen.STAGE_HEIGHT > 480 / 800)
				{
					bg.y = -80;
				}
			}
		}

		public static function initialize(stage:Stage, fullscreen:Boolean = true):void
		{
			if (initialized)
				return;
			initialized = true;
			Screen.fitLarge = fitLarge;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			exactWidth = stage.width;
			exactHeight = stage.height;
			//
			stage.scaleMode = StageScaleMode.NO_BORDER;
			nbWidth = stage.width;
			nbHeight = stage.height;
			//
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			saWidth = stage.width;
			saHeight = stage.height;
			//
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//
			STAGE_WIDTH = stage.width;
			STAGE_HEIGHT = stage.height;
			if (fullscreen)
			{
				STAGE_WIDTH = stage.fullScreenWidth;
				STAGE_HEIGHT = stage.fullScreenHeight;
			}
//			calculateSize();
			//
			H_QUOTA = designH;
			//
			fullscreenPort = new Rectangle(0, 0, STAGE_WIDTH, STAGE_HEIGHT); //
			
			showAllPort = RectangleUtil.fit(new Rectangle(0, 0, designW, designH), //
				new Rectangle(0, 0, STAGE_WIDTH, STAGE_HEIGHT), //
				ScaleMode.SHOW_ALL, false);

			noBorderPort = RectangleUtil.fit(new Rectangle(0, 0, designW, designH), //
				new Rectangle(0, 0, STAGE_WIDTH, STAGE_HEIGHT), //
				ScaleMode.NO_BORDER, false);

			n2aScaleFactor = noBorderPort.width / showAllPort.width;
			a2nScaleFactor = showAllPort.width / noBorderPort.width;
			//
			aspectRatio = stage.fullScreenWidth / stage.fullScreenHeight;
		}

		private static function calculateSize():void
		{
			if (STAGE_WIDTH / STAGE_HEIGHT > designW / designH)
			{
				//宽了，如iphone5，所以需要重新设置宽，高则不变
				designH = designW * STAGE_HEIGHT / STAGE_WIDTH;
			}
			else
			{
				//高了
				designW = designH * STAGE_WIDTH / STAGE_HEIGHT;
			}
		}
	}
}
