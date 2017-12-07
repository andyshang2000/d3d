package diary.ui.view
{
	import flash.display.BitmapData;
	
	import diary.avatar.Avatar;
	import diary.game.m3.Match3View;
	
	import fairygui.GComponent;
	import fairygui.GRoot;
	
	import starling.textures.TextureAtlas;
	
	public class Match3Screen extends GScreen implements IScreen
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
		
		public function Match3Screen()
		{
		}
		
		override public function createLayer(name:String):*
		{
			if(name == "front")
				return super.createLayer(name);
			return null;
		}
				
		override protected function onCreate():void
		{
			setGView("zz3d.dressup.gui", "Match3");
			var view:Match3View = new Match3View();
			GRoot.inst.addChild(view);
			
			view.enter();
		}
		
		override public function dispose():void
		{
			super.dispose();
			trace("dispose!!!!");
		}
	}
}

