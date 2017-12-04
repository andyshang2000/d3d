package zzsdk.templates
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import dragonBones.core.dragonBones_internal;

	import nblib.util.callLater;

	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.events.Event;

	import zzsdk.display.Screen;

	public class AppFrame_STL extends AppFrame_Stage3D
	{
		public var _starling:Starling;

		public var model:starling.display.DisplayObject;
		private var bg:Object;
		private var appClazz:Class;
		private var port:Rectangle;
		private var context3DCreateTid:uint;

		public function AppFrame_STL(appClazz:Class, port:Rectangle)
		{
			this.appClazz = appClazz;
			this.port = port;
		}

		override protected function addedToStageHandler(event:flash.events.Event):void
		{
			super.addedToStageHandler(event);
			//
			callLater(stage.removeChildAt, 0);
//
			if (initializeStarling())
			{
				initializeSound();
			}
		}

		//FIXME
		private function initializeStarling():Boolean
		{
			Starling.handleLostContext = true;
			_starling = new Starling(appClazz, stage, port);
			_starling.gDimenssion.width = Screen.designW;
			_starling.gDimenssion.height = Screen.designH;
			_starling.antiAliasing = 2;
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, rootCreated);
			_starling.start();
			return true;
		}

		private function rootCreated():void
		{
			starlingRootCreated();
		}

		override protected function getScreenBmpdata():BitmapData
		{
			var context3d:Context3D = Starling.context;
			var stage:Stage = Starling.current.stage;
			var support:RenderSupport = new RenderSupport;
			Starling.context.clear();
			support.setProjectionMatrix(0, 0, gDimenssion.width, gDimenssion.height);
			Starling.current.root.render(support, 1.0);
			support.finishQuadBatch();
			var bitmapdata:BitmapData = new BitmapData(Starling.current.nativeStage.fullScreenWidth, //
				Starling.current.nativeStage.fullScreenHeight //
				, false, 0);
			context3d.drawToBitmapData(bitmapdata);
			return bitmapdata;
		}

		override protected function onDeactive(event:*):void
		{
			super.onDeactive(event);
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
			_starling.stop(true);
			_starling.addEventListener("context3DCreate", preventDispatch);
			debug("lost " + NativeApplication.nativeApplication.systemIdleMode);
		}

		private function preventDispatch(event:starling.events.Event):void
		{
			_starling.removeEventListener("context3DCreate", preventDispatch);
			clearTimeout(context3DCreateTid);
		}

		override protected function onActive(event:*):void
		{
			super.onActive(event);
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			_starling.start();
			context3DCreateTid = setTimeout(function():void
			{
				_starling.dispatchEventWith("context3DCreate");
			}, 600);
			debug("gain " + _starling.context + "" + NativeApplication.nativeApplication.systemIdleMode);
		}
		
		override protected function exit():void
		{
			super.exit();
//			_starling.root.dispose();
//			_starling.dispose();
//			_starling = null;
		}

		/**
		 *
		 */
		protected function starlingRootCreated():void
		{
		}
	}
}
