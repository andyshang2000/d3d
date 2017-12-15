package diary.ui.view
{
	import com.popchan.sugar.core.Model;
	
	import diary.ui.util.GViewSupport;
	
	import fairygui.GComponent;
	import fairygui.GRoot;
	import fairygui.UIPackage;
	import fairygui.Window;

	public class EndPanel extends GComponent
	{
		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);
		}

		[Handler(clickGTouch)]
		public function closeButtonClick():void
		{
		}

		public static function show():void
		{
			var win:Window = new Window();
			win.contentPane = UIPackage.createObject("zz3d.m3.gui", "EndPanel").asCom;
			Model.gameModel.isScoreAimLevel()
			win.contentPane.getTransition("t0").play();
			win.contentPane.getTransition("t1").play();
			win.contentPane.getTransition("t2").play();
			GRoot.inst.showPopup(win);
		}
	}
}
