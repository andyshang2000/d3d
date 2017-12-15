package diary.ui.util
{
	import avmplus.DescribeTypeJSON;
	import avmplus.HIDE_OBJECT;
	import avmplus.INCLUDE_METADATA;
	import avmplus.INCLUDE_METHODS;
	import avmplus.INCLUDE_TRAITS;
	import avmplus.INCLUDE_VARIABLES;

	import fairygui.event.GTouchEvent;
	import fairygui.utils.ToolSet;

	public class GViewSupport
	{
		public static function assign(left, right = null):void
		{
			if (right == null)
				right = left
			var json:* = DescribeTypeJSON.describeType(left, INCLUDE_VARIABLES | INCLUDE_METHODS | INCLUDE_METADATA | INCLUDE_TRAITS | HIDE_OBJECT);
			trace(json);

			for each (var v:Object in json.traits.variables)
			{
				if (ToolSet.startsWith(v.type, "fairygui"))
				{
					left[v.name] = right.getChild(v.name);
					for each (var metadata:Object in v.metadata)
					{
						if (metadata.name == "G")
						{
							for each (var value:Object in metadata.value)
							{
								left[v.name].addEventListener(value.key, left[value.value]);
							}
						}
					}
				}
			}
			for each (var m:Object in json.traits.methods)
			{
				for each (var metadata:Object in m.metadata)
				{
					if (metadata.name == "Handler")
					{
						for each (var value:Object in metadata.value)
						{
							try
							{
								switch (value.value)
								{
									case GTouchEvent.CLICK:
										right.getChild(m.name.substr(0, m.name.length - 5)).addEventListener(GTouchEvent.CLICK, left[m.name]);
										break;
								}
							}
							catch (err:Error)
							{
								throw new Error("cannot found coresponding pair on method " + m.name + ".");
							}
						}
					}
				}
			}
		}
	}
}
