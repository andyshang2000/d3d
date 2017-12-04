package zzsdk.templates
{
	public class ZZGameEntry_STL_IOS extends ZZGameEntry
	{
		public function ZZGameEntry_STL_IOS(videoClass:*)
		{
			super(videoClass);
		}

		override protected function onVideoLastFrame():void
		{
			boot("res.txt");
		}
	}
}