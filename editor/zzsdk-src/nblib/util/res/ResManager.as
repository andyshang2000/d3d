package nblib.util.res
{
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import nblib.util.callLater;
	import nblib.util.res.formats.Res;

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

		public static function addProgressClient(client:IProgressClient, targetLoaderName:String = "double"):void
		{
			progressClients[targetLoaderName] = client;
		}

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

		public static function addRes(res:Res):void
		{
			resList[res.path] = res;
			markList.push(res.path);
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
		public static function removeRes(path:String):void
		{
			if (resList[path])
			{
				var result:Boolean = resList[path].dispose();

				if (result)
				{
					delete resList[path];
				}
			}
		}

		/**
		 * 同步获得资源
		 * @param path
		 * @return
		 *
		 */
		public static function getRes(path:String):Res
		{
			var result:Res = resList[path];
			if (!result)
			{
				if (!fileList[path])
				{
					path = getAbsoluteURL(path);
				}
				result = resList[path];
			}
			if (result)
			{
				result.markAsVisited();
			}
			return result
		}

		public static function list(filename:*):Array
		{
			return Directory(fileList[filename]).getChildren();
		}

		public static function isDirectory(filename:*):Boolean
		{
			return fileList[filename] && (fileList[filename] is Directory);
		}

		public static function addFile(filename:String, content:ByteArray):void
		{
			if (!fileList["/"])
			{
				fileList["/"] = new Directory;
			}
			trace("addfile:" + filename)
			fileList[filename] = content;
			if (content.length == 0)
			{
				fileList[filename] = new Directory;
			}
			findParent(filename).add(filename);
		}

		private static function findParent(filename:String):Directory
		{
			var last:int = filename.lastIndexOf("/", filename.length - 1);
			if (last == -1)
			{
				return fileList["/"];
			}
			var parent:String = filename.substring(0, last + 1);
			if (parent == filename)
			{
				var p:String = "/";
				var c:String = "";
				var i:int = filename.indexOf("/", 0);
				while (i != -1)
				{
					c = filename.substring(0, i + 1);
					if (!fileList[p])
					{
						fileList[p] = new Directory;
					}
					Directory(fileList[p]).add(c);
					if ((i = filename.indexOf("/", i + 1)) != -1)
					{
						p = c;
					}
				}

				return fileList[p];
			}
			return fileList[parent];
		}

		private static function hasFile(path:String):Boolean
		{
			// TODO Auto Generated method stub
			return fileList[path] != null;
		}

		private static function getFile(path:String):Object
		{
			// TODO Auto Generated method stub
			return fileList[path];
		}

		/**
		 * 异步下载资源，如资源不存在将会自动加载，否则直接取内存中的数据，完成后会调用 onComplete
		 * @param path
		 * @param onComplete 加载完成后会自动调用 onComplete(Res);
		 * @param loaderName 指定要使用的 ResLoader 名，默认使用 ResLoader.Background
		 * @return 没有或已下载完毕的 Res
		 *
		 */
		public static function getResAsync(path:String, //
			onComplete:Function, //
			loaderName:String = "double", // 
			resFactory:Class = null, //
			numThreads:int = 2):void
		{
			var result:Res = resList[path];
			if (!result)
			{
				if (!fileList[path])
				{
					path = getAbsoluteURL(path);
				}
				result = resList[path];
			}
			if (result)
			{
				result.markAsVisited();
				onComplete(result);
			}
			else
			{
				var resLoader:ResLoader = ResLoader.getInstance(loaderName);
				if (progressClients[loaderName])
					IProgressClient(progressClients[loaderName]).listen(resLoader);

				if (resFactory)
				{
					try
					{
						result = new resFactory(path);
						result.addEventListener(Event.COMPLETE, function(e:Event):void
						{
							e.currentTarget.removeEventListener(e.type, arguments.callee);
							onComplete(e.currentTarget);
						})
					}
					catch (err:Error)
					{
					}
				}

				if (!result)
				{
					result = getResInstance(path);
					result.addEventListener(Event.COMPLETE, function(e:Event):void
					{
						e.currentTarget.removeEventListener(e.type, arguments.callee);
						onComplete(e.currentTarget);
					})
				}
				if (hasFile(path))
				{
					callLater(function():void
					{
						result.data = getFile(path);
						result.data.position = 0;
						addRes(result);
						result.dispatchEvent(new Event(Event.COMPLETE));
					});
				}
				else
				{
					trace("url request: " + result.path);
					resLoader.addRes(result);
					resLoader.start(numThreads);
				}
			}
		}

		private static function getResInstance(path:String):Res
		{
			var extension:String = getExtension(path);
			var factory:Class;

			if (factoryDic[extension] == null)
			{
				factory = Res;
			}
			else
			{
				factory = factoryDic[getExtension(path)];
			}
			return new factory(path);
		}

		private static function getExtension(path:String):String
		{
			var lastDotIndex:int = path.lastIndexOf(".");

			if (lastDotIndex == -1)
			{
				return "";
			}
			return path.substring(lastDotIndex + 1);
		}

		public static function getAbsoluteURL(path:String):String
		{
			var protocol:RegExp = /^(-|\w)+:\/{1,3}[^\/]/i;
			if (protocol.test(path))
			{
				return path;
			}
			return rootPath + path;
		}
	}
}
import nblib.util.res.ResManager;
import nblib.util.res.formats.ImageRes;
import nblib.util.res.formats.LibRes;

ResManager.mapResource("swf", LibRes);
ResManager.mapResource("swc", LibRes);
ResManager.mapResource("png", ImageRes);
ResManager.mapResource("jpg", ImageRes);
ResManager.mapResource("gif", ImageRes);

class Directory
{
	private var children:Array = [];

	public function getChildren():Array
	{
		return children;
	}

	public function add(name:String):void
	{
		if (children.indexOf(name) == -1)
		{
			children.push(name);
		}
	}
}
