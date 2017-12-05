package diary.controller
{
	import flash.utils.getDefinitionByName;
	
	import avmplus.DescribeTypeJSON;
	import avmplus.HIDE_OBJECT;
	import avmplus.INCLUDE_ACCESSORS;
	import avmplus.INCLUDE_INTERFACES;
	import avmplus.INCLUDE_METADATA;
	import avmplus.INCLUDE_METHODS;
	import avmplus.INCLUDE_TRAITS;
	import avmplus.INCLUDE_VARIABLES;
	
	import fairygui.Controller;
	import fairygui.GComponent;
	import fairygui.GObject;
	import fairygui.GRoot;
	import fairygui.RelationType;
	import fairygui.ScreenMatchMode;
	import fairygui.Transition;
	import fairygui.UIPackage;
	import fairygui.event.GTouchEvent;
	import fairygui.utils.ToolSet;

	public class GScreen
	{
		private var gView:GComponent;

		private var initialized:Boolean = false;
		private var onInitCallback:Function = null;
		private var designWidth:int = 480;
		private var designHeight:int = 800;

		private var savedRectList:Object = {};

		public function GScreen(view:*)
		{
			view.loadAssets(initializeHandler);
		}

		protected function initializeHandler():void
		{
			initialized = true;
			if (onInitCallback != null)
			{
				onInitCallback();
			}
			onCreate();
		}

		public function onInit(callback:Function):void
		{
			this.onInitCallback = callback;
			if (initialized)
			{
				callback();
			}
		}

		protected function onCreate():void
		{
		}

		protected function setGView(packName:String, compName:String):void
		{
			GRoot.inst.setContentScaleFactor(designWidth, designHeight, ScreenMatchMode.MatchWidthOrHeight);
			gView = UIPackage.createObject(packName, compName).asCom;
			gView.setSize(GRoot.inst.width, GRoot.inst.height);
			gView.addRelation(GRoot.inst, RelationType.Size);
			GRoot.inst.addChild(gView);

			var json:* = DescribeTypeJSON.describeType(this, INCLUDE_VARIABLES | INCLUDE_METHODS | INCLUDE_METADATA | INCLUDE_TRAITS | HIDE_OBJECT);
			trace(json);

			for each (var v:Object in json.traits.variables)
			{
				if (ToolSet.startsWith(v.type, "fairygui"))
				{
					this[v.name] = getChild(v.name);
					for each (var metadata:Object in v.metadata)
					{
						if (metadata.name == "G")
						{
							for each (var value:Object in metadata.value)
							{
								this[v.name].addEventListener(value.key, this[value.value]);
							}
						}
					}
				}
			}
			for each (var m:Object in json.traits.methods)
			{
				for each (var metadata:Object in m.metadata)
				{
					if (metadata.name == "Handler")
					{
						for each (var value:Object in metadata.value)
						{
							try
							{
								switch (value.value)
								{
									case GTouchEvent.CLICK:
										getChild(m.name.substr(0, m.name.length - 5)).addEventListener(GTouchEvent.CLICK, this[m.name]);
										break;
								}
							}
							catch (err:Error)
							{
								throw new Error("cannot found coresponding pair on method " + m.name + ".");
							}
						}
					}
				}
			}
		}

		public function restore(name:String):void
		{
			var obj:GObject = gView.getChild(name);
			var c:Object = savedRectList[name];
			if(c == null)
				return;
			obj.setXY(c.x, c.y);
			obj.setSize(c.width, c.height);
			obj.setScale(1, 1);
			obj.rotation = 0
		}

		public function saveRect(name:String):void
		{
			if (savedRectList[name] != null)
				return;
			var obj:GObject = gView.getChild(name);
			savedRectList[name] = {x: obj.x, y: obj.y, width: obj.initWidth, height: obj.initHeight};
			var c:Object = savedRectList[name];
		}

		public function getChild(name:String):GObject
		{
			var segments:Array = name.split(".");
			var obj:* = gView;
			var c:GComponent;
//			c.getChild();
//			c.getTransition();
//			c.getController();
			for (var i:int = 0; i < segments.length; i++)
			{
				obj = obj.getChild(name)
			}
			return obj;
		}

		public function getController(name:String):Controller
		{
			return gView.getController(name);
		}

		public function getTransition(name:String):Transition
		{
			return gView.getTransition(name);
		}

		public function handleStateChange(type:String):void
		{
		}

		public function dispose():void
		{
		}
	}
}
