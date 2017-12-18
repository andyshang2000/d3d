package
{
	import com.popchan.framework.core.Core;
	import com.popchan.sugar.modules.game.view.GamePanel;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipEvent;
	
	import diary.game.Item;
	import diary.game.Shop;
	import diary.services.ScreenShot;
	import diary.services.ShareService;
	import diary.ui.view.Alert;
	import diary.ui.view.EndPanel;
	import diary.ui.view.EnterScreen;
	import diary.ui.view.ScreenManager;
	import diary.ui.view.ShopItemRenderer;
	import diary.ui.view.TitleBar;
	
	import fairygui.UIObjectFactory;
	
	import payment.ane.PaymentANE;
	
	import zzsdk.utils.FileUtil;

	[SWF(width = "480", height = "800", frameRate = "45")]
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

			var stage:Stage = this.stage;
			var screenMgr:ScreenManager = new ScreenManager(stage);
			screenMgr.addService(ScreenShot.inst);
			screenMgr.addService(ShareService.inst);
			screenMgr.addEventListener(Event.COMPLETE, function():void
			{
				Core.init(stage);
				screenMgr.changeScreen(EnterScreen);
			});

			var dir:* = File.applicationStorageDirectory;
			FileUtil.dir = dir;
			trace(dir.nativePath);
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
			UIObjectFactory.setPackageItemExtension("ui://zz3d.m3.gui/GamePanel", GamePanel);
			UIObjectFactory.setPackageItemExtension("ui://zz3d.m3.gui/Alert", Alert);
			UIObjectFactory.setPackageItemExtension("ui://zz3d.m3.gui/EndPanel", EndPanel);
			UIObjectFactory.setPackageItemExtension("ui://zz3d.dressup.gui/TitleBar", TitleBar);
			UIObjectFactory.setPackageItemExtension("ui://zz3d.dressup.gui/ShopItemRenderer", ShopItemRenderer);
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
				if (count == 0)
				{
					start();
				}
			});
			zip.loadBytes(FileUtil.readFile(File.applicationDirectory.resolvePath("xxxx.zip")));
			//config
			var json:Object = JSON.parse(FileUtil.readFile(File.applicationDirectory.resolvePath("map.json"), "text"));
			var game:Object = json["game"];
			var distrib:Array = [];
			for (var cat:String in game)
			{
				var items:Array = game[cat];
				var itemIndex:Array = json[cat + "_index"] = [];
				for (var i:int = 0; i < items.length; i++)
				{
					itemIndex[i] = Item.getHash(items[i]);
				}
			}
			FileUtil.save(json, "gameconfig");
		}
	}
}
