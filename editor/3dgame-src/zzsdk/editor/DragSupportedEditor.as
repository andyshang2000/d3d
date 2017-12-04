package zzsdk.editor
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import zzsdk.editor.gui.DragArea;
	import zzsdk.editor.support.ImportSupport;
	import zzsdk.templates.AppBase;

	public class DragSupportedEditor extends AppBase implements IEditor
	{
		private var importSupport:ImportSupport = new ImportSupport;

		public function DragSupportedEditor()
		{
			importSupport = new ImportSupport;
			importSupport.accept(this);
		}

		public function setSuppotExtension(... args):void
		{
			addChildAt(new DragArea(args), 0);
		}

		public function addImporter(importer:IFileImporter):void
		{
			importSupport.addImporter(importer);
		}

		public function importBytes(filename:String, content:ByteArray):void
		{
			importSupport.importBytes(filename, content);
		}

		public function saveQdrx():void
		{
		}

		public function preview():void
		{
		}

		public function exportIPA(debug:Boolean = false):void
		{
		}

		public function exportAPK(debug:Boolean = false):void
		{
		}
	}
}
