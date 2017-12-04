package zzsdk.editor.utils.binding
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;

	import zzsdk.editor.utils.Binding;

	public class ComboboxBinding extends Binding
	{
		public function ComboboxBinding()
		{
			super();
		}

		override public function updateView():void
		{
			var value:String = getterFromModel();
			var combo:ComboBox = comp as ComboBox;
			var dp:DataProvider = combo.dataProvider;

			for (var i:int = 0; i < dp.length; i++)
			{
				var item:* = dp.getItemAt(i);
				if (item.data == value)
				{
					combo.selectedIndex = i;
					return;
				}
			}
			combo.selectedIndex = 0;
		}

		override public function updateModel():void
		{
			var combo:ComboBox = comp as ComboBox;
			var value:String = combo.selectedItem.data;
			setterToModel(value);
		}
	}
}
