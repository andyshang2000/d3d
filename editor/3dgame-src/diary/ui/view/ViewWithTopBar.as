package diary.ui.view
{
	import diary.res.RES;

	import starling.display.Sprite;
	import starling.text.TextField;

	public class ViewWithTopBar extends ViewBase
	{
		public var $goldField:TextField;
		public var $energyField:TextField;
		public var $levelField:TextField;

		public function getTopbar():Sprite
		{
			return RES.get("gui/spr_topbar");
		}
	}
}
