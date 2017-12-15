package diary.ui.view
{
	import fairygui.GButton;
	import fairygui.GComponent;
	import fairygui.GImage;
	import fairygui.GRoot;
	import fairygui.event.GTouchEvent;

	public class MapScreen extends GScreen implements IScreen
	{
		private var worldMapButtons:Array;
		private var numSceneOpen:int = 5;		
		
		override public function createLayer(name:String):*
		{
			if(name == "front")
				return super.createLayer(name);
			return null;
		}

		override protected function onCreate():void
		{
			setGView("zz3d.dressup.gui", "Map")

			setupWorldmapSize();
			setupWorldmap();
			updateWorldMap();
			//prepare ad
			transferTo("map");
		}
		
		private function setupWorldmapSize():void
		{
			var world:GComponent = getChild("worldmap").asCom;
			var width:int = GRoot.inst.width;
			var height:int = GRoot.inst.height;
			world.setSize(width, height);
			
			var offset:int = 0;
			var scale:Number = 1;
			for (var i:int = 0; i < world.numChildren; i++)
			{
				var child:GImage = world.getChildAt(i) as GImage;
				if (child == null)
					break;
			}
			for (i -= 1; i >= 0; i--)
			{
				child = world.getChildAt(i) as GImage;
				scale = width / child.width;
				child.width = Math.round(width);
				child.height *= scale;
				child.height = Math.round(height);
				child.y = Math.round(offset);
				offset += child.height;
			}
		}
		
		private function setupWorldmap():void
		{
			var n:int = getChild("worldmap").asCom.numChildren;
			var worldMapCom:GComponent = getChild("worldmap").asCom;
			worldMapButtons = [];
			for (var i:int = 0; i < n; i++)
			{
				var button:GButton = worldMapCom.getChildAt(i).asButton;
				if (!button)
					continue;
				worldMapButtons.push(button);
				button.addEventListener(GTouchEvent.CLICK, function(event:GTouchEvent):void
				{
					var b:GButton = event.currentTarget as GButton;
					var index:int = worldMapButtons.indexOf(b);
					
					if(index < 2)
					{
						nextScreen(GameScreen);
					}
					else
					{
						nextScreen(Match3Screen);
					}

					trace("clicked: " + index);
				})
			}
			worldMapButtons.sort(function(up:GButton, down:GButton):int
			{
				if (up.y > down.y)
					return -1
				if (up.y < down.y)
					return 1
				return 0;
			});
		}

		private function updateWorldMap():void
		{
			for (var i:int = 0; i < numSceneOpen; i++)
			{
				GButton(worldMapButtons[i]).enabled = true;
			}
			for (var i:int = numSceneOpen; i < worldMapButtons.length; i++)
			{
				GButton(worldMapButtons[i]).enabled = false;
			}
		}
	}
}
