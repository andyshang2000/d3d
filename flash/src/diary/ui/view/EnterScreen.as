package diary.ui.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.utils.DataUtil;
	import com.popchan.sugar.core.Model;
	import com.popchan.sugar.core.manager.Sounds;
	
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	
	import fairygui.UIPackage;
	
	import payment.ane.PaymentANE;
	
	import starling.utils.AssetManager;
	
	import zzsdk.utils.FileUtil;

	public class EnterScreen extends GScreen implements IScreen
	{
		private var firstRun:Boolean;

		override protected function loadAssets():void
		{
			var _local_1:AssetManager = Core.texturesManager;
//			enqueue(_local_1, "assets/textures/card.png");
//			enqueue(_local_1, "assets/textures/card.xml");
//			enqueue(_local_1, "assets/textures/ui02.png");
//			enqueue(_local_1, "assets/textures/ui02.xml");
//			enqueue(_local_1, "assets/effect.png");
//			enqueue(_local_1, "assets/effect.xml");
//			enqueue(_local_1, "assets/textures/gameui.png");
//			enqueue(_local_1, "assets/textures/gameui.xml");
//			enqueue(_local_1, "assets/textures/game01.png");
//			enqueue(_local_1, "assets/textures/game01.xml");
//			enqueue(_local_1, "assets/textures/game02.png");
//			enqueue(_local_1, "assets/textures/game02.xml");
//			enqueue(_local_1, "assets/textures/game03.png");
//			enqueue(_local_1, "assets/textures/game03.xml");
			_local_1.enqueue((("assets/level/Level" + 105) + ".xml"));
			_local_1.enqueue((("assets/level/Level" + 216) + ".xml"));
			var _local_2:int;
			while (_local_2 <= 20)
			{
				_local_1.enqueue((("assets/level/Level" + _local_2) + ".xml"));
				_local_2++;
			}
			;
			_local_2 = 0;
			_local_1.verbose = false;
			_local_1.loadQueue(this.onLoadProgress);
			DataUtil.id = "com.popchanniuniu.bubble410";
			DataUtil.load(DataUtil.id);
			Model.levelModel.loadData();
			Sounds.init();
//			GameModule.getInstance().init();
//			EndModule.getInstance().init();
		}

		private function enqueue(_local_1:AssetManager, asset:String):void
		{
			_local_1.enqueue(asset);
		}
//
//			if (asset is String)
//			{
//				if (asset.indexOf("assets/textures") == 0)
//				{
//					if (asset.indexOf("xml") == asset.length - 3)
//					{
//						var loader:Loader = new Loader();
//						loader.loadBytes(FileUtil.readFile(asset.replace("xml", "png")));
//						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
//						{
//							parseAtlasXml(XML(FileUtil.readFile(asset, "text")) as XML, loader.content);
//						})
//					}
//				}
//			}
//		}
//
//		protected function parseAtlasXml(atlasXml:XML, bitmapData:*):void
//		{
//			var scale = 1;
//			var region:Rectangle = new Rectangle();
//			var frame:Rectangle = new Rectangle();
//
//			for each (var subTexture:XML in atlasXml.SubTexture)
//			{
//				var name:String = StringUtil.clean(subTexture.@name);
//				var x:Number = parseFloat(subTexture.@x) / scale;
//				var y:Number = parseFloat(subTexture.@y) / scale;
//				var width:Number = parseFloat(subTexture.@width) / scale;
//				var height:Number = parseFloat(subTexture.@height) / scale;
//				var frameX:Number = parseFloat(subTexture.@frameX) / scale;
//				var frameY:Number = parseFloat(subTexture.@frameY) / scale;
//				var frameWidth:Number = parseFloat(subTexture.@frameWidth) / scale;
//				var frameHeight:Number = parseFloat(subTexture.@frameHeight) / scale;
//				var rotated:Boolean = StringUtil.parseBoolean(subTexture.@rotated);
//
//				region.setTo(x, y, width, height);
//				frame.setTo(frameX, frameY, frameWidth, frameHeight);
//
//				if (frameWidth > 0 && frameHeight > 0)
//					addRegion(bitmapData, name, region, frame, rotated);
//				else
//					addRegion(bitmapData, name, region, null, rotated);
//			}
//		}
//
//		private function addRegion(source:*, name:String, region:Rectangle, frame:Rectangle, rotated:Boolean):void
//		{
//			if (frame == null)
//			{
//				frame = region.clone();
//				frame.x = 0;
//				frame.y = 0;
//			}
//			var dst:BitmapData = new BitmapData(frame.width, frame.height, true, 0);
//			var matrix:Matrix = new Matrix();
//			if (rotated)
//			{
////				matrix.translate(0,-1)
//				matrix.rotate(Math.PI / 2);
//			}
////			matrix.scale(region.width / frame.width, region.height / frame.height);
////			frame.x += region.x;
////			frame.y += region.y;
//			matrix.translate(-region.x, -region.y);
//			region.x = 0;
//			region.y = 0;
//			dst.draw(source, matrix, null, null, region);
//			if (frame.x != 0 || frame.y != 0)
//			{
//				source = dst;
//				dst = dst.clone();
//				dst.fillRect(dst.rect, 0);
//				dst.draw(source, new Matrix(1, 0, 0, 1, -frame.x, -frame.y), null, null);
//			}
//			FileUtil.save(dst.encode(dst.rect, new PNGEncoderOptions()), "output/textures/" + name + ".png");
//			dst.dispose();
//		}

		private function onLoadProgress(ratio:Number):void
		{
			if (ratio == 1)
			{
				FileUtil.dir = File.applicationDirectory;
				doLoadAssets();
				UIPackage.waitToLoadCompleted(initializeHandler);
				FileUtil.dir = File.applicationStorageDirectory;
			}
		}

		override protected function doLoadAssets():void
		{
			UIPackage.addPackage( //
				FileUtil.open("zz3d.dressup.gui"), //
				FileUtil.open("zz3d.dressup@res.gui"));
			UIPackage.addPackage( //
				FileUtil.open("zz3d.m3.gui"), //
				FileUtil.open("zz3d.m3@res.gui"));
		}

		override public function createLayer(name:String):*
		{
			if (name == "front")
				return super.createLayer(name);
			return null;
		}

		[Handler(clickGTouch)]
		public function startButtonClick():void
		{
			if (firstRun)
				nextScreen(GameScreen);
			else
				nextScreen(MapScreen);
		}

		override protected function onCreate():void
		{
			setGView("zz3d.dressup.gui", "Enter");

			fit(getChild("tpage").asLoader);
			try
			{
				PaymentANE.call("ready");
			}
			catch (err:Error)
			{
			}
			//prepare ad
			transferTo("transpage");
			setTimeout(function():void
			{
				transferTo("start");
			}, 2000);
		}
	}
}

