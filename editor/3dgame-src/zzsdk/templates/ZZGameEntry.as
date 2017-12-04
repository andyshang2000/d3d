package zzsdk.templates
{
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import nblib.util.Tracker;
	import nblib.util.callLater;
	import nblib.util.res.ResLoaderNames;
	import nblib.util.res.ResManager;
	
	import zzsdk.display.Screen;
	import zzsdk.game.conf.GameConfig;
	import zzsdk.misc.SimpleAnalysis;
	import zzsdk.utils.SystemUtil;

	public class ZZGameEntry extends AppBase
	{
		public static var videoObj:MovieClip;
		private var videoContainer:Sprite = new Sprite;
		private var videoClass:Class;
		private var animationEnd:Boolean;
		private var gameReady:Boolean;
		private var bgShape:Shape;
		private var loadingText:TextField;
		public function ZZGameEntry(videoClass:Class)
		{
			this.videoClass = videoClass;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		protected function onVideoLastFrame():void
		{
		}

		protected function onPreloadVideoLoaded():void
		{
		}

		/**
		 *
		 * @param resTxt
		 *
		 */
		protected function boot(resTxt:String = null):void
		{
			if (totalFrames == 2)
			{
				if (currentFrame == 1)
				{
					nextFrame();
					setTimeout(boot, 10, resTxt);
					return;
				}
			}
			trace("cannot use settimeout?");
			if (!resTxt || !File.applicationDirectory.resolvePath(resTxt).exists)
			{
				stage.addChild(new (getDefinitionByName("frame02")));
			}
			else
			{
				ResManager.getResAsync(resTxt, function(res:GameConfig):void
				{
					if (res.errorCode == 0)
					{
						boot();
					}
					else
					{
						debug("error occured when loading resources:" + res.errorCode);
					}
				}, ResLoaderNames.DoubleThreading, GameConfig);
			}
		}

		private function addedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
			stage.addEventListener("gameReady", removeVideo);
			//
			Screen.initialize(stage);
			drawBg();
			if (Capabilities.os.toLowerCase().indexOf("win") == -1)
			{
				Tracker.initialize("UA-60853528-2");
			}
			GameInfo.isDebug = File.applicationDirectory.resolvePath("ip.txt").exists;

			if (!videoClass)
				return;
			//
			var loader:Loader = new Loader;
			var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			lc.allowCodeImport = true;
			loader.loadBytes(new videoClass, lc);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, arguments.callee);
				videoObj = loader.content as MovieClip;
				videoObj.gotoAndPlay(1);
				onPreloadVideoLoaded();
				//开场动画的最后一帧
				videoObj.addFrameScript(videoObj.totalFrames - 1, function():void
				{
					addLoading();
					videoObj.stop();
					animationEnd = true;
					if (gameReady)
					{
						removeVideo();
					}
					onVideoLastFrame();
				});

				videoContainer.addChild(videoObj);
				stage.addChild(videoContainer);
				videoContainer.x = (Screen.STAGE_WIDTH - videoContainer.width) / 2;
				videoContainer.y = (Screen.STAGE_HEIGHT - videoContainer.height) / 2;				
			});
		}

		private function removeVideo(event:Event = null):void
		{
			gameReady = true;
			if (animationEnd)
			{
				if (videoContainer.parent)
				{
					videoContainer.parent.removeChild(videoContainer);
					SimpleAnalysis.getInstance().setAnalytics(GameInfo.managedID, GameInfo.managedID + ".analysis");
				}
			}
			removeBg();
			removeLoading();
		}
		private function drawBg():void
		{
			bgShape = new Shape();
			bgShape.graphics.beginFill(0xffffff);
			bgShape.graphics.drawRect(0,0,Screen.STAGE_WIDTH,Screen.STAGE_HEIGHT);
			bgShape.graphics.endFill();
			stage.addChild(bgShape);
			
		}
		private function removeBg():void
		{
			if(bgShape && bgShape.parent)
			{
				bgShape.parent.removeChild(bgShape);
				bgShape.graphics.clear();
				bgShape = null;
			}
			
		}
		private function addLoading():void
		{
			loadingText = new TextField();
			stage.addChild(loadingText);
			loadingText.text = "Loading...";
			loadingText.autoSize =  TextFieldAutoSize.CENTER;
			loadingText.setTextFormat(new TextFormat(null,30));
			loadingText.x = (stage.fullScreenWidth - loadingText.width)/2;
			loadingText.y = videoContainer.y + videoContainer.height -100;
		}
		private function removeLoading():void
		{
			if(loadingText && loadingText.parent)
			{
				loadingText.text = "";
				loadingText.parent.removeChild(loadingText);
				loadingText = null;
			}
		}
	}
}
