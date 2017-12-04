package diary.ui
{
	import flash.display.Stage;
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	
	import flare.basic.Scene3D;
	import flare.materials.filters.LightFilter;
	
	import starling.core.Starling;
	
	import zzsdk.display.Screen;

	[Event(name = "layerCreated", type = "flash.events.Event")]
	public class RenderManager extends Scene3D
	{
		private var stage:Stage;
		private var renderOrder:Array = [];
		private var bootQueue:Array = [];
		private var layerRequest:int = 0;

		public function RenderManager(stage:Stage)
		{
			super(this.stage = stage);
			Screen.designW = 800;
			Screen.designH = 600;
//			Screen.initialize(stage);
//			setViewport(
//				Screen.showAllPort.x, //
//				Screen.showAllPort.y, //
//				Screen.showAllPort.width, //
//				Screen.showAllPort.height);
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
		}

		protected function renderEvent(event:Event):void
		{
			event.preventDefault();
			for (var i:int = 0; i < renderOrder.length; i++)
			{
				renderLayer(renderOrder[i])
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
			trace("add layer:" + name + ", type:" + type);
			if (!context)
			{
				bootQueue.push(arguments);
				return;
			}
			//
			layerRequest++;
			//
			if (type.toUpperCase() == "2D")
			{
				var layer:Starling = new Starling(StarlingLayer, stage, Screen.showAllPort, null, Context3DRenderMode.AUTO);
				layer.antiAliasing = 2;
				layer.start();
				layer.simulateMultitouch = true;
				renderOrder.push(layer);
				layer.addEventListener("rootCreated", function():void
				{
					layer.stage.stageWidth = Screen.designW;
					layer.stage.stageHeight = Screen.designH;
					layer.addEventListener("rootCreated", arguments.callee);
					layer.root.name = name;
					updateLayerRequest();
				});
			}
			else
			{
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
