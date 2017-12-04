package sui.skinning.flash
{
	import flash.display.DisplayObject;

	import sui.core.sui_internal;
	import sui.core.flash.Component;
	import sui.plugins.PluginBase;
	import sui.reflect.Metadata;
	import sui.reflect.Property;
	import sui.reflect.SType;

	import zzsdk.editor.utils.BindingUtil;

	public class BindingPlugin extends PluginBase
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
				var metadata:Metadata = variable.metadatas["Bind"];
				if (metadata != null)
				{
					variableName = variable.name;
					variableType = variable.type;
					if (comp[variableName] != null)
					{
						var bindTerm:String = metadata.args["model"] || metadata.args[""];
						var model:Object = BindingUtil.getModel(bindTerm);
						var setter:Function = metadata.args["setter"] ? model[metadata.args["setter"]] : null;
						var getter:Function = metadata.args["getter"] ? model[metadata.args["getter"]] : null;
						var fieldName:String = BindingUtil.getFieldName(bindTerm);
						BindingUtil.bind(model, fieldName, comp[variableName], "text", setter, getter);
					}
				}
			}
		}
	}
}

