package diary.ui.view
{
	import fairygui.GComponent;
	import fairygui.GList;

	public class MapScreen extends GScreen implements IScreen
	{
		private var worldMapButtons:Array;
		private var numSceneOpen:int = 5;

		public static const NUM_MODULES:int = 6;

		[G]
		public var buyList:GList;

		[Handler(clickGTouch)]
		public function playButtonClick():void
		{
//			nextScreen(Match3Screen);
			nextScreen(DressupScreen);
		}

		override public function createLayer(name:String):*
		{
			if (name == "front")
				return super.createLayer(name);
			return null;
		}

		override protected function onCreate():void
		{
			setGView("zz3d.dressup.gui", "Map");

			buyList.itemRenderer = function(i:int, renderer:GComponent):void
			{
			};
			//prepare ad
			transferTo("map");
		}
	}
}
