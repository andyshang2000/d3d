package diary.game
{
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;

	public class Inventory extends EventDispatcher
	{
		public var gold:Number = 500;

		//items belong to player
		public var owned:Array;
		public var shop:Array;

		public function get(index:int):Item
		{
			return owned[index];
		}

		public function buy(index:int):int
		{
			var item:Item = shop[index];
			var cost:int = item.cost;
			if (!canAfford(cost))
			{
				return 1;
			}
			var order:Object = pay(cost);
			order.onSuccess = function():void
			{
				owned.push(shop.splice(index, 1));
			}
			order.onError = function():void
			{
//				owned.push(shop.splice(index, 1));
			}
			return 0;
		}

		public function gain(item:*):void
		{
			if (!(item is Item))
				item = Item.getItem(item);
			var index:int = shop.indexOf(item)
			item = shop.splice(index, 1)[0];
			owned.push(item);
		}

		public function canAfford(cost:*):Boolean
		{
			return cost <= gold;
		}

		private function pay(cost:*):Object
		{
			var res:Object = {};
			if (cost > 0)
			{
				gold -= cost;
				setTimeout(res.onSuccess, 1);
			}
			else
			{
				setTimeout(res.onSuccess, 1);
			}
			return res;
		}
	}
}
