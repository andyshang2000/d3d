package diary.ui.view
{
	import avmplus.DescribeTypeJSON;
	import avmplus.FLASH10_FLAGS;
	import avmplus.INCLUDE_VARIABLES;
	
	import flare.basic.Scene3D;
	import flare.core.Pivot3D;
	
	import starling.display.Sprite;
	import starling.events.EventDispatcher;

	public class ViewBase extends EventDispatcher implements IScreen
	{
		public var view:Sprite;

		private var scene:Scene3D;
		private var layers:Array = [];
		private var fieldsPendingToInit:Array = [];
		
		private var initialized:Boolean = false;
		private var assetsLoadedCallback:Function = null;
		
		public function loadAssets(callback:Function = null):void
		{
			assetsLoadedCallback = callback;
			doLoadAssets();
		}
		
		protected function doLoadAssets():void
		{
			onAssetsLoaded();
		}
		
		protected function onAssetsLoaded():void
		{
			initialized = true;
			if (assetsLoadedCallback)
			{
				assetsLoadedCallback();
			}
		}
		
		
		public function onViewAdded():void
		{
		}

		public function set visible(v:Boolean):void
		{
			this.view.visible = v;
		}

		public function update2DLayer(name:String, root:Sprite):void
		{
			if(!initialized)
				return;
			
			var funcName:String = "get" + name.charAt(0).toUpperCase() + name.substr(1);
			if (this.hasOwnProperty(funcName))
			{
				var view:* = this[funcName]();
				root.addChild(view);
				layers.push(view);
			}
		}

		public function update3DLayer(scene:Scene3D):void
		{
			if (this.hasOwnProperty("update3D"))
			{
				this.scene = scene;
				this["update3D"](scene);
			}
		}

		public function dispose():void
		{
			var typeInfo:Object = DescribeTypeJSON.describeType(this, INCLUDE_VARIABLES | FLASH10_FLAGS);
			for each (var v:Object in typeInfo.traits.variables)
			{
				if (v.name.charAt(0) == "$")
				{
					this[v.name] = null;
				}
			}
			for (var i:int = 0; i < layers.length; i++)
			{
				layers[i].dispose();
				layers[i].parent.removeChild(layers[i])
			}

			if (scene)
			{
				while (scene.children.length > 0)
				{
					var child:Pivot3D = scene.children[0];
					child.dispose();
					child.parent = null;
				}
			}
		}
	}
}
