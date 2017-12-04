package sui.utils
{
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	import lzm.starling.STLConstant;
	import lzm.starling.swf.Swf;

	import nblib.util.res.ResManager;
	import nblib.util.res.formats.Res;

	import starling.display.DisplayObject;
	import starling.utils.AssetManager;

	public class stlSWFUtil
	{
		public static var defaultFPS:int = 30;
		public static var assetManagerDic:Dictionary = new Dictionary();

		private static var currentPath:String;

		private static var assets:AssetManager;

		private static var swf:Swf;

		public static var guiName:String = "gui";
		public static var resPath:String = "res/gui/";

		public static function load(path:String, callback:Function):void
		{
			if (assets)
			{
				assets.dispose();
			}
			ResManager.getResAsync(path, function(res:Res):void
			{
				currentPath = path;
				assets = new BundledAssetMgr(STLConstant.scale, STLConstant.useMipMaps);
				assets.enqueue(resPath);
				assets.loadQueue(function(ratio:Number):void
				{
					if (ratio == 1)
					{
						stlSWFUtil.setAssetManager(path, assets);
						callback();
					}
				});
			})
		}

		public static function clear():void
		{
			for (var key:* in assetManagerDic)
			{
				var assetManager:AssetManager = assetManagerDic[key];
				assetManager.dispose();
				delete assetManagerDic[key];
			}
			assets = null;
		}

		public static function setAssetManager(url:String, assetManager:AssetManager):void
		{
			assetManagerDic[url] = assetManager;
			swf = new Swf(assetManager.getByteArray(guiName), assetManager, 30);
		}

		public static function getAssetManager(url:String):AssetManager
		{
			return assetManagerDic[url];
		}

		public static function createSWF(path:String, fps:int = 0):DisplayObject
		{
			fps ||= defaultFPS;
			//
			var arr:Array = path.split("/");
			var name:String = arr.pop();
			return swf.createDisplayObject(name);
		}

		public static function getAssetAsync(param0:*, param1:String):AssetManager
		{
			var assets:AssetManager;
			if (param0 is File)
			{
				assets = new AssetManager(STLConstant.scale, STLConstant.useMipMaps);
			}
			else if (param0 is String)
			{
				assets = new BundledAssetMgr(STLConstant.scale, STLConstant.useMipMaps);
			}
			assets.verbose = true;
			assets.enqueue(param0);
			return assets;
		}

		public static function loadQueue(param0:String, param1:String, param2:Function):void
		{
			getAssetAsync(param0, param1).loadQueue(param2) //
		}

		public static function loadQueueFromFile(param0:File, param1:String, param2:Function):void
		{
			var asset:AssetManager = getAssetAsync(param0, param1)
			asset.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1)
				{
					setAssetManager(param1, asset);
				}
				param2(ratio);
			}) //
		}
	}
}
