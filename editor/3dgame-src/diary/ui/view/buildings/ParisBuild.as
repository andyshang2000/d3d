package diary.ui.view.buildings
{
	import starling.display.MovieClip;

	public class ParisBuild extends BuildBase
	{
		private var eff1:MovieClip;
		private var eff2:MovieClip;
		private var eff3:MovieClip;
		private var eff4:MovieClip;

		public function ParisBuild(assets:* = null)
		{
			super(assets)
			id = "paris";
			initView();
		}

		private function initView():void
		{
			createSkin(256, 350);
			createEffect("butterfly1", -10, 161);
			createEffect("bigfly1", 183, 129);
			createEffect("butterfly2", 209, 245);
			createEffect("bigfly2", 32, 25);
		}
	}
}
