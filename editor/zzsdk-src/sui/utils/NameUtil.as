package sui.utils
{

	public class NameUtil
	{

		public static function displayObjectToString(_arg1:*):String
		{
			var result:String;
			var o:*;
			var s:String;
			var displayObject:* = _arg1;
			try
			{
				o = displayObject;
				while (o != null)
				{
					if (((((o.parent) && (o.stage))) && ((o.parent == o.stage))))
					{
						break;
					}
					;
					s = (((("id" in o)) && (o["id"]))) ? o["id"] : o.name;
					result = ((result == null)) ? s : ((s + ".") + result);
					o = o.parent;
				}
			}
			catch (e:SecurityError)
			{
			}
			return (result);
		}
	}
} 
