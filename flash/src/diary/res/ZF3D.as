package diary.res
{
	import flash.debugger.enterDebugger;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import flare.core.Pivot3D;
	import flare.loaders.Flare3DLoader;

	public class ZF3D
	{
		public var url:String;
		
		private var _content:Pivot3D;
		private var callback:Function

		public function ZF3D(url:String)
		{
			this.url = url;
		}

		public function get content():Pivot3D
		{
			return _content //.clone();
		}
		
		public function handle(bytes:ByteArray, onLoad:Function):void
		{
			callback = onLoad;
			if (!_content)
			{
				_content = new Flare3DLoader(bytes);
				Flare3DLoader(_content).addEventListener(Event.COMPLETE, f3dloaded);
				Flare3DLoader(_content).load();
			}
		}
		
		protected function f3dloaded(event:Event):void
		{
			if(content.children == null)
				enterDebugger();
			if(content.children != null)
				callback(this);
		}
		
		public function dispose():Boolean
		{
//			Device3D.scene.library.re
			content.parent = null;
			content.dispose();
			return true;
		}
	}
}
