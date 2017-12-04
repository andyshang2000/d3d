package zzsdk.editor.utils.binding
{
	import zzsdk.editor.gui.JoyPadConfig;
	import zzsdk.editor.utils.Binding;

	public class JoyPadBinding extends Binding
	{
		override public function updateView():void
		{
			var value:String = getterFromModel();
			var joyPad:JoyPadConfig = comp as JoyPadConfig;
			joyPad.update(value);
		}

		override public function updateModel():void
		{
			var joyPad:JoyPadConfig = comp as JoyPadConfig;
			setterToModel(joyPad + "");
		}
	}
}
