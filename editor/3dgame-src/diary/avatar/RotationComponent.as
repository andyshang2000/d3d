package diary.avatar
{
	import flash.events.Event;
	
	import flare.core.IComponent;
	import flare.core.Pivot3D;
	import flare.system.Input3D;

	public class RotationComponent implements IComponent
	{
		private var pivot:Pivot3D;

		public function added(target:Pivot3D):Boolean
		{
			pivot = target;
			if (!pivot)
				return false;
			pivot.addEventListener(Event.ENTER_FRAME, enterframe);
			return true;
		}

		protected function enterframe(event:Event):void
		{
			if (Input3D.mouseDown)
			{
				pivot.rotateY(-Input3D.mouseXSpeed);
			}
		}

		public function removed():Boolean
		{
			pivot.removeEventListener(Event.ENTER_FRAME, enterframe);
			return true;
		}
	}
}
