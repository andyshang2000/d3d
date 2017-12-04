package nblib.util.res.formats
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	import nblib.util.callLater;
	import nblib.util.res.ResManager;
	import nblib.util.res.event.ResEvent;

	[Event(name = "start", type = "nblib.util.res.event.ResEvent")]
	[Event(name = "dispose", type = "nblib.util.res.event.ResEvent")]
	public class Res extends URLLoader
	{
		/**
		 * 资源的状态
		 * @see ResState
		 */
		public var state:int;

		/**
		 * 相对于 ResMetadataManager.rootPath 的路径
		 */
		public var path:String;

		/**
		 * 资源的完整 URL
		 */
		public var url:String;

		/**
		 * 标记资源是否缓存，如果为 false，每次都会读取新的
		 */
		public var cacheable:Boolean;

		/**
		 * 已重试次数
		 */
		public var retired:int;

		/**
		 * 当前资源被访问的次数
		 */
		public var numVisited:int;

		/**
		 * 当前资源最后访问的时间
		 */
		public var lastVisited:Number;

		public function Res(path:String)
		{
			this.path = path;
			url = ResManager.getAbsoluteURL(path);
			state = ResState.Idle;
			dataFormat = URLLoaderDataFormat.BINARY;
			retired = -1;
			addEventListener(Event.COMPLETE, completeHandler, false, int.MAX_VALUE);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, int.MAX_VALUE);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, int.MAX_VALUE);
			cacheable = true;
			markAsVisited();
		}

		/**
		 * 标记资源已被访问，此时会设置 numVisited++ 和 lastVisited = getTimer()
		 *
		 */
		public function markAsVisited():void
		{
			numVisited++;
			lastVisited = getTimer();

			if (data is ByteArray)
			{
				(data as ByteArray).position = 0;
			}
		}

		protected function securityErrorHandler(event:SecurityErrorEvent):void
		{
			state = ResState.Idle;
		}

		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			state = ResState.Idle;
		}

		protected function completeHandler(event:Event):void
		{
			state = ResState.LoadComplete;
		}

		/**
		 * 开始加载
		 *
		 */
		public function startLoad():void
		{
			load(urlRequest);
			retired++;
			state = ResState.LoadInProgress;
			dispatchEvent(new ResEvent(ResEvent.START));
		}

		public function get extension():String
		{
			return path.substring(path.lastIndexOf("."));
		}

		public function get urlRequest():URLRequest
		{
			return new URLRequest(url)
		}

		/**
		 * 手动调用完成当前资源加载
		 * @param data 完成时的数据
		 *
		 */
		public function complete(data:*):void
		{
			this.data = data;
			callLater(dispatchEvent, new Event(Event.COMPLETE));
		}

		/**
		 * 释放资源
		 *
		 */
		public function dispose():Boolean
		{
//			trace(this + "|" + this.path + " disposed!.....................");
			try
			{
				close();
			}
			catch (error:Error)
			{
//				trace("RES ERROR~~~~~~!");
			}
			dispatchEvent(new ResEvent(ResEvent.DISPOSE));
			return true;
		}
	}
}
