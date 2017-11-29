package diary.ui.view
{
	import flash.geom.Rectangle;

	import diary.avatar.AnimatedAvatar;
	import diary.avatar.AnimationTicker;
	import diary.avatar.Wink;
	import diary.game.Context;
	import diary.res.RES;
	import diary.ui.view.dressing.LeftPanel;
	import diary.ui.view.dressing.RightPanel;

	import extend.particlesystem.PDParticleSystem;

	import flare.basic.Scene3D;
	import flare.core.Camera3D;

	import lzm.starling.swf.display.SwfButton;

	import qd3d.gui.views.BottomPanel;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;

	import zzsdk.display.Screen;

	public class LegacyDressingView extends ViewWithTopBar implements IScreen
	{
		public var $_leftPanel:LeftPanel;
		public var $_rightPanel:RightPanel;
		public var $_bottomPanel:BottomPanel;
		public var $homeBtn:SwfButton;
		public var avatar:AnimatedAvatar;
		public var stage:Stage;

		private var _isshowEff:Boolean = false;
		private var _dressEff:PDParticleSystem;

		override public function loadAssets(callback:Function = null):void
		{
			super.loadAssets(callback);
			$homeBtn.visible = false;
		}

		public function update3D(scene:Scene3D):void
		{
			scene.addChild(avatar = new AnimatedAvatar);
			scene.camera.setPosition(0, 150, -240);
			scene.camera.lookAt(0, 120, 0);
			scene.camera.fovMode = Camera3D.FOV_VERTICAL;
			scene.camera.fieldOfView = 62;
			scene.camera.viewPort = new Rectangle(0, -100, scene.viewPort.width, scene.viewPort.height);
			avatar.addComponent(new AnimationTicker);
			avatar.addComponent(new Wink);
		}

		public function getFront():Sprite
		{
			return view = RES.get("gui_legacy/spr_MainUi");
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

		public function showDressEff():void
		{
			EffectMgr.Instance().getEffConf("img_starparticle", function onFin(eff:PDParticleSystem):void
			{
				view.addChild(eff);
				eff.emitterX = (Screen.designW - eff.width) / 2;
				eff.emitterY = Screen.designH;
			});
		}
	}
}
import flash.utils.Dictionary;

import diary.res.RES;
import diary.ui.view.dressing.EmbedMgr;

import extend.particlesystem.PDParticleSystem;

import starling.animation.IAnimatable;
import starling.core.Starling;

class EffectMgr implements IAnimatable
{
	private static var _instance:EffectMgr;
	private var _effDic:Dictionary

	public function EffectMgr()
	{
		_effDic = new Dictionary();
	}

	public static function Instance():EffectMgr
	{
		if (!_instance)
		{
			_instance = new EffectMgr;
		}
		return _instance;
	}

	public function getEffConf(effname:String, onFin:Function):void
	{
		if (!_effDic[effname])
		{
			_effDic[effname] = new PDParticleSystem(EmbedMgr.Instance().getXml(effname), RES.get(effname));
			Starling.juggler.add(_effDic[effname]);
		}
		if (onFin != null)
		{
			Starling.juggler.add(this);
			_effDic[effname].start();
			onFin(_effDic[effname]);
		}
	}

	public function advanceTime(time:Number):void
	{
		for each (var e:PDParticleSystem in _effDic)
		{
			e.emitterY -= 500 * time;
			if (e.emitterY <= -200)
			{
				Starling.juggler.remove(this);
				e.stop();
//				e.parent.removeChild(e);
			}
		}
	}
}
