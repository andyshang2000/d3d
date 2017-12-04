package zzsdk.ad {
	import flash.events.*;
	import flash.desktop.*;
	import flash.utils.*;
	import mx.utils.*;
	import flash.system.*;
	import nblib.util.res.formats.*;
	
	public class AdConfig extends Res {
		
		public var json:Object;// = null
		
		private static var templateReturn:Object = {errorCode:0, result:[{bannerKey:"bbbb", adtype:"ADMOB", bannerPercent:"0", interstitialKey:"bbbb", interstitialPercent:"0"}, {bannerKey:"df3c495c", adtype:"BAIDU", bannerPercent:"100", interstitialKey:"b98da273", interstitialPercent:"100"}]};
		public static var apiCN:String = "http://app.936.com/ad/get-app-ad.php?i={0}&o={1}&l={2}&v={3}";
		public static var apiEN:String = "http://app.qiqiads.com/ad/get-app-ad.php?i={0}&o={1}&l={2}&v={3}";
		
		public function AdConfig(path:String){
			var _local2:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var _local3:Namespace = _local2.namespaceDeclarations()[0];
			path = StringUtil.substitute(((Capabilities.language)=="zh-CN") ? apiCN : apiEN, path, Capabilities.os, Capabilities.language, _local2._local3::versionNumber);
			super(path);
		}
		override protected function completeHandler(event:Event):void{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			event.stopImmediatePropagation();
			event.preventDefault();
			if (data){
				data = ByteArray(data).readUTFBytes(ByteArray(data).bytesAvailable);
				json = JSON.parse(data);
				setTimeout(dispatchEvent, 500, new Event("complete"));
			};
		}
		
	}
}//package zzsdk.ad 

