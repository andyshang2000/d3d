package sui.utils
{

	import flash.display.Bitmap;

	import nblib.util.res.ResManager;
	import nblib.util.res.formats.ImageRes;
	import nblib.util.res.formats.LibRes;
	import nblib.util.res.formats.Res;

	import starling.utils.AssetManager;

	public class BundledAssetMgr extends AssetManager
	{
		public function BundledAssetMgr(scaleFactor:Number = 1, useMipmaps:Boolean = false)
		{
			super(scaleFactor, useMipmaps);
			verbose = false
		}

		override public function enqueue(... rawAssets):void
		{
			for each (var rawAsset:Object in rawAssets)
			{
				if (rawAsset is Array)
				{
					enqueue.apply(this, rawAsset);
				}
				else if (rawAsset is Class)
				{
					super.enqueue(rawAsset);
				}
				else if (rawAsset is String)
				{
					if (ResManager.isDirectory(rawAsset))
					{
						enqueue.apply(this, ResManager.list(rawAsset));
					}
					else
					{
						enqueueWithName(rawAsset);
					}
				}
			}
		}

		public function loadRawAsset(rawAsset:Object, onProgress:Function, onComplete:Function):void
		{
			trace("loadRawAsset:" + rawAsset);
			if (rawAsset is String)
			{
				ResManager.getResAsync(rawAsset + "", function(res:Res):void
				{
					if (res is ImageRes)
					{
						onComplete(new Bitmap(ImageRes(res).bitmapData.clone()));
					}
					else if (res is LibRes)
					{
						onComplete(LibRes(res).content);
					}
					else
					{
						onComplete(res.data);
					}
				})
			}
			else
			{
				super.loadRawAsset(rawAsset, onProgress, onComplete);
			}
		}

		override public function dispose():void
		{
			super.dispose();
		}
	}
}
