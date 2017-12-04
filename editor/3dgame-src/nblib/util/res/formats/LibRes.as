package nblib.util.res.formats
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class LibRes extends Res
	{
		public var content:*;

		public var linkageClass:Class;

		protected var loader:Loader;

		public function LibRes(url:String)
		{
			super(url);
		}

		protected override function completeHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			event.stopImmediatePropagation();
			event.preventDefault();
			addLoader();
		}

		private function addLoader():void
		{
			removeLoader();
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
			var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			lc.allowCodeImport = true;
			loader.loadBytes(data, lc);
		}

		protected function loader_completeHandler(event:Event):void
		{
			state = ResState.LoadComplete;
			content = loader.content;
			linkageClass = loader.content["constructor"];
			removeLoader();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function removeLoader():void
		{
			if (loader)
			{
				loader.unload();
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_completeHandler);
				loader = null;
			}
		}
	}
}
