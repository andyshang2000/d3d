package nblib.util
{

	public class TabTxtPaser
	{
		public static function parse(str:String, clazz:Class, fieldToXCase:String = null):Array
		{
			var i:int = 0;
			var firstLine:Boolean = true;
			var propNames:Array = [];
			var cache:String = "";
			var selector:int = 0;
			var obj:Object = new clazz;
			var res:Array = [];
			while (i < str.length)
			{
				var c:String = str.charAt(i);
				if (c == "\t" || c == "\r")
				{
					if (firstLine)
					{
						if (fieldToXCase == "lower")
						{
							propNames.push(cache.toLowerCase());
						}
						else if (fieldToXCase == "upper")
						{
							propNames.push(cache.toUpperCase());
						}
						else
						{
							propNames.push(cache);
						}
					}
					else
					{
						var value:* = Number(cache);
						if (isNaN(value))
						{
							value = cache + "";
						}
						if (propNames[selector].charAt(0) != "*")
						{
							obj[propNames[selector]] = value;
						}
						selector++;
					}
					cache = "";
				}
				else if (c == "\n")
				{
					if (firstLine)
					{
						firstLine = false;
						trace(propNames);
					}
					if (selector != 0)
					{
						selector = 0;
						if (obj)
						{
							res.push(obj);
						}
						obj = new clazz;
					}
				}
				else
				{
					if (c != "\"")
					{
						cache += c;
					}
				}
				i++;
			}
			return res;
		}
	}
}
