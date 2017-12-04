package zzsdk.game
{
	import starling.events.Event;

	public class GameEvent extends Event
	{
		public static const START:String = "game/start";
		
		public function GameEvent(type:String, bubbles:Boolean = false, data:Object = null)
		{
			super(type, bubbles, data);
		}
	}
}
