//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.framework.utils
{
	import flash.net.SharedObject;

	public class DataUtil
	{

		public static var id:String = "fdfd";
		private static var _shared:SharedObject;
		private static var _data:Object = {};
		public static var prefix:String = "FlashPunk";
		private static const DEFAULT_FILE:String = "_file";
		private static const SIZE:uint = 10000;

		public static function load(_arg_1:String = ""):void
		{
			var _local_3:String;
			var _local_2:Object = loadData(_arg_1);
			_data = {};
			for (_local_3 in _local_2)
			{
				_data[_local_3] = _local_2[_local_3];
			}
		}

		public static function save(_arg_1:String = ""):void
		{
			var _local_3:String;
			if (_shared)
			{
				_shared.clear();
			}
			var _local_2:Object = loadData(_arg_1);
			for (_local_3 in _data)
			{
				_local_2[_local_3] = _data[_local_3];
			}
			_shared.flush(SIZE);
		}

		public static function readInt(_arg_1:String, _arg_2:int = 0):int
		{
			return (int(read(_arg_1, _arg_2)));
		}

		public static function readUint(_arg_1:String, _arg_2:uint = 0):uint
		{
			return (uint(read(_arg_1, _arg_2)));
		}

		public static function readObj(_arg_1:String, _arg_2:Object = null):Object
		{
			return (read(_arg_1, _arg_2));
		}

		public static function readBool(_arg_1:String, _arg_2:Boolean = true):Boolean
		{
			return (Boolean(read(_arg_1, _arg_2)));
		}

		public static function readString(_arg_1:String, _arg_2:String = ""):String
		{
			return (String(read(_arg_1, _arg_2)));
		}

		public static function writeInt(_arg_1:String, _arg_2:int = 0):void
		{
			_data[_arg_1] = _arg_2;
		}

		public static function writeUint(_arg_1:String, _arg_2:uint = 0):void
		{
			_data[_arg_1] = _arg_2;
		}

		public static function writeBool(_arg_1:String, _arg_2:Boolean = true):void
		{
			_data[_arg_1] = _arg_2;
		}

		public static function writeObj(_arg_1:String, _arg_2:*):void
		{
			_data[_arg_1] = _arg_2;
		}

		public static function writeString(_arg_1:String, _arg_2:String = ""):void
		{
			_data[_arg_1] = _arg_2;
		}

		private static function read(_arg_1:String, _arg_2:*)
		{
			if (_data.hasOwnProperty(_arg_1))
			{
				return (_data[_arg_1]);
			}
			return (_arg_2);
		}

		private static function loadData(_arg_1:String):Object
		{
			if (!_arg_1)
			{
				_arg_1 = DEFAULT_FILE;
			}
			if (id)
			{
				_shared = SharedObject.getLocal(((((prefix + "/") + id) + "/") + _arg_1), "/");
			}
			else
			{
				_shared = SharedObject.getLocal(((prefix + "/") + _arg_1));
			}
			return (_shared.data);
		}

	}
} //package com.popchan.framework.utils
