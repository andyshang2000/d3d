package zzsdk.editor
{
	import flash.events.Event;
	import flash.filesystem.File;

	public class ImportFileEvent extends Event
	{

		private var _file:File;

		public static const IMPORT:String = "importFile";

		public function ImportFileEvent(file:File)
		{
			super(IMPORT, false, false);
			this._file = file;
		}

		public function get file():File
		{
			return (this._file);
		}

		public function get url():String
		{
			return (this.file.url);
		}

		override public function toString():String
		{
			return (formatToString("ImportFileEvent", "type", "url"));
		}
	}
}
