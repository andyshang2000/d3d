package diary.ui.view.buildings
{
	import diary.res.RES;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class BuildBase extends Sprite
	{
		protected var clkEff:MovieClip;
		protected var defaultSkin:Quad;
		protected var lockImg:Image;
		public var id:String;
		public var islock:Boolean;

		public var assets:*;

		public function BuildBase(assets:*)
		{
			this.assets = assets;
			clkEff = createMovieClip("selectEffect");
			clkEff.scaleX = 3;
			clkEff.scaleY = 3;
			lockImg = RES.get("gui_legacy/img_lock");
			touchGroup = true;
		}

		protected function createSkin(w:Number = 100, h:Number = 200):void
		{
			defaultSkin = new Quad(w, h, 0x000000);
			defaultSkin.name = "quad for button";
			defaultSkin.alpha = 0.01;
			addChild(defaultSkin);
			defaultSkin.x = -30;
			defaultSkin.y = -50;
			addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		protected function removeSkin():void
		{
			if (defaultSkin && defaultSkin.parent)
			{
				defaultSkin.parent.removeChild(defaultSkin);
				defaultSkin.dispose();
				defaultSkin = null;
			}
		}

		protected function touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as BuildBase);
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				showAlert();
				playEff();
			}
		}

		protected function showAlert():void
		{
			if (!islock)
			{
				dispatchEventWith("ClkBuildEvent", true);
			}
		}

		protected function playEff():void
		{
			addChild(clkEff);
			clkEff.x = 0;
			clkEff.y = 100;
			clkEff.play();
			clkEff.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				if (clkEff.parent)
				{
					clkEff.stop();
					clkEff.parent.removeChild(clkEff);
				}
			});
		}

		protected function createEffect(name:String, x:int, y:int):MovieClip
		{
			var mc:MovieClip = createMovieClip(name);
			addChild(mc);
			mc.x = x - 35;
			mc.y = y - 45;
			mc.scaleX = 1;
			mc.scaleY = 1;
			mc.play();
			return mc;
		}

		protected function createMovieClip(name:String):MovieClip
		{
			var mc:MovieClip = new MovieClip(Vector.<Texture>([Texture.fromColor(2, 2, 0x0)]), 12);
			Starling.juggler.add(mc);
			return mc;
		}

		protected function createEff(eff_png:Class, eff_xml:Class, loop:Boolean = true):MovieClip
		{
			var atlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new eff_png(), false), XML(new eff_xml()));
			var mc:MovieClip = new MovieClip(atlas.getTextures(), 20);
			Starling.juggler.add(mc);
			mc.loop = loop;
			mc.stop();
			return mc;
		}

		public function addLock():void
		{
			islock = true;
			if (lockImg)
			{
				addChild(lockImg);
				lockImg.x = (this.width - lockImg.width) / 2;
				lockImg.y = (this.height - lockImg.height) / 2;
			}
		}

		public function removeLock():void
		{
			islock = false;
			if (lockImg)
			{
				removeChild(lockImg);
			}
		}

		override public function dispose():void
		{
			super.dispose();
			removeSkin();
		}
	}
}
