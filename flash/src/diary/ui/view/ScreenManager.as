package diary.ui.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import diary.ui.RenderManager;

	import starling.utils.AssetManager;

	import zzsdk.display.Screen;

	[Event(name = "complete", type = "flash.events.Event")]
	public class ScreenManager extends Sprite
	{
		private var currentScreen:IScreenCtrl;
		public var renderManager:RenderManager;

		private var screenMap:Object = {};

		public var assetManager:AssetManager;
		private var scaleFactor:Number;
		//splash related
		private var splashMap:Object = {};
		private var currentSplash:DisplayObject;

		public function ScreenManager(stage:Stage, scaleFactor:Number = 2.0)
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

		public function changeScreen(name:String):void
		{
			var self:* = this;
			var view:IScreen = new (screenMap[name].view);
			var s:IScreenCtrl = new (screenMap[name].ctrl)(view);
			s.onInit(function():void
			{
				if (currentScreen)
				{
					currentScreen.dispose();
				}
				view.update2DLayer("back", renderManager.getLayerRoot("back"));
				view.update2DLayer("front", renderManager.getLayerRoot("front"));

				view.update3DLayer(renderManager);

				currentScreen = s;
			})
		}

		public function addScreen(name:String, view:Class, ctrl:Class):void
		{
			screenMap[name] = {view: view, ctrl: ctrl};
		}

		public function showSplash(name:String = "default"):void
		{
			addChild(currentSplash = splashMap[name]);
			Screen.fitBackground(currentSplash, 1, 0, 0, false);
			stage.scaleMode = StageScaleMode.NO_BORDER;
			stage.align = StageAlign.TOP;
		}

		public function hideSplash():void
		{
			removeChild(currentSplash);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}

		public function addSplash(name:String, splashObj:DisplayObject):void
		{
			splashMap[name] = splashObj;
		}

		public function requestChange(request:String):void
		{
			currentScreen.handleStateChange(request);
		}
	}
}
