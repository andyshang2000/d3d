package diary.game
{
	import com.popchan.framework.utils.DataUtil;

	import flash.events.EventDispatcher;

	import nblib.util.TabTxtPaser;

	import zzsdk.utils.FileUtil;

	public class Inventory extends EventDispatcher
	{
		protected static var json:*;

		private var items:Object = {};

		public function Inventory():void
		{
			if (!json)
				json = FileUtil.open("gameconfig", "AMF");
		}

		public function load():void
		{
			DataUtil.load(DataUtil.id);
			var data:String = DataUtil.readString("inventory", defaultInv()); // xxx,xxx,xxx|
			var value:Object;
			for each (var ii:ItemIndex in TabTxtPaser.parse(data, ItemIndex))
			{
				if (json[ii.type + "_index"].indexOf(ii.id) != -1)
				{
					if (items[ii.type] == null)
					{
						items[ii.type] = [];
					}
					items[ii.type].push(ii);
				}
			}
		}

		public function save():void
		{
			DataUtil.load(DataUtil.id);
			DataUtil.writeString("inventory", serialize());
		}

		private function serialize():String
		{
			var res:String = "";
			res += "type\tid\tamount\r\n";
			for (var cat:String in items)
			{
				var catItems:Array = items[cat];
				for (var obj:Object in catItems)
				{
					res += cat + "\t" + obj.id + "\t" + obj.amount + "\r\n";
				}
			}
			return "";
		}

		private static function defaultInv():String
		{
			return "type\tid\tamount\r\n" + // 
				"h\tg0033_h_dod\t1\r\n" + //
				"j\tg0037_j_dod\t1\r\n" + //
				"j\tg0052_j_dod\t1\r\n" + //
				"p\tg0037_p_dod\t1\r\n" + //
				"s\tg0024_s_dod\t1\r\n"
		}

		public function hasItem(item:Object):Boolean
		{
			var i:int = getIndex(item);
			return i != -1;
		}

		public function getAmount(item:Object):int
		{
			var i:int = getIndex(item);
			if (i != -1)
				return items[item.type][i].amount;
			return 0;
		}

		public function remove(item:Object):void
		{
			var indexName:String = item.type + "_index";
			var i:int = getIndex(item);
			if (i == -1)
				items[item.type].push(new ItemIndex(item));
			items[item.type].splice(i, 1);
			items[indexName].splice(i, 1);
		}

		public function add(item:Object, amount:int = 1):void
		{
			var indexName:String = item.type + "_index";
			var i:int = getIndex(item);
			if (i == -1)
			{
				items[item.type].push(new ItemIndex(item));
				items[indexName].push(Item.getHash(item))
			}
			else
				items[item.type][i].amount += amount;
		}

		private function getIndex(item:Object):int
		{
			var indexName:String = item.type + "_index";
			var i:int = items[indexName].indexOf(Item.getHash(item));
			return i;
		}

		public function filterBy(cat:String):Array
		{
			var res:Array = [];
			if (items[cat] == null)
				return res;
			for (var i:int = 0; i < items[cat].length; i++)
			{
				var ii:ItemIndex = items[cat][i];
				var item:Object = getItem(ii);
				res.push(item);
			}
			return res;
		}

		public function getItem(ii:ItemIndex):Object
		{
			var jIndex:int = json[ii.type + "_index"].indexOf(ii.id);
			return json.game[ii.type][jIndex];
		}
	}
}
import diary.game.Item;

class ItemIndex
{
	public var type:String; //1,2,3,4,9 cat
	public var id:*;
	public var amount:int;

	public function ItemIndex(item:Object = null)
	{
		if (item != null)
		{
			type = item.getCat();
			id = Item.getHash(item);
			amount = 0;
		}
	}
}
