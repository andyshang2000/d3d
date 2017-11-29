package diary.game
{
	import nblib.util.TabTxtPaser;

	public class Treasure
	{
		private static var lookup:Object = {};
		
		public var group:int = -1;
		public var level:int = 3;
		
		public var code:String;
		public var picks:int = 0;
		public var noDrop:Number = 100;
		public var item1:String;
		public var prob1:int;
		public var item2:String;
		public var prob2:int;
		public var item3:String;
		public var prob3:int;
		public var item4:String;
		public var prob4:int;
		public var item5:String;
		public var prob5:int;
		public var item6:String;
		public var prob6:int;
		public var item7:String;
		public var prob7:int;
		public var item8:String;
		public var prob8:int;

		private var probList:Array = [];
		private var total:Number;

		public function pick(result:Array, level:int = 3):Array
		{
			this.level = Math.max(level, 3);
			if (picks > 0)
			{
				for (var i:int = 0; i < picks; i++)
				{
					if (result.length >= 6)
					{
						return result;
					}
					var r:Number = Math.random() * total;
					for (var j:int = probList.length - 1; j >= 0; j--)
					{
						if (r > probList[j].prob)
						{
							pickItem(probList[j].item, result);
							break;
						}
					}
				}
			}
			else
			{
				var p:int = -picks;
				for (var j:int = 0; j < probList.length; j++)
				{
					var n:int = probList[j].prob
					for (var k:int = 0; k < n; k++)
					{
						pickItem(probList[j].item, result);
					}
				}
			}
			trace(result);
			return result;
		}

		private function pickItem(item:String, result:Array):void
		{
			if (lookup[item] != null)
			{
				Treasure(lookup[item]).pick(result, level);
			}
			else
			{
				var reg:RegExp = /([a-z]+)(\d+)?/ig;
				var match:Array = reg.exec(item);
//				var match:Array = item.match(/([a-z]+)(\d+)?/ig);
				var itemResult:Vector.<Item> = ItemType.lookupItem(match[1], int(match[2]));
				// TODO Auto Generated method stub
				if (itemResult.length > 0)
				{
					var itemBase:Item = itemResult[int(Math.random() * itemResult.length)];
					var itemInstance:Item = new Item;
					itemInstance.copyFrom(itemBase);
					if (itemInstance.code == "gld" || itemInstance.code == "hp" || itemInstance.code == "mp")
					{
						itemInstance.dropLevel = level * (1 + int(match[2])) * 0.01;
					}
					else
					{
					}
					result.push(itemInstance);
				}
				else
				{
					trace("treasure not defined: " + match[1]);
				}
			}
		}

		public static function addData(src:String):void
		{
			var result:Array = TabTxtPaser.parse(src, Treasure);
			for (var i:int = 0; i < result.length; i++)
			{
				var t:Treasure = result[i];
				lookup[t.code] = t;
				if (t.picks > 0)
				{
					t.total = t.noDrop;
					for (var j:int = 1; j < 9; j++)
					{
						if (t["item" + j] == "0")
						{
							break;
						}
						t.probList.push({ //
								prob: t.total, //
								item: t["item" + j] //
							});
						t.total += t["prob" + j];
					}
				}
				else
				{
					for (var j:int = 1; j < 9; j++)
					{
						if (t["item" + j] == "0")
						{
							break;
						}
						t.probList.push({ //
								prob: t["prob" + j], //
								item: t["item" + j] //
							});
					}
				}
			}
			trace("treasure prepared");
		}

		public static function get(code:String):Treasure
		{
			return lookup[code];
		}
	}
}
