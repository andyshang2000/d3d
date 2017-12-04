package diary.ui.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import diary.ui.RenderManager;
	
	import lzm.starling.swf.Swf;
	
	import starling.utils.AssetManager;
	
	import zzsdk.display.Screen;

	[Event(name = "complete", type = "flash.events.Event")]
	public class ScreenManager extends Sprite
	{
		private var currentScreen:IScreenCtrl;
		private var renderManager:RenderManager;

		private var screenMap:Object = {};

		public var assetManager:AssetManager;
		private var scaleFactor:Number;
		//splash related
		private var splashMap:Object = {};
		private var currentSplash:DisplayObject;

		public function ScreenManager(stage:Stage, scaleFactor:Number = 2.0)
		{
			this.renderManager = new RenderManager(stage);
			this.scaleFactor = scaleFactor;

			stage.removeChildren();
			stage.addChild(this);

			renderManager.addLayer("back", "2D");
			renderManager.addLayer("avatar", "3D");
			renderManager.addLayer("front", "2D");
			renderManager.addLayer("topbar", "2D");
			renderManager.addEventListener("layerCreated", renderManagerLayerCreated);
		}

		protected function renderManagerLayerCreated(event:Event):void
		{
			Swf.init(renderManager.getLayerRoot("back"));
			assetManager = new AssetManager(scaleFactor, false);
			dispatchEvent(new Event("complete"));
		}

		public function changeScreen(name:String):void
		{
			if (currentScreen)
			{
				currentScreen.dispose();
			}
			var self:* = this;
			var view:IScreen = new (screenMap[name].view);
			view.loadAssets(function():void
			{
				view.update2DLayer("back", renderManager.getLayerRoot("back"));
				view.update2DLayer("front", renderManager.getLayerRoot("front"));
				view.update2DLayer("topbar", renderManager.getLayerRoot("topbar"));
				
				view.update3DLayer(renderManager);
				currentScreen = new (screenMap[name].ctrl)(self, view);
			});
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
