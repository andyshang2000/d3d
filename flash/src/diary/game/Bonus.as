package diary.game
{

	public class Bonus implements IItem
	{
		public var cost_m1;
		public var cost_m2;
		public var cost_m3;
		public var cost_m4;
		public var cost_m5;
		public var bonus_type;
		public var bonus_name;
		public var bonus_value;
		public var icon;
		public var citizen;
		public var bought:Boolean = false;

		public function getPrice():Money
		{
			var m:Money = new Money;
			m.m1 = int(cost_m1);
			m.m2 = int(cost_m2);
			m.m3 = int(cost_m3);
			m.m4 = int(cost_m4);
			m.m5 = int(cost_m5);
			return m;
		}
	}
}
