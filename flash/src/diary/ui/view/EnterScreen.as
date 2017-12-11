package diary.ui.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.utils.DataUtil;
	import com.popchan.sugar.core.Model;
	import com.popchan.sugar.core.manager.Sounds;
	import com.popchan.sugar.modules.end.EndModule;
	import com.popchan.sugar.modules.game.GameModule;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	
	import diary.avatar.Avatar;
	
	import fairygui.GComponent;
	import fairygui.UIPackage;
	
	import payment.ane.PaymentANE;
	
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	import zzsdk.utils.FileUtil;
	
	public class EnterScreen extends GScreen implements IScreen
	{
		private var json:Object;
		
		private var iconAtlas:TextureAtlas;
		private var avatar:Avatar;
		
		private var snapAtlas:BitmapData;
		private var snapTextures:Array = [];
		
		private var worldMapButtons:Array;
		private var numSceneOpen:int = 3;
		
		private var onInitCallback:Function = null;
		private var initialized:Boolean;
		
		public var leftBar:GComponent;
		private var firstRun:Boolean;
		
		public function EnterScreen()
		{
		}
		
		override protected function loadAssets():void
		{
			var _local_1:AssetManager = Core.texturesManager;
			_local_1.enqueue("assets/textures/card.png?rnd=1");
			_local_1.enqueue("assets/textures/card.xml?rnd=100");
			_local_1.enqueue("assets/textures/ui02.png");
			_local_1.enqueue("assets/textures/ui02.xml");
			_local_1.enqueue("assets/textures/map.png");
			_local_1.enqueue("assets/textures/map.xml");
			_local_1.enqueue("assets/textures/menu.png");
			_local_1.enqueue("assets/textures/menu.xml");
			_local_1.enqueue("assets/effect.png");
			_local_1.enqueue("assets/effect.xml");
			_local_1.enqueue("assets/textures/gameui.png");
			_local_1.enqueue("assets/textures/gameui.xml");
			_local_1.enqueue("assets/title_bg.jpg");
			_local_1.enqueue("assets/worldBg_2.png");
			_local_1.enqueue("assets/textures/game01.png");
			_local_1.enqueue("assets/textures/game01.xml");
			_local_1.enqueue("assets/textures/game02.png");
			_local_1.enqueue("assets/textures/game02.xml");
			_local_1.enqueue("assets/textures/game03.png");
			_local_1.enqueue("assets/textures/game03.xml");
			_local_1.enqueue((("assets/level/Level" + 125) + ".xml"));
			var _local_2:int;
			while (_local_2 <= 20)
			{
				_local_1.enqueue((("assets/level/Level" + _local_2) + ".xml"));
				_local_2++;
			};
			_local_2 = 0;
			_local_1.verbose = false;
			_local_1.loadQueue(this.onLoadProgress);
			DataUtil.id = "com.popchanniuniu.bubble410";
			DataUtil.load(DataUtil.id);
			Model.levelModel.loadData();
			Sounds.init();
			GameModule.getInstance().init();
			EndModule.getInstance().init();
		}
		
		private function onLoadProgress(ratio:Number):void
		{
			if(ratio == 1)
			{
				FileUtil.dir = File.applicationDirectory;
				doLoadAssets();
				UIPackage.waitToLoadCompleted(initializeHandler);
				FileUtil.dir = File.applicationStorageDirectory;
			}
		}
		
		override protected function doLoadAssets():void
		{
			UIPackage.addPackage( //
				FileUtil.open("zz3d.dressup.gui"), //
				FileUtil.open("zz3d.dressup@res.gui"));
			UIPackage.addPackage( //
				FileUtil.open("zz3d.m3.gui"), //
				FileUtil.open("zz3d.m3@res.gui"));
		}
		
		override public function createLayer(name:String):*
		{
			if(name == "front")
				return super.createLayer(name);
			return null;
		}
		
		[Handler(clickGTouch)]
		public function startButtonClick():void
		{
			if(firstRun)
				nextScreen(GameScreen);
			else
				nextScreen(MapScreen);
		}
		
		override protected function onCreate():void
		{
			setGView("zz3d.dressup.gui", "Enter");
			
			fit(getChild("tpage").asLoader);
			try
			{
				PaymentANE.call("ready");
			}
			catch (err:Error)
			{
			}
			//prepare ad
			transferTo("transpage");
			setTimeout(function():void
			{
				transferTo("start");
			}, 2000);
		}
		
		override public function dispose():void
		{
			super.dispose();
			trace("dispose!!!!");
		}
	}
}

