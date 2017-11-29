package diary.game
{
	import nblib.util.TabTxtPaser;

	public class Quest
	{
		public var code:String;
		public var name:String;
		public var treasure:String;
		public var first:String
		public var S:int;
		public var A:int;
		public var B:int;
		public var C:int;
		public var prop1:Number;
		public var prop2:Number;
		public var prop3:Number;
		public var prop4:Number;
		public var prop5:Number;

		public static var lookup:Object = {};
		public static var list:Array = [];

		public static function addData(_arg1:String):void
		{
			var quests:Array = TabTxtPaser.parse(_arg1, Quest);
			for (var i:int = 0; i < quests.length; i++)
			{
				var q:Quest = quests[i];
				lookup[q.name] = q;
				lookup[q.code] = q;
				list.push(q);
			}
		}

		public static function get(a:*):Quest
		{
			return lookup[a];
		}
	}
}
