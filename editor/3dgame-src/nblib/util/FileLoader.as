package nblib.util
{
	import flash.display.Loader;
	import flash.filesystem.File;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	import zzsdk.editor.FileUtil;

	public class FileLoader extends Loader
	{
		private var loaderContext:LoaderContext;

		public function FileLoader(lc:LoaderContext = null)
		{
			if (!lc)
			{
				lc = new LoaderContext(false, ApplicationDomain.currentDomain);
				lc.allowCodeImport = true;
			}
			loaderContext = lc;
		}

		public function loadFile(file:File):void
		{
			loadBytes(FileUtil.readFile(file), loaderContext);
		}
	}
}
