package diary.ui.view
{
	import com.greensock.TweenLite;

	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	import diary.avatar.AnimationTicker;
	import diary.avatar.Avatar;
	import diary.avatar.RotationComponent;
	import diary.ui.Carousel;

	import fairygui.GComponent;
	import fairygui.GLoader;
	import fairygui.GObject;
	import fairygui.GRoot;
	import fairygui.UIPackage;

	import flare.basic.Scene3D;
	import flare.core.Camera3D;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;

	import zzsdk.display.Screen;
	import zzsdk.utils.FileUtil;

	public class GameUI extends ViewBase implements IScreen
	{
		public var gView:GComponent;

		private var designWidth:int = 480;
		private var designHeight:int = 800;
		private var scene:Scene3D;
		private var back:Sprite
		private var backImage:Image;
		private var backList:Carousel;
		private var avatar:Avatar;
		private var avatarlist:Object = {};

		public function getFront():Sprite
		{
			return GRoot.inst.displayObject as Sprite;
		}

		public function getBack():Sprite
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

		public static function getFitRect(obj:*, scale:Number = 1.0):Rectangle
		{
			var port:Rectangle;
			var target:Rectangle;
			var result:Rectangle;
			if (obj is GLoader)
			{
				port = new Rectangle(0, 0, obj.initWidth, obj.initHeight);
				target = new Rectangle(0, 0, GRoot.inst.width, GRoot.inst.height);
			}
			else if (obj is GObject)
			{
				port = new Rectangle(0, 0, obj.width, obj.height);
				target = new Rectangle(0, 0, GRoot.inst.width, GRoot.inst.height);
			}
			else
			{
				port = new Rectangle(0, 0, obj.width, obj.height);
				target = Screen.fullscreenPort.clone();
			}
			if (scale != 1.0)
			{
				var second:Rectangle = target.clone();
				second.inflate(target.width * (scale - 1), target.height * (scale - 1));
				target = second;
			}
			result = RectangleUtil.fit(port, target, ScaleMode.NO_BORDER);
			return result;
		}

		public static function fit(obj:*):void
		{
			var result:Rectangle = getFitRect(obj);
			if (obj is GLoader)
			{
				GLoader(obj).setXY(result.x, result.y);
				GLoader(obj).setScale(result.width / obj.initWidth, result.height / obj.initHeight);
			}
			else if (obj is GObject)
			{
				obj.setXY(result.x, result.y);
				obj.setSize(result.width, result.height);
			}
			else
			{
				obj.x = result.x;
				obj.y = result.y;
				obj.width = result.width;
				obj.height = result.height;
			}
		}

		public function addBackground():void
		{
			TweenLite.to(back, 0.5, {x: 0.1});
			backImage.texture = Texture.fromTexture(UIPackage.createObject("zz3d.dressup.gui", "bedroom2").asImage.texture);
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

		public function nextBackground():void
		{
			backList.next();
		}

		public function prevBackground():void
		{
			backList.prev();
		}

		public function update3D(scene:Scene3D):void
		{
			this.scene = scene;
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

		override protected function doLoadAssets():void
		{
			FileUtil.dir = File.applicationDirectory;
			UIPackage.addPackage( //
				FileUtil.open("zz3d.dressup.gui.zip"), //
				FileUtil.open("zz3d.dressup.gui@res.zip"));
			UIPackage.waitToLoadCompleted(onAssetsLoaded);
			FileUtil.dir = File.applicationStorageDirectory;
		}
	}
}
