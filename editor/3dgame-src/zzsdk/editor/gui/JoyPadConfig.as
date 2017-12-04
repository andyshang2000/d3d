package zzsdk.editor.gui
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.describeType;

	import fl.controls.ComboBox;
	import fl.controls.TextInput;

	import sui.core.flash.Component;

	public class JoyPadConfig extends Component
	{
		[Skin]
		public var up:TextInput;
		[Skin]
		public var down:TextInput;
		[Skin]
		public var left:TextInput;
		[Skin]
		public var right:TextInput;

		[Skin]
		public var A:TextInput;
		[Skin]
		public var B:TextInput;
		[Skin]
		public var L:TextInput;
		[Skin]
		public var R:TextInput;

		[Skin]
		public var start:TextInput;
		[Skin]
		public var select:TextInput;

		[Skin]
		public var styleCombo:ComboBox;

		private var invIndex:Array = [];

		private var tIndex:int = 0;
		private var tabArr:Array = [];

		public function JoyPadConfig()
		{
			super(JoyPadPanelAsset);
			//
			setupInput(up);
			setupInput(down);
			setupInput(left);
			setupInput(right);
			setupInput(A);
			setupInput(B);
			setupInput(L);
			setupInput(R);
			setupInput(start);
			setupInput(select);
			//
			var xml:XML = describeType(Keyboard);
			for each (var node:XML in xml.constant)
			{
				var vName:String = node.@name;
				if (Keyboard[vName] is Number)
				{
					invIndex[Keyboard[vName]] = vName;
				}
			}

			var self:JoyPadConfig = this;
			addEventListener(Event.ADDED_TO_STAGE, function():void
			{
				stage.focus = up;
				x = 300;
				y = 200;
				stage.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void
				{
					if (!getBounds(stage).contains(event.stageX, event.stageY))
					{
						stage.removeEventListener(MouseEvent.MOUSE_DOWN, arguments.callee, true);
						visible = false;
						parent.removeChild(self);
					}
				}, true)
			})

			styleCombo.addEventListener(Event.CHANGE, function():void
			{
				if (styleCombo.selectedIndex == 0)
				{
					update("W,S,A,D,K,J,U,I,ENTER,SPACE");
				}
				else if (styleCombo.selectedIndex == 1)
				{
					update("UP,DOWN,LEFT,RIGHT,C,X,Z,V,ENTER,SPACE");
				}
				stage.focus = up;
			});
		}

		private function setupInput(input:TextInput):void
		{
			input.tabIndex = tIndex++;
			tabArr.push(input);
			input.addEventListener(KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent):void
			{
				event.preventDefault();
				if (event.keyCode == Keyboard.COMMA)
				{
					return;
				}
				if (event.keyCode == Keyboard.BACKSPACE || event.keyCode == Keyboard.DELETE)
				{
					styleCombo.selectedIndex = 2;
					input.text = "";
				}
				else if (event.keyCode == Keyboard.TAB)
				{
					stage.focus = tabArr[(input.tabIndex + 1) % tabArr.length];
				}
				else
				{
					styleCombo.selectedIndex = 2;
					input.text = invIndex[event.keyCode];
					stage.focus = tabArr[(input.tabIndex + 1) % tabArr.length];
				}
			})
		}

		public function update(str:String):void
		{
			if (!str)
				return;
			var args:Array = str.split(",")
			for (var i:int = 0; i < args.length; i++)
			{
				tabArr[i].text = args[i] || "";
			}
		}

		override public function toString():String
		{
			var res:String = "";
			for (var i:int = 0; i < tabArr.length; i++)
			{
				res += tabArr[i].text + ","
			}
			return res.substring(0, res.length - 1);
		}
	}
}
