package diary.game
{
	import com.popchan.framework.utils.DataUtil;
	import com.popchan.sugar.core.Model;

	import nblib.util.TabTxtPaser;

	import zzsdk.utils.FileUtil;

	public class BonusModel
	{
		public var bonus:Array

		public function BonusModel()
		{
			bonus = TabTxtPaser.parse(FileUtil.readFile("bonus.txt"), Bonus);
		}

		public function hasBonus(id:int):Boolean
		{
			return false;
		}

		public function getBonus(id:int):Bonus
		{
			return bonus[id];
		}

		public function buy(id:int):Boolean
		{
			var bonus:Bonus = getBonus(id)
			var price:Money = bonus.getPrice();
			if (Model.money.afford(price))
			{
				new Buy(bonus).execute();
				return true;
			}
			return false;
		}

		public function load():void
		{
			DataUtil.load(DataUtil.id);
			var str:String = DataUtil.readString("bonus", "1,3,5,9");
			var arr:Array = str.split(",");
			for (var i:int = 0; i < arr.length; i++)
			{
				bonus[int(arr[i])].bought = true;
			}
		}

		public function save():void
		{
			DataUtil.save(DataUtil.id);
		}
	}
}
