package ands.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class FileUtil
	{
		public static function open(file:File):Reader
		{
			if (file.exists)
			{
				var fs:FileStream = new FileStream;
				fs.open(file, FileMode.READ);
				return new Reader(fs);
			}
			else
				return null;
		}
	}
}
