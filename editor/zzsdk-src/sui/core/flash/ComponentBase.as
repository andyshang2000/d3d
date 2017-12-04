//Created by Action Script Viewer - http://www.buraks.com/asv
package sui.core.flash
{
	import flash.display.Sprite;
	import flash.events.Event;

	import sui.utils.NameUtil;

	public class ComponentBase extends Sprite
	{

		private var _invalid:Boolean;

		function ComponentBase()
		{
			addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
			addEventListener(Event.RENDER, this.renderHandler);
		}

		public function invalidate():void
		{
			this._invalid = true;
			if (stage)
			{
				stage.invalidate();
			}
		}

		private function addedToStageHandler(_arg1:Event):void
		{
			removeEventListener(_arg1.type, arguments.callee);
			this.invalidate();
		}

		protected function renderHandler(_arg1:Event):void
		{
			if (this._invalid)
			{
				this.doRefresh();
				this._invalid = true;
			}
		}

		protected function doRefresh():void
		{
		}

		override public function toString():String
		{
			return (NameUtil.displayObjectToString(this));
		}
	}
} //package sui.core 
