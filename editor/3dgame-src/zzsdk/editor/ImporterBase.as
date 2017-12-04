package zzsdk.editor
{
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	import zzsdk.editor.utils.FileUtil;

	public class ImporterBase implements IFileImporter
	{
		private static var _p:int = 0;

		private var _priority:int = ++_p;

		public function get priority():int
		{
			return _priority;
		}

		public function get terminate():Boolean
		{
			return false;
		}

		public function validate(filename:String):Boolean
		{
			return false;
		}

		public function importFile(file:File):void
		{
			importBytes(file.name, FileUtil.readFile(file));
		}

		public function importBytes(filename:String, bytes:ByteArray):void
		{
		}
	}
}
