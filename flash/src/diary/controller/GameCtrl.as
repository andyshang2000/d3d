package diary.controller
{
	import com.greensock.TweenLite;
	import com.greensock.TweenNano;
	import com.greensock.easing.Back;

	import flash.display.BitmapData;
	import flash.utils.setTimeout;

	import diary.avatar.Avatar;
	import diary.services.ScreenShot;
	import diary.ui.view.GameUI;
	import diary.ui.view.IScreenCtrl;

	import fairygui.GButton;
	import fairygui.GComponent;
	import fairygui.GImage;
	import fairygui.GList;
	import fairygui.GRoot;
	import fairygui.UIConfig;
	import fairygui.event.GTouchEvent;
	import fairygui.event.ItemEvent;
	import fairygui.event.StateChangeEvent;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import zzsdk.utils.FileUtil;

	public class GameCtrl extends GScreen implements IScreenCtrl
	{
		private var view:GameUI;
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

		public function GameCtrl(view:GameUI)
		{
			super(view);
			this.view = view;
			json = FileUtil.open("gameconfig", "AMF");
			iconAtlas = new TextureAtlas( //
				Texture.fromAtfData(FileUtil.open("icon/texture.atf")), //
				XML(FileUtil.open("icon/texture.xml", "text")));
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
			world.scrollPane.scrollBottom(true);
		}

		[Handler(clickGTouch)]
		public function backButtonClick():void
		{
			transferTo("map");
		}

		[Handler(clickGTouch)]
		public function yesButtonClick():void
		{
			getTransition("t1").play(function():void
			{
				transferTo("show");
				view.removeBackground();
			});
		}

		[Handler(clickGTouch)]
		public function showLeftButtonClick():void
		{
			view.prevBackground();
		}

		[Handler(clickGTouch)]
		public function showRightButtonClick():void
		{
			view.nextBackground();
		}

		[Handler(clickGTouch)]
		public function returnButtonClick():void
		{
			transferTo("game", function():void
			{
				view.addBackground();
			});
		}

		[Handler(clickGTouch)]
		public function cancelButtonClick():void
		{
			getChild("photoFrame").visible = false;
			getChild("photoButton").visible = true;
			getChild("cancelButton").asButton.visible = false;
			getChild("nextSceneButton").asButton.visible = false;
			restore("photoFrame")
		}

		[Handler(clickGTouch)]
		public function nextSceneButtonClick():void
		{
			getChild("cancelButton").asButton.visible = false;
			getChild("nextSceneButton").asButton.visible = false;
			restore("photoFrame")
			try
			{
				//					PaymentANE.call("saveImage", snapAtlas.encode(snapAtlas.rect, new JPEGXREncoderOptions(75)));
				getTransition("t3").play(function():void
				{
					getChild("photoButton").visible = true;
					getChild("photoFrame").visible = false;
					restore("photoFrame")
				});
			}
			catch (err:Error)
			{
				getChild("photoFrame").visible = false;
			}
		}

		[Handler(clickGTouch)]
		public function cameraButtonClick():void
		{
			saveRect("photoFrame");
			GRoot.inst.visible = false;
			ScreenShot.draw(snapAtlas, null, ["back", "avatar"], function():void
			{
				GRoot.inst.visible = true;
				var t:Texture = Texture.fromBitmapData(snapAtlas);
				getChild("photoFrame").asCom.getChild("image").asImage.texture = t; //
				getChild("photoFrame").visible = true;

				TweenLite.to(getChild("photoFrame"), 0.5, {x: 0, y: 0, width: GRoot.inst.width, height: GRoot.inst.height, ease: Back.easeOut, onComplete: function():void
				{
					getChild("cancelButton").asButton.visible = true;
					getChild("nextSceneButton").asButton.visible = true;
					getChild("photoButton").asCom.getChild("image").asImage.texture = t;
				}});
			});
		}

		[Handler(clickGTouch)]
		public function zoomSwitchButtonClick():void
		{
			view.zoom(getChild("zoomSwitchButton").asButton.selected);
		}

		override protected function onCreate():void
		{
			snapAtlas = new BitmapData(GRoot.inst.width, GRoot.inst.height, false, 0);
			setGView("zz3d.dressup.gui", "Root")
			GameUI.fit(getChild("tpage").asLoader);

			setupWorldmap();
			updateWorldMap();

			getChild("leftBar").asCom.getController("c1").addEventListener(StateChangeEvent.CHANGED, function():void
			{
				var cat:String = getChild("leftBar").asCom.getController("c1").selectedPage;
				var list:GList = getChild("rightBar").asCom.getChild("list").asList;
				list.setVirtual();
				list.itemRenderer = function(i:int, renderer:GComponent):void
				{
					var item:* = json["game"][cat][i]["id"];
					var image:GImage = renderer.getChild("image").asImage;
					image.texture = iconAtlas.getTexture(item);
				}
				if (json["game"][cat] != null)
				{
					list.numItems = json["game"][cat].length;
				}
				else
				{
					list.numItems = 0;
				}
				getTransition("t2").play();
			});
			getChild("rightBar").asCom.getChild("list").asList.addEventListener(ItemEvent.CLICK, function(event:ItemEvent):void
			{
				var list:GList = getChild("rightBar").asCom.getChild("list").asList
				var i:int = list.childIndexToItemIndex(list.getChildIndex(event.itemObject));
				var cat:String = getChild("leftBar").asCom.getController("c1").selectedPage;
				var id:String = json["game"][cat][i]["id"];
				view.updatePart(id);
			});

			//prepare ad
			transferTo("transpage");
			setTimeout(function():void
			{
				transferTo("start");
			}, 2000);
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
						view.addAvatar("girl");
						view.addBackground();
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

		private function transferTo(target:String, onCompleteHandler:Function = null):void
		{
			getChild("transferMask").asGraph.visible = true;
			getChild("transferMask").asGraph.alpha = 0;
			TweenNano.to(getChild("transferMask").asGraph, 0.25, {alpha: 1, onComplete: function():void
			{
				getController("sceneControl").selectedPage = target;
				if (onCompleteHandler != null)
				{
					onCompleteHandler();
				}
			}})
			TweenNano.to(getChild("transferMask").asGraph, 0.25, {alpha: 0, delay: 0.3, onComplete: function():void
			{
				getChild("transferMask").asGraph.visible = false;
			}});
		}
	}
}
