package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.setTimeout;

	[SWF(width = "480", height = "800")]
	public class Gamehandler extends Sprite
	{
		private var cross:Cross

		[Embed(source = "content.swf", mimeType = "application/octet-stream")]
		private var content_swf:Class;

		public function Gamehandler()
		{
			var loader:Loader = new Loader;
			var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			lc.allowCodeImport = true;
			loader.loadBytes(new content_swf, lc);
			addChild(loader);

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
			{
				addChild(loader.content);

				setTimeout(function():void
				{
					addChild(cross = new Cross);
					cross.scaleX = 0.5
					cross.scaleY = 0.5
					cross.y = 256
				}, 1000);
			})
		}
	}
}
