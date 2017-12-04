package zzsdk.editor.utils
{
	public class Binding
	{

		public var model:Object;
		public var field:Object;
		public var comp:Object;
		public var compField:Object;

		public var setterToModel:Function = _setterToModel;
		public var getterFromModel:Function = _getterFromModel;

		private function _setterToModel(value:*):void
		{
			model[field] = value;
		}

		private function _getterFromModel():*
		{
			return model[field]
		}

		public function updateView():void
		{
			comp[compField] = getterFromModel();
		}

		public function updateModel():void
		{
			setterToModel(comp[compField])
		}
	}
}
