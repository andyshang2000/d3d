package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;

	import deng.fzip.FZip;
	import deng.fzip.FZipEvent;

	import diary.controller.GameCtrl;
	import diary.controller.State;
	import diary.services.ScreenShot;
	import diary.services.ShareService;
	import diary.ui.view.GameUI;
	import diary.ui.view.ScreenManager;

	import payment.ane.PaymentANE;

	import starling.textures.Texture;

	import zzsdk.utils.FileUtil;

	[SWF(frameRate = "60", backgroundColor = 0x0)]
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

			screenMgr.addScreen(State.MENU, GameUI, GameCtrl);
			screenMgr.addEventListener(Event.COMPLETE, function():void
			{
				screenMgr.changeScreen(State.MENU);
			});

			FileUtil.dir = File.applicationStorageDirectory;
			if (!FileUtil.dir.resolvePath("gameconfig").exists)
			{
				firstRun();
			}
		}

		private function firstRun():void
		{
			var zip:FZip = new FZip;
			zip.addEventListener(FZipEvent.FILE_LOADED, function(event:FZipEvent):void
			{
				FileUtil.save(event.file.content, event.file.filename);
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
