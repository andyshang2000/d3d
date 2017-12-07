package diary.ui.view
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import diary.ui.RenderManager;

	[Event(name = "complete", type = "flash.events.Event")]
	public class ScreenManager extends Sprite
	{
		private var currentScreen:IScreen;
		public var renderManager:RenderManager;

		public function ScreenManager(stage:Stage)
		{
			this.renderManager = new RenderManager(stage);

			stage.removeChildren();
			stage.addChild(this);

			renderManager.addLayer("back", "2D");
			renderManager.addLayer("avatar", "3D");
			renderManager.addLayer("front", "2D");
			renderManager.addEventListener("layerCreated", renderManagerLayerCreated);
		}

		public function addService(obj:*):void
		{
			obj.initialize(this);
		}

		protected function renderManagerLayerCreated(event:Event):void
		{
			dispatchEvent(new Event("complete"));
		}

		public function changeScreen(clazz:Class):void
		{
			var self:* = this;
			var s:IScreen = new clazz;
			s.onInit(this, function():void
			{
				if (currentScreen)
				{
					currentScreen.dispose();
				}
				s.update2DLayer("back", renderManager.getLayerRoot("back"));
				s.update2DLayer("front", renderManager.getLayerRoot("front"));

				s.update3DLayer(renderManager);

				currentScreen = s;
			})
		}
	}
}
