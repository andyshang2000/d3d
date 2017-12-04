package sui.skinning.starlingswf
{

	import mx.utils.StringUtil;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	import sui.core.sui_internal;
	import sui.core.starlingswf.stlComponent;
	import sui.plugins.PluginBase;
	import sui.reflect.Metadata;
	import sui.reflect.Property;
	import sui.reflect.SType;

	public class stlSkinning extends PluginBase
	{
		private var tempObj:DisplayObject;

		override public function onConstruct(_arg1:*, _arg2:SType):void
		{
			if (!(_arg1 is stlComponent))
			{
				return;
			}
			var depthObjects:Array;
			var variable:Property;
			var comp:stlComponent = _arg1;
			var description:SType = _arg2;
			var skin:* = comp.skin;
			;
			var processSkinMetadata:Function = function(_arg1:Property):void
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
					if (hasProperty(skin, variableName))
					{
						part = getChild(skin, variableName) as DisplayObject;
						if (((part) && ((part.parent == skin))))
						{
							depth = part.parent.getChildIndex(part);
						}
						if ((part is variableType))
						{
							var _local3:stlComponent = comp;
							_local3.sui_internal::setVariableSkin(variableName, part, metadata);
						}
						else
						{
							try
							{
								x = part.x;
								y = part.y;
							}
							catch (err:Error)
							{
							}
							_local3 = comp;
							_local3.sui_internal::setVariableSkin(variableName, new variableType(part), metadata);
							comp[variableName].x = x;
							comp[variableName].y = y;
							skin.addChildAt(comp[variableName], depth);
						}
						depthObjects[depth] = comp[variableName];
					}
					else
					{
						if (!((metadata.has("optional") && metadata.get("optional") == true) || metadata.get("") == "optional"))
						{
							throw(new ReferenceError(StringUtil.substitute("{0} is required in {1} but not found in skin {2}", [variableName, (comp["constructor"] + ""), skin.name])));
						}
					}
				}
			}
			var positioning:Function = function():void
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
				}
				else
				{
					comp.addChild(skin);
					skin.x = 0;
					skin.y = 0;
				}
			}
			depthObjects = [];
			for each (variable in description.variables)
			{
				processSkinMetadata(variable);
			}
			positioning();
		}

		private function getChild(skin:*, variableName:String):*
		{
			// TODO Auto Generated method stub
			try
			{
				return tempObj;
			}
			finally
			{
				tempObj = null;
			}
		}

		private function hasProperty(skin:*, variableName:String):Boolean
		{
			var obj:DisplayObjectContainer = skin as DisplayObjectContainer;
			if (!obj)
			{
				return false;
			}
			tempObj = obj.getChildByName(variableName)
			if (tempObj)
			{
				return true;
			}
			else
			{
				return obj.hasOwnProperty(variableName);
			}
		}
	}
}
