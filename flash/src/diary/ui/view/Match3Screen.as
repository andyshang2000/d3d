package diary.ui.view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.popchan.framework.core.MsgDispatcher;
	import com.popchan.sugar.core.Model;
	import com.popchan.sugar.core.cfg.Config;
	import com.popchan.sugar.core.cfg.levels.LevelCO;
	import com.popchan.sugar.core.data.AimType;
	import com.popchan.sugar.core.data.GameConst;
	import com.popchan.sugar.core.data.GameMode;
	import com.popchan.sugar.core.events.GameEvents;
	import com.popchan.sugar.modules.game.view.GamePanel;
	import com.popchan.sugar.modules.game.view.XImage;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	import diary.avatar.AnimationTicker;
	import diary.avatar.Avatar;
	import diary.avatar.MatchRespond;

	import fairygui.GComponent;
	import fairygui.GImage;
	import fairygui.GRoot;
	import fairygui.UIObjectFactory;
	import fairygui.UIPackage;
	import fairygui.Window;

	import flare.core.Camera3D;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.RectangleUtil;

	public class Match3Screen extends AvatarScreen implements IScreen
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

		private var view:GamePanel;
		private var imageLoaded:Boolean;

		private var aimList:Array;
		private var aimViews:Array = [];

		override protected function onCreate():void
		{
			UIObjectFactory.setPackageItemExtension("ui://zz3d.m3.gui/GamePanel", GamePanel);
			UIObjectFactory.setPackageItemExtension("ui://zz3d.m3.gui/Alert", Alert);
			UIObjectFactory.setPackageItemExtension("ui://zz3d.m3.gui/EndPanel", EndPanel);

			setGView("zz3d.m3.gui", "Match3");
			view = GamePanel(getChild("board"));

			setupCircle();
			setupViewSize();

			MsgDispatcher.add(GameEvents.AIMS_CHANGE, this.onAimChange);
			MsgDispatcher.add(GameEvents.SCORE_CHANGE, this.onScoreChange);
			MsgDispatcher.add(GameEvents.STEP_CHANGE, this.onStepChange);
			MsgDispatcher.add(GameEvents.TIME_CHANGE, this.onTimeChange);

			view.newGame(Config.levelConfig.getLevel(Model.levelModel.selectedLevel));
			setInfo(Config.levelConfig.getLevel(Model.levelModel.selectedLevel));

			var avatar:Avatar = addAvatar("girl");

			avatar.addComponent(new AnimationTicker);
			avatar.addComponent(new MatchRespond);

			scene.camera.setPosition(0, 180, -450);
			scene.camera.setRotation(12, 0, 0);
			scene.camera.fovMode = Camera3D.FOV_VERTICAL;
			scene.camera.fieldOfView = 23;

			addBackground();

			MsgDispatcher.add(GameEvents.OPEN_GAME_END_UI, function():void
			{
				EndPanel.show();
			});
		}

		private function setupAim(aim:Array):void
		{
			aimList = [getChild("aim1"), getChild("aim2"), getChild("aim3"), getChild("aim4")];
			getController("numAims").selectedIndex = aim.length - 1;
			for (var i:int = 0; i < aim.length; i++)
			{
				var aimView:GComponent = aimList[i];
				var seg:Array = aim[i].split(",");
				var aimID:int = int(seg[0]);
				var aimOrg:int = int(seg[1]);
				Model.gameModel.addAim(aimID, aimOrg);
				new XImage(aimView.getChild("icon").asImage).texture2 = AimType.AIM_ICONS[aimID];
				aimView.getChild("value").asTextField.text = aimOrg + "";
				aimViews[aimID] = aimView;
			}
		}

		private function setupCircle():void
		{
			var bar:GComponent = getChild("progressBar").asCom;
			bar.getChild("bar").rotation = 20;
			bar.getChild("bar").asMovieClip.playing = false;
		}

		private function setupViewSize():void
		{
			var initWidth:int = GameConst.CARD_W * 9;
			var initHeight:int = GameConst.CARD_W * 9;
			var port480x800:Rectangle = new Rectangle(0, 0, 480, 800);
			var port:Rectangle = RectangleUtil.fit(port480x800, new Rectangle(10, 0, GRoot.inst.width - 20, GRoot.inst.height));

			view.scaleX = port.width / initWidth;
			view.scaleY = port.width / initWidth;
			var actualWidth:int = initWidth * view.scaleX;
			view.x = port.x;
			view.y = port.bottom - actualWidth - 35;
		}

		public function addBackground(name:String = "bedroom2"):void
		{
			var image:GImage = UIPackage.createObject("zz3d.m3.gui", "bg04").asImage;
			backImage.visible = true;

			setTimeout(function():void
			{
				if (image.texture == null)
				{
					setTimeout(arguments.callee, 1);
					return;
				}
				backImage.texture = Texture.fromTexture(image.texture);
				fit(backImage);
			}, 1);
		}

		[Handler(clickGTouch)]
		public function pauseButtonClick():void
		{
			Alert.show();
		}

		public function setInfo(level:LevelCO):void
		{
			var _local_7:Array;
			var aimID:int;
			var amiOrg:int;
			if (level.mode == GameMode.NORMAL)
			{
				Model.gameModel.step = (level.step);
			}
			else if (level.mode == GameMode.TIME)
			{
				Model.gameModel.time = (level.step);
			}
			setupAim(level.aim);
		}

		private function onTimeChange():void
		{
		}

		private function onStepChange():void
		{
			getChild("stepLabel").text = (Model.gameModel.step + "");
		}

		private function onScoreChange():void
		{
			var cfg:* = Config.levelConfig.getLevel(Model.levelModel.selectedLevel);
			var bar:GComponent = getChild("progressBar").asCom;
			var p = Model.gameModel.score / (cfg.needScore * 10)
			TweenLite.killTweensOf(bar.getChild("bar"));
			TweenLite.to(bar.getChild("bar"), 0.8, {rotation: 20 - 135 * Math.min(1.0, p), ease: Bounce.easeOut})
			if (Model.gameModel.score > cfg.needScore * 6)
			{
				bar.getChild("star3").grayed = false;
			}
			if (Model.gameModel.score > cfg.needScore * 3)
			{
				bar.getChild("star2").grayed = false;
			}
			if (Model.gameModel.score > cfg.needScore)
			{
				bar.getChild("star1").grayed = false;
			}
		}

		private function onAimChange(_arg_1:*):void
		{
//			MsgDispatcher.execute(GameEvents.AIMS_CHANGE, { //
//				"type": _arg_1, //
//				"value": this.aim[_arg_1], //
//				"orgValue": this.aimOrg[_arg_1]});
			if (_arg_1.type == AimType.SCORE)
			{
				return;
			}
			var aimView:GComponent = aimViews[_arg_1.type];
			aimView.getChild("value").text = (_arg_1.orgValue - _arg_1.value) + "";
			if (_arg_1.orgValue - _arg_1.value == 0)
			{
				aimView.getTransition("t1").play(function():void
				{
					aimView.visible = false;
				});
			}
			else
			{
				aimView.getTransition("t0").play(function():void
				{
					aimView.getTransition("t2").play(null, null, -1);
				});
			}
		}

		override public function dispose():void
		{
			super.dispose();
			view.dispose();
			trace("dispose!!!!");
		}
	}
}

