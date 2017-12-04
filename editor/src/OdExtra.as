package
{
	import flash.debugger.enterDebugger;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.PNGEncoderOptions;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.text.StaticText;
	import flash.utils.ByteArray;

	public class OdExtra extends Sprite
	{

		private var swfList:Array;

		public function OdExtra()
		{
			stage.frameRate = 120;
			var file:File = new File("C:\\odswfs\\odyssey");
			file.getDirectoryListingAsync();
			file.addEventListener(FileListEvent.DIRECTORY_LISTING, function(event:FileListEvent):void
			{
				swfList = event.files.filter(function(f:File, ... args):Boolean
				{
					if (f.parent.resolvePath("output/" + f.name + ".png").exists ||
						f.parent.resolvePath("output/hero/" + f.name + ".png").exists||
						f.parent.resolvePath("output/monster/" + f.name + ".png").exists)
					{
						f.deleteFileAsync();
						return false;
					}
					if (f.extension == "swf")
						return true;
					return false;
				});
				next();
			});
		}

		private function next():void
		{
			if (swfList.length == 0)
				return;
			var file:File = swfList.pop();
			var loader:Loader = new Loader();
			loader.load(new URLRequest(file.url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
			{
				var mc:MovieClip = loader.content as MovieClip
				if (!mc)
				{
					loader.unloadAndStop(true);
					next();
					return;
				}
				if (file.name == "symbol_62087.swf")
					enterDebugger()
				if (mc.numChildren == 1)
				{
					var child:* = mc.getChildAt(0);
					if (child is StaticText)
					{
						loader.unloadAndStop(true);
						next();
						return;
					}
					else if (child is Shape)
					{
						if (child.height == 100)
						{
							var bitmap:BitmapData = new BitmapData(child.width, 100, true, 0)
							bitmap.draw(child);
							var b:ByteArray = bitmap.encode(bitmap.rect, new PNGEncoderOptions(true));
							var fs:FileStream = new FileStream;
							fs.open(new File(file.parent.resolvePath("output/" + file.name + ".png").nativePath), FileMode.WRITE);
							fs.writeBytes(b);
							fs.close();
							loader.unloadAndStop(true);
							next();
							return;
						}
						else if (child.height == 125)
						{
							var bitmap:BitmapData = new BitmapData(child.width, 125, true, 0)
							bitmap.draw(child);
							var b:ByteArray = bitmap.encode(bitmap.rect, new PNGEncoderOptions(true));
							var fs:FileStream = new FileStream;
							fs.open(new File(file.parent.resolvePath("output/hero/" + file.name + ".png").nativePath), FileMode.WRITE);
							fs.writeBytes(b);
							fs.close();
							loader.unloadAndStop(true);
							next();
							return;
						}
						else if (child.height == 200)
						{
							var bitmap:BitmapData = new BitmapData(child.width, 200, true, 0)
							bitmap.draw(child);
							var b:ByteArray = bitmap.encode(bitmap.rect, new PNGEncoderOptions(true));
							var fs:FileStream = new FileStream;
							fs.open(new File(file.parent.resolvePath("output/monster/" + file.name + ".png").nativePath), FileMode.WRITE);
							fs.writeBytes(b);
							fs.close();
							loader.unloadAndStop(true);
							next();
							return;
						}
						else if (child.height == 40)
						{
							var bitmap:BitmapData = new BitmapData(child.width, 40, true, 0)
							bitmap.draw(child);
							var b:ByteArray = bitmap.encode(bitmap.rect, new PNGEncoderOptions(true));
							var fs:FileStream = new FileStream;
							fs.open(new File(file.parent.resolvePath("output/effect/" + file.name + ".png").nativePath), FileMode.WRITE);
							fs.writeBytes(b);
							fs.close();
							loader.unloadAndStop(true);
							next();
							return;
						}
						else if (child.height <130 && child.height > 115 && child.width < 110 && child.width > 85)
						{
							var bitmap:BitmapData = new BitmapData(child.width, child.height, true, 0)
							bitmap.draw(child);
							var b:ByteArray = bitmap.encode(bitmap.rect, new PNGEncoderOptions(true));
							var fs:FileStream = new FileStream;
							fs.open(new File(file.parent.resolvePath("output/profile/" + file.name + ".png").nativePath), FileMode.WRITE);
							fs.writeBytes(b);
							fs.close();
							loader.unloadAndStop(true);
							next();
							return;
						}
						else
						{
							loader.unloadAndStop(true);
							next();
							return;
						}
					}
				}
				mc.numChildren
			});
		}
	}
}
