package diary.res
{
	import flash.events.Event;
	import flash.utils.setTimeout;

	import flare.core.Pivot3D;
	import flare.loaders.Flare3DLoader;

	import nblib.util.res.formats.Res;
	import nblib.util.res.formats.ResState;

	public class ZF3D extends Res
	{
		private var _content:Pivot3D;

		public function ZF3D(path:String)
		{
			super(path);
		}

		public function get content():Pivot3D
		{
			return _content //.clone();
		}

		protected override function completeHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			event.stopImmediatePropagation();
			event.preventDefault();

			if (!_content)
			{
				_content = new Flare3DLoader(data);
				Flare3DLoader(_content).load();
				Flare3DLoader(_content).addEventListener(Event.COMPLETE, completeHandler);
			}
			if (_content.children.length > 0)
			{
				state = ResState.LoadComplete;
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				setTimeout(completeHandler, 10, event);
			}
		}

		override public function dispose():Boolean
		{
//			Device3D.scene.library.re
			content.parent = null;
			content.dispose();
			return super.dispose();
		}
	}
}
