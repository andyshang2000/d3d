package diary.ui
{
	import flash.debugger.enterDebugger;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flare.basic.Scene3D;
	import flare.materials.filters.LightFilter;
	import flare.system.Device3D;
	
	import starling.core.Starling;
	import starling.utils.RenderUtil;
	
	import zzsdk.display.Screen;

	[Event(name = "layerCreated", type = "flash.events.Event")]
	public class RenderManager extends Scene3D
	{
		private var stage:Stage;
		private var renderOrder:Array = [];
		private var bootQueue:Array = [];
		private var layerRequest:int = 0;

		private var bufferBitmapData:BitmapData;
		private var outputBitmapData:BitmapData;
		private var drawScheduled:Boolean;
		private var targetRect:Rectangle;

		public function RenderManager(stage:Stage)
		{
			Device3D.profile = Context3DProfile.ENHANCED;
			super(this.stage = stage);
			Screen.designW = 480;
			Screen.designH = 800;
			Screen.initialize(stage);
			setViewport(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			//
			stage.color = 0;
			ignoreInvisibleUnderMouse = true;
			showLogo = false;
			//
			antialias = 2;
			autoResize = false;
			autoDispose = true;
			lights.techniqueName = LightFilter.NO_LIGHTS;
			//
			scene.addEventListener(Scene3D.RENDER_EVENT, firstRenderEvent);
		}

		public function drawTo(bitmap:BitmapData, rect:Rectangle = null, filter:Array = null):void
		{
			outputBitmapData = bitmap;
			targetRect = rect;
			if (targetRect == null)
				targetRect = bitmap.rect;
			drawScheduled = true;
		}

		protected function firstRenderEvent(event:Event):void
		{
			scene.removeEventListener(Scene3D.RENDER_EVENT, firstRenderEvent);
			scene.addEventListener(Scene3D.RENDER_EVENT, renderEvent);
			while (bootQueue.length > 0)
			{
				var obj:Object = bootQueue.shift();
				var f:Function = obj.callee;
				f.apply(null, obj);
			}

			bufferBitmapData = new BitmapData(context.backBufferWidth, //
				context.backBufferHeight, //
				false, 0x0);
		}

		protected function renderEvent(event:Event):void
		{
			event.preventDefault();
			for (var i:int = 0; i < renderOrder.length; i++)
			{
				renderLayer(renderOrder[i]);
			}
			var snap:Boolean = false;
			if (drawScheduled)
			{
				context.drawToBitmapData(bufferBitmapData);
				drawScheduled = false;

				outputBitmapData.draw(bufferBitmapData, //
					new Matrix( //
					targetRect.width / bufferBitmapData.width, 0, //
					0, targetRect.height / bufferBitmapData.height, //
					-targetRect.x, -targetRect.y));
				snap = true;
			}
			if (snap)
			{
				dispatchEvent(new Event("snap"));
			}
		}

		private function renderLayer(layer:*):void
		{
			if (layer is Starling)
			{
				Starling(layer).nextFrame();
			}
			else if (layer is Scene3D)
			{
				context.clear(0, 0, 0, 1, 1, 0, Context3DClearMask.DEPTH);
				render();
			}
		}

		public function addLayer(name:String, type:String):void
		{
			if (!context)
			{
				bootQueue.push(arguments);
				return;
			}
			trace("add layer:" + name + ", type:" + type);
			//
			layerRequest++;
			//
			if (type.toUpperCase() == "2D")
			{
				var layer:Starling = new Starling(StarlingLayer, stage, Screen.fullscreenPort, null, Context3DRenderMode.AUTO);
//				layer.stage.stageWidth = Screen.designW;
//				layer.stage.stageHeight = Screen.designH;
				layer.antiAliasing = 2;
				layer.start();
				layer.simulateMultitouch = true;
				renderOrder.push(layer);
				layer.addEventListener("rootCreated", function():void
				{
					layer.addEventListener("rootCreated", arguments.callee);
					layer.root.name = name;
					updateLayerRequest();
				});
			}
			else
			{
				this.name = name;
				renderOrder.push(this);
				updateLayerRequest();
			}
		}

		private function updateLayerRequest():void
		{
			layerRequest--;
			if (layerRequest == 0)
			{
				dispatchEvent(new Event("layerCreated"));
			}
		}

		public function getLayerRoot(name:String):*
		{
			for (var i:int = 0; i < renderOrder.length; i++)
			{
				var layer:* = renderOrder[i] as Starling;
				if (layer && layer.root && layer.root.name == name)
				{
					return layer.root;
				}
			}
		}
	}
}
import starling.display.Sprite;

class StarlingLayer extends Sprite
{
}
