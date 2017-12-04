package diary.module.idle.view
{
	import diary.module.idle.model.Progress;

	import starling.display.Sprite;
	import starling.text.TextField;

	public class ProgressBar extends Sprite
	{
		public var text:TextField;
		private var progress:Progress;

		public function ProgressBar()
		{
			text = new TextField(120, 30, "");
			addChild(text);
		}

		public function setProgress(progress:Progress):void
		{
			this.progress = progress;
		}

		public function update():void
		{
			text.text = (100 * progress.current / progress.total).toPrecision(3) + "%"
		}
	}
}
