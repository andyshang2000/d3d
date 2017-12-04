package zzsdk.editor.gui
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	import mx.utils.StringUtil;

	import fl.controls.ComboBox;

	import nblib.util.Reader;

	import sui.components.flash.Input;
	import sui.components.flash.PushButton;

	import zzsdk.editor.utils.FileUtil;

	public class AddScreenSizeControl
	{
		private var screenSizeCombo:ComboBox;
		private var addSizeButton:PushButton;
		private var addSizeField:Input;
		private var commitAddButton:PushButton;

		public function AddScreenSizeControl(screenSizeCombo:Object, addSizeButton:PushButton, addSizeField:Input, commitAddButton:PushButton)
		{
			this.screenSizeCombo = screenSizeCombo as ComboBox;
			this.addSizeButton = addSizeButton;
			this.addSizeField = addSizeField;
			this.commitAddButton = commitAddButton;

			addSizeField.visible = false;
			commitAddButton.visible = false;

			addSizeButton.addEventListener(MouseEvent.CLICK, addHandler);
			commitAddButton.addEventListener(MouseEvent.CLICK, commitHandler);

			readScreenSize();
		}

		private function readScreenSize():void
		{
			var reader:Reader = Reader.open(File.applicationDirectory.resolvePath("screensize.txt"));
			if (reader)
			{
				while (reader.hasNextline())
				{
					var line:String = StringUtil.trim(reader.readLine());
					if (line.length == 0)
					{
						continue;
					}
					screenSizeCombo.addItem({label: line.split(":")[1]});
				}
			}
		}

		protected function addHandler(event:MouseEvent):void
		{
			addSizeField.visible = true;
			commitAddButton.visible = true;

			addSizeButton.removeEventListener(MouseEvent.CLICK, addHandler);
			addSizeButton.stage.addEventListener(MouseEvent.CLICK, stageClick, true)
		}

		protected function stageClick(event:MouseEvent):void
		{
			if (!commitAddButton.contains(event.target as DisplayObject) && // 
				!addSizeField.contains(event.target as DisplayObject))
			{
				addSizeField.text = "";
				addSizeField.visible = false;
				commitAddButton.visible = false;
				addSizeButton.addEventListener(MouseEvent.CLICK, addHandler);
			}
		}

		protected function commitHandler(event:MouseEvent):void
		{
			if (valid(addSizeField.text))
			{
				addSizeField.visible = false;
				commitAddButton.visible = false;

				var str:String = addSizeField.text;
				var d:Array = str.split("x")
				var w:int = int(d[0]);
				var h:int = int(d[1]);
				addScreenSize(StringUtil.substitute("{0}x{2}:{0}x{1}", w, h, h - 20));
			}
		}

		private function addScreenSize(line:String):void
		{
			var item:Object
			var dp:Array = screenSizeCombo.dataProvider.toArray();
			for each (item in dp)
			{
				if (item.label == line)
				{
					return;
				}
			}
			screenSizeCombo.addItem({label: line.split(":")[1]});
			dp = screenSizeCombo.dataProvider.toArray();
			var str:String = "";
			for each (item in dp)
			{
				str += item.label + ":" + item.label + "\n"
			}
			FileUtil.save(str, File.applicationDirectory.resolvePath("screensize.txt").nativePath);
		}

		private function valid(text:String):Boolean
		{
			return /^\d{3,}x\d{3,}$/.test(text);
		}
	}
}
