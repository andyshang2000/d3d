package zzsdk.editor.utils.binding
{
	import fl.controls.CheckBox;

	import zzsdk.editor.utils.Binding;

	public class CheckboxBinding extends Binding
	{
		override public function updateView():void
		{
			var value:String = getterFromModel();
			var box:CheckBox = comp as CheckBox;
			box.selected = value == "1";
		}

		override public function updateModel():void
		{
			var box:CheckBox = comp as CheckBox;
			setterToModel(box.selected ? "1" : "0");
		}
	}
}

