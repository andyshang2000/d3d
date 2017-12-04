package zzsdk.editor.utils
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;

	import mx.utils.StringUtil;

	import zzsdk.editor.Config;

	public class Client
	{
		public static var workingDirectory:File = File.applicationDirectory;
		private static var pd:Array = [];

		/**
		 *
		 * @param args 参数中的相对路径应该调用Client.resolve转化绝对路径
		 * @return
		 *
		 * @example
		call("", "", "")//
		.onSuceess(function():void
		{
		}).onFail(function():void
		{
		})
		 */
		public static function call(... args):_IPromise
		{
			if (args.length == 1 && args[0] is String)
			{
				return call.apply(null, stringToArgs(args[0]));
			}
			if (args.length == 1 && args[0] is Array)
			{
				return call.apply(null, args[0]);
			}
			if ((args[0] + "").substr(-4, 4) == ".bat")
			{
				return call.apply(null, ["C:\\WINDOWS\\system32\\cmd.exe", "/c"].concat(args));
			}
			if (/^[a-zA-Z0-9]+$/ig.test(args[0] + ""))
			{
				return call.apply(null, ["C:\\WINDOWS\\system32\\cmd.exe", "/c"].concat(args));
			}
			//
//			Log(args.join(" "));
			//
			var result:_Promise = new _Promise;
			var npInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo;
			var argArr:Array = args.slice(1);
			var vecArr:Vector.<String> = Vector.<String>(argArr);
			npInfo.workingDirectory = workingDirectory;
			npInfo.executable = workingDirectory.resolvePath(args[0]); //注意在app.xml里面设置权限 <supportedProfiles>extendedDesktop</supportedProfiles>
			npInfo.arguments = vecArr;

			var np:NativeProcess = new NativeProcess();
			np.addEventListener(NativeProcessExitEvent.EXIT, function(event:NativeProcessExitEvent):void
			{
				np.removeEventListener(NativeProcessExitEvent.EXIT, arguments.callee);
				if (event.exitCode == 0)
				{
					if (result.successHandler != null)
					{
						result.successHandler();
					}
				}
				else
				{
					if (result.failHandler != null)
					{
						result.failHandler();
					}
				}
				pd.splice(pd.indexOf(np), 1);
			});
			np.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, function(event:ProgressEvent):void
			{
				var str:String = StringUtil.trim(np.standardOutput.readMultiByte(np.standardOutput.bytesAvailable, "GBK"));
				if (str.length)
				{
					trace(str)
				}
			});
			np.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, function(event:ProgressEvent):void
			{
				var str:String = StringUtil.trim(np.standardError.readMultiByte(np.standardError.bytesAvailable, "GBK"));
				if (str.length)
				{
					trace(str)
				}
			});
			trace(npInfo.arguments.join(" "))
			np.start(npInfo);
			pd.push(np);
			return result;
		}

		private static function stringToArgs(str:String):Object
		{
			// TODO Auto Generated method stub
			var buffer:String = "";
			var arr:Array = [];
			var wrapped:Boolean = false;
			for (var i:int = 0; i < str.length; i++)
			{
				var char:String = str.charAt(i);
				if (char == " ")
				{
					if (!wrapped)
					{
						arr.push(buffer);
						buffer = "";
					}
					else
					{
						buffer += char;
					}
				}
				else if (char == "\"")
				{
					wrapped = !wrapped
					buffer += char;
				}
				else
				{
					buffer += char;
				}
			}
			arr.push(buffer)
			buffer = "";
			return arr;
		}

		public static function closeAll():void
		{
			while (pd.length > 0)
			{
				NativeProcess(pd.pop()).exit(true);
			}
		}

		public static function resolve(param0:String):String
		{
			// TODO Auto Generated method stub
			return workingDirectory.resolvePath(param0).nativePath;
		}

		public static function unzip(fileStr:String, param1:Function):void
		{
			var file:File = File.applicationDirectory.resolvePath(fileStr);
			call(Config.ZZSDK + "/tools/7z.exe x " + file.nativePath + " -o" + file.parent.nativePath).onSuccess(function():void
			{
				param1(file.parent);
			});
		}
	}
}

interface _IPromise
{
	function onSuccess(func:Function):_IPromise;
	function onFail(func:Function):_IPromise;
}

class _Promise implements _IPromise
{
	public var successHandler:Function;
	public var failHandler:Function;

	public function onSuccess(func:Function):_IPromise
	{
		successHandler = func;
		return this;
	}

	public function onFail(func:Function):_IPromise
	{
		failHandler = func;
		return this;
	}
}
