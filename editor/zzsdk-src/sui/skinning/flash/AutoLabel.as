package sui.skinning.flash
{
	import flash.display.DisplayObject;
	
	import sui.core.sui_internal;
	import sui.core.flash.Component;
	import sui.plugins.PluginBase;
	import sui.reflect.Metadata;
	import sui.reflect.Property;
	import sui.reflect.SType;

	public class AutoLabel extends PluginBase
	{
		override public function postConstruct(_arg1:*, _arg2:SType):void
		{
			var skin:*;
			var depthObjects:Array;
			var variable:Property;
			var comp:Component = _arg1;
			var description:SType = _arg2;

			skin = comp.sui_internal::skin;
			if (!skin)
			{
				return;
			}
			depthObjects = [];
			for each (variable in description.variables)
			{
				processSkinMetadata(variable);
			}
			function processSkinMetadata(_arg1:Property):void
			{
				var variableName:String;
				var variableType:Class;
				var part:DisplayObject;
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
						var value:String = metadata.args["value"]
						value ||= metadata.args[""];
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
						return;
					}
				}
			}
		}
	}
}
