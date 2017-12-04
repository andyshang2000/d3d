package diary.res
{
	import flash.media.Sound;
	import flash.utils.ByteArray;

	import lzm.starling.swf.Swf;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	public class RES
	{
		private static var _provider:AssetManager;
		private static var swfDic:Object = {};

		public static function set provider(provider:*):void
		{
			_provider = provider;
		}

		public static function enqueue(... args):void
		{
			_provider.enqueue.apply(null, args);
		}

		public static function loadQueue(onProgress):void
		{
			_provider.loadQueue(onProgress);
		}

		public static function dispose():void
		{
			_provider.dispose();
		}

		public static function get(name:String):*
		{
			var res:* = getTexture(name);
			if (!res)
				res = getTextureAtlas(name);
			if (!res)
				res = getXml(name);
			if (!res)
				res = getByteArray(name);
			if (!res)
				res = getSound(name);
			if (!res)
				res = getObject(name);
			if (!res)
				res = createDisplayObject(name);
			if (!res)
				res = getTextures(name);
			return res;
		}

		public static function createSWF(name:String, fps:Number = 24):Swf
		{
			var swf:Swf = new Swf(getByteArray(name), _provider, fps);
			return swfDic[name] = swf;
		}

		public static function createDisplayObject(name:String):*
		{
			var arr:Array = name.split("/");
			if (arr.length != 2)
				return null;
			var swf:Swf = swfDic[arr[0]];
			if (!swf)
				return null;
			return swf.createDisplayObject(arr[1]);
		}

		public static function getTextures(name):Vector.<Texture>
		{
			var res:Vector.<Texture> = _provider.getTextures(name);
			if (res.length == 0)
				return null;
			return res
		}

		public static function getByteArray(name):ByteArray
		{
			return _provider.getByteArray(name)
		}

		public static function getObject(name):Object
		{
			return _provider.getObject(name)
		}

		public static function getSound(name):Sound
		{
			return _provider.getSound(name)
		}

		public static function getTexture(name):Texture
		{
			return _provider.getTexture(name)
		}

		public static function getTextureAtlas(name):TextureAtlas
		{
			return _provider.getTextureAtlas(name)
		}

		public static function getXml(name):XML
		{
			return _provider.getXml(name)
		}
	}
}
