package sui.skinning.flash
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	import mx.utils.StringUtil;

	import sui.core.sui_internal;
	import sui.core.flash.Component;
	import sui.plugins.PluginBase;
	import sui.reflect.Metadata;
	import sui.reflect.Property;
	import sui.reflect.SType;

	public class flashSkinning extends PluginBase
	{
		override public function onConstruct(_arg1:*, _arg2:SType):void
		{
			if (!(_arg1 is Component))
			{
				return;
			}
			var comp:Component = _arg1;
			var skin:* = comp.sui_internal::skin;
			;
			var depthObjects:Array = [];
			var variable:Property;
			var description:SType = _arg2;

			if (!skin)
			{
				return;
			}

			for each (variable in description.variables)
			{
				processSkinMetadata(variable);
			}
			positioning();

			function processSkinMetadata(_arg1:Property):void
			{
				var variableName:String;
				var variableType:Class;
				var part:DisplayObject;
				var depth:int;
				var x:int;
				var y:int;
				var variable:Property = _arg1;
				var metadata:Metadata = variable.metadatas["Skin"];
				if (metadata != null)
				{
					variableName = variable.name;
					variableType = variable.type;
					if (comp[variableName] != null)
					{
						return;
					}
					if (skin.hasOwnProperty(variableName))
					{
						part = (skin[variableName] as DisplayObject);
						if (((part) && ((part.parent == skin))))
						{
							depth = part.parent.getChildIndex(part);
						}
						if ((skin[variableName] is variableType))
						{
							var _local3:Component = comp;
							_local3.sui_internal::setVariableSkin(variableName, skin[variableName], metadata);
						}
						else
						{
							try
							{
								x = skin[variableName].x;
								y = skin[variableName].y;
							}
							catch (err:Error)
							{
//                                ExternalInterface.call("alert", variableName);
							}
							_local3 = comp;
							_local3.sui_internal::setVariableSkin(variableName, new variableType(skin[variableName]), metadata);
							comp[variableName].x = x;
							comp[variableName].y = y;
							skin.addChildAt(comp[variableName], depth);
						}
						depthObjects[depth] = comp[variableName];
					}
					else
					{
						if (metadata.has("optional") || metadata.get("optional") == true || metadata.get("") == "optional")
						{
							//ok optional, no error occurs
						}
						else
						{
							throw(new ReferenceError(StringUtil.substitute("{0} is required in {1} but not found in skin {2}", [variableName, (comp["constructor"] + ""), skin.name])));
						}
					}
				}
			}
			function positioning():void
			{
				comp.x = skin.x;
				comp.y = skin.y;
				comp.scaleX = skin.scaleX;
				comp.scaleY = skin.scaleY;
				if (skin.parent)
				{
					skin.parent.removeChild(skin);
				}
				if ((((skin is DisplayObjectContainer)) && ((skin.numChildren > 0))))
				{
					while (skin.numChildren > 0)
					{
						comp.addChild((skin as DisplayObjectContainer).removeChildAt(0));
					}
					if ((skin is Sprite))
					{
						try
						{
							comp.graphics.copyFrom(skin.graphics);
						}
						catch (err:Error)
						{
//							trace("for those ancent flash players");
						}
					}
				}
				else
				{
					comp.addChild(skin);
					skin.x = 0;
					skin.y = 0;
				}
			}
		}
	}
}
