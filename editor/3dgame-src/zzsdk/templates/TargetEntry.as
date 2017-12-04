package zzsdk.templates
{
	TARGET::AND
	{
		import zzsdk.templates.ZZGameEntry_STL_AND;

		public class TargetEntry extends ZZGameEntry_STL_AND
		{
			public function TargetEntry(videoClass:*):void
			{
				super(videoClass);
			}
		}
	}

	TARGET::IOS
	{
		import zzsdk.templates.ZZGameEntry_STL_IOS;

		public class TargetEntry extends ZZGameEntry_STL_IOS
		{
			public function TargetEntry(videoClass:*):void
			{
				super(videoClass);
			}
		}
	}
}
