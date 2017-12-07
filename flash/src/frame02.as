package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipEvent;
	
	import diary.services.ScreenShot;
	import diary.services.ShareService;
	import diary.ui.view.EnterScreen;
	import diary.ui.view.EnterUI;
	import diary.ui.view.GameScreen;
	import diary.ui.view.GameUI;
	import diary.ui.view.ScreenManager;
	import diary.ui.view.State;
	import payment.ane.PaymentANE;
	import starling.textures.Texture;
	
	import zzsdk.utils.FileUtil;

	[SWF(frameRate = "45")]
	public class frame02 extends Sprite
	{
		public function frame02()
		{
			try
			{
				PaymentANE.call("init");
			}
			catch (err:Error)
			{
			}
			var screenMgr:ScreenManager = new ScreenManager(stage);
			Texture.asyncBitmapUploadEnabled = true;
			screenMgr.addService(ScreenShot.inst);
			screenMgr.addService(ShareService.inst);
			screenMgr.addEventListener(Event.COMPLETE, function():void
			{
				screenMgr.changeScreen(EnterScreen);
			});
			
			var dir:* = File.applicationStorageDirectory;
			FileUtil.dir = dir;
			if (!FileUtil.dir.resolvePath("gameconfig").exists)
			{
				firstRun();
			}
			else
			{
				start();
			}
		}
		
		private function start():void
		{
			trace(":)");
		}
		
		private function firstRun():void
		{
			var zip:FZip = new FZip;
			var count:int = zip.getFileCount();
			zip.addEventListener(FZipEvent.FILE_LOADED, function(event:FZipEvent):void
			{
				FileUtil.save(event.file.content, event.file.filename);
				count--
				if(count == 0)
				{
					start();
				}
			});
			zip.loadBytes(FileUtil.readFile(File.applicationDirectory.resolvePath("xxxx.zip")));
			//config
			var json:Object = JSON.parse(FileUtil.readFile(File.applicationDirectory.resolvePath("map.json"), "text"));
			var game:Object = json["game"];
			var distrib:Array = [];
			for each (var items:Array in game) 
			{
				for (var i:int = 4; i < items.length; i++) 
				{
					items[i].locked = true;
					items[i].scene = 0;
				}
			}
			FileUtil.save(json, "gameconfig");
		}
	}
}
