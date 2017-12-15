package diary.ui.view
{
	import com.greensock.TweenLite;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	import diary.avatar.AnimationTicker;
	import diary.avatar.Avatar;
	import diary.avatar.RandomPoseComp;
	import diary.avatar.RotationComponent;
	import diary.services.ScreenShot;
	import diary.ui.Carousel;

	import fairygui.GComponent;
	import fairygui.GImage;
	import fairygui.GList;
	import fairygui.GRoot;
	import fairygui.UIPackage;
	import fairygui.event.ItemEvent;
	import fairygui.event.StateChangeEvent;

	import flare.core.Camera3D;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import zzsdk.utils.FileUtil;

	public class GameScreen extends AvatarScreen implements IScreen
	{
		private var json:Object;

		private var iconAtlas:TextureAtlas;

		private var snapAtlas:BitmapData;
		private var snapTextures:Array = [];

		private var worldMapButtons:Array;
		private var numSceneOpen:int = 3;

		private var onInitCallback:Function = null;
		private var initialized:Boolean;

		public var leftBar:GComponent;
		private var backList:Carousel;

		public function GameScreen()
		{
			json = FileUtil.open("gameconfig", "AMF");
			iconAtlas = new TextureAtlas( //
				Texture.fromAtfData(FileUtil.open("icon/texture.atf")), //
				XML(FileUtil.open("icon/texture.xml", "text")));
		}

		[Handler(clickGTouch)]
		public function yesButtonClick():void
		{
			transferTo("show", removeBackground);
		}

		[Handler(clickGTouch)]
		public function showLeftButtonClick():void
		{
			backList.prev();
		}

		[Handler(clickGTouch)]
		public function showRightButtonClick():void
		{
			backList.next();
		}

		[Handler(clickGTouch)]
		public function returnButtonClick():void
		{
			if ("show" == getController("sceneControl").selectedPage || //
				"mall" == getController("sceneControl").selectedPage)
			{
				transferTo("game", function():void
				{
					getTransition("t5").play();
					addBackground();
				});
			}
			else if ("game" == getController("sceneControl").selectedPage)
			{
				nextScreen(MapScreen);
			}
		}

		[Handler(clickGTouch)]
		public function cancelButtonClick():void
		{
			transferTo("show", null, 0);
		}

		[Handler(clickGTouch)]
		public function nextSceneButtonClick():void
		{
			try
			{
				TweenLite.to(getChild("photoFrame"), 0.5, {rotation: -64, scaleX: 0.08, scaleY: 0.08, x: -157, y: 395, onComplete: function():void
				{
					getChild("photoFrame").visible = false;
					transferTo("show", null);
				}});
			}
			catch (err:Error)
			{
				getChild("photoFrame").visible = false;
			}
		}

		[Handler(clickGTouch)]
		public function cameraButtonClick():void
		{
			GRoot.inst.visible = false;
			ScreenShot.draw(snapAtlas, null, ["back", "avatar"], function():void
			{
				GRoot.inst.visible = true;

				var t:Texture = Texture.fromBitmapData(snapAtlas);
				getChild("photoFrame").asCom.getChild("image").asImage.texture = t; //
				getChild("photoFrame").setXY(0, 0);
				getChild("photoFrame").setScale(1, 1);
				getChild("photoFrame").setSize(GRoot.inst.width, GRoot.inst.height);
				getChild("photoFrame").rotation = 0;

				transferTo("confirm", function():void
				{
					getChild("photoFrame").visible = true;
					getChild("photoFrame").setXY(0, 0);
					getChild("photoFrame").setScale(1, 1);
					getChild("photoFrame").setSize(GRoot.inst.width, GRoot.inst.height);
					getChild("photoFrame").rotation = 0;

					getChild("cancelButton").asButton.visible = true;
					getChild("nextSceneButton").asButton.visible = true;
					getChild("cancelButton").asButton.enabled = true;
					getChild("nextSceneButton").asButton.enabled = true;
				}, 0.1, 0.1);
			});
		}

		[Handler(clickGTouch)]
		public function zoomSwitchButtonClick():void
		{
			zoom(getChild("zoomSwitchButton").asButton.selected);
		}

		[Handler(clickGTouch)]
		public function mallButtonClick():void
		{
			transferTo("mall", function():void
			{
				addBackground("mallBG");
			});
		}

		[Handler(clickGTouch)]
		public function hangerClick():void
		{
			getTransition("t5").play();
		}

		override protected function onCreate():void
		{
			var shopIndex:int = -1;

			snapAtlas = new BitmapData(GRoot.inst.width, GRoot.inst.height, false, 0);
			setGView("zz3d.dressup.gui", "Dressup");
			transferTo("game", function():void
			{
				getChild("leftBar").asCom.getController("c1").selectedIndex = 1;
				getChild("background").asImage.visible = false;
				var avatar:Avatar = addAvatar("girl");

				avatar.addComponent(rotationComp = new RotationComponent);
				avatar.addComponent(new AnimationTicker);
				avatar.addComponent(new RandomPoseComp);

				scene.camera.setPosition(0, 195, -450);
				scene.camera.setRotation(12, 0, 0);
				scene.camera.fovMode = Camera3D.FOV_VERTICAL;
				scene.camera.fieldOfView = 28;

				addBackground();
			});

			getChild("leftBar").asCom.getController("c1").addEventListener(StateChangeEvent.CHANGED, function():void
			{
				var cat:String = getChild("leftBar").asCom.getController("c1").selectedPage;
				var list:GList = getChild("rightBar").asCom.getChild("list").asList;
				var shopList:GList = getChild("shopList").asList;
				shopIndex = -1;
				shopList.itemRenderer = function(i:int, renderer:GComponent):void
				{
					var item:* = json["game"][cat][i]["id"];
					var image:GImage = renderer.getChild("image").asImage;
					image.texture = iconAtlas.getTexture(item);
				};
				list.itemRenderer = function(i:int, renderer:GComponent):void
				{
					var item:* = json["game"][cat][i]["id"];
					var image:GImage = renderer.getChild("image").asImage;
					var lock:GImage = renderer.getChild("lock").asImage;
					image.texture = iconAtlas.getTexture(item);
					lock.visible = i > 4;
				}
				if (json["game"][cat] != null)
				{
					list.numItems = json["game"][cat].length;
					shopList.numItems = json["game"][cat].length;
				}
				else
				{
					list.numItems = 0;
					shopList.numItems = 0;
				}
				getTransition("t4").play();
			});

			var list:GList = getChild("rightBar").asCom.getChild("list").asList;
			list.setVirtual();
			list.addEventListener(ItemEvent.CLICK, function(event:ItemEvent):void
			{
				var i:int = list.childIndexToItemIndex(list.getChildIndex(event.itemObject));
				var cat:String = getChild("leftBar").asCom.getController("c1").selectedPage;
				var id:String = json["game"][cat][i]["id"];

				if (i < 4)
				{
					updatePart(id);
				}
				else
				{
					transferTo("mall", function():void
					{
						addBackground("mallBG");
					});
				}
			});

			var shopList:GList = getChild("shopList").asList;
			shopList.setVirtual();
			shopList.addEventListener("itemClick", function(event:ItemEvent):void
			{
				var item:GComponent = event.itemObject.asCom;
				var i:int = shopList.childIndexToItemIndex(shopList.getChildIndex(item));
				if (shopList.selectedIndex == shopIndex)
				{
					trace(":D" + event.itemObject);
				}
				else
				{
					shopIndex = shopList.selectedIndex;
				}
			});

			backList = new Carousel;
			var images:Array = [];
			var len:int = 5;
			for (var i:int = 1; i <= len; i++)
			{
				images.push("bg0" + (i) + ".png");
			}

			backList.setImages(images);
			back.addChild(backList);
			//prepare ad
			transferTo("map");
		}

		public function zoom(zoomIn:Boolean):void
		{
			if (zoomIn)
			{
				TweenLite.killTweensOf(backList);
				getAvatar("girl").zoomIn();
				var fitRectZoomIn:Rectangle = getFitRect(backList, 1.5);
				var fitRectZoomOut:Rectangle = getFitRect(backList, 1);
				TweenLite.to(backList, 0.25, {x: fitRectZoomIn.x, //
						y: fitRectZoomIn.y, //
						scaleX: fitRectZoomIn.width / 480, //
						scaleY: fitRectZoomIn.height / 800});
				TweenLite.to(backImage, 0.25, {x: fitRectZoomIn.x, //
						y: fitRectZoomIn.y, //
						scaleX: fitRectZoomIn.width / 480, //
						scaleY: fitRectZoomIn.height / 800});
			}
			else
			{
				TweenLite.killTweensOf(backList);
				getAvatar("girl").zoomOut();
				var fitRect:Rectangle = getFitRect(backList);
				TweenLite.to(backList, 0.25, {x: fitRect.x, //
						y: fitRect.y, //
						scaleX: fitRect.width / 480, //
						scaleY: fitRect.height / 800});
				TweenLite.to(backImage, 0.25, {x: fitRect.x, //
						y: fitRect.y, //
						scaleX: fitRect.width / 480, //
						scaleY: fitRect.height / 800});
			}
		}

		public function addBackground(name:String = "bedroom2"):void
		{
			var image:GImage = UIPackage.createObject("zz3d.dressup.gui", name).asImage;
			TweenLite.to(back, 0.5, {x: 0.1});
			backImage.visible = true;
			backList.visible = false;

			setTimeout(function():void
			{
				if (image.texture == null)
				{
					setTimeout(arguments.callee, 1);
					return;
				}
				backImage.texture = Texture.fromTexture(image.texture);
				fit(backList);
				fit(backImage);
			}, 1);
		}

		public function removeBackground():void
		{
			TweenLite.to(back, 0.5, {x: 0.1});
			backImage.visible = false;
			backList.visible = true;
		}
	}
}
