package net
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import events.ServerEvent;

	public class ServerMgr extends EventDispatcher
	{
		public static var stage:Stage;
		
		private static var _instance:ServerMgr = null;

		public static const OPCODE:int = 1;
		public static const LENGTH:int = 2;
		public static const BODY:int = 3;
		private var pending:int = OPCODE;
		private var buffer:ByteArray = new ByteArray;
		private var length:int;
		private var dataType:int = 1; //1 String ,2 bmp
		private var _socket:Socket;

		public function ServerMgr(pri:priClass)
		{
			createConnect();
		}

		private function createConnect():void
		{
			start("127.0.0.1");
		}

		public function start(ip:String):void
		{
			trace("createConnect!!!!!!!!!!!!!!!!!!!!!!!!!")
			if (_socket)
			{
				return;
			}
			var socket:Socket = new Socket();
			socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			socket.addEventListener(flash.events.Event.CLOSE, closeHandler);

			socket.connect(ip, 52001);
			trace("createConnect!!!!!!!!!!!!!!!!!!!!!!!!!" + ip);
		}

		private function onConnect(e:Event):void
		{
			trace("client connected !!!!!!!!!!!!!!!!!!!!!!!!!")
			if (_socket)
			{
				(e.target as Socket).close();
			}
			else
			{
				_socket = e.target as Socket;
			}
		}

		public function onData(e:ProgressEvent):void
		{
			var socket:Socket = e.currentTarget as Socket;
			switch (pending)
			{
				case OPCODE:
					if (socket.bytesAvailable > 2)
					{
						dataType = socket.readUnsignedShort();
						pending = LENGTH;
						onData(e);
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
						onData(e);
					}
					break;
				case BODY:
					if (socket.bytesAvailable >= length)
					{
						socket.readBytes(buffer, buffer.position, length);
						buffer.position = 0;
						unserialize(buffer);
						pending = OPCODE;

						onData(e);
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

		private function unserialize(buffer:ByteArray):void
		{
			if (dataType == 1)
			{
				var str:String = buffer.readUTF();
				switch (str)
				{
					case "photo":
						trace("take a photo");
						dispatchEvent(new ServerEvent(ServerEvent.PHOTO));
						break;
				}
			}

		}

		public function save(bytes:ByteArray):void
		{
			call(2, bytes);
		}

		private function call(opcode:int, bytes:ByteArray):void
		{
			var sendBytes:ByteArray = new ByteArray();
			sendBytes.writeShort(opcode);
			sendBytes.writeInt(bytes.length);
			sendBytes.writeBytes(bytes);
			trace("length of body:" + bytes.length);
			sendData(sendBytes);
		}

		public function sendData(bytes:ByteArray):void
		{
			if (!_socket.connected)
			{
				return;
			}
			_socket.writeBytes(bytes, 0, bytes.length);
			_socket.flush();
		}

		protected function onSecurityError(event:SecurityErrorEvent):void
		{
		}

		protected function onIOError(event:IOErrorEvent):void
		{
			trace("ioerror " + event);
			var s:Socket = event.target as Socket;
			s.removeEventListener(Event.CONNECT, onConnect);
			s.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			s.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			s.removeEventListener(ProgressEvent.SOCKET_DATA, onData);
			s.removeEventListener(flash.events.Event.CLOSE, closeHandler);
		}

		protected function closeHandler(event:Event):void
		{
		}

		public static function getInstance():ServerMgr
		{
			if (_instance == null)
			{
				_instance = new ServerMgr(new priClass);
			}
			return _instance;
		}
	}
}

class priClass
{
}
