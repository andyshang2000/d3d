package diary.ui.view
{
	import flash.display.BitmapData;
	import flash.utils.setTimeout;
	
	import diary.avatar.Avatar;
	
	import fairygui.GComponent;
	import fairygui.UIPackage;
	
	import starling.textures.TextureAtlas;
	
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
		
		
		override protected function doLoadAssets():void
		{
			UIPackage.addPackage( //
				FileUtil.open("zz3d.dressup.gui"), //
				FileUtil.open("zz3d.dressup@res.gui"));
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
			setGView("zz3d.dressup.gui", "Enter")
			
			fit(getChild("tpage").asLoader);
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

