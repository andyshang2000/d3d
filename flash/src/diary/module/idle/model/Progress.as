package diary.module.idle.model
{

	public class Progress
	{
		public static function open(duration:Number, auto:Boolean = true):Progress
		{
			var p:Progress = new Progress;
			p.duration = duration;
			p.open();
			return p;
		}

		public var duration:Number;
		public var start:Date;
		public var current:Number;
		public var total:Number;
		private var profit:IProfit;

		public function setProfit(profit:IProfit):void
		{
			this.profit = profit
		}

		public function open():void
		{
			start = new Date;
			current = 0;
			total = duration;
		}

		public function close():void
		{
			if (profit != null)
				profit.commit();
		}

		public function advance(elapsed:Number):void
		{
			current += elapsed;
			while (current > total)
			{
				current -= total;
				close();
			}
		}
	}
}
