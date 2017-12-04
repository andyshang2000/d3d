package sui.skinning.starlingswf
{
	import flash.display.DisplayObject;
	
	import sui.core.sui_internal;
	import sui.core.flash.Component;
	import sui.plugins.IPlugin;
	import sui.reflect.Metadata;
	import sui.reflect.Property;
	import sui.reflect.SType;
	import sui.utils.SoundManager;

	public class GuiSound implements IPlugin
	{
		public function onConstruct(_arg1:*, _arg2:SType):void
		{
			var skin:*;
			var depthObjects:Array;
			var variable:Property;
			var comp = _arg1;
			var description = _arg2;

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
				var part:DisplayObject;
				var depth:int;
				var x:int;
				var y:int;
				var variable:* = _arg1;
				var metadata:Metadata = variable.metadatas["Skin"];
				if (metadata != null)
				{
					variableName = variable.name;
					variableType = variable.type;
					if (comp[variableName] != null)
					{
						var sound:String = metadata.args.sound;
						if (!sound)
						{
							return;
						}
						var soundArr:Array = sound.split(",");
						SoundManager.mapGUI(comp[variableName], soundArr);
						return;
					}
				}
			}
		}
	}
}
