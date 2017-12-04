package zzsdk.templates
{
	import nblib.util.res.ResManager;
	import nblib.util.res.formats.Res;

	public class ZZGameEntry_STL_AND extends ZZGameEntry
	{
		private var gameReady:Boolean;
		private var frame01Loaded:Boolean;
		private var animationEnd:Boolean;

		public function ZZGameEntry_STL_AND(videoClass:*)
		{
			super(videoClass);
		}

		override protected function onPreloadVideoLoaded():void
		{
			ResManager.getResAsync("frame02.swf", function(lib:Res):void
			{
				frame01Loaded = true;
				requestBoot();
			});
		}

		override protected function onVideoLastFrame():void
		{
			animationEnd = true;
			requestBoot();
		}

		private function requestBoot():void
		{
			if (frame01Loaded && animationEnd)
			{
				boot("res.txt");
			}
		}
	}
}
