package zzsdk.editor.gui
{
	import flash.filesystem.File;
	import flash.text.TextField;

	import nblib.util.Properties;

	import sui.components.flash.Input;

	import zzsdk.editor.utils.FileUtil;

	public class AutoVersion
	{
		private var version:String;
		private var versionField:Input;
		private var autoVersionField:TextField;
		private var p:Properties;
		private var upper:String;
		private var auto:String;
		private var appid:String;

		public function AutoVersion(versionField:Input, autoVersionField:TextField)
		{
			this.versionField = versionField;
			this.autoVersionField = autoVersionField;
			autoVersionField.visible = false;

			var file:File = File.applicationDirectory.resolvePath("version.db");
			if (!file.exists)
				p = new Properties;
			else
				p = Properties.readFile("version.db", "=");
		}

		public function update(appid:String):String
		{
			if (this.appid == appid)
			{
				return versionField.text + autoVersionField.text;
			}
			this.appid = appid;
			version = p[appid];
			if (!version)
			{
				version = "1.0.1";
			}
			versionField.text = upper = version.substr(0, version.lastIndexOf("."));
			autoVersionField.text = "." + (auto = version.substr(version.lastIndexOf(".") + 1));
			autoVersionField.visible = true;
			return versionField.text + autoVersionField.text;
		}

		public function increase():String
		{
			if (upper == versionField.text)
			{
				auto = (int(auto) + 1) + "";
			}
			else
			{
				upper = versionField.text;
				auto = "0";
			}
			versionField.text = upper;
			autoVersionField.text = "." + (auto);
			version = versionField.text + autoVersionField.text;
			p[appid] = version;
			FileUtil.save(p, File.applicationDirectory.resolvePath("version.db").nativePath);
			return version;
		}

		public function toString():String
		{
			return version;
		}
	}
}
