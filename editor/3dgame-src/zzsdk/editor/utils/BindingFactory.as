package zzsdk.editor.utils
{
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;

	import zzsdk.editor.gui.AutoVersion;
	import zzsdk.editor.gui.JoyPadConfig;
	import zzsdk.editor.utils.binding.AutoVersionBinding;
	import zzsdk.editor.utils.binding.CheckboxBinding;
	import zzsdk.editor.utils.binding.ComboboxBinding;
	import zzsdk.editor.utils.binding.JoyPadBinding;

	public class BindingFactory
	{
		private static var instance:BindingFactory;

		public static function create(model:Object, field:String, comp:*, compField:String = null, setter:* = null, getter:* = null):Binding
		{
			var binding:Binding = instance.create(comp, compField);

			binding.model = model;
			binding.field = field;
			binding.comp = comp;
			binding.compField = compField;
			binding.setterToModel = setter || binding.setterToModel;
			binding.getterFromModel = getter || binding.getterFromModel;

			return binding;
		}

		public function BindingFactory()
		{
			instance = this;
		}

		protected function create(comp:*, compField:String):Binding
		{
			if (comp is ComboBox)
			{
				return new ComboboxBinding;
			}
			if (comp is AutoVersion)
			{
				return new AutoVersionBinding;
			}
			if (comp is CheckBox)
			{
				return new CheckboxBinding;
			}
			if (comp is JoyPadConfig)
			{
				return new JoyPadBinding;
			}
			return new Binding;
		}
	}
}
