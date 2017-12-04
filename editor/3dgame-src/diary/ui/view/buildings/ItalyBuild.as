package diary.ui.view.buildings
{
	import starling.display.MovieClip;

	/**
	 *意大利
	 */
	public class ItalyBuild extends BuildBase
	{
		private var eff1:MovieClip;

		public function ItalyBuild(assets:* = null)
		{
			super(assets)
			id = "italy";
			initView();
		}

		private function initView():void
		{
			createSkin(300, 300);
			createEffect("grass", 239 - 328, 50 - 74);
		}
	}
}
