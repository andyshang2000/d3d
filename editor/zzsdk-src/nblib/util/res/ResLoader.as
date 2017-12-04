package nblib.util.res
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;

	import nblib.util.res.event.ResEvent;
	import nblib.util.res.formats.Res;
	import nblib.util.res.formats.ResState;

	[Event(name = "start", type = "nblib.util.res.event.ResEvent")]
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	/**
	 * 资源下载类，通常用 3 个事件完成整个侦听操作
	 * <ol>
	 * <li><code>complete</code>：整个包完全加载完毕后使用</li>
	 * <li><code>progress</code>：只要有进度就会触发，其中的 bytesLoaded 和 bytesTotal 是指<strong>正在下载</strong>的资源的具体进度<br/>
	 * 当 threads 属性 > 1 时，bytesLoaded 和 bytesTotal 会失去原有效果，应自行遍历 resLoadingList 获得正确的进度</li>
	 * <li><code>ioError</code>：只要有任意一个资源加载时出现错误超过 maxRetires 次就会触发，默认是 3 次</li>
	 * </ol>
	 * @author zhanghaocong
	 *
	 */
	public class ResLoader extends EventDispatcher
	{
		/**
		 * 默认线程数
		 */
		public static const DefaultThreads:int = 1;

		/**
		 * 错误后最大重试次数
		 */
		public static const DefaultMaxRetires:int = 1;

		protected static var instanceList:Object = {};

		/**
		 * 得到一个 ResLoader 的实例
		 * @param name
		 * @return
		 *
		 */
		public static function getInstance(name:String = ResLoaderNames.BlockUserOperation):ResLoader
		{
			if (!instanceList.hasOwnProperty(name))
			{
				instanceList[name] = new ResLoader(name);
			}
			return instanceList[name];
		}

		public static function register(name:String, loader:ResLoader):void
		{
			instanceList[name] = loader;
		}

		/**
		 * name
		 */
		public var name:String;

		/**
		 * 要加载的资源列表
		 */
		public var resList:Array;

		/**
		 * 已开启的线程数
		 */
		public var threadsRunning:int;

		/**
		 * 同时加载的线程数
		 */
		public var threadsMax:int;

		/**
		 * 当前 ResLoader 的状态
		 */
		public var state:int;

		/**
		 * 当前已下载完几个
		 */
		public var resLoaded:int;

		/**
		 * 每个资源最多重试次数
		 */
		public var maxRetires:int;

		/**
		 * 正在加载中的资源列表
		 */
		public var resLoadingList:Array;

		/**
		 * 总共有几个待加载
		 * @return
		 *
		 */
		public function get resTotal():int
		{
			return resList.length;
		}

		public function get resTotalReadable():String
		{
			return String(resTotal == 1 ? resTotal : resTotal - 1);
		}

		/**
		 * 空闲中的线程数
		 * @return
		 *
		 */
		public function get threadsIdle():int
		{
			return threadsMax - threadsRunning;
		}

		/**
		 * 创建一个新的 ResLoader<br/>
		 * [未实现] ResLoader 增加缓存功能<br/>
		 * 要接触缓存，请使用 ResManager
		 * @param name
		 *
		 */
		public function ResLoader(name:String)
		{
			super();
			this.name = name;
			reset();
		}

		public function addRes(res:Res):void
		{
			addListeners(res);
			resList.push(res);
		}

		private function addListeners(res:Res):void
		{
			res.addEventListener(IOErrorEvent.IO_ERROR, res_ioErrorHandler, false, int.MAX_VALUE);
			res.addEventListener(ProgressEvent.PROGRESS, res_progressHandler, false, int.MAX_VALUE);
			res.addEventListener(Event.COMPLETE, res_completeHandler, false, int.MAX_VALUE);
			res.addEventListener(ResEvent.START, res_startHandler, false, int.MAX_VALUE);
		}

		private function removeListeners(res:Res):void
		{
			res.removeEventListener(IOErrorEvent.IO_ERROR, res_ioErrorHandler);
			res.removeEventListener(ProgressEvent.PROGRESS, res_progressHandler);
			res.removeEventListener(Event.COMPLETE, res_completeHandler);
			res.removeEventListener(ResEvent.START, res_startHandler);
		}

		protected function res_progressHandler(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}

		protected function res_ioErrorHandler(event:IOErrorEvent):void
		{
			threadsRunning--;
			var res:Res = event.currentTarget as Res;

			if (res.retired > maxRetires) // 这货超过重试次数了
			{
				resLoaded++; // 就当他加载完成了，不然 complete 事件出不去
				res.state = ResState.Error;
				dispatchEvent(event);
			}
			checkAndComplete();
		}

		protected function res_completeHandler(event:Event):void
		{
			var res:Res = event.currentTarget as Res;
			removeValueFromArray(resLoadingList, res);
			removeListeners(res);
			resLoaded++;
			threadsRunning--;
			ResManager.addRes(res);
			checkAndComplete();
		}

		public static function removeValueFromArray(arr:Array, value:Object):int
		{
			var removed:int = 0;
			var len:uint = arr.length;

			for (var i:Number = len; i > -1; i--)
			{
				if (arr[i] === value)
				{
					arr.splice(i, 1);
					removed++;
				}
			}
			return removed;
		}

		protected function res_startHandler(event:Event):void
		{
			dispatchEvent(event);
		}

		protected function checkAndComplete():void
		{
			if (resLoaded == resTotal)
			{
				dispatchEvent(new Event(Event.COMPLETE));
				reset();
			}
			else
			{
				loadNext();
			}
		}

		public function start(threadsMax:int = DefaultThreads):void
		{
			this.threadsMax = threadsMax;

			//checkAndComplete();
			if (resList.length)
			{
				loadNext();
			}
			else
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		public function loadNext():void
		{
			state = ResLoaderState.Busy;

			while (threadsIdle > 0)
			{
				var res:Res = getIdleRes();

				if (res)
				{
					var samePathRes:Res = getSamePathRes(res.path);
					threadsRunning++;
					resLoadingList.push(res);

					if (threadsMax == 1)
					{
						if (!samePathRes)
						{
							res.startLoad();
						}
						else
						{
							res.complete(samePathRes.data);
						}
					}
					else
					{
						res.startLoad();
					}

					if (res.bytesTotal > 0)
					{
						dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, res.bytesLoaded, res.bytesTotal));
					}
				}
				else
				{
					break;
				}
			}
		}

		/**
		 * 在已加载列表中寻找指定路径的 res，如果 path 为 null 或 ""，返回 null
		 * @param res
		 * @return
		 *
		 */
		public function getSamePathRes(path:String):Res
		{
			if (path == null || path.length == 0)
			{
				return null;
			}
			else
			{
				for each (var res:Res in resList)
				{
					if (res.cacheable)
					{
						if (res.path == path)
						{
							if (res.state == ResState.LoadComplete)
							{
								return res;
							}
						}
					}
				}
			}
			return null;
		}

		/**
		 * 获得一个空闲的 Res
		 * @return
		 *
		 */
		public function getIdleRes():Res
		{
			var result:Res;

			for each (var res:Res in resList)
			{
				if (res.state == ResState.Idle)
				{
					result = res;
					break;
				}
			}
			return result;
		}

		public function reset():void
		{
			maxRetires = DefaultMaxRetires;
			threadsRunning = 0;
			threadsMax = 0;
			resLoaded = 0;

			if (resList)
			{
				for each (var res:Res in resList)
				{
					removeListeners(res);
				}
				resList.length = 0;
				resList = null;
			}

			if (!resList)
			{
				resList = [];
			}

			if (resLoadingList)
			{
				resLoadingList.length = 0;
				resLoadingList = null
			}

			if (!resLoadingList)
			{
				resLoadingList = [];
			}
			state = ResLoaderState.Idle;
		}
	}
}
