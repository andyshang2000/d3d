package
{
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import zzsdk.editor.utils.FileUtil;
	
	public class Compress extends Sprite
	{
		
		[Embed(source = "flare3d.swf", mimeType = "application/octet-stream")]
		public var f3dX:Class;
		
		private var exporterClazz:*;
		private var data:ItemData;
		private var appMain:ApplicationDomain;
		private var loaderClass:Object;
		private var tid:uint;
		
		public function Compress()
		{
			var self:Compress = this;
//			appMain = new ApplicationDomain();
//			var lc:LoaderContext = new LoaderContext(false, appMain);
//			lc.allowCodeImport = true;
//			var loader:Loader = new Loader();
//			loader.loadBytes(new MainSWF, lc);
			setTimeout(function(){
//				Scene3D
//				var scene = new (getDefinitionByName("flare.basic::Scene3D"))(self);
				var loader:Loader = new Loader;
				var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
				lc.allowCodeImport = true;
				loader.loadBytes(new f3dX, lc)
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
				{
					setTimeout(function():void
					{
						exporterClazz = getDefinitionByName("flare.exporters.ZF3DExporter");
						loaderClass = getDefinitionByName("flare.loaders::Flare3DLoader");
						initialize();
					}, 200);
				})
			},100);
		}
		
		private function initialize():void
		{
			data = new ItemData();
			var items = data.items;
			var filelist = data.filelist;
			var files = [];
			for (var n:String in filelist) 
			{
				if(n.substr(n.lastIndexOf(".")) == ".f3d")
				{
					var saveURL:String =  "file:///F:/games/flash/F3C/bin-debug/compressed/" + n;
					saveURL = saveURL.replace(".f3d", ".zf3d");
//					if(new File(saveURL).exists)
//						continue;
					files.push({url:n, v:filelist[n]});
				}
			}
			
			loadNext(files);
		}
		
		private function loadNext(files):void
		{
			clearTimeout(tid);
			if(files.length == 0)
			{
				NativeApplication.nativeApplication.exit();
				return;
			}
			var file = files.shift();
			var url = "file:///F:/games/flash/F3C/bin-debug/export/" + file.url;
			var loader = new loaderClass(url);
			var exporter:* = new exporterClazz;
			var saveURL:String =  "file:///F:/games/flash/F3C/bin-debug/compressed/" + file.url;
			saveURL = saveURL.replace(".f3d", ".zf3d");
			loader.addEventListener(Event.COMPLETE, function():void
			{
				exporter.add(loader.children[0]);
				FileUtil.save(exporter.save(), saveURL);
				setTimeout(loadNext,1, files);
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(err:Event):void
			{
				trace(err);
				setTimeout(loadNext,1, files);
			})
			loader.load();
			if(loader.loaded)
			{
				exporter.add(loader.children[0]);
				FileUtil.save(exporter.save(), saveURL);
				setTimeout(loadNext,1, files);
				return;
			}
			tid = setTimeout(function():void{
				trace("error occured on flare3d loader:" + file.url)
				loadNext(files);
			},3000);
		}
	}
}
