package diary.ui.view
{
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	import diary.game.Level;
	import diary.res.RES;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.layout.VerticalLayout;
	
	import lzm.starling.display.Button;
	import lzm.starling.swf.display.SwfButton;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import zzsdk.display.Screen;

	public class Worldmap extends ViewWithTopBar implements IScreen
	{
		public var $shopButton:SwfButton;
		public var $settingsButton:SwfButton;
		
		private var scroller:ScrollContainer;
		private var gui:Sprite;

		override public function loadAssets(callback:Function = null):void
		{
			super.loadAssets(callback);
			$shopButton.addEventListener(Event.TRIGGERED, buyHandler);
		}

		private function buyHandler():void
		{
			dispatchEventWith("buyEvent");
		}

		public function getBack():Sprite
		{
			var res:Sprite = new FixedScaleContainer;
			gui = RES.get("gui/spr_mapView");
			retriveFields(gui);
			scroller = new ScrollContainer;
			scroller.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			scroller.width = Screen.designW;
			scroller.height = Screen.designH;
			var container:Sprite = new Sprite;
			var ot:Vector.<Texture> = RES.get("worldmap_m");
			var lg:LayoutGroup = new LayoutGroup;
			lg.layout = new VerticalLayout;
			for (var i:int = 0; i < ot.length; i++)
			{
				var image:Image = new IntXYImage(ot[i]);
				lg.addChild(image);
			}
			for (i = 0; i < Level.lookup.length; i++)
			{
				var level:Level = Level.getData(i);
				var button:Button = new Button(new Image(RES.get("img_mapButtonActive")));
				button.disabledSkin = new Image(RES.get("img_mapButtonInActive"));
				container.addChild(button);
				button.x = level.x;
				button.y = level.y;
				button.enabled = !level.locked;
				button.name = level.code;
				button.addEventListener(Event.TRIGGERED, triggeredHandler);
			}
			scroller.addChild(lg);
			scroller.addChild(container);
			scroller.verticalScrollPosition = 99999;
//			scroller.
			res.addChild(scroller);
			res.addChild(gui);
			return res;
		}

		private function triggeredHandler(event:Event):void
		{
			dispatchEventWith("enterLevel", false, (event.currentTarget as Button).name)
		}

		public function unlock(index:int):void
		{
		}

		public function playSound(id:String):void
		{
			var sound:Sound;
			var bytes:ByteArray;
			switch (id)
			{
				case "china":
					sound = RES.get("bgm_china");
					break;
				case "america":
					sound = RES.get("bgm_usa");
					break;
				case "paris":
					sound = RES.get("bgm_france");
					break;
				case "italy":
					sound = RES.get("bgm_italy");
					break;
				case "worldmap":
					sound = RES.get("bgm");
					break;
			}
			sound.play();
		}
	}
}
import feathers.controls.ScrollContainer;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

class IntXYImage extends Image
{
	public function IntXYImage(texture:Texture)
	{
		super(texture);
	}

	override public function set x(value:Number):void
	{
		super.x = Math.round(value)
	}

	override public function set y(value:Number):void
	{
		super.y = Math.round(value)
	}
}

class FixedScaleContainer extends Sprite
{
	override public function set x(value:Number):void
	{
		super.x = 0;
	}

	override public function set y(value:Number):void
	{
		super.y = 0;
	}

	override public function set scaleX(value:Number):void
	{
		super.scaleX = 1;
	}

	override public function set scaleY(value:Number):void
	{
		super.scaleY = 1;
	}
	
	override public function dispose():void
	{
		super.dispose();
	}
}
