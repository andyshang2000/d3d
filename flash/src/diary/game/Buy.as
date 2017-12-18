package diary.game
{
	import com.popchan.sugar.core.Model;

	public class Buy
	{
		private var item:*;

		public function Buy(item:*)
		{
			this.item = item;
		}

		public function execute():Boolean
		{
			var price:Money;
			try
			{
				price = item.getPrice();
			}
			catch (err:Error)
			{
				price = new Money;
				price.m1 = item.m1;
				price.m2 = item.m2;
				price.m3 = item.m3;
				price.m4 = item.m4;
				price.m5 = item.m5;
			}
			if (Model.money.afford(price))
			{
				Model.money.substract(price);
				return true;
			}
			return false;
		}
	}
}
