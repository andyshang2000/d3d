package zzsdk.editor.utils.binding
{
	import zzsdk.editor.gui.AutoVersion;
	import zzsdk.editor.utils.Binding;

	public class AutoVersionBinding extends Binding
	{
		public function AutoVersionBinding()
		{
			super();
		}

		override public function updateView():void
		{
			var value:String = getterFromModel();
			var version:AutoVersion = comp as AutoVersion;
			version.update(GameInfo.app_id);
		}

		override public function updateModel():void
		{
			var version:AutoVersion = comp as AutoVersion;
			var value:String = version.toString();
			setterToModel(value);
		}
	}
}
