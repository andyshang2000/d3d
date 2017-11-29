package diary.ui.components
{
	import feathers.controls.List;
	import feathers.controls.ToggleButton;

	public class ItemRendererBase extends ToggleButton
	{
		//
		private var _index:int = -1;
		private var _owner:List;
		private var _data:Object;
		private var _isSelected:Boolean;
		
		public function ItemRendererBase() 
		{
			touchable = true;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			if (_index == value)
				return;

			_index = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}

		public function get owner():List
		{
			return _owner;
		}

		public function set owner(value:List):void
		{
			if (_owner == value)
				return;

			_owner = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			if (_data == value)
				return;

			_data = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}

		override protected function draw():void
		{
			var dataInvalid:Boolean = isInvalid(INVALIDATION_FLAG_DATA);

			if (dataInvalid)
			{
				commitData();
			}
		}

		protected function commitData():void
		{
		}
	}
}
