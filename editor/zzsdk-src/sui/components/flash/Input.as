package sui.components.flash
{
	import flash.text.TextField;
	
	import fl.controls.TextInput;
	
	import sui.core.flash.Component;

	public class Input extends Component
	{
		private var skin2:*;

		public function Input(skin:*)
		{
			super(null);
			this.skin2 = skin
			addChild(skin);
			skin.x = 0;
			skin.y = 0;
		}

		public function set enabled(value:Boolean):void
		{
			skin2.enabled = value;
		}

		override public function set tabIndex(index:int):void
		{
			skin2.tabIndex = index;
		}

		public function get text():String
		{
			return skin2.text;
		}

		public function set text(value:String):void
		{
			skin2.text = value;
		}
		
		public function asPassword(bool:Boolean):void
		{
			skin2.displayAsPassword = bool;
		}

		public function focus():void
		{
			stage.focus = skin2;
		}
		
		override public function toString():String
		{
			return text;
		}
	}
}
