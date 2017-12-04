package diary.game
{
	import nblib.util.TabTxtPaser;
	import flash.utils.Dictionary;

	public class Item
	{
		//static and const
		public static const T_GOLD:int = 0;
		public static const T_APPRL:int = 1;
		public static const T_MISC:int = 4;
		public static const S_APPRL_J:int = 1;
		public static const S_APPRL_P:int = 2;
		public static const S_APPRL_S:int = 3;
		public static const S_APPRL_H:int = 4;
		public static const S_MISC_F:int = 1;
		public static const S_MISC_MATERAL:int = 2;
		public static const S_MISC_CHIPPED:int = 3;
		public static const S_MISC_GIFT:int = 4;

		public static var lookup:Object = {};
		public static var list:Array = [];
		public static var dummyItem:Item;

		//member
		public var code:String;
		public var name:String;
		public var model:String;
		public var mcode:int = 0;
		public var type:int = 0;
		public var subType:int = 0;
		public var type2:String = "0";
		public var cost:int = 0;
		public var dropLevel:int = 0;
		public var prop1:int = 0;
		public var prop2:int = 0;
		public var prop3:int = 0;
		public var prop4:int = 0;
		public var prop5:int = 0;
		public var tag:String = "";
		public var desc:String = "";
		public var selected:Boolean;
		public var locked:Boolean;

		public var quality:int;
		public var render:Object = null;
		public static var filelist:Dictionary;

		public function getTypeString():String
		{
			switch (int(this.type))
			{
				case T_APPRL:
					return ("apperal");
				case T_MISC:
					if (this.subType == S_MISC_F)
					{
						return ("face");
					}
					return ("misc");
			}
			return ("none");
		}

		public function copyFrom(_arg1:Item):void
		{
			this.name = _arg1.name;
			this.model = _arg1.model;
			this.mcode = _arg1.mcode;
			this.model = _arg1.model;
			this.type = _arg1.type;
			this.type2 = _arg1.type2;
			this.subType = _arg1.subType;
			this.cost = _arg1.cost;
			this.dropLevel = _arg1.dropLevel;
			this.cost = _arg1.cost
			this.prop1 = _arg1.prop1
			this.prop2 = _arg1.prop2
			this.prop3 = _arg1.prop3
			this.prop4 = _arg1.prop4
			this.prop5 = _arg1.prop5
			this.tag = _arg1.tag
		}

		public static function getItem(_arg1:String):Item
		{
			if (lookup[_arg1] == null)
			{
				return ((dummyItem = ((dummyItem) || (new (Item)))));
			}
			return (lookup[_arg1]);
		}

		public static function addData(_arg1:String):void
		{
			var items:Array = TabTxtPaser.parse(_arg1, Item);
			for (var i:int = 0; i < items.length; i++)
			{
				var item:Item = items[i];
				lookup[item.model] = item;
				lookup[item.name] = item;
				list.push(item);
				ItemType.addItem(item);
			}
		}

		private function getFieldName(i:int):String
		{
			// TODO Auto Generated method stub
			return ["name", "model", "mcode", //
				"type", "type2", "subType", //
				"cost", "dropLevel", //
				"prop1", "prop2", "prop3", "prop4", "prop5", "tag"][i];
		}

		public function serialize():String
		{
			var str:String = name + "\t" + model + "\t";
			for (var i:int = 2; i < 14; i++)
			{
				str += this[getFieldName(i)] + "\t"
			}
			return str.substr(0, str.length - 1);
		}

		public function toString():String
		{
			if (type2 == "gld")
				return "金币";
			return name + (/^(b|g)\d{4}_(.*)_/.exec(model)[2]) + "(" + (/^(g|b)(\d{4})/.exec(model)[2]) + ")"
		}
	}
}
