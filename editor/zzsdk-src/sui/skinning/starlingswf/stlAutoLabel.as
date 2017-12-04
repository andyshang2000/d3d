package sui.skinning.starlingswf
{
	import starling.text.TextField;

	import sui.core.sui_internal;
	import sui.core.starlingswf.stlComponent;
	import sui.plugins.PluginBase;
	import sui.reflect.Metadata;
	import sui.reflect.Property;
	import sui.reflect.SType;

	import zzsdk.utils.TTFFont;

	public class stlAutoLabel extends PluginBase
	{
		override public function postConstruct(_arg1:*, _arg2:SType):void
		{
			if (!(_arg1 is stlComponent))
				return;

			var skin:*;
			var depthObjects:Array;
			var variable:Property;
			var comp:stlComponent = _arg1;
			var description:SType = _arg2;

			skin = comp.sui_internal::skin;
			depthObjects = [];
			for each (variable in description.variables)
			{
				processSkinMetadata(variable);
			}
			function processSkinMetadata(_arg1:Property):void
			{
				var variableName:String;
				var variableType:Class;
				var depth:int;
				var x:int;
				var y:int;
				var variable:* = _arg1;
				var metadata:Metadata = variable.metadatas["Label"];
				if (metadata != null)
				{
					variableName = variable.name;
					variableType = variable.type;
					if (comp[variableName] != null)
					{
						var isSetter:Boolean = metadata.args.setter;
						var labelVName:String = metadata.args.field;
						labelVName ||= "label";
						var value:String = metadata.args["value"];
						if (!value && metadata.args.i18n)
						{
							value = i18n(metadata.args.i18n);
						}
						if (comp[variableName].hasOwnProperty(labelVName))
						{
							if (isSetter)
							{
								comp[variableName][labelVName](value);
							}
							else
							{
								comp[variableName][labelVName] = value;
							}
						}
						else if (comp[variableName].hasOwnProperty("text"))
						{
							TextField(comp[variableName]).autoScale = true;
							comp[variableName].text = value;
							comp[variableName].fontName = TTFFont.defaultFont.fontName;
						}
						return;
					}
				}
			}
		}
	}
}
