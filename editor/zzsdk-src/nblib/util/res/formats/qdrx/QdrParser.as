package nblib.util.res.formats.qdrx
{
	import flash.utils.ByteArray;

	import deng.fzip.FZip;
	import deng.fzip.FZipFile;

	import nblib.util.res.ResManager;
	import nblib.util.res.formats.TextureRes;

	public class QdrParser
	{
		private static var callback:Function;
		private static var queued:int = 0;

		public static function parse(zip:FZip, callback:Function):void
		{
			QdrParser.callback = callback;

			var count:int = zip.getFileCount();
			for (var i:int = 0; i < count; i++)
			{
				var file:FZipFile = zip.getFileAt(i);
				parseFile(file.filename, file.content);
			}
			zip.close();
			zip = null;
		}

		private static function parseFile(filename:String, content:ByteArray):void
		{
			if (filename == "_g")
			{
				ResManager.addRes(new _g(content));
			}
			else if (filename.substr(-7) == "alt.xml")
			{
				addAltasXML(XML(String(content)));
			}
			else if (filename.substr(-7) == "txt.png")
			{
				queueTexture(filename, content)
			}
			else
			{
				ResManager.addFile(filename, content);
			}
		}

		private static function queueTexture(filename:String, content:ByteArray):void
		{
			var ar:AltasRes = new AltasRes(filename, content)
			ResManager.addRes(ar);

			queued++;
			ar.addEventListener("done", function():void
			{
				queued--;
				if (queued == 0)
				{
					callback();
				}
			})
		}

		private static function addAltasXML(content:XML):void
		{
			var imagePath:String = (content.@imagePath);
			for each (var subText:XML in content.SubTexture)
			{
				ResManager.addRes(new TextureRes(imagePath, subText));
			}
		}
	}
}
import flash.events.Event;
import flash.utils.ByteArray;

import nblib.util.res.ResManager;
import nblib.util.res.formats.ImageRes;
import nblib.util.res.formats.Res;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

class AltasRes extends ImageRes
{
	public var texture:TextureAtlas;

	public function AltasRes(filename:String, data:ByteArray)
	{
		super(filename);
		ResManager.addFile(filename, this.data = data);
		ResManager.addRes(this);
		dispatchEvent(new Event(Event.COMPLETE));
	}

	override protected function loader_completeHandler(event:Event):void
	{
		super.loader_completeHandler(event);
		texture = new TextureAtlas(Texture.fromBitmapData(bitmapData, false, true));
		dispatchEvent(new Event("done"));
//		bitmapData.dispose();
	}
	
	override public function dispose():Boolean
	{
		texture.dispose();
		return super.dispose();
	}
}

class _g extends Res
{
	public function _g(data:ByteArray)
	{
		super("_g");
		this.data = data
	}
}
