package diary.ui.view.dressing
{
	import flash.media.Sound;

	import lzm.starling.STLConstant;

	import nblib.util.callLater;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	public class AbstractAssets
	{
		public var assetManager:AssetManager;
		protected var loadedHandler:Function;
		private var xmls:Object = {};

		public var initialized:Boolean;

		public function AbstractAssets()
		{
			assetManager = new AssetManager(STLConstant.scale, STLConstant.useMipMaps);
			enqueue();
			callLater(assetManager.loadQueue, function(ratio:Number):void
			{
				if (ratio == 1)
				{
					initialized = true;
					loadedHandler();
				}
			});
		}

		protected function enqueue():void
		{
		}

		public function onLoaded(func:Function):void
		{
			loadedHandler = func;
			if (initialized)
				func();
		}

		public function getTexture(n:String):Texture
		{
			return assetManager.getTexture(n);
		}

		public function getSound(n:String):Sound
		{
			return assetManager.getSound(n);
		}

		protected function addXML(param0:XML, param1:String):void
		{
			// TODO Auto Generated method stub
			xmls[param1] = param0
		}

		public function getXml(n:String):XML
		{
			return xmls[n];
		}

		public function getTextures(n:String):Vector.<Texture>
		{
			return assetManager.getTextures(n);
		}

		public function getTextureAtlas(n:String):TextureAtlas
		{
			return assetManager.getTextureAtlas(n);
		}
	}
}
