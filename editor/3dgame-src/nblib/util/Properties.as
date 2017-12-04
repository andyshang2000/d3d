package nblib.util
{
	import flash.filesystem.File;
	import flash.utils.IDataInput;
	
	import mx.utils.StringUtil;

	dynamic public class Properties
	{
		public function Properties(reader:Reader = null, spliter:String = null)
		{
			if (reader)
			{
				while (reader.hasNextline())
				{
					var line:String = StringUtil.trim(reader.readLine());
					if (line.length < 1 || line.charAt(0) == "#")
					{
						continue;
					}
					var arr:Array = line.split(spliter);
					var key:String = StringUtil.trim(arr[0]);
					var value:String = StringUtil.trim(arr[1]);
					for (var i:int = 2; i < arr.length; i++)
					{
						value += " " + arr[i];
					}
					value = StringUtil.trim(value);
					while (value.charAt(value.length - 1) == "\\")
					{
						var nextline:String = StringUtil.trim(reader.readLine());
						if (nextline.length < 1 || nextline.charAt(0) == "#")
						{
							continue;
						}
						value = value.substr(0, value.length - 1) + nextline;
					}
					if (key && value)
					{
						this[key] = StringUtil.unpack(value);
					}
				}
				reader.close()
			}
		}

		/**
		 *
		 * @param file ByteArray, String(path of File), File
		 * @param spliter
		 * @param charSet
		 * @return
		 *
		 */
		public static function readFile(file:*, spliter:String = " ", charSet:String = "utf-8", output:Object = null):Properties
		{
			if (file is String)
			{
				file = File.applicationDirectory.resolvePath(file);
				return readFile(file, spliter, charSet);
			}
			var p:Properties = new Properties(getReader(file, charSet), spliter);
			if (output)
			{
				for (var k:String in p)
				{
					if (output.hasOwnProperty(k))
					{
						output[k] = p[k];
					}
				}
			}
			return p;
		}

		private static function getReader(file:*, charSet:String):Reader
		{
			var reader:Reader;
			if (file is File)
			{
				reader = Reader.open(file);
			}
			else if (file is IDataInput)
			{
				reader = new Reader(file, charSet);
			}
			return reader;
		}

		public function toString():String
		{
			var str:String = "";
			for (var key:String in this)
			{
				str += key + "=" + this[key] + "\n"
			}
			return str
		}
	}
}
