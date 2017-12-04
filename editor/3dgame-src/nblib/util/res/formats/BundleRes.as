package nblib.util.res.formats
{
	import flash.events.Event;
	import flash.system.System;

	import deng.fzip.FZip;
	import deng.fzip.FZipFile;

	import nblib.util.res.ResManager;

	public class BundleRes extends Res
	{
		private var zip:FZip;

		public function BundleRes(path:String)
		{
			super(path);
		}

		protected override function completeHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			event.stopImmediatePropagation();
			event.preventDefault();

			zip = new FZip();
			zip.addEventListener(Event.COMPLETE, zip_completeHandler);
			try
			{
				trace(System.freeMemory + "/" + System.privateMemory + "/" + System.totalMemoryNumber)
				zip.loadBytes(data);
			}
			catch (err:Error)
			{
				trace(err.getStackTrace());
			}
		}

		private function zip_completeHandler(event:Event):void
		{
			parseZip(zip);
		}

		protected function parseZip(zip:FZip):void
		{
			var count:int = zip.getFileCount();
			for (var i:int = 0; i < count; i++)
			{
				var file:FZipFile = zip.getFileAt(i);
				ResManager.addFile(file.filename, file.content);
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}

		override public function dispose():Boolean
		{
			var count:int = zip.getFileCount();
			for (var i:int = 0; i < count; i++)
			{
				var file:FZipFile = zip.getFileAt(i);
				ResManager.removeRes(file.filename);
			}

			zip.close();
			zip = null;
			super.dispose();
			return true;
		}
	}
}
