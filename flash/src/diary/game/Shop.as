package diary.game
{

	public class Shop extends Inventory
	{
		override public function filterBy(cat:String):Array
		{
			var res:Array = [];
			if (json.game[cat] == null)
				return res;
			for (var i:int = 0; i < json.game[cat].length; i++)
			{
				res.push(json.game[cat][i]);
			}
			return res;
		}
	}
}
