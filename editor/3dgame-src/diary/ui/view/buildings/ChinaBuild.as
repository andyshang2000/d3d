package diary.ui.view.buildings
{
	import starling.display.MovieClip;

	public class ChinaBuild extends BuildBase
	{
		private var eff1:MovieClip;
		private var eff2:MovieClip;
		private var eff3:MovieClip;

		public function ChinaBuild(assets:* = null)
		{
			super(assets)
			id = "china";
			initView();
		}

		protected function initView():void
		{
			createSkin(210, 350);
			createEffect("uwa", 37 - 10, 253.5 - 10);
			createEffect("rad", 80 - 10, 64 - 10);
			createEffect("twinkle", 85 - 10, 18 - 10);
		}
	}
}
