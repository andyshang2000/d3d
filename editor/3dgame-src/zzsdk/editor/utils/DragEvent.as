package zzsdk.editor.utils
{
	import flash.events.Event;

	public class DragEvent extends Event
	{
		public static const START:String = "dragStart";
		public static const ENTER:String = "dragEnter";
		public static const DROP:String = "dragDrop";
		public static const OUT:String = "dragOut";
		public static const COMPLETE:String = "dragComplete";

		public var source:Object;

		public function DragEvent(type:String, source:Object = null)
		{
			super(type);
			this.source = source;
		}

		override public function clone():Event
		{
			return new DragEvent(type, source);
		}
	}
}
