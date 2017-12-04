package sui.components.flash
{
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;

	import sui.core.flash.Component;

	public class GUIControl extends Component
	{
		public var enabled:Boolean;

		public function GUIControl(_arg1:*)
		{
			super(_arg1);
			addEventListener(MouseEvent.CLICK, clickHandler, false, int.MAX_VALUE, true);
		}

		public function enable(value:Boolean):void
		{
			this.enabled = value;
			if (!enabled)
			{
				filters = [new ColorMatrixFilter([ //
					0.3086, 0.6094, 0.0820, 0, 0, //  
					0.3086, 0.6094, 0.0820, 0, 0, //
					0.3086, 0.6094, 0.0820, 0, 0, //
					0, 0, 0, 1, 0])];
				mouseEnabled = false;
				mouseChildren = false;
			}
			else
			{
				filters = null;
				mouseEnabled = true;
				mouseChildren = true;
			}
		}

		protected function clickHandler(event:MouseEvent):void
		{
			if (event.target != this)
			{
				event.stopImmediatePropagation();
				dispatchEvent(event);
			}
		}
	}
}
