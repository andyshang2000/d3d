package zzsdk.api
{
	import flash.events.MouseEvent;

	import mx.utils.StringUtil;

	import sui.plugins.Managed;
	import sui.utils.NameUtil;

	import zzsdk.ad.AdManager;
	import zzsdk.share.ShareUtil;
	import zzsdk.templates.AppFrameBase;
	import zzsdk.utils.VirtualCrossController;

	public class SDKAPI
	{
		showAD;
		showPopup;
		promote;
		sdk_manage;

		public static function setup():void
		{
			zzapi.addMethod("set_useVideoAD", function(value:Boolean):void
			{
				if (value)
					AdManager.preferVideo();
			});
			zzapi.addMethod("showAD", function(id:String = null):void
			{
				id ||= GameInfo.managedID;
				AdManager.show(id);
			});
			zzapi.addMethod("promote", function(id:String = null):void
			{
				AdManager.moregames();
			});
			zzapi.addMethod("sdk_manage", function(obj:*, type:String = "promotion"):void
			{
				trace(StringUtil.substitute("sdk_manage({0},{1})", NameUtil.displayObjectToString(obj), type));
				if (Managed.add(obj))
				{
					obj.addEventListener(MouseEvent.CLICK, function():void
					{
						trace(StringUtil.substitute("managed obj({0}, clicked:type:{1})", obj.name, type));
						if (type == "promotion")
							zzapi.promote();
						else
							zzapi.showAD();
					})
				}
			});
			zzapi.addMethod("saveToLocal", function():void
			{
				ShareUtil.snap(AppFrameBase.screenshot());
				ShareUtil.saveLocal();
			})
			zzapi.addMethod("set_joypad", function(value:Boolean):void
			{
				if (value)
				{
					VirtualCrossController.enable();
				}
				else
				{
					VirtualCrossController.disable();
				}
			});
			zzapi.addMethod("manage", "sdk_manage");
		}
	}
}
