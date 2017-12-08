package diary.ui.view
{
	import com.greensock.TweenLite;
	import com.greensock.TweenNano;
	import com.greensock.easing.Back;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import diary.avatar.AnimationTicker;
	import diary.avatar.Avatar;
	import diary.avatar.AvatarBoy;
	import diary.avatar.AvatarGirl;
	import diary.avatar.RotationComponent;
	import diary.services.ScreenShot;
	import diary.ui.Carousel;
	
	import fairygui.GButton;
	import fairygui.GComponent;
	import fairygui.GImage;
	import fairygui.GList;
	import fairygui.GRoot;
	import fairygui.UIPackage;
	import fairygui.event.GTouchEvent;
	import fairygui.event.ItemEvent;
	import fairygui.event.StateChangeEvent;
	
	import flare.core.Camera3D;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import zzsdk.utils.FileUtil;

	public class GameScreen extends GScreen implements IScreen
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
		
		private var back:Sprite
		private var backImage:Image;
		private var backList:Carousel;
		private var avatarlist:Object = {};

		public function GameScreen()
		{
			json = FileUtil.open("gameconfig", "AMF");
			iconAtlas = new TextureAtlas( //
				Texture.fromAtfData(FileUtil.open("icon/texture.atf")), //
				XML(FileUtil.open("icon/texture.xml", "text")));
		}
		
		
		override public function createLayer(name:String):*
		{
			if(name == "front")
				return super.createLayer(name);
			else if(name == "back")
			{
				if (back == null)
				{
					back = new Sprite;
					backList = new Carousel;
					var images:Array = [];
					var len:int = 5;
					for (var i:int = 1; i <= len; i++)
					{
						images.push("bg0" + (i) + ".png");
					}
					
					backList.setImages(images);
					backImage = new Image(Texture.empty(480, 800));
					back.addChild(backImage);
					back.addChild(backList);
				}
				return back;
			}
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
			snapAtlas = new BitmapData(GRoot.inst.width, GRoot.inst.height, false, 0);
			setGView("zz3d.dressup.gui", "Dressup");
			transferTo("game", function():void
			{
				getChild("leftBar").asCom.getController("c1").selectedIndex = 1;
				getChild("background").asImage.visible = false;
				addAvatar("girl");
				addBackground();
			});

			getChild("leftBar").asCom.getController("c1").addEventListener(StateChangeEvent.CHANGED, function():void
			{
				var cat:String = getChild("leftBar").asCom.getController("c1").selectedPage;
				var list:GList = getChild("rightBar").asCom.getChild("list").asList;
				var shopList:GList = getChild("shopList").asList;
				list.setVirtual();
				shopList.setVirtual();
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
			getChild("rightBar").asCom.getChild("list").asList.addEventListener(ItemEvent.CLICK, function(event:ItemEvent):void
			{
				var list:GList = getChild("rightBar").asCom.getChild("list").asList
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

			//prepare ad
			transferTo("map");
		}
		
		public function addAvatar(name:String, gender:String="girl"):void
		{
			if (avatarlist[name] != null)
				return;
			var avatar:Avatar = gender == "girl" ? new AvatarGirl : new AvatarBoy;
			
			avatar.addComponent(new RotationComponent);
			avatar.addComponent(new AnimationTicker);
			
			scene.addChild(avatar);
			scene.camera.setPosition(0, 195, -450);
			scene.camera.setRotation(12, 0, 0);
			scene.camera.fovMode = Camera3D.FOV_VERTICAL;
			scene.camera.fieldOfView = 28;
			
			avatarlist[name] = avatar
		}
		
		public function getAvatar(name):Avatar
		{
			return avatarlist[name]
		}
		
		public function updatePart(id:String):void
		{
			avatar.updatePart(id, true);
		}
		
		public function zoom(zoomIn:Boolean):void
		{
			if (zoomIn)
			{
				TweenLite.killTweensOf(scene);
				TweenLite.killTweensOf(backList);
				TweenLite.to(scene.camera, 0.25, {fieldOfView: 11, //
					x: -3, //
					y: 230});
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
				TweenLite.killTweensOf(scene);
				TweenLite.killTweensOf(backList);
				TweenLite.to(scene.camera, 0.25, {fieldOfView: 28, //
					x: 0, //
					y: 195});
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
			TweenLite.to(back, 0.5, {x: 0.1});
			backImage.texture = Texture.fromTexture(UIPackage.createObject("zz3d.dressup.gui", name).asImage.texture);
			backImage.visible = true;
			backList.visible = false;
			
			setTimeout(function():void
			{
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
