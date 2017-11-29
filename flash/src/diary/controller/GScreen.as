package diary.controller
{
	import fairygui.Controller;
	import fairygui.GComponent;
	import fairygui.GObject;
	import fairygui.GRoot;
	import fairygui.RelationType;
	import fairygui.ScreenMatchMode;
	import fairygui.Transition;
	import fairygui.UIPackage;

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
			
			
		}

		public function restore(name:String):void
		{
			var obj:GObject = gView.getChild(name);
			var c:Object = savedRectList[name];
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

		public function findById(name:String):GObject
		{
			return gView.getChild(name);
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
