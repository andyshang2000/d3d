package sui.components.flash
{
	import flash.display.SimpleButton;
	import flash.text.TextField;

	import fl.core.UIComponent;

	public class PushButton extends GUIControl
	{
		[Skin(optional = true)]
		public var labelField:TextField;

		public function PushButton(_arg1:*)
		{
			super(_arg1 is UIComponent ? null : _arg1);
			if (_arg1 is UIComponent)
			{
				addChild(_arg1);
				_arg1.x = 0;
				_arg1.y = 0;
			}
			if (labelField)
			{
				labelField.mouseEnabled = false;
				labelField.selectable = false;
			}
			if (_arg1 is SimpleButton)
			{
				removeChild(_arg1);
				addChild(new SimpleButtonWrap(_arg1 as SimpleButton));
			}
		}

		public function set label(str:String):void
		{
			if (labelField)
			{
				labelField.text = str;
			}
		}
	}
}
import flash.display.DisplayObject;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class SimpleButtonWrap extends Sprite
{
	private var button:SimpleButton;
	private var upState:DisplayObject;
	private var overState:DisplayObject;
	private var downState:DisplayObject;

	public function SimpleButtonWrap(button:SimpleButton)
	{
		this.button = button;
		addChild(button);
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	private function addedToStageHandler(event:Event):void
	{
		button.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE, false, true, -100, -100));
		button.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, false, true, -100, -100));
	}

	private function rollOutHandler(event:MouseEvent):void
	{
	}
}
