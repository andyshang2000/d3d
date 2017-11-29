package diary.game
{

	public class Tachie
	{
		public static var lookup:Object = {};

		public static function add(param0:String, param1:String):void
		{
			lookup[param0] = new Tachie(param1)
		}

		public static function get(name:String):Tachie
		{
			return lookup[name];
		}

		public var source:String;
		public var defaultPos:String = "中";

		public function Tachie(source:String)
		{
			this.source = source;
		}
	}
}
