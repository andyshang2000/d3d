package events
{
	import flash.events.Event;

	public class ServerEvent extends Event
	{
		public static const PHOTO:String = "PHOTO";
		public var data:Object = {};

		public function ServerEvent(type:String, data:Object = null)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}
