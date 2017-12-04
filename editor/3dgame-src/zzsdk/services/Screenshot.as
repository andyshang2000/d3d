package zzsdk.services
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	import mx.graphics.codec.PNGEncoder;

	import nblib.util.Properties;
	import nblib.util.callLater;

	import zero.codec.JPEGEncoder;

	import zzsdk.editor.utils.FileUtil;

	public class Screenshot extends EventDispatcher
	{
		public var started:Boolean = false;

		private var server:ServerSocket;
		private var socket:Socket;

		private var queue:Array = [];
		private static var uniqueFolder:String;

		public function request():void
		{
			var buffer:ByteArray = new ByteArray;
			buffer.writeUTF("photo");
			socket.writeShort(1);
			socket.writeInt(buffer.length);
			socket.writeBytes(buffer);
			socket.flush();
		}

		public function start():void
		{
			server = new ServerSocket();
			server.bind(52001, "0.0.0.0");
			server.addEventListener(ServerSocketConnectEvent.CONNECT, function(event:ServerSocketConnectEvent):void
			{
				started = true;
				dispatchEvent(new Event("start"))
				socket = event.socket;
				event.socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
				event.socket.addEventListener(Event.CLOSE, function():void
				{
					started = false;
					dispatchEvent(new Event("close"))
				});
			});
			server.listen();

			//
			const OPCODE:int = 1;
			const LENGTH:int = 2;
			const BODY:int = 3;
			//
			var pending:int = OPCODE;
			var length:int = 0;
			var command:int = -1;
			var buffer:ByteArray = new ByteArray;

			function onData(event:ProgressEvent):void
			{
				var socket:Socket = event.currentTarget as Socket;
				switch (pending)
				{
					case OPCODE:
						if (socket.bytesAvailable > 2)
						{
							command = socket.readUnsignedShort();
							//						response = PacketFactory.createResponse(opcode);
							//						interpreter = getInterpreter(opcode);
							pending = LENGTH;
							onData(event);
						}
						break;
					case LENGTH:
						if (socket.bytesAvailable > 2)
						{
							//due to the design
							//length here presents the total length of the packet
							//-4 is the modifier
							//for the header is 4 bytes length
							length = socket.readUnsignedInt();
							pending = BODY;
							buffer.position = 0;
							onData(event);
						}
						break;
					case BODY:
						if (socket.bytesAvailable >= length)
						{
							socket.readBytes(buffer, buffer.position, length);
							buffer.position = 0;
							executeCommand(command, buffer);
							buffer.length = 0;
							pending = OPCODE;

							onData(event);
						}
						else if (socket.bytesAvailable > 0)
						{
							var bytesAvailable:int = socket.bytesAvailable;
							length -= bytesAvailable
							socket.readBytes(buffer, buffer.position);
							buffer.position += bytesAvailable
							pending = BODY;
						}
						break;
					default:
						//todo error alert needed
						throw new Error("parsing error");
				}
			}
		}

		private function executeCommand(command:int, buffer:ByteArray):void
		{
			trace(command + ":" + buffer.length);
			if (command == 1)
			{
				var str:String = buffer.readUTF();
				switch (str)
				{
					case "photo":
						trace("take a photo");
						break;
				}
			}
			else if (command == 2)
			{
				saveImg(buffer);
			}
		}

		private function saveImg(bytes:ByteArray):void
		{
			var appID:String = bytes.readUTF();
			var buffer:ByteArray = new ByteArray;
			bytes.readBytes(buffer, 0, bytes.bytesAvailable);
			var loader:Loader = new Loader;
			loader.loadBytes(buffer); //读取ByteArray    
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function complete(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete);
				FileUtil.defaultFileName = appID.substr(appID.lastIndexOf(".") + 1) + ".png"
				FileUtil.saveAs(new PNGEncoder().encode((loader.content as Bitmap).bitmapData), function():void
				{
					var cp:Properties = Properties.readFile("screenshot.txt");
					updateUnique();
					for each (var value:String in cp)
					{
						if (/\d+x\d+/.test(value))
						{
							queueSaving(loader.content as Bitmap, value, FileUtil.lastSavedFile.parent.nativePath);
						}
					}
					executeQueue();
				});
			});
		}

		private function executeQueue():void
		{
			if (queue.length > 0)
			{
				var c:Object = queue.shift();
				var arr:Array = c.d.split("x");
				var w:int = int(arr[0]);
				var h:int = int(arr[1]);
				var obj:DisplayObject = c.obj;
				if (obj.width > obj.height)
				{
					var tmp:int = w;
					w = h;
					h = tmp;
				}
				var bitmapData:BitmapData = new BitmapData(w, h, false, 0);
				var t:String = c.t;
				bitmapData.draw(obj, new Matrix(w / obj.width, 0, 0, h / obj.height, 0, 0), null, null, null, true);
				FileUtil.save(new JPEGEncoder(70).encode(bitmapData), t + "/" + uniqueFolder + "/" + (w + "x" + h) + ".jpg");
				callLater(executeQueue);
			}
		}

		private static function updateUnique():String
		{
			var arr:Array = FileUtil.lastSavedFile.parent.getDirectoryListing();
			var valid:Array = [];
			for (var i:int = 0; i < arr.length; i++)
			{
				var file:File = arr[i];
				if (/^\d+$/.test(file.name))
				{
					valid.push(int(file.name));
				}
			}
			if (valid.length == 0)
				return uniqueFolder = "1";

			valid.sort(Array.NUMERIC);

			return uniqueFolder = (valid.pop() + 1) + "";
		}

		private function queueSaving(obj:DisplayObject, d:String, t:String):void
		{
			queue.push({obj: obj, d: d, t: t})
		}
	}
}
