package diary.ui.view
{
	import com.greensock.TweenNano;
	
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	import avmplus.DescribeTypeJSON;
	import avmplus.HIDE_OBJECT;
	import avmplus.INCLUDE_METADATA;
	import avmplus.INCLUDE_METHODS;
	import avmplus.INCLUDE_TRAITS;
	import avmplus.INCLUDE_VARIABLES;
	
	import fairygui.Controller;
	import fairygui.GComponent;
	import fairygui.GLoader;
	import fairygui.GObject;
	import fairygui.GRoot;
	import fairygui.RelationType;
	import fairygui.ScreenMatchMode;
	import fairygui.Transition;
	import fairygui.UIPackage;
	import fairygui.event.GTouchEvent;
	import fairygui.utils.ToolSet;
	
	import flare.basic.Scene3D;
	
	import starling.display.Sprite;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	import zzsdk.display.Screen;
	import zzsdk.utils.FileUtil;

	public class GScreen implements IScreen
	{
		public var scene:Scene3D;
		
		private var gView:GComponent;

		private var initialized:Boolean = false;
		private var onInitCallback:Function = null;
		private var designWidth:int = 480;
		private var designHeight:int = 800;

		private var savedRectList:Object = {};
		private var layers:Array = [];
		private var screenMgr:ScreenManager;

		public function GScreen()
		{
			loadAssets();
		}
		
		protected function loadAssets():void
		{
			FileUtil.dir = File.applicationDirectory;
			UIPackage.addPackage( //
				FileUtil.open("zz3d.dressup.gui"), //
				FileUtil.open("zz3d.dressup@res.gui"));
			UIPackage.waitToLoadCompleted(initializeHandler);
			FileUtil.dir = File.applicationStorageDirectory;
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

		public function onInit(screenMgr:ScreenManager, callback:Function):void
		{
			this.screenMgr = screenMgr;
			this.onInitCallback = callback;
			if (initialized)
			{
				callback();
			}
		}
		
		public function nextScreen(clazz:Class):void
		{
			screenMgr.changeScreen(clazz);
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
		
		public function update2DLayer(name:String, root:Sprite):void
		{
			if(!initialized)
				return;
			
			var view:* = createLayer(name);
			if (view != null)
			{
				root.addChild(view);
				layers.push(view);
			}
		}
		
		public function createLayer(name:String):*
		{
			return GRoot.inst.displayObject as Sprite;
		}
		
		public function update3DLayer(scene:Scene3D):void
		{
			this.scene = scene;
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

		public function dispose():void
		{
			gView.dispose();
		}
		
		public static function getFitRect(obj:*, scale:Number = 1.0):Rectangle
		{
			var port:Rectangle;
			var target:Rectangle;
			var result:Rectangle;
			if (obj is GLoader)
			{
				port = new Rectangle(0, 0, obj.initWidth, obj.initHeight);
				target = new Rectangle(0, 0, GRoot.inst.width, GRoot.inst.height);
			}
			else if (obj is GObject)
			{
				port = new Rectangle(0, 0, obj.width, obj.height);
				target = new Rectangle(0, 0, GRoot.inst.width, GRoot.inst.height);
			}
			else
			{
				port = new Rectangle(0, 0, obj.width, obj.height);
				target = Screen.fullscreenPort.clone();
			}
			if (scale != 1.0)
			{
				var second:Rectangle = target.clone();
				second.inflate(target.width * (scale - 1), target.height * (scale - 1));
				target = second;
			}
			result = RectangleUtil.fit(port, target, ScaleMode.NO_BORDER);
			return result;
		}
		
		public static function fit(obj:*):void
		{
			var result:Rectangle = getFitRect(obj);
			if (obj is GLoader)
			{
				GLoader(obj).setXY(result.x, result.y);
				GLoader(obj).setScale(result.width / obj.initWidth, result.height / obj.initHeight);
			}
			else if (obj is GObject)
			{
				obj.setXY(result.x, result.y);
				obj.setSize(result.width, result.height);
			}
			else
			{
				obj.x = result.x;
				obj.y = result.y;
				obj.width = result.width;
				obj.height = result.height;
			}
		}
		
		public function transferTo(target:String, onCompleteHandler:Function = null, dur1:Number = 0.25, dur2:Number = 0.25):void
		{
			getChild("transferMask").asCom.visible = true;
			getChild("transferMask").asCom.getChild("graphic").alpha = 0;
			if (dur1 < 0.01)
			{
				getController("sceneControl").selectedPage = target;
				if (onCompleteHandler != null)
				{
					onCompleteHandler();
				}
				return;
			}
			if (dur2 < 0.01)
				dur2 = dur1;
			
			TweenNano.to(getChild("transferMask").asCom.getChild("graphic"), dur1, {alpha: 1, onComplete: function():void
			{
				getController("sceneControl").selectedPage = target;
				if (onCompleteHandler != null)
				{
					onCompleteHandler();
				}
			}})
			TweenNano.to(getChild("transferMask").asCom.getChild("graphic"), dur2, {alpha: 0, delay: dur1, onComplete: function():void
			{
				getChild("transferMask").asCom.visible = false;
			}});
		}
	}
}
