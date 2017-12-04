package zzsdk.editor.utils
{
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import zzsdk.editor.ImportFileEvent;

	public class DragDropUtils
	{
		public static var currentTrigger:DisplayObject;
		
		private static var objects:Dictionary = new Dictionary();
		public static var stage:Stage;

		private static var accepted:Array;

		public static function setAcceptedExtension(... args):void
		{
			accepted = args;
		}

		public static function isAccepted(obj:*):Boolean
		{
			if (obj is File)
			{
				return isAccepted((obj as File).extension);
			}
			if (obj is String)
			{
				obj = (obj + "").toLowerCase();
				if (accepted.indexOf(obj) != -1)
				{
					return true;
				}
				else
				{
					var str:String = obj + "";
					for (var i:int = 0; i < accepted.length; i++)
					{
						if (str.lastIndexOf(accepted[i]) + accepted[i].length == str.length)
						{
							return true;
						}
					}
				}
			}
			return false;
		}

		public static function setStage(stage:Stage):void
		{
			DragDropUtils.stage = stage;
		}

		public static function enable(target:InteractiveObject, callback:Function = null):void
		{
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDropEvent);
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnterEvent);
			target.addEventListener(NativeDragEvent.NATIVE_DRAG_OVER, dragEnterEvent);
			var dragParam:DragParams = new DragParams();
			dragParam.target = target;
			dragParam.listener = callback || importFiles;
			objects[target] = dragParam;
		}

		private static function dragEnterEvent(event:NativeDragEvent):void
		{
			NativeDragManager.acceptDragDrop((event.target as InteractiveObject));
		}

		private static function dragDropEvent(event:NativeDragEvent):void
		{
			var dragParam:DragParams = objects[event.currentTarget];
			if (dragParam && dragParam.listener != null)
			{
				currentTrigger = event.currentTarget as DisplayObject;
				dragParam.listener(event);
				currentTrigger = null;
			}
		}

		private static function importFiles(event:NativeDragEvent):void
		{
			var arr:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			for (var i:int = 0; i < arr.length; i++)
			{
				handleFile(arr[i]);
			}
		}

		private static function handleFile(file:File):void
		{
			if (file.isDirectory)
			{
				var arr:Array = file.getDirectoryListing();
				arr.sort(function(a:File, b:File):int
				{
					if (a.name < b.name)
						return -1;
					else if (a.name > b.name)
						return 1;
					return 0;
				})
				for (var i:int = 0; i < arr.length; i++)
				{
					handleFile(arr[i]);
				}
			}
			else
			{
				if (isAccepted(file))
				{
					stage.dispatchEvent(new ImportFileEvent(file));
				}
			}
		}
	}
}

import flash.display.InteractiveObject;

class DragParams
{
	public var target:InteractiveObject;
	public var listener:Function;
}
