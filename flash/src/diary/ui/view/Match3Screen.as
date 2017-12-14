package diary.ui.view
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
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
	import fairygui.GList;
	import fairygui.GRoot;
	import fairygui.UIObjectFactory;
	import fairygui.UIPackage;
	import fairygui.Window;
	
	import flare.core.Camera3D;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.TextSprite;
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
		private var aimDic:Array = [];

		override protected function onCreate():void
		{
			UIObjectFactory.setPackageItemExtension("ui://zz3d.m3.gui/GamePanel", GamePanel);

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
				var win:Window = new Window();
				win.contentPane = UIPackage.createObject("zz3d.m3.gui", "EndPanel").asCom;
				Model.gameModel.isScoreAimLevel()
				win.contentPane.getTransition("t0").play();
				win.contentPane.getTransition("t1").play();
				win.contentPane.getTransition("t2").play();
				GRoot.inst.showPopup(win);
			});
		}

		private function setupCircle():void
		{
			var bar:GComponent = getChild("progressBar").asCom;
			bar.getChild("bar").rotation = 20;
			bar.getChild("bar").asMovieClip.playing = false;
			var a = function():void
			{
//				bar.getChild("bar").asMovieClip.playing = false;
//				bar.getChild("bar").asMovieClip.setPlaySettings(0, -1, 30, -1, function():void
//				{
//					setTimeout(a, 3000);
//				});
			};
			a();
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
			view.y = port.bottom - actualWidth - 10;
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
		public function returnButtonClick():void
		{
			nextScreen(MapScreen);
		}

		public function setInfo(_arg_1:LevelCO):void
		{
			var _local_7:Array;
			var aimID:int;
			var amiOrg:int;
			if (_arg_1.mode == GameMode.NORMAL)
			{
				Model.gameModel.step = (_arg_1.step);
			}
			else if (_arg_1.mode == GameMode.TIME)
			{
				Model.gameModel.time = (_arg_1.step);
			}

			getChild("aimList").asList.itemRenderer = function(i:int, item:GComponent):void
			{
				_local_7 = _arg_1.aim[i].split(",");
				aimID = int(_local_7[0]);
				amiOrg = int(_local_7[1]);
				Model.gameModel.addAim(aimID, amiOrg);
				new XImage(item.getChild("icon").asImage).texture2 = AimType.AIM_ICONS[aimID];
				aimDic[aimID] = item;
				item.getChild("value").asTextField.text = amiOrg + "";
			};
			getChild("aimList").asList.numItems = _arg_1.aim.length;
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
			var list:GList = getChild("aimList").asList
			var item:GComponent = aimDic[_arg_1.type];
			item.getChild("value").text = (_arg_1.orgValue - _arg_1.value) + "";
			if (_arg_1.orgValue - _arg_1.value == 0)
			{
				TweenLite.to(item, 0.8, {scaleX:0.1, scaleY:0.1, ease:Back.easeIn, onComplete:function():void
				{
					item.visible = false;
				}});
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

