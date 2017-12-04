package
{
	import flash.display.Sprite;
	import flash.filesystem.File;

	public class Cleanup extends Sprite
	{
		public function Cleanup()
		{
			var root:File = File.applicationDirectory.resolvePath("D:\\3dgame\\f3dfiles");
			doClean(root);
		}

		private function doClean(root:File):void
		{
			var dir:Array = root.getDirectoryListing();
			for each (var file:File in dir)
			{
				if (file.isDirectory)
				{
					doClean(file);
				}
				else if (file.extension != "zf3d")
				{
					new File(file.nativePath).deleteFileAsync();
				}
			}
		}
	}
}
