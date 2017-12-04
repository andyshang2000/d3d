package nblib.util
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	public class Reader
	{
		private var input:IDataInput;
		private var buffer:ByteArray

		private var endToken1:int = "\n".charCodeAt(0);
		private var endToken2:int = "\r".charCodeAt(0);

		private var sIndex:int = 0;
		private var eIndex:int = 0;

		private var encoding:String;

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

		public function Reader(fs:IDataInput, encoding:String = "utf-8")
		{
			this.encoding = encoding;
			input = fs;
			buffer = new ByteArray;
		}

		public function close():void
		{
			if (Object(input).hasOwnProperty("close"))
				input["close"]()
		}

		public function hasNextline():Boolean
		{
			return input.bytesAvailable > 0;
		}

		public function readLine():String
		{
			while (input.bytesAvailable)
			{
				var char:int = input.readUnsignedByte();
				buffer.writeByte(char);
				eIndex++;
				if (char == endToken2 || char == endToken1)
				{
					break;
				}
			}
			buffer.position = 0;
			var res:String = buffer.readMultiByte(buffer.bytesAvailable, encoding);
			buffer.length = 0;
			return res;
		}
	}
}
