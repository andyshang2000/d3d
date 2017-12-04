package nblib.util
{
	import com.milkmangames.nativeextensions.GAnalytics;

	public class Tracker
	{
		private static var tracker:*;

		public static function initialize(trackerID:String):void
		{
//			if (GAnalytics.isSupported())
//			{
//				var ga:GAnalytics = GAnalytics.create(trackerID);
//				tracker = ga.defaultTracker;
//			}
		}

		public static function trackView(page:String):void
		{
			if (tracker)
			{
				tracker.trackScreenView(page);
			}
			trace("[GA]:" + page);
		}
	}
}
