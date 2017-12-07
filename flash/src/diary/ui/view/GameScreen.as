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
		public function startButtonClick():void
		{
			transferTo("map");
			//			UIConfig.scrollAniTweenTime = 1.2;
			var world:GComponent = getChild("worldmap").asCom;
			var width:int = GRoot.inst.width;
			var height:int = GRoot.inst.height;
			world.setSize(width, height);
			
			var offset:int = 0;
			var scale:Number = 1;
			for (var i:int = 0; i < world.numChildren; i++)
			{
				var child:GImage = world.getChildAt(i) as GImage;
				if (child == null)
					break;
			}
			for (i -= 1; i >= 0; i--)
			{
				child = world.getChildAt(i) as GImage;
				scale = width / child.width;
				child.width = Math.round(width);
				child.height *= scale;
				child.height = Math.round(height);
				child.y = Math.round(offset);
				offset += child.height;
			}
		}
		
		[Handler(clickGTouch)]
		public function yesButtonClick():void
		{
			transferTo("show", function():void
			{
				removeBackground();
			});
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
				transferTo("map");
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

		override protected function onCreate():void
		{
			snapAtlas = new BitmapData(GRoot.inst.width, GRoot.inst.height, false, 0);
			setGView("zz3d.dressup.gui", "Root")
			fit(getChild("tpage").asLoader);

			setupWorldmapSize();
			setupWorldmap();
			updateWorldMap();

			getChild("hanger").asButton.addClickListener(function():void
			{
				getTransition("t5").play();
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
		
		private function setupWorldmapSize():void
		{
			var world:GComponent = getChild("worldmap").asCom;
			var width:int = GRoot.inst.width;
			var height:int = GRoot.inst.height;
			world.setSize(width, height);
			
			var offset:int = 0;
			var scale:Number = 1;
			for (var i:int = 0; i < world.numChildren; i++)
			{
				var child:GImage = world.getChildAt(i) as GImage;
				if (child == null)
					break;
			}
			for (i -= 1; i >= 0; i--)
			{
				child = world.getChildAt(i) as GImage;
				scale = width / child.width;
				child.width = Math.round(width);
				child.height *= scale;
				child.height = Math.round(height);
				child.y = Math.round(offset);
				offset += child.height;
			}
		}
		
		private function setupWorldmap():void
		{
			var n:int = getChild("worldmap").asCom.numChildren;
			var worldMapCom:GComponent = getChild("worldmap").asCom;
			worldMapButtons = [];
			for (var i:int = 0; i < n; i++)
			{
				var button:GButton = worldMapCom.getChildAt(i).asButton;
				if (!button)
					continue;
				worldMapButtons.push(button);
				button.addEventListener(GTouchEvent.CLICK, function(event:GTouchEvent):void
				{
					var b:GButton = event.currentTarget as GButton;
					var index:int = worldMapButtons.indexOf(b);
					transferTo("game", function():void
					{
						getChild("leftBar").asCom.getController("c1").selectedIndex = 1;
						getChild("background").asImage.visible = false;
						addAvatar("girl");
						addBackground();
					});

					trace("clicked: " + index);
				})
			}
			worldMapButtons.sort(function(up:GButton, down:GButton):int
			{
				if (up.y > down.y)
					return -1
				if (up.y < down.y)
					return 1
				return 0;
			});
		}

		private function updateWorldMap():void
		{
			for (var i:int = 0; i < numSceneOpen; i++)
			{
				GButton(worldMapButtons[i]).enabled = true;
			}
			for (var i:int = numSceneOpen; i < worldMapButtons.length; i++)
			{
				GButton(worldMapButtons[i]).enabled = false;
			}
		}
		
		public function addAvatar(name:String):void
		{
			if (avatarlist[name] != null)
				return;
			avatar = new Avatar;
			
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
