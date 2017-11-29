package diary.ui.view
{
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;

	import avmplus.DescribeTypeJSON;
	import avmplus.FLASH10_FLAGS;
	import avmplus.INCLUDE_VARIABLES;

	import flare.basic.Scene3D;
	import flare.core.Pivot3D;

	import starling.display.Sprite;
	import starling.events.EventDispatcher;
	import starling.utils.ScaleMode;

	import zzsdk.display.Screen;

	public class AbstractView extends EventDispatcher
	{
		public var view:Sprite;

		private var scene:Scene3D;
		private var layers:Array = [];
		private var fieldsPendingToInit:Array = [];

		public function loadAssets(callback:Function = null):void
		{
			callback();
		}

		public function initialize(callback:Function = null):void
		{
			while (fieldsPendingToInit.length > 0)
			{
				var field:AbstractView = fieldsPendingToInit.pop() as AbstractView;
				if (field)
				{
					field.initialize();
				}
			}
			if (callback)
			{
				callback();
			}
		}

		public function set visible(v:Boolean):void
		{
			this.view.visible = v;
		}

		public function update2DLayer(name:String, root:Sprite):void
		{
			var funcName:String = "get" + name.charAt(0).toUpperCase() + name.substr(1);
			if (this.hasOwnProperty(funcName))
			{
				var view:Sprite = this[funcName]();
				retriveFields(view);
				root.addChild(view);
				layers.push(view);
				var rect:Rectangle = Screen.fitView(new Rectangle(0, 0, 480, 800), ScaleMode.SHOW_ALL);
				view.x = rect.x;
				view.y = rect.y;
				view.scaleX = view.scaleY = rect.width / 480;
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

		public function retriveFields(view:Sprite):void
		{
			if (!view)
				return;

			this.view ||= view;
			var typeInfo:Object = DescribeTypeJSON.describeType(this, INCLUDE_VARIABLES | FLASH10_FLAGS);

			var comp:*;
			for each (var v:Object in typeInfo.traits.variables)
			{
				if (v.name.charAt(0) == "$")
				{
					if (v.name.charAt(1) == "_")
					{
						comp = view.getChildByName(v.name.substr(2)) as Sprite
						if (comp && !this[v.name])
						{
							this[v.name] = new (getDefinitionByName(v.type));
							AbstractView(this[v.name]).retriveFields(comp);
							AbstractView(this[v.name])._fieldInit();
							fieldsPendingToInit.push(this[v.name]);
						}
					}
					else
					{
						comp = view.getChildByName(v.name.substr(1));
						this[v.name] = comp || this[v.name];
					}
				}
			}
		}

		protected function _fieldInit():void
		{
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
