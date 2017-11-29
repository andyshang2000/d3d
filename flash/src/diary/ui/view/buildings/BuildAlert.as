package diary.ui.view.buildings
{
	import flash.text.Font;
	
	import feathers.controls.Button;
	
	import diary.ui.view.Worldmap;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	import sui.utils.stlSWFUtil;
	
	import zzsdk.display.Screen;

	public class BuildAlert extends Sprite
	{
		private var msgText:TextField;
		private var skin:DisplayObject;
		private var callback:Function;
		private var yesBtn:Button;
		private var closeBtn:Button;
		private var bgImg:Image;

		public function BuildAlert()
		{
			var quad:Quad = new Quad(Screen.designW, Screen.designH);
			quad.name = "build alter";
			addChild(quad);
			quad.alpha = 0.1;
			bgImg = new Image(stlSWFUtil.getAssetManager("gui").getTexture("img_alertBg"));
			addChild(bgImg);
			bgImg.x = (Screen.designW - bgImg.width) / 2;
			bgImg.y = (Screen.designH - bgImg.height) / 2;

			closeBtn = new Button();
			addChild(closeBtn);
			closeBtn.defaultSkin = new Image(stlSWFUtil.getAssetManager("gui").getTexture("img_closeButton"));
			closeBtn.x = bgImg.x + bgImg.width - 60;
			closeBtn.y = bgImg.y - 10;
			closeBtn.addEventListener(Event.TRIGGERED, closeHandler);
			closeBtn.touchable = true

			yesBtn = new Button();
			addChild(yesBtn);
			var btnSkin:Image = new Image(stlSWFUtil.getAssetManager("gui").getTexture("img_yesButton"));
			yesBtn.defaultSkin = btnSkin;
			yesBtn.x = (Screen.designW - btnSkin.width) / 2;
			yesBtn.y = bgImg.y + bgImg.height - 100;
			yesBtn.addEventListener(Event.TRIGGERED, yesHandler);
			yesBtn.touchable = true;

			msgText = new TextField(280, 380, "", "Verdana", 30, 0x000066);
			addChild(msgText);
			msgText.autoScale = true;
			msgText.x = (Screen.designW - msgText.width) / 2;
			msgText.y = yesBtn.y - msgText.height;
			msgText.touchable = false;
		}

		private function yesHandler(e:Event):void
		{
			callback("yes");
			hide();
		}

		private function closeHandler(e:Event):void
		{
			hide();
		}

		private function hide():void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			msgText.text = "";
		}

		public function show(msg:String, fun:Function):void
		{
			callback = fun;
			msgText.text = msg;
		}

	}
}
