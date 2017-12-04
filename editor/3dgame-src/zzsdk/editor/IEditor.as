package zzsdk.editor
{
	import flash.utils.ByteArray;

	public interface IEditor
	{
		function saveQdrx():void;
		function preview():void;
		function exportIPA(debug:Boolean = false):void;
		function exportAPK(debug:Boolean = false):void;
		function importBytes(filename:String, bytes:ByteArray):void
		function addImporter(importer:IFileImporter):void
	}
}
