//Created by Action Script Viewer - http://www.buraks.com/asv
package zzsdk.misc
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	import zzsdk.utils.SystemUtil;

	public class SimpleAnalysis
	{
		public static var SO:SharedObject;
		public static var APP_ID:String;
		private static var _instance:SimpleAnalysis;

		private var _analysisRequest:URLRequest;
		private var _analysisVariables:URLVariables;
		private var _urlLoader:URLLoader;
		private var _analysisSoName:String;

		public function SimpleAnalysis()
		{
			SystemUtil.language == "zh-cn" ? // 
				(_analysisRequest = new URLRequest("http://app.936.com/ad/analysis.php")) //
				: //
				(_analysisRequest = new URLRequest("http://app.qiqiads.com/ad/analysis.php"));
			_analysisVariables = new URLVariables();
			_urlLoader = new URLLoader();
			_analysisRequest.method = URLRequestMethod.POST;
		}

		public static function getInstance():SimpleAnalysis
		{
			if (_instance != null)
			{
				return (_instance);
			}
			_instance = new (SimpleAnalysis);
			return (_instance);
		}

		public function setAnalytics(_arg1:String, _arg2:String):void
		{
			APP_ID = _arg1;
			this._analysisVariables.appID = APP_ID;
			this._analysisSoName = (SystemUtil.language == "zh-cn" ? "com.936." : "com.mafa") + (_arg2 + APP_ID);
			SO = SharedObject.getLocal(this._analysisSoName);
			if (SO.data.newUser == null)
			{
				SO.data.cachePlayTimes = 1;
				SO.data.newUser = true;
				SO.data.playTimes = 1;
			}
			else
			{
				SO.data.cachePlayTimes = (SO.data.cachePlayTimes + 1);
				SO.data.newUser = false;
				SO.data.playTimes = (SO.data.playTimes + 1);
			}
			SO.flush();
			this._analysisVariables.newUser = SO.data.newUser;
			this._analysisVariables.cachePlayTimes = SO.data.cachePlayTimes;
			this._analysisRequest.data = this._analysisVariables;
			this._urlLoader.load(this._analysisRequest);
			this._urlLoader.addEventListener(Event.COMPLETE, this.urlLoaded);
			this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.urlLoadError);
		}

		private function urlLoadError(_arg1:IOErrorEvent):void
		{
			trace(("统计发送失败：" + _arg1.text));
		}

		private function urlLoaded(_arg1:Event):void
		{
			trace(("统计发送成功：" + this._urlLoader.data));
			if (this._urlLoader.data > 0)
			{
				SO.data.newUser = false;
				SO.data.cachePlayTimes = 0;
				SO.flush();
			}
		}

		public function get newUser():Boolean
		{
			return (SO.data.newUser);
		}

		public function get playTimes():int
		{
			return (SO.data.playTimes);
		}
	}
}
