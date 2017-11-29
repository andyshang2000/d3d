package diary.game
{
	import nblib.util.TabTxtPaser;

	public class Level
	{

		public static var lookup:Array = [];

		//member
		public var code:String;
		public var name:String;
		public var x:int;
		public var y:int;
		public var bg:String;
		public var locked:Boolean = true;
		public var quests:Array;

		public static function getData(_arg1:*):Level
		{
			return (lookup[_arg1]);
		}

		public static function addData(_arg1:String):void
		{
			var items:Array = TabTxtPaser.parse(_arg1, Level);
			for (var i:int = 0; i < items.length; i++)
			{
				var level:Level = items[i];
				lookup[i] = level;
				lookup[level.code] = level;
				lookup[level.name] = level;
			}
		}

		public function setLevels(line:String):void
		{
			var arr:Array = line.split("~");
			if (arr.length == 1)
			{
				quests = [Quest.get(arr[0])];
			}
			else
			{
				var start:int = Quest.list.indexOf(Quest.get(arr[0]));
				if (start == -1)
					throw new Error("Quest " + arr[0] + " not found!");
				var end:int = Quest.list.indexOf(Quest.get(arr[1]));
				if (end == -1)
					throw new Error("Quest " + arr[1] + " not found!");
				quests = Quest.list.slice(start, end + 1);
			}
		}

		public function setMedia(line:String):void
		{
			bg = line;
		}
	}
}

