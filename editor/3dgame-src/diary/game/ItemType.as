package diary.game
{
	import nblib.util.TabTxtPaser;

	public class ItemType
	{
		public static var NO_CLASS:ItemType
		public var code:String = "";
		public var equiv:String = "";
		public var equiv2:String = "";
		public var comment:String = "";
		public var equivalents:Vector.<ItemType> = new Vector.<ItemType>;
		public var subTypes:Vector.<ItemType> = new Vector.<ItemType>;

		public static var types:Object = {};
		private static var itemIndex:Object = {};
		private static var empty:Vector.<Item> = new Vector.<Item>;

		public static function addType(str:String):void
		{
			NO_CLASS = new ItemType
			var result:Array = TabTxtPaser.parse(str, ItemType);
			for (var i:int = 0; i < result.length; i++)
			{
				var type:ItemType = result[i];
				var equiv:ItemType;
				types[type.code] = type;
				if (type.equiv != "0")
				{
					type.equivalents.push(equiv = types[type.equiv])
					equiv.subTypes.push(type);
				}
				if (type.equiv2 != "0")
				{
					type.equivalents.push(equiv = types[type.equiv]);
					equiv.subTypes.push(type);
				}
			}
			trace("item type prepared")
		}

		public static function isType(item:Item, type:String):Boolean
		{
			if (item.code == type)
			{
				return true;
			}
			return checkType(getType(item.type2), type)
		}

		private static function checkType(itemType:ItemType, type:String):Boolean
		{
			if (itemType == null)
			{
				return false;
			}
			if (itemType.code == type)
			{
				return true;
			}
			else
			{
				for (var i:int = 0; i < itemType.equivalents.length; i++)
				{
					if (checkType(itemType.equivalents[i], type))
					{
						return true;
					}
				}
				return false;
			}
		}

		public static function addItem(item:Item):void
		{
			var type:ItemType = getType(item.type2);
			addItemAs(item, type);
		}

		private static function addItemAs(item:Item, type:ItemType):void
		{
			if (!type)
			{
				type = (NO_CLASS ||= new ItemType);
			}
			if (!itemIndex[type.code])
			{
				itemIndex[type.code] = new Vector.<Item>;
			}
			itemIndex[type.code].push(item);
			for (var i:int = 0; i < type.equivalents.length; i++)
			{
				addItemAs(item, type.equivalents[i]);
			}
		}

		public static function lookupItem(str:String, filter:int = 0):Vector.<Item>
		{
			if (filter == 0)
			{
				filter = 99;
			}
			var item:Item = Item.getItem(str);
			if (item != Item.dummyItem)
			{
				return Vector.<Item>([item]);
			}
			var res:Vector.<Item> = (itemIndex[str] as Vector.<Item>);
			if (res == null)
			{
				return empty;
			}
			for (var i:int = 0; i < res.length; i++)
			{
				if (res[i].dropLevel > filter)
				{
					break;
				}
			}
			return res.slice(0, i);
		}

		public static function getType(code:String):ItemType
		{
			return types[code];
		}

		public static function sort():void
		{
			for (var code:String in types)
			{
				var list:Vector.<Item> = itemIndex[code];
				if (list)
				{
					list.sort(byDropLevel)
				}
			}
		}

		private static function byDropLevel(item1:Item, item2:Item):int
		{
			if (item1.dropLevel < item2.dropLevel)
			{
				return -1;
			}
			else if (item1.dropLevel > item2.dropLevel)
			{
				return 1;
			}
			return 0;
		}
	}
}
