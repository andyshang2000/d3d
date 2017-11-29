package diary.ui.view
{
	import lzm.starling.display.Button;

	import starling.events.Event;

	public class ConfirmAlert extends ViewWithTopBar
	{
		public var $confirmButton:Button;
		public var $cancelButton:Button;
		private var _onConfirm:Object;
		private var _onCancel:Object;

		override public function loadAssets(callback:Function = null):void
		{
			$confirmButton.text = "接受任务";
			$cancelButton.text = "取消";
			$confirmButton.addEventListener(Event.TRIGGERED, function():void
			{
				_onConfirm();
			});
			$cancelButton.addEventListener(Event.TRIGGERED, function():void
			{
				_onCancel();
			});
		}

		public function set onCancel(value:Object):void
		{
			_onCancel = value;
		}

		public function set onConfirm(value:Object):void
		{
			_onConfirm = value;
		}

	}
}
