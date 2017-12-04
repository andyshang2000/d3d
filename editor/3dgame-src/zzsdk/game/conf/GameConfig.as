package zzsdk.game.conf
{
	import com.codecatalyst.promise.Deferred;
	import com.codecatalyst.promise.Promise;
	
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	
	import mx.utils.StringUtil;
	
	import nblib.util.res.ResManager;
	import nblib.util.res.formats.Res;

	public class GameConfig extends Res
	{
		public var errorCode:int = 0;

		public function GameConfig(path:String)
		{
			super(path);
			dataFormat = URLLoaderDataFormat.TEXT;
		}

		protected override function completeHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			event.stopImmediatePropagation();
			event.preventDefault();

			buildPromise(fromString(data));
		}

		private function fromString(data:String):Array
		{
			var lines:Array = StringUtil.trimArrayElements(data, "\r").split("\r");
			var result:Array = [];
			for (var i:int = 0; i < lines.length; i++)
			{
				if (StringUtil.trim(lines[i]).length == 0 || lines[i].indexOf("#") == 0)
				{
					continue;
				}
				result = result.concat(StringUtil.trimArrayElements(lines[i], ",").split(","))
			}
			return result;
		}

		private function buildPromise(result:Array):void
		{
			var promise:Promise = Promise.when(true); //
			for (var i:int = 0; i < result.length; i++)
			{
				promise = promise.then(loadEntry(result[i]));
			}
			promise.then(function():void
			{
				errorCode = 0;
				dispatchEvent(new Event(Event.COMPLETE));
			})
		}

		private function loadEntry(path:String):Function
		{
			return function():Promise
			{
				var def:Deferred = new Deferred;
				ResManager.getResAsync(path, function(res:Res):void
				{
					def.resolve(null);
				});
				return def.promise;
			}
		}
	}
}
