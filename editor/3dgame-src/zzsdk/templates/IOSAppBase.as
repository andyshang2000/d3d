package zzsdk.templates
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	import events.ServerEvent;
	
	import nblib.util.Tracker;
	
	import net.ServerMgr;
	
	import zzsdk.display.Screen;
	import zzsdk.editor.utils.FileUtil;
	import zzsdk.utils.SystemUtil;

	public class IOSAppBase extends AppFrameBase
	{
		public function IOSAppBase()
		{
			Screen.initialize(stage);
			trace("init$IOSAppBase");
			trace("initialize GA");
			Tracker.initialize("UA-60853528-2");
			GameInfo.unserialize(FileUtil.readFile(File.applicationDirectory.resolvePath(".ginfo")));
			trace("reading .ginfo");
		}

		override protected function addedToStageHandler(event:Event):void
		{
			trackView("gameload");
			//
			var desc:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = desc.namespace();
			var app_id:String = "" + desc.ns::id;

			if (GameInfo.isDebug)
			{
				if (SystemUtil.platform != "IOS")
				{
					ServerMgr.getInstance().addEventListener(ServerEvent.PHOTO, getPhotoHandler);
				}
			}
			else if (app_id != GameInfo.app_id)
			{
				NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
				NativeApplication.nativeApplication.exit(1);
			}

			NativeApplication.nativeApplication.addEventListener("activate", onActive);
			NativeApplication.nativeApplication.addEventListener("deactivate", onDeactive);
			//
			stage.scaleMode = GameInfo.scaleMode;
			if (stage.scaleMode == StageScaleMode.EXACT_FIT || stage.scaleMode == StageScaleMode.NO_SCALE)
			{
				stage.align = StageAlign.TOP_LEFT
			}
			else
			{
				stage.align = StageAlign.TOP;
			}
			//
			initializeAd();
			initializeJoyPad();
		}

		override protected function onDeactive(event:*):void
		{
			SoundMixer.soundTransform = new SoundTransform(0, 0);
		}

		override protected function onActive(event:*):void
		{
			SoundMixer.soundTransform = new SoundTransform(1, 0);
		}
	}
}
