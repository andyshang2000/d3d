package diary.ui.view.buildings
{
	import starling.display.MovieClip;

	public class AmericaBuild extends BuildBase
	{
		private var eff1:MovieClip;
		private var eff2:MovieClip;
		private var eff3:MovieClip;

		public function AmericaBuild(assets:* = null)
		{
			super(assets)
			id = "america";
			initView();
		}

		private function initView():void
		{
			createSkin(220, 360);
			createEffect("lamp3", 37.5 - 74, 246.5 - 161);
			createEffect("lamp3", 156 - 74, 272 - 161);
			createEffect("lamp3", 179 - 74, 206 - 161);
		}
	}
}
