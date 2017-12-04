package diary.module.idle.model
{

	public class GoldProfit implements IProfit
	{
		public function GoldProfit()
		{
		}

		public function commit():void
		{
			var a:int = 0
			for (var i:int = 0; i < 10; i++)
			{
				a++;
			}
			trace("you get some gold, heavy loop")
		}
	}
}
