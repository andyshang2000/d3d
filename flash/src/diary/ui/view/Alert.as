package diary.ui.view
{
	import diary.ui.util.GViewSupport;

	import fairygui.GComponent;
	import fairygui.GRoot;
	import fairygui.UIPackage;
	import fairygui.Window;

	public class Alert extends GComponent
	{
		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);
		}

		[Handler(clickGTouch)]
		public function replayButtonClick():void
		{
			trace("replay!");
		}

		[Handler(clickGTouch)]
		public function quitButtonClick():void
		{
			if (quit != null)
				quit();
			trace("quitButtonClick!");
		}

		[Handler(clickGTouch)]
		public function musicButtonClick():void
		{
			trace("musicButtonClick!");
		}

		[Handler(clickGTouch)]
		public function soundButtonClick():void
		{
			trace("soundButtonClick!");
		}

		[Handler(clickGTouch)]
		public function helpButtonClick():void
		{
			trace("helpButtonClick!");
		}

		[Handler(clickGTouch)]
		public function closeButtonClick():void
		{
		}

		private var quit:Function;
		private var replay:Function;
		private var help:Function;
		private var sound:Function;
		private var music:Function;

		public static function show(param:* = null):void
		{
			var win:Window = new Window();
			win.contentPane = UIPackage.createObject("zz3d.m3.gui", "Alert").asCom;
			if (param != null)
			{
				var inst:Alert = win.contentPane as Alert;
				inst.quit = param.quit;
				inst.replay = param.quit;
				inst.help = param.quit;
				inst.sound = param.quit;
				inst.music = param.quit;
			}
			GRoot.inst.showPopup(win);
		}
	}
}
