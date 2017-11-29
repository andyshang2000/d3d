package diary.ui.view
{
	import diary.game.Item;

	import lzm.starling.swf.display.SwfButton;

	import starling.events.Event;
	import starling.text.TextField;

	public class RewardPanel extends ViewBase
	{
		public var $titleField:TextField;
		public var $getButton:SwfButton;

		override protected function _fieldInit():void
		{
			visible = false;
			$getButton.addEventListener(Event.TRIGGERED, triggerEvent);
			$getButton.text = "放进背包";
		}

		private function triggerEvent():void
		{
			dispatchEventWith("get");
		}

		public function show(item:Item):void
		{
			$titleField.text = item.name;
			visible = true;
		}

		public function hide():void
		{
		}

		public function RewardPanel()
		{
		}
	}
}
