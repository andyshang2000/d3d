package diary.game
{
	import com.popchan.sugar.core.Model;

	public class Buy
	{
		private var item:Item;

		public function Buy(item:Item)
		{
			this.item = item
		}

		public function execute():Boolean
		{
			var price:Money = Money.getPrice(item);
			if (Model.money.afford(price))
			{
				Model.money.substract(price);
				Model.inventory.add(item);
				return true;
			}
			return false;
		}
	}
}
