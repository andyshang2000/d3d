package zzsdk.editor

{
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public interface IFileImporter
	{
		function get terminate():Boolean
		function validate(filename:String):Boolean
		function importFile(file:File):void;
		function importBytes(filename:String, bytes:ByteArray):void;
	}
}
