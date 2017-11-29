package diary.game
{

	public class Quality
	{
		public static const UNIQUE:int = 0;
		public static const SET:int = 1;
		public static const RARE:int = 2;
		public static const MAGIC:int = 3;
		public static const NORMAL:int = 4;
		public static const LOW:int = 5;
		
		private static var factors:Array = [400, 160, 100, 34, 12, 2];
		private static var thresholds:Array = [6400, 5600, 3200, 192, 0, 0];
		private static var divisors:Array = [1, 2, 2, 3, 8, 2];
		private static var mfw:Array = [250, 500, 600, 0, 0, 0]

		/*
		基础暗金判定几率值 = (Unique– (MLvl-底材QLvl)/UniqueDivisor)*128

		暗金判定增加：UF = [MF * 250 / (MF + 250)]
		绿色判定增加：SF = [MF * 500 / (MF + 500)]
		黄色判定增加：RF = [MF * 600 / (MF + 600)]
		蓝色判定增加：MF=MF

		MF修正后暗金判定几率值=基础暗金判定几率值/（1 +UF%）

		最终判定几率值=MF值修正后的判定几率值* (1 -修正参数/ 1024)

		成色判定实际几率= 128 /（1 +最终判定几率值）
		*/
		public static function calcRatio(monLevel:Number, itemDopLevel:int, mf:int, modify:int, q:int):Number
		{
			var diff:Number = monLevel = itemDopLevel;
			var factor:Number = (factors[q] - (diff) / divisors[q]) * 128;
			mf *= mfw[q] / (mf + mfw[q]);
			mf = Math.max(thresholds[q], factor / (1 + mf * 0.01));
			mf *= 1 - modify/ 1024;
			return 128 / (1 + mf);
		}
	}
}
