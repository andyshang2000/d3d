package zzsdk.utils
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import zzsdk.editor.Config;
	public class FontUtil
	{
		private static var res:Array;
		public static var fontCharsMap:Dictionary = new Dictionary;
		public static var fontCharsMap2:Dictionary = new Dictionary;//为了储存旁白字体
		private static var loader:Loader;
		
		public static function replace(fontName:String, withFontName:String,isAnswer:Boolean = true):void
		{
			if(isAnswer)
			{
				fontCharsMap[withFontName] = fontCharsMap[fontName];
				delete fontCharsMap[fontName];
			}
			else
			{
				fontCharsMap2[withFontName] = fontCharsMap2[fontName];
				delete fontCharsMap2[fontName];
			}
			
		}
		
		public static function getUnicodeRangeByFont(fontName:String,isAnswer:Boolean = true):String
		{
			if(isAnswer)
			{
				return getUnicodeRange(fontCharsMap[fontName]);
			}
			return getUnicodeRange(fontCharsMap2[fontName]);
		}
		
		
		
		public static function getUnicodeRange(str:String):String
		{
			var result:String = "";
			var arr:Array = []
			for (var i:int = 0; i < str.length; i++)
			{
				arr.push(str.charCodeAt(i));
			}
			
			arr.sort(Array.NUMERIC);
			var uc:String = "";
			var isMultiple:Boolean = false;
			for (i = 0; i < arr.length; i++)
			{
				//out(j +": " + values[j]);
				if (i == 0)
					uc = "U+" + getValueString(arr[i]);
				if (i + 1 < arr.length && //
					uc != "" && //
					(arr[i + 1] == arr[i] + 1))
				{
					isMultiple = true;
				}
				else
				{
					if (isMultiple)
						result += uc + "-U+" + getValueString(arr[i]);
					else
						result += uc;
					isMultiple = false;
					if (i + 1 < arr.length)
						uc = ",U+" + getValueString(arr[i + 1]);
				}
			}
			return result;
		}
		
		private static function getValueString(num:uint):String
		{
			var msg:String = num.toString(16);
			for (var i:int = msg.length; i < 4; i++)
			{
				msg = "0" + msg;
			}
			return msg;
		}
		
		public static function addCharToEmbed(fontName:String, str:String):void
		{
			if (!fontCharsMap[fontName])
			{
				fontCharsMap[fontName] = "";
			}
			var s:String = fontCharsMap[fontName];
			var c:String
			for (var i:int = 0; i < str.length; i++)
			{
				c = str.charAt(i);
				if (s.indexOf(c) == -1)
				{
					s += c;
				}
			}
			fontCharsMap[fontName] = s;
		}
		
		public static function addCharToEmbed2(fontName:String, str:String):void
		{
			if (!fontCharsMap2[fontName])
			{
				fontCharsMap2[fontName] = "a";
			}
			var s:String = fontCharsMap2[fontName];
			var c:String
			for (var i:int = 0; i < str.length; i++)
			{
				c = str.charAt(i);
				if (s.indexOf(c) == -1)
				{
					s += c;
				}
			}
			fontCharsMap2[fontName] = s;
		}
		
		public static function getAll():Array
		{
			if (res)
			{
				return res;
			}
			var arr:Array = new File("c:\\windows\\fonts").getDirectoryListing();
			var fontList:Array = Font.enumerateFonts(true);
			var count:int = 0;
			res = [];
			for (var i:int = 0; i < arr.length; i++)
			{
				var file:File = File(arr[i]);
				if (file.extension.toLowerCase() == "ttf")
				{
					for (var j:int = 0; j < fontList.length; j++)
					{
						var font:Font = fontList[j];
						if (font.fontName.toLowerCase() == file.name.substr(0, file.name.length - 4).toLowerCase())
						{
							res.push({fontName: font.fontName, file: file});
							count++;
						}
					}
				}
			}
			return res;
		}
		
		public static function loadFontSwf(fontName:String, cb:Function = null):void
		{
			var file:File = new File(File.userDirectory.resolvePath(Config.ZZSDK+"/sourcebase/fonts/.zzfonts/" + fontName + ".swf").nativePath);
			if (file.exists)
			{
				if (loader)
				{
					loader.unloadAndStop();
				}
				else
				{
					loader = new Loader();
				}
				
				var bytes:ByteArray = new ByteArray;
				var fs:FileStream = new FileStream;
				fs.open(file as File, FileMode.READ);
				fs.readBytes(bytes);
				fs.close();
				
				var domain:ApplicationDomain = new ApplicationDomain;
				var loaderContext:LoaderContext = new LoaderContext(false, domain);
				loaderContext.allowCodeImport = true;
				loader.loadBytes(bytes, loaderContext);
				
				loader.contentLoaderInfo.addEventListener(Event.INIT, function(e:Event):void
				{
					(e.currentTarget as LoaderInfo).removeEventListener(Event.INIT, arguments.callee);
					var _class:Class = domain.getDefinition("FontToSwf") as Class;
					Font.registerFont(_class.fontClass);
					
					var fontname:String = _class.FONT_NAME;
					
					if (cb != null)
					{
						cb(fontname);
					}
				});
			}
		}
	}
}
