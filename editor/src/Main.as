package
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PNGEncoderOptions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;

	import flare.basic.Scene3D;

	import zzsdk.editor.ImportFileEvent;
	import zzsdk.editor.gui.DragArea;
	import zzsdk.editor.utils.Client;
	import zzsdk.editor.utils.FileUtil;

	public class Main extends Sprite
	{
		[Embed(source = "flare3d.swf", mimeType = "application/octet-stream")]
		private var f3dIDE:Class;

		private var fileList:Array;

		private var exporter:*;

		private var scene:Scene3D;
		private var currentFile:File;
		private var f3dFolderName:String;
		private var tid:uint;

		private var currentFile2:File;

		public function Main()
		{
			scene = new Scene3D(stage);
			//
			var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			lc.allowCodeImport = true;
			var loader:Loader = new Loader;
			loader.loadBytes(new f3dIDE, lc);
			loader.contentLoaderInfo.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function():void
			{
			});
//			setTimeout(function():void
//			{
//				exporter = new (getDefinitionByName("flare.exporters::ZF3DExporter"))
//				var file:File = File.applicationDirectory.resolvePath("E:\\server\\guess\\editor\\3d_fodder");
//				fileList = file.getDirectoryListing();
//				next();
//			}, 2000);
			//
			addChild(new DragArea("f3d", "zf3d"));
			fileList = []
			stage.addEventListener(ImportFileEvent.IMPORT, function(event:ImportFileEvent):void
			{
				fileList.push(event.file);
				clearTimeout(tid);
				tid = setTimeout(next, 100);
			});
		}

		private function next():void
		{
			if (fileList.length == 0)
			{
				NativeApplication.nativeApplication.exit(0);
				return;
			}
			currentFile2 = fileList.pop();
			if (currentFile2.extension != "f3d")
			{
				next();
				return;
			}
			if (File.applicationDirectory.resolvePath(currentFile2.nativePath.substr(0, currentFile2.nativePath.length - 4) + "/gg.zf3d").exists)
			{
//				next();
//				return;
			}
			f3dFolderName = currentFile2.name;
			process(currentFile2 = new File(currentFile2.nativePath));
		}

		private function process(file:File):void
		{
			currentFile = file;
			while (scene.children.length > 0)
			{
				scene.children[0].dispose();
			}
			scene.addChildFromFile(file.url);
			scene.addEventListener(Event.COMPLETE, function():void
			{
				scene.removeEventListener(Event.COMPLETE, arguments.callee);
				exporter = new (getDefinitionByName("flare.exporters::ZF3DExporter"))
				exporter.add(scene.children[0]);
				FileUtil.save(exporter.save(), "jiong.zf3d");
				Client.call("tools/7z.exe x jiong.zf3d -o" + f3dFolderName + " -y").onSuccess(handleContent);
			});
		}

		private function handleContent():void
		{
			var xml:XML = XML(FileUtil.readFile(File.applicationDirectory.resolvePath(f3dFolderName + "/main.xml")));
			for each (var map:XML in xml.maps.map)
			{
				var s:String = map.@source;
				s = /((g|b)?\d{4}_[a-z]+[0-9]?(_(dod|DMZ))?)/ig.exec(s)[1] + ".atf";
				map.@source = s;
			}
			for each (var sampler:XML in xml..sampler)
			{
				sampler.@mip = 0;
			}
			for each (var shader:XML in xml..shader)
			{
				shader.@enableLights = false;
			}

			FileUtil.save(xml.toXMLString(), f3dFolderName + "/main.xml");
			processImages();
		}

		private function processImages():void
		{
			var files:Array = File.applicationDirectory.resolvePath(f3dFolderName).getDirectoryListing();
			convert();
			function convert():void
			{
				if (files.length == 0)
				{
					pack();
					return;
				}
				var f:File = files.pop();
				if (f.extension != "png" && f.extension != "jpg")
				{
					convert();
					return;
				}
				var filepath:String = f.nativePath.substring(0, f.nativePath.length - 3) + "png";
				if (f.extension == "jpg" || f.extension == "png")
				{
					var loader:Loader = new Loader;
					loader.loadBytes(FileUtil.readFile(f));
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
					{
						var bmd:BitmapData = Bitmap(loader.content).bitmapData;
						if (bmd.width != bmd.height || //
							[64, 128, 256, 512, 1024, 2048].indexOf(bmd.width) == -1 || //
							[64, 128, 256, 512, 1024, 2048].indexOf(bmd.height) == -1)
						{
							var m:int = bmd.width * bmd.height;
							var max:int
							if (m < 75 * 75)
								max = 64
							else if (m < 140 * 140)
								max = 128;
							else if (m < 270 * 270)
								max = 256;
							else
								max = 512;

							bmd = new BitmapData(max, max, true, 0)
							bmd.draw(loader.content, new Matrix(bmd.width / loader.content.width, 0, 0, bmd.height / loader.content.height));
						}
						FileUtil.save(bmd.encode(bmd.rect, new PNGEncoderOptions()), filepath);
						doConvert(filepath);
					})
				}
			}

			function doConvert(filepath:String):void
			{
				var path:String = filepath.substr(0, filepath.length - 4);
//				Client.call("tools/png2atf.exe -c e -r -n 0,0 -q 0 -i " + path + ".png -o " + path + ".atf").onSuccess(function():void
				var platform:String = "d";
//				Client.call("tools/png2atf.exe", "-n", "0,0", "-q", "0", "-i", path + ".png", "-o", path + ".atf").onSuccess(function():void
				Client.call("tools/png2atf.exe", "-c", "-r", "-n", "0,0", "-q", "0", "-i", path + ".png", "-o", path + ".atf").onSuccess(function():void
				{
					convert();
				})
			}

			function pack():void
			{
				Client.workingDirectory = File.applicationDirectory.resolvePath(f3dFolderName);
				Client.call("D:\\3dgame\\3dTools\\tools\\7z.exe a gg.zf3d *.atf *.vertex *.xml -y -tzip").onSuccess(function():void
				{
					new File(Client.workingDirectory.nativePath + "\\gg.zf3d").moveTo(File.applicationDirectory.resolvePath(currentFile2.nativePath.substr(0, currentFile2.nativePath.length - 4) + "\\gg.zf3d"), true);
					Client.workingDirectory = File.applicationDirectory;
					next();
				});
			}
		}
	}
}
