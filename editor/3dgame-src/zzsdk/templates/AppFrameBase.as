package zzsdk.templates
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	import events.ServerEvent;
	
	import net.ServerMgr;
	
	import so.cuo.platform.common.CommonANE;
	
	import sui.utils.SoundManager;
	
	import zzsdk.api.SDKAPI;
	import zzsdk.display.Screen;
	import zzsdk.utils.SystemUtil;

	public class AppFrameBase extends MovieClip
	{
		private static var instance:AppFrameBase;

		public function AppFrameBase()
		{
			if (stage)
			{
				Screen.initialize(stage);
				GameInfo.isDebug = File.applicationDirectory.resolvePath("ip.txt").exists;
			}
			instance = this;
			SDKAPI.setup();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, int.MIN_VALUE);
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, errorHandler);
		}

		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			//
			trackView("gameload")
			//
			var desc:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = desc.namespace();
			var app_id:String = "" + desc.ns::id;

			if (GameInfo.isDebug)
			{
				if (SystemUtil.platform != "IOS")
				{
					ServerMgr.getInstance().addEventListener(ServerEvent.PHOTO, getPhotoHandler);
					stage.addEventListener(KeyboardEvent.KEY_UP, function(event:KeyboardEvent):void
					{
						if (event.keyCode == Keyboard.F2)
							getPhotoHandler(null);
					});
				}
			}
			else if (app_id != GameInfo.app_id)
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
				NativeApplication.nativeApplication.exit(1);
				throw new Error("invalid appid")
			}

			NativeApplication.nativeApplication.addEventListener("activate", onActive);
			NativeApplication.nativeApplication.addEventListener("deactivate", onDeactive);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys);
			//
			setupStage();
		}
		
		protected function errorHandler(e:UncaughtErrorEvent):void
		{
			if (e.error is Error)
			{
				var error:Error = e.error as Error;
				debug("error:", error.errorID, error.name, error.message);
			}
			else
			{
				var errorEvent:ErrorEvent = e.error as ErrorEvent;
				debug("errorEventID:", errorEvent.errorID);
			}
		}

		protected function setupStage():void
		{
			stage.scaleMode = GameInfo.scaleMode;
			if (stage.scaleMode == StageScaleMode.EXACT_FIT || stage.scaleMode == StageScaleMode.NO_SCALE)
			{
				stage.align = StageAlign.TOP_LEFT
			}
			else
			{
				stage.align = StageAlign.TOP;
			}
		}

		protected function getPhotoHandler(e:flash.events.Event):void
		{
			var bdata:BitmapData = getScreenBmpdata();
			var png:PNGEncoder = new PNGEncoder();
			var bytes:ByteArray = png.encode(bdata);
			var pack:ByteArray = new ByteArray;
			pack.writeUTF(GameInfo.app_id);
			pack.writeBytes(bytes);
			ServerMgr.getInstance().save(pack);
		}

		public static function screenshot():BitmapData
		{
			return instance.getScreenBmpdata();
		}

		protected function getScreenBmpdata():BitmapData
		{
			var w:int = Screen.STAGE_WIDTH;
			var h:int = Screen.STAGE_HEIGHT;
			var bdata:BitmapData = new BitmapData(Screen.STAGE_WIDTH, Screen.STAGE_HEIGHT, false, 0);
			bdata.draw(stage, new Matrix(w / gDimenssion.width, 0, 0, h / gDimenssion.height), null, null, null, true);
			return bdata;
		}

		protected function handleKeys(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				onUserPressBack();
			}
		}

		protected function onUserPressBack():void
		{
			CommonANE.getInstance().alert(i18n("退出游戏"), //
				i18n("确认要退出游戏么？"), //
				i18n("确定"), //
				function(value:int):void
				{
					if (value == 0)
					{
						exit();
					}
				}, i18n("取消"));
		}

		protected function exit():void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			NativeApplication.nativeApplication.exit(0);
		}

		protected function initializeSound():void
		{
		}

		protected function onDeactive(event:*):void
		{
			SoundManager.pause();
			notifyTomorrow();
		}

		protected function onActive(event:*):void
		{
			SoundManager.resume();
		}

		private function notifyTomorrow():void
		{
//			TARGET::AND
//			{
//				if (NotificationManager.isSupported)
//				{
//					var notificationManager:NotificationManager = new NotificationManager();
//					notification.actionLabel = i18n("有更新啦");
//					notification.body = i18n("您已经24小时没来看看了，来试试新衣服吧！");
//					notification.title = i18n("有更新啦");
//					var notification:Notification = new Notification();
//					notification.fireDate = new Date((new Date().time + 86400000));
//					notification.numberAnnotation = 1;
//					notificationManager.cancel("CODE_001");
//					notificationManager.notifyUser("CODE_001", notification);
//				}
//			}
		}

		public function gameReady():void
		{
			stage.dispatchEvent(new Event("gameReady", true));
		}
	}
}
