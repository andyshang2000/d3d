package diary.res
{
	import flash.filesystem.File;
	import flash.sampler.DeleteObjectSample;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import zzsdk.utils.FileUtil;

	public class ResManager
	{
		public static var fileList:Object = {};
		public static var resList:Object = {};
		public static var rootPath:String = "";
		public static var version:Boolean;
		private static var directory:Object = {};
		private static var _loadToCurrentDomain:LoaderContext;
		private static var factoryDic:Object = {};
		private static var progressClients:Object = {};
		private static var markList:Array = [];
		private static var _mark:uint;

		public static function mapResource(extension:String, clazz:Class):void
		{
			extension = extension.toLowerCase();
			factoryDic[extension] = clazz;
		}

		public static function getResourceType(path:String):Class
		{
			var extension:String = path.substr(path.lastIndexOf(".") + 1);
			extension = extension.toLowerCase();
			return factoryDic[extension]
		}

		public static function get loadToCurrentDomain():LoaderContext
		{
			if (!_loadToCurrentDomain)
			{
				_loadToCurrentDomain = new LoaderContext(false, ApplicationDomain.currentDomain);
				_loadToCurrentDomain.allowCodeImport = true;
			}
			return _loadToCurrentDomain;
		}

		public static function addRes(res:*):void
		{
			resList[res.url] = res;
			
			var mIndex:int = markList.indexOf(res.url)
			if(mIndex != -1)
			{
				markList.removeAt(mIndex);
			}
			markList.push(res.url);
		}

		public static function mark():void
		{
			_mark = markList.length;
		}

		public static function removeToLastMark():void
		{
			while (markList.length > _mark)
			{
				removeRes(markList.pop());
			}
		}

		/**
		 * 从 resList 中删除缓存了的资源
		 * @param res
		 *
		 */
		public static function removeRes(res:*):void
		{
			if (resList[res.url])
			{
				delete resList[res.url];
				res.dispose();
			}
		}

		/**
		 * 同步获得资源
		 * @param path
		 * @return
		 *
		 */
		public static function getResAsync(file:*, type:Class, onLoad:Function):*
		{
			if(!(file is File))
			{
				getResAsync(FileUtil.dir.resolvePath(file), type, onLoad);
				return;
			}
			var result:* = resList[file.url];
			if(result != null)
			{
				onLoad(result);
			}
			else
			{
				result = new type(file.url);
				addRes(result);
				result.handle(FileUtil.readFile(file), onLoad);
			}
		}
	}
}
