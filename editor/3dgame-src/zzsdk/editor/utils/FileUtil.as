package zzsdk.editor.utils
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import nblib.util.callLater;

	//FIXME to merge the save method family
	public class FileUtil
	{
		public static var defaultFileName:String = "work.qdr";
		public static var lastSavedFile:File;

		private static var saveQueue:Array = [];
		private static var running:Boolean;
		
		public static var dir:File = File.applicationDirectory;

		public static function copy(from:String, to:String):void
		{
			var workingDir:File = Client.workingDirectory;
			var source:File = workingDir.resolvePath(from)
			if (source.exists)
			{
				try
				{
					source.copyTo(new File(workingDir.resolvePath(to).nativePath), true)
				}
				catch (err:IOError)
				{
					trace(to + " 文件没有关闭");
				}
			}
		}

		public static function xcopy(from:String, to:String):void
		{
			var workingDir:File = Client.workingDirectory;
			workingDir.resolvePath(from).copyTo(new File(workingDir.resolvePath(to).nativePath), true)
		}

		/**
		 *
		 * @param content ByteArray, String, AMF(Object)
		 * @param to
		 *
		 */
		public static function save(content:*, to:String = null, sync:Boolean = false):void
		{
			if (to == null)
			{
				saveAs(content);
			}
			saveDataToFile(content, new File(Client.workingDirectory.resolvePath(to).nativePath), sync);
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
					saveDataToFile(content, fr, true);
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
		private static function saveDataToFile(content:*, targetFile:File, sync:Boolean):void
		{
			if (content is String)
			{
				var bytes:ByteArray = new ByteArray;
				bytes.writeMultiByte(content + "", "utf-8");
				saveDataToFile(bytes, targetFile, sync);
				return;
			}
			else if (!(content is ByteArray))
			{
				saveDataToFile(content + "", targetFile, sync);
				return;
			}
			if (sync)
			{
				var fs:FileStream = new FileStream();
				trace("saving..." + targetFile.nativePath)
				fs.open(targetFile, FileMode.WRITE);
				fs.writeBytes(content);
				fs.close();
			}
			else
			{
				saveQueue.push({content: content, targetFile: targetFile});
				if (!running)
				{
					callLater(fetch);
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
					trace("清理出错了，不过没有影响");
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

		public static function readFile(file:File, format:String = "binary", charSet:String = "utf-8"):*
		{
			// TODO Auto Generated method stub
			var fs:FileStream = new FileStream;
			fs.open(file, FileMode.READ);
			if (format == "binary")
			{
				var bytes:ByteArray = new ByteArray
				fs.readBytes(bytes);
				fs.close();
				return bytes;
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
