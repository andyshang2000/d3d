package events
{
	import starling.events.Event;

	public class GameEvent extends Event
	{
		public static const SET_ITEM:String = "set_item";
		public static const BACK_GAME:String = "back_game";
		public static const SET_COLOR:String = "set_color";
		public static const RESET_ITEMS:String = "refresh_items";

		public static const REFRESH_ITEM:String = "refresh_Item";
		public static const SELECT_RESULT:String = "select_result";
		public static const SET_DEGREE:String = "set_degree"; //游戏难度
		public static const RESET_GAME:String = "reset_game";
		public static const START_GAME:String = "start_game";
		public static const GAME_GUIDE:String = "game_guide";

		public static const NEXT_ITEM:String = "next_item"; //下一个
		public static const GAME_RESULT:String = "game_result";
		public static const ADD_TIME:String = "add_time"; //加时间

		public function GameEvent(type:String, bubbles:Boolean = false, data:Object = null)
		{
			super(type, bubbles, data);
		}
	}
}
