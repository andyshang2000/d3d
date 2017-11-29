package zzsdk.ad
{
	import com.milkmangames.nativeextensions.AdMob;
	import com.milkmangames.nativeextensions.events.AdMobErrorEvent;
	import com.milkmangames.nativeextensions.events.AdMobEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import nblib.util.callLater;
	import nblib.util.res.ResLoaderNames;
	import nblib.util.res.ResManager;
	
	import so.cuo.platform.baidu.BaiDu;
	import so.cuo.platform.baidu.BaiDuAdEvent;
	import so.cuo.platform.baidu.RelationPosition;
	import so.cuo.platform.baidu.VideoType;
	
	import sui.utils.SoundManager;
	
	import zzsdk.utils.SystemUtil;

	public class AdManager extends MovieClip
	{
		public static const BAIDU:String = "BAIDU";
		public static const ADMOB:String = "ADMOB";

		public static const LEFT:String = "LEFT"
		public static const RIGHT:String = "RIGHT"
		public static const CENTER:String = "CENTER"
		public static const TOP:String = "TOP"
		public static const BOTTOM:String = "BOTTOM"
		public static const BANNER:String = "BANNER"
		public static const IAB_BANNER:String = "IAB_BANNER"
		public static const IAB_LEADERBOARD:String = "IAB_LEADERBOARD"
		public static const IAB_MRECT:String = "IAB_MRECT"
		public static const GET_DATA_SUCCESS:String = "AD_MANAGER_GET_DATA_SUCCESS";
		public static const GET_AD_FAIL:String = "AD_MANAGER_GET_AD_FAIL";

		public static var autoCache:Boolean = true;
		//
		private static var _useVideo:Boolean = false;
		//
		private static var instance:AdManager;
		//
		protected static var serverControlled:Object = {};
		private static var interstitialAvaiable:Boolean = true;
		//
		protected var _errorCode:int = -1;
		private var _admobIsCache:Boolean = false;
		private var _baiduIsCache:Boolean = false;
		//
		protected var adConfig:Object = {};

		private var defaultBannerType:String;

		private var mode:String;
		private var ad_id:String;

		private var currentCount:int = 0;
		private var defaultBH:String = GameInfo.bannerH;
		private var defaultBV:String = GameInfo.bannerV;
		private var showBannerT:int = -1;
		private static var bannerDisabled:Boolean;

		public function AdManager(ad_id:String)
		{
			this.ad_id = ad_id
			serverControlled[this.ad_id] = this;
			addEventListener(GET_DATA_SUCCESS, onAdConfigData);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			instance = this;
		}

		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener("showAD", showAdHandler);
			trace("loadAdconfig!!!!!!!!!!")
			loadConfig();
		}

		protected function showAdHandler(event:TextEvent):void
		{
			var id:String = event.text;
			if (id && id.length > 0)
			{
				showAD(id);
			}
			else
			{
				showAD();
			}
		}

		protected function loadConfig():void
		{
			ResManager.getResAsync(ad_id, function(res:AdConfig):void
			{
				var json:Object = res.json;
				_errorCode = json.errorCode;
				if (_errorCode == 0)
				{
					var _adObjArr:Array = json.result;
					for (var i:int = 0; i < _adObjArr.length; i++)
					{
						adConfig[_adObjArr[i].adtype] = _adObjArr[i];
					}
					if (SystemUtil.isCN())
						setupBaidu();
					else if (AdMob.isSupported)
						setupAdMob();

					dispatchEvent(new Event(GET_DATA_SUCCESS));
				}
			}, //
			ResLoaderNames.DoubleThreading, AdConfig);
		}

		public static function create(id:String, special:String = ""):AdManager
		{
			var adMgr:AdManager;
			if (special == "baitong")
			{
				TARGET::AND
				{
					adMgr = new BaitongAd(id);
				}
			}
			if (!adMgr)
			{
				adMgr = new AdManager(id);
			}
			return adMgr;
		}

		private function setupAdMob(value:String = "ADMOB"):void
		{
			mode = ADMOB;
			if (!adConfig[mode].bannerKey)
			{
				_errorCode = 101; //
			}
			else
			{
				AdMob.init(adConfig[mode].bannerKey);
				AdMob.addEventListener(AdMobErrorEvent.FAILED_TO_RECEIVE_AD, onGoogleAdErrorEvent);
				AdMob.addEventListener(AdMobEvent.RECEIVED_AD, onGoogleAdEvent);
				AdMob.addEventListener(AdMobEvent.SCREEN_PRESENTED, onGoogleAdEvent);
				AdMob.addEventListener(AdMobEvent.SCREEN_DISMISSED, onInterstitialDismissEvent);
				AdMob.addEventListener(AdMobEvent.LEAVE_APPLICATION, onGoogleAdEvent);
			}
		}

		private function setupBaidu():void
		{
			mode = BAIDU;
			if (!adConfig[mode].bannerKey)
			{
				_errorCode = 101; //
			}
			else
			{
				BaiDu.getInstance().setKeys(adConfig[mode].bannerKey);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onBannerLeaveApplication, onBaiduAdEvent);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialReceive, onBaiduAdEvent);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialFailedReceive, onBaiduInterstitialAdErrorEvent);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onBannerFailedReceive, onBaiduBannerAdErrorEvent);
				BaiDu.getInstance().addEventListener(BaiDuAdEvent.onInterstitialDismiss, onInterstitialDismissEvent);
			}
		}

		private function onInterstitialDismissEvent(event:Event):void
		{
			trace("onInterstitialDismissEvent");
			if (autoCache)
			{
				interstitialAvaiable = true;
				callLater(function():void
				{
					SoundManager.resume();
					cacheInterstitial();
				});
			}
		}

		private function onBaiduAdEvent(event:BaiDuAdEvent):void
		{
			trace(("onBaiduAdEvent:" + event));
			if (event.type == BaiDuAdEvent.onInterstitialReceive)
			{
			}
		}

		private function onBaiduBannerAdErrorEvent(event:BaiDuAdEvent):void
		{
			trace(("获得baidu banner广告失败：" + event));
			dispatchEvent(new Event(GET_AD_FAIL));
		}

		private function onBaiduInterstitialAdErrorEvent(event:BaiDuAdEvent):void
		{
			trace(("获得baidu全屏广告失败：" + event));
			dispatchEvent(new Event(GET_AD_FAIL));
		}

		private function onGoogleAdEvent(event:Event):void
		{
			trace(event);
		}

		private function onGoogleAdErrorEvent(event:AdMobErrorEvent):void
		{
			trace(("获得google广告失败：" + event.text));
			dispatchEvent(new Event(GET_AD_FAIL));
		}

		public static function disableBanner():void
		{
			bannerDisabled = true;
		}

		public static function enableBanner():void
		{
			bannerDisabled = false;
			runBanner();
		}

		protected function showBannerC(bannerH:String = null, bannerV:String = null):void
		{
			if (bannerDisabled || _errorCode != 0 || mode == null || !GameInfo.bannerAvaliable)
			{
				return;
			}
			var conf:* = adConfig[mode];
			trace(">>>>>>>>>>>>>>>>runbanner!!!!conf" + conf + "|mode:" + mode + "adtype:" + (conf && conf.adtype) + ">>>>>>>>>>>>>>>>>>>>>")
			if (conf)
			{
				if (bannerH)
					conf.bannerH = bannerH;

				if (bannerV)
					conf.bannerV = bannerV;
				switch (conf.adtype)
				{
					case "ADMOB":
						if (int(conf.bannerPercent) > 1)
						{
							showAdmobBanner(conf.bannerType || BANNER, conf.bannerH, conf.bannerV);
						}
						break;
					case "BAIDU":
						if (int(conf.bannerPercent) > 1)
						{
							showBaiduBanner(conf.bannerType || BANNER, conf.bannerH, conf.bannerV);
						}
						break;
				}
			}
		}

		private function showBaiduBanner(bannerType:String = "IAB_LEADERBOARD", //
			horizontal:String = "CENTER", // 
			vertical:String = "TOP"):void
		{
			trace("showBaiduBanner: " + bannerType + ":" + horizontal + ":" + vertical)
			if (BaiDu.getInstance().supportDevice)
			{
				if (vertical == TOP)
				{
					BaiDu.getInstance().showBanner(BaiDu[bannerType], RelationPosition[("TOP_" + horizontal)]);
				}
				else if (vertical == CENTER)
				{
					BaiDu.getInstance().showBanner(BaiDu[bannerType], RelationPosition[("MIDDLE_" + horizontal)]);
				}
				else if (vertical == BOTTOM)
				{
					BaiDu.getInstance().showBanner(BaiDu[bannerType], RelationPosition[("BOTTOM_" + horizontal)]);
				}
			}
		}

		private function showAdmobBanner(bannerType:String = "IAB_LEADERBOARD", //
			horizontal:String = "CENTER", //
			vertical:String = "TOP", //
			offsetX:int = 0, offsetY:int = 0):void
		{
			if (AdMob.isSupported)
			{
//				if (this.os != this.IPAD && (bannerType == IAB_LEADERBOARD || bannerType == IAB_BANNER))
//				{
//					trace(("bannerType: " + bannerType));
//					AdMob.showAd(BANNER, horizontal, vertical, offsetX, offsetY);
//				}
//				else
//				{
				trace(("bannerType2: " + bannerType));
				AdMob.showAd(bannerType, horizontal, vertical, offsetX, offsetY);
//				}
				if (AdMob.isInterstitialReady())
					AdMob.showPendingInterstitial();
			}
		}

		public function hideBanner():void
		{
			try
			{
				switch (adConfig[mode].adtype)
				{
					case "ADMOB":
						if (AdMob.isSupported)
						{
							AdMob.destroyAd();
						}
						break;
					case "BAIDU":
						if (BaiDu.getInstance().supportDevice)
						{
							BaiDu.getInstance().hideBanner();
						}
						break;
				}
			}
			catch (error:Error)
			{
			}
		}

		public function cacheInterstitial():void
		{
			var _adAdmobObj:Object = adConfig[mode];
			if (_errorCode == 0 || mode == null)
			{
				switch (mode)
				{
					case BAIDU:
						this._baiduIsCache = true;
						this._admobIsCache = false;
						if (interstitialAvaiable && BaiDu.getInstance().supportDevice)
						{
							interstitialAvaiable = false;
							if (_useVideo)
								BaiDu.getInstance().cacheVideo();
							else
								BaiDu.getInstance().cacheInterstitial(adConfig[mode].interstitialKey);
						}
						break;
					case ADMOB:
						this._baiduIsCache = false;
						this._admobIsCache = true;
						if (interstitialAvaiable && AdMob.isSupported)
						{
							interstitialAvaiable = false;
							AdMob.loadInterstitial(_adAdmobObj.interstitialKey, false);
						}
						break;
				}
			}
		}

		public function showInterstitial():void
		{
			if (_errorCode != 0 || mode == null)
			{
				return;
			}
			if (!adConfig[mode].interstitialKey || adConfig[mode].interstitialKey.length == 0)
			{
				return;
			}
			var percent:int = parseInt(adConfig[mode].interstitialPercent)
			if (percent == 0)
			{
				return;
			}
			else
			{
				currentCount += percent;
				if (currentCount < 100)
				{
					return;
				}
			}
			if (this._admobIsCache && AdMob.isSupported)
			{
				if (AdMob.isInterstitialReady())
				{
					SoundManager.pause();
					setTimeout(AdMob.showPendingInterstitial, 500);
				}
			}
			else if (_useVideo)
			{
				SoundManager.pause();
				setTimeout(BaiDu.getInstance().showVideo, 500, VideoType.VideoPause, new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
			}
			else if (this._baiduIsCache && BaiDu.getInstance().supportDevice && BaiDu.getInstance().isInterstitialReady())
			{
				SoundManager.pause();
				setTimeout(BaiDu.getInstance().showInterstitial, 500);
			}
		}

		private function onAdConfigData(event:*):void
		{
			if (autoCache)
				cacheInterstitial();
			runBanner();
		}

		public static function runBanner(bannerH:String = null, bannerV:String = null):void
		{
			instance.runBanner(bannerH, bannerV);
		}

		public static function hideBanner():void
		{
			instance.hideBanner();
		}

		public function runBanner(bannerH:String = null, bannerV:String = null):void
		{
			trace(">>>>>>>>>>>>>>>>runbanner!!!!_errorCode:" + _errorCode + ">>>>>>>>>>>>>>>>>>>>>")
			defaultBH ||= bannerH;
			defaultBV ||= bannerV;
			if (_errorCode != 0)
			{
				return;
			}
			hideBanner();
			if (showBannerT != -1)
			{
				clearTimeout(showBannerT);
			}
			showBannerT = setTimeout(function():void
			{
				showBannerC(bannerH || defaultBH, bannerV || defaultBV);
			}, 500);
		}

		public static function show(id:String = null, type:String = "interst"):void
		{
			id ||= GameInfo.managedID;
			if (type == "interst")
				AdManager(serverControlled[id]).showInterstitial();
		}

		public static function moregames():void
		{
			serverControlled[GameInfo.managedID].moregames();
		}

		public function moregames():void
		{
			stage.dispatchEvent(new Event("showCrossPromotion"));
		}

		public static function preferVideo():void
		{
			_useVideo = true;
		}
	}
}
