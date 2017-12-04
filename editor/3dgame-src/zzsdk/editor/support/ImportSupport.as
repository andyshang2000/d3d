package zzsdk.editor.support
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import zzsdk.editor.IFileImporter;
	import zzsdk.editor.ImportFileEvent;
	import zzsdk.editor.ImporterBase;

	public class ImportSupport
	{
		private var host:DisplayObjectContainer;
		private var importerList:Vector.<IFileImporter> = new Vector.<IFileImporter>;

		public function accept(host:DisplayObjectContainer):void
		{
			this.host = host;
			if (host.stage)
				setup();
			else
				host.addEventListener(Event.ADDED_TO_STAGE, function():void
				{
					host.removeEventListener(Event.ADDED_TO_STAGE, arguments.calee);
					setup();
				})
		}

		private function setup():void
		{
			host.stage.addEventListener(ImportFileEvent.IMPORT, importFileHandler);
		}

		protected function importFileHandler(event:ImportFileEvent):void
		{
			importFile(event.file);
		}

		public function addImporter(importer:IFileImporter):void
		{
			if ((importer is DisplayObject) && importer != host)
			{
				host.addChild(importer as DisplayObject).visible = false;
			}
			importerList.push(importer);
			importerList.sort(function(p1:ImporterBase, p2:ImporterBase):int
			{
				if (p1.priority > p2.priority)
					return -1;
				if (p1.priority < p2.priority)
					return 1;
				return 0;
			});
		}

		public function importBytes(filename:String, bytes:ByteArray):void
		{
			for (var i:int = 0; i < importerList.length; i++)
			{
				if (importerList[i].validate(filename))
				{
					importerList[i].importBytes(filename, bytes)
					if (importerList[i].terminate)
					{
						break;
					}
				}
			}
		}

		public function importFile(file:File):void
		{
			for (var i:int = 0; i < importerList.length; i++)
			{
				if (importerList[i].validate(file.name))
				{
					importerList[i].importFile(file)
					if (importerList[i].terminate)
					{
						break;
					}
				}
			}
		}
	}
}
