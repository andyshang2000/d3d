package sui.components.bridge.feathers
{
	import feathers.controls.Button;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	import sui.core.starlingswf.stlComponent;

	public class Button extends stlComponent
	{
		private var obj:feathers.controls.Button;

		[Skin(optional)]
		public var upSkin:DisplayObject;
		[Skin(optional)]
		public var hoverSkin:DisplayObject;
		[Skin(optional)]
		public var downSkin:DisplayObject;

		public function Button(skin:*)
		{
			super(skin);
			obj = new feathers.controls.Button
			obj.addEventListener(Event.TRIGGERED, triggerHandler);
			obj.addEventListener(TouchEvent.TOUCH, touchHandler);
			if (!upSkin)
			{
				obj.upSkin = obj.hoverSkin = obj.downSkin = skin;
			}
			else
			{
				obj.upSkin = upSkin;
				obj.hoverSkin = hoverSkin || upSkin;
				obj.downSkin = downSkin || upSkin;
			}
			addChild(obj);
		}
		
		private function touchHandler(event:TouchEvent):void
		{
			trace("hu??")
		}
		
		private function triggerHandler(event:Event):void
		{
			trace("triggered")
			dispatchEvent(event);
		}
	}
}
