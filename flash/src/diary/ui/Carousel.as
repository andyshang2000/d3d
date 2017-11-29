package diary.ui
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Ease;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	import zzsdk.utils.FileUtil;

	public class Carousel extends Sprite
	{
		private var isAnim:Boolean = false;
		private var index:int = 0;

		private var imageList:Array;
		private var holders:Vector.<Image> = new Vector.<Image>;

		private var loader:Loader;
		private var cache:Object = {};
		private var duration:Number = 0.3;

		public function Carousel()
		{
			var t:Texture = Texture.empty(480, 800);
			for (var i:int = 0; i < 3; i++)
			{
				holders[i] = new Image(t);
				holders[i].x = 480 * (i - 1)
//				holders[i].y = 50 * i
				addChild(holders[i]);
			}
			trace(holders);
		}

		override public function get width():Number
		{
			return 480;
		}

		override public function get height():Number
		{
			return 800;
		}

		override public function set height(value:Number):void
		{
			scaleY = value / 800;
		}

		override public function set width(value:Number):void
		{
			scaleX = value / 480;
		}

		public function setImages(arr:Array):void
		{
			imageList = arr;
			index = 0;
			update();
		}

		public function next():void
		{
			if (isAnim)
				return;
			isAnim = true;
			var ease:Ease = Cubic.easeInOut;
			TweenLite.to(holders[1], duration, {x: holders[0].x, ease: ease});
			TweenLite.to(holders[2], duration, {x: holders[1].x, ease: ease, onComplete: function():void
			{
				var holder0:* = holders[0];
				holders[0] = holders[1];
				holders[1] = holders[2];
				holders[2] = holder0;
				index++;
				if (index > imageList.length - 1)
				{
					index = 0;
				}
//				update();
				isAnim = false;
			}});
			holders[0].x = holders[2].x;
		}

		public function prev():void
		{
			if (isAnim)
				return;
			isAnim = true;
			var ease:Ease = Cubic.easeInOut;
			TweenLite.to(holders[1], duration, {x: holders[2].x, ease: ease});
			TweenLite.to(holders[0], duration, {x: holders[1].x, ease: ease, onComplete: function():void
			{
				var holder2:* = holders[2];
				holders[2] = holders[1];
				holders[1] = holders[0];
				holders[0] = holder2;
				index--;
				if (index < 0)
				{
					index = imageList.length - 1;
				}
//				update();
				isAnim = false;
			}});
			holders[2].x = holders[0].x;
		}

		public function update():void
		{
			setTexture(holders[0], imageList[correct(index - 1)]);
			setTexture(holders[1], imageList[index]);
			setTexture(holders[2], imageList[correct(index + 1)]);
		}

		private function setTexture(image:Image, obj:*):void
		{
			if (obj is String)
			{
				if (cache[obj] == null)
				{
					cache[obj] = {loader: null, texture: null}
				}
				var texture:Texture = cache[obj].texture;
				var loader:Loader = cache[obj].loader;
				if (texture != null)
				{
					image.texture = texture;
					return;
				}
				if (loader == null)
				{
					loader = new Loader;
					cache[obj] = {loader: loader};
				}
				if (!loader.content)
				{
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
					{
						useLoaderContent(image, obj, loader);
					});
					loader.loadBytes(FileUtil.readFile(obj));
				}
				else
				{
					useLoaderContent(image, obj, loader);
				}
			}
		}

		private function useLoaderContent(image:Image, obj:*, loader:Loader):void
		{
			var bmd:BitmapData = Bitmap(loader.content).bitmapData;
			var texture:Texture = Texture.fromBitmapData(bmd, false);
			bmd.dispose();
			image.texture = texture;
			cache[obj].loader = loader;
			cache[obj].texture = texture;
			texture.root.onRestore = function():void
			{
				cache[obj].texture = null;
				setTexture(image, obj);
			};
		}

		private function correct(i:int):Object
		{
			if (i < 0)
			{
				return imageList.length - 1;
			}
			if (i >= imageList.length)
			{
				return 0;
			}
			return i;
		}
	}
}
