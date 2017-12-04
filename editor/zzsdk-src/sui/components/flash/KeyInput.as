package sui.components.flash
{
	import flash.events.KeyboardEvent;

	public class KeyInput extends Input
	{
		private var skin2:*

		public function KeyInput(skin:*)
		{
			super(skin);
			skin2 = skin;
			skin2.addEventListener(KeyboardEvent.KEY_DOWN, textInput);
		}

		private function textInput(event:KeyboardEvent):void
		{
			event.preventDefault();
//			trace(event.keyCode);
			text = String.fromCharCode(event.charCode);
			if (event.charCode == 0)
			{
//				text = KeyNames
			}
		}
	}
}
import flash.ui.Keyboard;
import flash.utils.Dictionary;
import flash.utils.describeType;

class KeyNames
{
	init();

	private static var dic:Dictionary = new Dictionary;

	public static function init():void
	{
		var type:XML = describeType(Keyboard)
		for each (var c:XML in type.constant)
		{
			trace(c)
			dic;
		}
	}

	public static function getName(code:int):String
	{
		if (dic.hasOwnProperty("" + code))
			return dic["" + code];
		return "N/A"
	}
}
