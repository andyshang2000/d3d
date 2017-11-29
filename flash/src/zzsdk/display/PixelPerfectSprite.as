package zzsdk.display
{
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import nblib.util.res.formats.TextureRes;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class PixelPerfectSprite extends Sprite
	{
		private var bitmapData:BitmapData;
		private var scaleFactor:Number;
		
		public function PixelPerfectSprite(res:TextureRes, scaleFactor:Number=1.0)
		{
			touchable=true;
			
			scaleX=1 / scaleFactor;
			scaleY=1 / scaleFactor;
			addChild(new Image(res.texture));
			this.bitmapData=res.bitmapData;
			this.scaleFactor=scaleFactor;
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			var superRes:DisplayObject=super.hitTest(localPoint, forTouch);
			if (superRes)
			{
				var pixel:uint=bitmapData.getPixel32(localPoint.x, localPoint.y)
				if (bitmapData && pixel > 0)
				{
//					trace("hit!!!")
					return superRes;
				}
				else
				{
//					trace("fail to test")
				}
			}
			return null;
		}
		
		public function hitTest2():void
		{
		}
	}

}