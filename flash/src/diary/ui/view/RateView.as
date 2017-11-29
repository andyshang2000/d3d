package diary.ui.view
{
	import flash.geom.Rectangle;
	import flash.text.Font;

	import diary.game.Context;
	import diary.res.RES;
	import diary.ui.font.FZArtHei;

	import flare.basic.Scene3D;
	import flare.core.Camera3D;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	public class RateView extends ViewWithTopBar implements IScreen
	{
		public var $rateField:TextField;
		public var $scoreField:TextField;
		public var $content:TextField;
		public var $_rewardPanel:RewardPanel

		private var font:Font = new FZArtHei;

		private var front:Sprite;
		private var flashlight:Quad;

		override public function loadAssets(callback:Function = null):void
		{
			super.loadAssets(callback);
			view.addEventListener(TouchEvent.TOUCH, touchHandler);
//			front.
			Starling.juggler.tween(flashlight, 0.3, {color: 0xFFcccccc, alpha: 0});
			$_rewardPanel.addEventListener("get", getHandler);
		}

		private function getHandler():void
		{
			dispatchEventWith("next");
		}

		public function update3D(scene:Scene3D):void
		{
			scene.addChild(Context.context.get("avatar"));
			scene.camera.setPosition(0, 150, -240);
			scene.camera.lookAt(0, 120, 0);
			scene.camera.fovMode = Camera3D.FOV_VERTICAL;
			scene.camera.fieldOfView = 60;
			scene.camera.viewPort = new Rectangle(0, -100, scene.viewPort.width, scene.viewPort.height);
		}

		private function touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(view, TouchPhase.BEGAN);
			if (touch)
			{
				view.removeEventListener(TouchEvent.TOUCH, touchHandler);
				dispatchEventWith("next");
			}
		}

		public function getFront():Sprite
		{
			front = RES.get("gui/spr_RateView");
			front.addChild(flashlight = new Quad(1024, 1024, 0xFFFFFFFF));
			return front;
		}

		public function getBack():Sprite
		{
			var backgroundLayer:Sprite = new Sprite;
			var name:String = Context.context.level.bg;
			var image:Image = new Image(RES.get(name));
			backgroundLayer.addChild(image);
			image.name = name;
			image.scaleX = 2;
			image.scaleY = 2;
			return backgroundLayer;
		}
	}
}
