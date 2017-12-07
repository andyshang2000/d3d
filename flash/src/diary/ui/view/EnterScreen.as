package diary.ui.view
{
	import flash.display.BitmapData;
	import flash.utils.setTimeout;
	
	import diary.avatar.Avatar;
	
	import fairygui.GComponent;
	
	import starling.textures.TextureAtlas;
	
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
		
		public function EnterScreen()
		{
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
			nextScreen(GameScreen);
		}
		
		override protected function onCreate():void
		{
			setGView("zz3d.dressup.gui", "Root")
			
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

