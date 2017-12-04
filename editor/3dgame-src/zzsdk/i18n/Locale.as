package zzsdk.i18n
{
	import flash.system.Capabilities;
	
	import nblib.util.TabTxtPaser;
	
	import zzsdk.editor.Config;

	public class Locale
	{
		private static var cnIndex:Object = {};
		private static var langCode:String;

		public static function setLangCode(code:String):void
		{
			langCode = code;
		}

		public static function initialize(str:String, code:String = null):void
		{
			code ||= Capabilities.language.toLowerCase();
			if (code != "zh-cn")
			{
				code = "en"
			}
			var items:Array = TabTxtPaser.parse(str, LangItem, "lower");
			//
			for (var i:int = 0; i < items.length; i++)
			{
				cnIndex[items[i].get("zh-cn")] = items[i];
			}
			setLangCode(code);
			i18n = get;
		}

		public static function get(str:String):String
		{
			if (cnIndex[str] === undefined)
			{
				if(GameInfo.isDebug)
					return "**" + str + "**";
				return str;
			}
			return cnIndex[str].get(langCode);
		}
	}
}

dynamic class LangItem
{
	public function get(code:String):String
	{
		return this[code] || this["zh-cn"];
	}
}
