package diary.ui.view
{
	import com.popchan.framework.core.MsgDispatcher;
	import com.popchan.sugar.core.Model;
	import com.popchan.sugar.core.cfg.Config;
	import com.popchan.sugar.core.cfg.levels.LevelCO;
	import com.popchan.sugar.core.data.AimType;
	import com.popchan.sugar.core.data.GameConst;
	import com.popchan.sugar.core.data.GameMode;
	import com.popchan.sugar.core.events.GameEvents;
	import com.popchan.sugar.modules.game.view.GamePanel;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	import diary.avatar.Avatar;

	import fairygui.GComponent;
	import fairygui.GImage;
	import fairygui.GRoot;
	import fairygui.UIPackage;
	import fairygui.Window;

	import starling.display.Image;
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

		override protected function onCreate():void
		{
			setGView("zz3d.m3.gui", "Match3");
			view = new GamePanel();
			GRoot.inst.addChild(view);
//			DisplayObjectContainer(Starling.current.root).addChild(view);

//			var infoPanel:InfoPanel = new InfoPanel();
//			GRoot.inst.nativeStage.addChild(infoPanel);
//			view.infoPanel = infoPanel;
//			view.infoPanel.setInfo(Config.levelConfig.getLevel(Model.levelModel.selectedLevel));

			var initWidth:int = GameConst.CARD_W * 9;
			var initHeight:int = GameConst.CARD_W * 9;
			var port480x800:Rectangle = new Rectangle(0, 0, 480, 800);
			var port:Rectangle = RectangleUtil.fit(port480x800, new Rectangle(10, 0, GRoot.inst.width - 20, GRoot.inst.height));

			view.scaleX = port.width / initWidth;
			view.scaleY = port.width / initWidth;
			var actualWidth:int = initWidth * view.scaleX;
			view.x = port.x;
			view.y = port.bottom - actualWidth - 10;

			MsgDispatcher.add(GameEvents.AIMS_CHANGE, this.onAimChange);
			MsgDispatcher.add(GameEvents.SCORE_CHANGE, this.onScoreChange);
			MsgDispatcher.add(GameEvents.STEP_CHANGE, this.onStepChange);
			MsgDispatcher.add(GameEvents.TIME_CHANGE, this.onTimeChange);

			var rect:Rectangle

			view.init();
			view.newGame(Config.levelConfig.getLevel(Model.levelModel.selectedLevel));
			setInfo(Config.levelConfig.getLevel(Model.levelModel.selectedLevel));

			addAvatar("girl");
			addBackground();

			MsgDispatcher.add(GameEvents.OPEN_GAME_END_UI, function():void
			{
				var win:Window = new Window();
				win.contentPane = UIPackage.createObject("zz3d.m3.gui", "EndPanel").asCom;
//				win.contentPane.getChild(
				GRoot.inst.showPopup(win);
			});
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
			var _local_2:Image;
			var _local_3:*;
			var _local_6:TextSprite;
			var _local_7:Array;
			var _local_8:int;
			var _local_9:int;
			var _local_10:TextSprite;
//			this.scoreAim = _arg_1.needScore;
//			for (_local_3 in aimIconDict)
//			{
//				_local_2 = this.aimIconDict[_local_3];
//				_local_2.removeFromParent(true);
//				_local_2 = null;
//				delete this.aimIconDict[_local_3];
//			};
//			for (_local_3 in aimLabelDict)
//			{
//				_local_6 = this.aimLabelDict[_local_3];
//				_local_6.removeFromParent(true);
//				_local_6 = null;
//				delete this.aimLabelDict[_local_3];
//			};
			if (_arg_1.mode == GameMode.NORMAL)
			{
				Model.gameModel.step = (_arg_1.step + 10);
			}
			else
			{
				if (_arg_1.mode == GameMode.TIME)
				{
					Model.gameModel.time = (_arg_1.step + 15);
				}
			}
			var _local_4:int;
			if (_arg_1.aim.length == 1)
			{
				_local_4 = 300;
			}
			else
			{
				if (_arg_1.aim.length == 2)
				{
					_local_4 = 240;
				}
				else
				{
					if (_arg_1.aim.length == 3)
					{
						_local_4 = 200;
					}
				}
			}
			var _local_5:int;
			while (_local_5 < _arg_1.aim.length)
			{
				_local_7 = _arg_1.aim[_local_5].split(",");
				_local_8 = int(_local_7[0]);
				_local_9 = int(_local_7[1]);
				Model.gameModel.addAim(_local_8, _local_9);
//				_local_2 = new Image(Texture.fromTexture(Core.getTexture(AimType.AIM_ICONS[_local_8])));
//				_local_2.pivotY = (_local_2.height >> 1);
//				if (_local_8 != AimType.SCORE)
//				{
//					_local_2.pivotX = (_local_2.width >> 1);
//					_local_2.scaleX = (_local_2.scaleY = 0.6);
//				}
//				else
//				{
//					_local_2.pivotX = _local_2.width;
//				};
//				_local_2.x = ((_local_4 + (_local_5 * 80)) + 30);
//				_local_2.y = 31;
//				this.addChild(_local_2);
//				this.aimIconDict[_local_8] = _local_2;
//				_local_10 = ToolKit.createTextSprite(this, Core.getTextures("font1_"), 0, 0, 16, "0123456789/x+-");
//				addChild(_local_10);
//				_local_10.text = (_local_9 + "");
//				_local_10.x = ((_local_4 + 45) + (_local_5 * 80));
//				_local_10.y = 23;
//				this.aimLabelDict[_local_8] = _local_10;
				_local_5++;
			}
		}

		private function onTimeChange():void
		{
			// TODO Auto Generated method stub

		}

		private function onStepChange():void
		{
//			getChild("stepsRemain").text = (Model.gameModel.step + "");
		}

		private function onScoreChange():void
		{
			// TODO Auto Generated method stub
		}

		private function onAimChange(_arg_1:*):void
		{
			if (_arg_1.type == AimType.SCORE)
			{
				return;
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

