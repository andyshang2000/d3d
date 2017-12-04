package diary.game
{

	public class Record
	{
		private var shop:Array;
		private var owned:Array;
		private var inventory:Inventory;

		public function setup(context:Context):void
		{
			context.inventory = inventory = new Inventory;
			context.inventory.shop = shop = []
			context.inventory.owned = owned = [];
			context.level = Level.lookup[0];
			sortItems(Item.list);
			gainItems()
			context.avatar = new AvatarModel;
			trace("init record ok!")
		}

		private function gainItems():void
		{
			inventory.gain("g2015_j_dod");
			inventory.gain("g2015_p_dod");
			inventory.gain("g0030_s_dod");
			inventory.gain("g2023_h_dod");

			inventory.gain("g0012_s_dod");
			inventory.gain("g0084_s_dod");
			inventory.gain("g0106_s_dod");
			inventory.gain("g0021_j_dod");
			inventory.gain("g0110_j_dod");
			inventory.gain("g0028_j_dod");
			inventory.gain("g0024_p_dod");
			inventory.gain("g0036_p_dod");
			inventory.gain("g0028_p_dod");
			inventory.gain("g5167_jp_dod");
		}

		private function sortItems(lookup:Object):void
		{
			for each (var item:Item in lookup)
			{
				if (ItemType.isType(item, "apprl"))
				{
					if (valid(item))
					{
						shop.push(item);
					}
				}
			}
		}

		private function valid(item:Item):Boolean
		{
			if (item.tag == "初始")
				return false;
			if (item.tag == "任务")
				return false;
			if (item.tag == "非卖")
				return false;
			return true;
		}
	}
}
