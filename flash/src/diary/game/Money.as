package diary.game
{
	import com.popchan.framework.utils.DataUtil;

	public class Money
	{
		public var m1:int = 0; //coin
		public var m2:int = 0; //vitality
		public var m3:int = 0; //ingenious
		public var m4:int = 0; //score?
		public var m5:int = 0; //level?

		public static var free:Money = new Money;

		public function Money()
		{
		}

		public function to_json():Object
		{
			return {m1: m1, m2: m2, m3: m3, m4: m4, m5: m5}
		}

		public function afford(m:Money):Boolean
		{
			if (m1 < m.m1)
				return false;
			if (m2 < m.m2)
				return false;
			if (m3 < m.m3)
				return false;
			if (m4 < m.m4)
				return false;
			if (m5 < m.m5)
				return false;
			return true;
		}

		public function getLack(m:Money):Money
		{
			var res:Money = new Money;
			res.m1 = Math.min(0, m1 - m.m1)
			res.m2 = Math.min(0, m2 - m.m2)
			res.m3 = Math.min(0, m3 - m.m3)
			res.m4 = Math.min(0, m4 - m.m4)
			res.m5 = Math.min(0, m5 - m.m5)
			return res;
		}

		public static function add(m1:Money, m2:Money):Money
		{
			var res:Money = m1.clone();
			res.add(m2);
			return res;
		}

		public static function substract(m1:Money, m2:Money):Money
		{
			var res:Money = m1.clone();
			res.substract(m2);
			return res;
		}

		public function clone():Money
		{
			var res:Money = new Money;
			res.m1 = m1;
			res.m2 = m2;
			res.m3 = m3;
			res.m4 = m4;
			res.m5 = m5;
			return res;
		}

		public function add(model:Money):void
		{
			m1 += model.m1;
			m2 += model.m2;
			m3 += model.m3;
			m4 += model.m4;
			m5 += model.m5;
		}

		public function substract(model:Money):void
		{
			m1 -= model.m1;
			m2 -= model.m2;
			m3 -= model.m3;
			m4 -= model.m4;
			m5 -= model.m5;
		}

		public function save():void
		{
			DataUtil.writeInt("m1", m1);
			DataUtil.writeInt("m2", m2);
			DataUtil.writeInt("m3", m3);
			DataUtil.writeInt("m4", m4);
			DataUtil.writeInt("m5", m5);
			DataUtil.save(DataUtil.id);
		}

		public function load():void
		{
			DataUtil.load(DataUtil.id);
			m1 = DataUtil.readInt("m1");
			m2 = DataUtil.readInt("m2");
			m3 = DataUtil.readInt("m3");
			m4 = DataUtil.readInt("m4");
			m5 = DataUtil.readInt("m5");
		}
	}
}
