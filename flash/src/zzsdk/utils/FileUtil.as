package zzsdk.utils
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	//FIXME to merge the save method family
	public class FileUtil
	{
		public static var defaultFileName:String = "work.qdr";
		public static var lastSavedFile:File;

		private static var saveQueue:Array = [];
		private static var running:Boolean;

		public static var dir:File = File.applicationDirectory;
		public static var useCache:Boolean = true;

		private static var cache:Dictionary = new Dictionary();

		/**
		 *
		 * @param content ByteArray, String, AMF(Object)
		 * @param to
		 *
		 */
		public static function save(content:*, to:* = null):void
		{
			if (to == null)
			{
				saveAs(content);
			}
			if (to is String)
			{
				save(content, new File(dir.resolvePath(to).nativePath))
				return
			}
			if (to is File)
				saveDataToFile(content, to);
		}

		/**
		 *
		 * @param content ByteArray, String, File
		 *
		 */
		public static function saveAs(content:*, callback:Function = null):void
		{
			if (content is File)
			{
				saveFileAs(content as File, callback);
				return;
			}
			if (content is String)
			{
				var bytes:ByteArray = new ByteArray;
				bytes.writeMultiByte(content + "", "utf-8");
				saveAs(bytes, callback);
				return;
			}
			else if (!(content is ByteArray))
			{
				saveAs(content + "", callback);
				return;
			}
			var fr:File = new File();
			fr.save("", FileUtil.defaultFileName);
			trace("save file to default path: " + FileUtil.defaultFileName);
			fr.addEventListener(Event.SELECT, function selectHandler(e:Event):void
			{
				lastSavedFile = fr;
				fr.removeEventListener(Event.SELECT, selectHandler);
				setTimeout(function():void
				{
					saveDataToFile(content, fr);
					if (callback != null)
					{
						callback();
					}
				}, 500);
			});
			fr.addEventListener(Event.CANCEL, function cancelHandler(e:Event):void
			{
				fr.removeEventListener(Event.CANCEL, cancelHandler);

				if (callback != null)
				{
					callback();
				}
			});
		}

		private static function saveFileAs(file:File, callback:Function = null):void
		{
			var fr:File = new File();
			fr.save("", FileUtil.defaultFileName)
			fr.addEventListener(Event.SELECT, function selectHandler(e:Event):void
			{
				lastSavedFile = fr;
				fr.removeEventListener(Event.SELECT, arguments.callee);
				setTimeout(function():void
				{
					file.copyTo(new File(fr.nativePath), true);
					if (callback != null)
					{
						callback();
					}
				}, 500);
			});
			fr.addEventListener(Event.CANCEL, function cancelHandler(e:Event):void
			{
				fr.removeEventListener(Event.CANCEL, cancelHandler);

				if (callback != null)
				{
					callback();
				}
			});
		}

		/**
		 *
		 * @param content ByteArray, String
		 * @param targetFile
		 *
		 */
		private static function saveDataToFile(content:*, targetFile:File):void
		{
			try
			{
				if (content is String)
				{
					var bytes:ByteArray = new ByteArray;
					bytes.writeMultiByte(content + "", "utf-8");
					saveDataToFile(bytes, targetFile);
					return;
				}
				else if (!(content is ByteArray))
				{
					var bytes:ByteArray = new ByteArray;
					bytes.writeObject(content);
					saveDataToFile(bytes, targetFile);
					return;
				}
				var fs:FileStream = new FileStream();
				trace("saving..." + targetFile.nativePath)
				fs.open(targetFile, FileMode.WRITE);
				fs.writeBytes(content);
				fs.close();
			}
			finally
			{
				if (useCache)
				{
					cache[targetFile.url] = content;
				}
			}
		}

		private static function fetch():void
		{
			if (saveQueue.length > 0)
			{
				setTimeout(fetch, 100);
			}
			else
			{
				running = false;
				return;
			}

			running = true;
			var obj:Object = saveQueue.shift();
			var fs:FileStream = new FileStream();
			trace("saving..." + obj.targetFile.nativePath)
			fs.open(obj.targetFile, FileMode.WRITE);
			fs.writeBytes(obj.content);
			fs.close();

		}

		public static function clear(folder:File):void
		{
			if (folder.exists)
			{
				try
				{
					folder.deleteDirectory(true);
				}
				catch (err:Error)
				{
					trace("fail to clean html5");
				}
				if (folder.exists)
				{
					for each (var f:File in folder.getDirectoryListing())
					{
						if (f.isDirectory)
							f.deleteDirectory(true);
						else
							f.deleteFile();
					}
				}
				try
				{
					folder.createDirectory();
				}
				catch (err:Error)
				{
				}
			}
		}

		public static function open(file:String, format:String = "binary", charSet:String = "utf-8"):*
		{
			return readFile(dir.resolvePath(file), format, charSet);
		}

		public static function readFile(file:*, format:String = "binary", charSet:String = "utf-8"):*
		{
			if (file is String)
			{
				return readFile(File.applicationDirectory.resolvePath(file), format, charSet);
			}
			if (cache[file.url] != null)
			{
				if (cache[file.url] is ByteArray)
					ByteArray(cache[file.url]).position = 0;
				return cache[file.url];
			}
			// TODO Auto Generated method stub
			var fs:FileStream = new FileStream;
			fs.open(file, FileMode.READ);
			if (format == "binary")
			{
				var bytes:ByteArray = new ByteArray
				fs.readBytes(bytes);
				fs.close();
				cache[file.url] = bytes;
				return bytes;
			}
			else if (format == "AMF")
			{
				var obj:Object = fs.readObject();
				fs.close();
				return obj;
			}
			else
			{
				var str:String = fs.readMultiByte(fs.bytesAvailable, charSet);
				fs.close();
				return str;
			}
		}

		public static function delFile(folder:File):void
		{
			if (folder.exists)
			{
				try
				{
					folder.deleteDirectory(true);
				}
				catch (err:Error)
				{
					trace(err.getStackTrace());
				}
				if (folder.exists)
				{
					for each (var f:File in folder.getDirectoryListing())
					{
						if (f.isDirectory)
							f.deleteDirectory(true);
						else
							f.deleteFile();
					}
				}
			}
		}
	}
}
