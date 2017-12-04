package zzsdk.editor.utils
{
	import mx.utils.StringUtil;

	import zzsdk.editor.Config;

	public class AntTask
	{
		/**
		 * 要打包哪些文件，空格分开的字符串, 不包括2, default.png
		 */
		public static const FILE_LIST:String = "FILE_LIST";
		/**
		 * 预览的尺寸
		 */
		public static const PREVIEW_SIZE:String = "PREVIEW_SIZE";
		/**
		 * 导出SWF时设置的舞台尺寸，就是这个了[SWF(width="",height="")]，
		 * <p>对于使用DisplayObject的游戏，需要拉伸舞台的情况，这个参数很重要</p>
		 * <p>对于使用starling之类的游戏，这个参数无效</p>
		 */
		public static const CONTENT_SIZE:String = "CONTENT_SIZE";
		/**
		 * 预览的尺寸，是给adl的参数，用多大的屏幕预览
		 */
		public static const ASPECT_RATIO:String = "aspectRatio";

		public static const P12:String = "P12";
		public static const P12_PASS:String = "P12_PASS";
		public static const PP:String = "PP";

		public static var mergeTexture:Boolean = false;
		public static var defaultPreviewSize:String = "480x800";
		public static var defaultAspectRatio:String = "portrait";

		private var tasks:Array;
		private var properties:Object = {};
		private var properties_internal:Object = {};

		private var isDebug:Boolean = false;
		private var packType:String

		public static var bfile:String = "build.xml";

		public static function preview(width:int, height:int):AntTask
		{
			if (width == 0 || height == 0)
			{
				var arr:Array = defaultPreviewSize.split("x");
				width = int(arr[0]);
				height = int(arr[1]);
			}
			return new AntTask("copyXMLs replace buildIPA " + (mergeTexture ? "merge " : "") + "preview") //
				.set(PREVIEW_SIZE, StringUtil.substitute("{0}x{1}:{0}x{1}", width, height)) //
				.set(ASPECT_RATIO, defaultAspectRatio)
		}

		public static function ipa(debug:Boolean = false):AntTask
		{
			return new AntTask("copyXMLs replace buildIPA " + (mergeTexture ? "merge " : "") + "ipa") //
				.setDebugMode(debug) //
				.set(ASPECT_RATIO, defaultAspectRatio) //
				.set(AntTask.P12, debug ? "debug_zzisok.p12" : "release_zzisok.p12") //
				.set(AntTask.P12_PASS, debug ? "111111" : "zzisok123456") //
				.set(AntTask.PP, debug ? "0.mobileprovision" : "1.mobileprovision") //
		}

		public static function apk(debug:Boolean = false, ad_provider:String = "default", ad_id:String = "13a2b1bab0857a7085dbf56916ea2f9f"):AntTask
		{
			return new AntTask("copyXMLs replace buildAPK " + (mergeTexture ? "merge " : "") + "apk") //
				.setDebugMode(debug) //
				.setMisc("adprovider", ad_provider) //
				.set(ASPECT_RATIO, defaultAspectRatio) //
				.set(AntTask.P12, "mario_rebuild_done.p12") //
				.set(AntTask.P12_PASS, "111111") //
				.set("APP_XML", getAPPXML(ad_provider)) //
				.set("AD_ID", ad_id);
		}

		private static function getAPPXML(ad_provider:String):String
		{
			if (ad_provider == "baitong")
			{
				return "main-app-baitong.xml";
			}
			return "main-app-android.xml";
		}

		public static function save():AntTask
		{
			return new AntTask("save")
		}

		public static function zip():AntTask
		{
			return new AntTask("zip")
		}

		public static function unzip():AntTask
		{
			return new AntTask("unzip");
		}

		public function AntTask(... tasks)
		{
			if (tasks.length == 1)
			{
				tasks = tasks[0].split(" ");
			}
			this.tasks = tasks;
		}

		public function set(key:String, value:String):AntTask
		{
			properties[key] = value;
			if (isDebug && key == FILE_LIST)
			{
				properties[key] += " ip.txt";
				//如果是baidu的话，添加jar文件
				//ane的作者表示jar文件该放到一个文件夹里边
				if (properties_internal["adprovider"] == "default")
				{
					properties[key] += " biduad_plugin"
				}
			}
			return this;
		}

		public function execute():*
		{
			var args:Array = [Config.ant.nativePath];
			args = args.concat(tasks);
			for (var key:String in properties)
			{
				args.push("-D" + key + "=" + properties[key]);
			}
			args.push("-f");
			args.push(bfile);
			return Client.call.apply(null, args);
		}

		public function setDebugMode(debug:Boolean):AntTask
		{
			// TODO Auto Generated method stub
			isDebug = debug
			return this;
		}

		public function setMisc(k:String, v:String):Object
		{
			properties_internal[k] = v;
			return this;
		}
	}
}
