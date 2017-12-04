package nblib.util.res.event
{
	import flash.events.Event;

	public class ResEvent extends Event
	{
		public static const START:String = "start";

		public static const DISPOSE:String = "dispose";

		public function ResEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		public override function clone():Event
		{
			return new ResEvent(type, bubbles, cancelable);
		}
	}
}
