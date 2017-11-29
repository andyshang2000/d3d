package zzsdk.ad
{
	import com.baidu.baitong.Baitong;
	
	import so.cuo.platform.baidu.RelationPosition;

	public class BaitongAd extends AdManager
	{
		public function BaitongAd(ad_id:String)
		{
			super(ad_id);
		}

		override protected function loadConfig():void
		{
			_errorCode = 0;
			runBanner();
		}

		override protected function showBannerC(bannerH:String = null, bannerV:String = null):void
		{
			var position:int = 8;
			if (Baitong.getInstance().supportDevice)
			{
				if (bannerV == TOP)
				{
					position = RelationPosition[("TOP_" + bannerH)]
				}
				else if (bannerV == CENTER)
				{
					position = RelationPosition[("MIDDLE_" + bannerH)]
				}
				else if (bannerV == BOTTOM)
				{
					position = RelationPosition[("BOTTOM_" + bannerH)]
				}
				Baitong.getInstance().showBanner(position);
			}
		}

		override public function moregames():void
		{
			Baitong.getInstance().moreApp();
		}
	}
}
