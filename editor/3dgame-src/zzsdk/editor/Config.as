package zzsdk.editor
{
	import flash.filesystem.File;

	import nblib.util.Properties;

	import zzsdk.editor.utils.FileUtil;

	public class Config
	{
		public static var AIR_SDK_HOME:String;
		public static var ANT_HOME:String;
		public static var ZZSDK:String;
		public static var DEPLOY_DIR:String;
		public static var GAME_NAME:String;
		public static var MainAS:String;

		public static var _additional:Object = {list: []};

		private static var _ant:File;

		public static function get ant():File
		{
			if (!initialized)
			{
				initialize();
			}
			return _ant;
		}

		private static var _appXml:XML;

		public static function get appXml():XML
		{
			if (!initialized)
			{
				initialize();
			}
			return _appXml;
		}

		private static var initialized:Boolean = false;

		public static function writeBack():void
		{
			var str:String = "";
			str += "AIR_SDK_HOME=" + AIR_SDK_HOME + "\n";
			str += "ZZSDK=" + ZZSDK + "\n";
			str += "DEPLOY_DIR=" + DEPLOY_DIR + "\n";
			str += "GAME_NAME=" + GAME_NAME + "\n";
			FileUtil.save(str, File.applicationDirectory.resolvePath("build.properties").nativePath);
		}

		public static function initialize():void
		{
			var localConfig:File = File.applicationDirectory.resolvePath("build.properties");
			var config:File = localConfig;
			if (!config.exists)
			{
				throw new Error("请配置build.properties")
			}
			var p:Properties = Properties.readFile(config, "=");
			for (var k:String in p)
			{
				if ((Config as Object).hasOwnProperty(k))
				{
					Config[k] ||= p[k];
				}
				else
				{
					_additional[k] = p[k];
					_additional.list.push(k);
				}
			}

			ANT_HOME ||= ZZSDK + "/ant";
			initialized = true;
			_ant = new File(ANT_HOME + "/bin/ant.bat");

			//用IOS作为标准好了
			_appXml = XML(FileUtil.readFile(File.applicationDirectory.resolvePath(Config.ZZSDK + "/compile.conf/main-app-ios.xml"), "xml"));
		}
	}
}
