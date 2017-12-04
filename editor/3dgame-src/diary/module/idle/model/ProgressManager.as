package diary.module.idle.model
{
	import flash.utils.ByteArray;

	public class ProgressManager
	{
		public function load(bytes:ByteArray):void
		{
		}

		public function save():ByteArray
		{
			return null;
		}

		private var progressList:Vector.<Progress> = new Vector.<Progress>;

		public function addProgress(progress:Progress):void
		{
			progressList.push(progress);
		}

		public function tagProgress(progress:Progress, ... tags:Array):void
		{
		}

		public function advance(elapsed:Number):void
		{
			progressList.forEach(function(p:Progress, ... args:Array):void
			{
				p.advance(elapsed);
			});
		}
	}
}
