package zzsdk.share
{
	import com.milkmangames.nativeextensions.events.GVFacebookEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.media.CameraRoll;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	import mx.graphics.codec.PNGEncoder;

	import so.cuo.platform.common.CommonANE;
	import so.cuo.platform.wechat.WeChat;
	import so.cuo.platform.wechat.WechatScene;

	import zzsdk.display.Screen;
	import zzsdk.utils.SystemUtil;

	public class ShareUtil
	{
		private static var watermark:BitmapData;

		public static const FACEBOOK_APP_ID:String = "1430208220546304"; //696579200399064
		public static const WX_APP_ID:String = "wx03413aaeaeb822f3";

		public static var enabled:Boolean = true;
		private static var bitmapToShare:BitmapData;

		private static var cr:CameraRoll;
		private static var fbInitialized:Boolean;

		private static var content:BitmapData;

		public static function initialize(watermarkMafa:Class, watermarkMafa2x:Class):void
		{
			if (!watermark)
			{
				try
				{
					if (Screen.STAGE_WIDTH > 769)
					{
						watermark = new watermarkMafa2x().bitmapData;
					}
					else
					{
						watermark = new watermarkMafa().bitmapData;
					}
				}
				catch (err:Error)
				{
					trace("no watermark");
				}
			}
			if (!cr)
			{
				cr = new CameraRoll();
			}
			if (SystemUtil.language == "zh-cn")
			{
				WeChat.getInstance().registerApp(WX_APP_ID);
			}
			else
			{
				if (!fbInitialized)
				{
					GoViralExample.getInstance().init();
					fbInitialized = true;
				}
			}
		}

		protected static function onFacebookEvent(event:Event):void
		{
			switch (event.type)
			{
				case GVFacebookEvent.FB_DIALOG_CANCELED:
				case GVFacebookEvent.FB_DIALOG_FAILED:
				case GVFacebookEvent.FB_LOGIN_CANCELED:
				case GVFacebookEvent.FB_LOGIN_FAILED:
				case GVFacebookEvent.FB_REQUEST_FAILED:
					bitmapToShare = null;
					break;
				case GVFacebookEvent.FB_LOGGED_IN:
					share();
					break;
			}
		}

		public static function clear():void
		{
			if (bitmapToShare != null)
			{
				bitmapToShare.dispose();
			}
			bitmapToShare = null;
		}

		public static function snap(bitmapData:BitmapData):void
		{
			if (bitmapToShare)
			{
				bitmapToShare.dispose();
			}
			bitmapToShare = bitmapData;
			if (watermark)
			{
				bitmapToShare.draw(watermark, new Matrix(1, 0, 0, 1, 5, bitmapToShare.height - watermark.height - 5), null, null, null, false);
			}
		}

		public static function saveLocal():Boolean
		{
			if (bitmapToShare == null)
			{
				return false;
			}
			if (CameraRoll.supportsAddBitmapData)
			{
				if (!cr)
				{
					cr = new CameraRoll();
				}
				cr.addBitmapData(bitmapToShare);
				CommonANE.getInstance().alert(i18n("提示"), i18n("已经将照片保存到您的相册"));
				return true;
			}
			else
			{
				new FileReference().save(new PNGEncoder().encode(bitmapToShare));
			}
			return true;
		}

		public static function share():void
		{
			if (bitmapToShare == null)
			{
				return;
			}
			shareImage();
		}

		private static function shareImage():void
		{
			if (!content)
			{
				content = new BitmapData(bitmapToShare.width * 0.6, bitmapToShare.height * 0.6, false, 0);
			}

			content.draw(bitmapToShare, new Matrix(0.6, 0, 0, 0.6, 0, 0));
			if (SystemUtil.language == "zh-cn")
			{
				var url:String = saveInfoToCameraRoll(content);
				WeChat.getInstance().sendImageMessage(url, "公主宝贝换装", WechatScene.WXSceneTimeline);
			}
			else
			{
				GoViralExample.getInstance().postPhotoFacebook(i18n("免费手机游戏尽在http://m.mafa.com"), content, function():void
				{
				});
			}
		}

		private static function saveInfoToCameraRoll(bitmap:BitmapData):String
		{
			var bytes:ByteArray = bitmap.encode(bitmap.rect, new PNGEncoderOptions());
			var file:File = File.applicationStorageDirectory.resolvePath("temp.png");
			var st:FileStream = new FileStream();
			st.open(file, FileMode.WRITE);
			st.writeBytes(bytes);
			st.close();
			return file.nativePath;
		}
	}
}
