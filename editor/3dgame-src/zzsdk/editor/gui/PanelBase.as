package zzsdk.editor.gui
{
	import sui.core.flash.Component;

	public class PanelBase extends Component
	{
		public function PanelBase(_arg1:*)
		{
			super(_arg1);
		}
	}
}
import flash.text.TextFormat;

import fl.controls.Button;
import fl.controls.CheckBox;
import fl.controls.ComboBox;
import fl.controls.TextArea;
import fl.controls.TextInput;
import fl.core.UIComponent;
import fl.managers.StyleManager;

{

	var obj:* = UIComponent.getStyleDefinition();
	obj.defaultTextFormat.font = "Courier New";
	obj.defaultTextFormat.size = 14;
	StyleManager.setComponentStyle(TextInput, "defaultTextFormat", obj.defaultTextFormat);
	StyleManager.setComponentStyle(TextInput, "textFormat", obj.defaultTextFormat);
	StyleManager.setComponentStyle(TextInput, "disabledTextFormat", obj.defaultTextFormat);
	StyleManager.setComponentStyle(TextArea, "defaultTextFormat", obj.defaultTextFormat);
	StyleManager.setComponentStyle(TextArea, "textFormat", obj.defaultTextFormat);
	StyleManager.setComponentStyle(ComboBox, "defaultTextFormat", obj.defaultTextFormat);
	StyleManager.setComponentStyle(ComboBox, "textFormat", obj.defaultTextFormat);
	StyleManager.setComponentStyle(Button, "defaultTextFormat", obj.defaultTextFormat);
	StyleManager.setComponentStyle(Button, "textFormat", obj.defaultTextFormat);
	StyleManager.setComponentStyle(CheckBox, "defaultTextFormat", new TextFormat("微软雅黑", 15));
	StyleManager.setComponentStyle(CheckBox, "textFormat", new TextFormat("微软雅黑", 15));
}
