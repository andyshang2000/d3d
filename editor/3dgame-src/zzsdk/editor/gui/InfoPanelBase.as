package zzsdk.editor.gui
{
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import fl.controls.ComboBox;

	import sui.components.flash.Input;
	import sui.components.flash.PushButton;

	public class InfoPanelBase extends PanelBase
	{
		[Skin]
		public var closeButton:PushButton;
		//
		[Skin]
		public var qdrxButton:PushButton;
		[Skin]
		public var apkButton:PushButton;
		[Skin]
		public var ipaButton:PushButton;
		[Skin]
		public var previewButton:PushButton;
		[Skin(optional)]
		public var iosPreviewButton:PushButton;
		[Skin]
		public var screenshotButton:PushButton;
		//预览尺寸什么的
		[Skin]
		public var screenSizeCombo:ComboBox;
		[Skin]
		public var addSizeButton:PushButton;
		[Skin]
		public var addSizeField:Input;
		[Skin]
		public var commitAddButton:PushButton;
		//
		[Skin]
		public var iconField:TextField;
		[Skin]
		public var iconRoundCombo:ComboBox;
		[Skin]
		public var iconSaveAsButton:PushButton;

		public function InfoPanelBase(_arg1:*)
		{
			super(_arg1);
			new AddScreenSizeControl(screenSizeCombo, addSizeButton, addSizeField, commitAddButton);

			closeButton.useHandCursor = true;
			closeButton.buttonMode = true;
			closeButton.addEventListener(MouseEvent.CLICK, function():void
			{
				hide();
			})
		}

		public function show():void
		{
			x = 12;
			y = 8;
		}

		private function hide():void
		{
			parent.removeChild(this);
			visible = false;
		}
	}
}
