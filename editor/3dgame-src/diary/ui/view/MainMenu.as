package diary.ui.view
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import ands.utils.FileUtil;
	
	import diary.res.RES;
	
	import fairygui.UIPackage;
	
	import lzm.starling.swf.display.SwfButton;
	
	import starling.display.Sprite;
	import starling.text.TextField;

	public class MainMenu extends ViewBase implements IScreen
	{
		public var $title:TextField;
		public var $startButton:SwfButton;
		public var $settingsButton:SwfButton;
		public var $galleryButton:SwfButton;

		public function getBack():Sprite
		{
			return RES.get("gui/spr_mainMenu");
		}
		
		override public function loadAssets(callback:Function = null):void
		{
			UIPackage.addPackage(ByteArray(FileUtil.open(File.applicationDirectory.resolvePath("assets/Joystick.zip"))), null);			
			//等待图片资源全部解码，也可以选择不等待，这样图片会在用到的时候才解码
			UIPackage.waitToLoadCompleted(callback);
		}

		override public function initialize(callback:Function = null):void
		{
			$startButton.text = "新游戏";
			$settingsButton.text = "加载游戏";
			$galleryButton.text = "相册";
//			$galleryButton.text = "";
		}
	}
}
