//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.framework.utils
{
    import flash.utils.ByteArray;

    public class Base64 
    {

        private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
        public static const version:String = "1.0.0";

        public function Base64()
        {
            throw (new Error("Base64 class is static container only"));
        }

        public static function encode(_arg_1:String):String
        {
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUTFBytes(_arg_1);
            return (encodeByteArray(_local_2));
        }

        public static function encodeByteArray(_arg_1:ByteArray):String
        {
            var _local_3:Array;
            var _local_5:uint;
            var _local_6:uint;
            var _local_7:uint;
            var _local_2 = "";
            var _local_4:Array = new Array(4);
            _arg_1.position = 0;
            while (_arg_1.bytesAvailable > 0)
            {
                _local_3 = new Array();
                _local_5 = 0;
                while ((((_local_5 < 3)) && ((_arg_1.bytesAvailable > 0))))
                {
                    _local_3[_local_5] = _arg_1.readUnsignedByte();
                    _local_5++;
                };
                _local_4[0] = ((_local_3[0] & 252) >> 2);
                _local_4[1] = (((_local_3[0] & 3) << 4) | (_local_3[1] >> 4));
                _local_4[2] = (((_local_3[1] & 15) << 2) | (_local_3[2] >> 6));
                _local_4[3] = (_local_3[2] & 63);
                _local_6 = _local_3.length;
                while (_local_6 < 3)
                {
                    _local_4[(_local_6 + 1)] = 64;
                    _local_6++;
                };
                _local_7 = 0;
                while (_local_7 < _local_4.length)
                {
                    _local_2 = (_local_2 + BASE64_CHARS.charAt(_local_4[_local_7]));
                    _local_7++;
                };
            };
            return (_local_2);
        }

        public static function decode(_arg_1:String):String
        {
            var _local_2:ByteArray = decodeToByteArray(_arg_1);
            return (_local_2.readUTFBytes(_local_2.length));
        }

        public static function decodeToByteArray(_arg_1:String):ByteArray
        {
            var _local_6:uint;
            var _local_7:uint;
            var _local_2:ByteArray = new ByteArray();
            var _local_3:Array = new Array(4);
            var _local_4:Array = new Array(3);
            var _local_5:uint;
            while (_local_5 < _arg_1.length)
            {
                _local_6 = 0;
                while ((((_local_6 < 4)) && (((_local_5 + _local_6) < _arg_1.length))))
                {
                    _local_3[_local_6] = BASE64_CHARS.indexOf(_arg_1.charAt((_local_5 + _local_6)));
                    _local_6++;
                };
                _local_4[0] = ((_local_3[0] << 2) + ((_local_3[1] & 48) >> 4));
                _local_4[1] = (((_local_3[1] & 15) << 4) + ((_local_3[2] & 60) >> 2));
                _local_4[2] = (((_local_3[2] & 3) << 6) + _local_3[3]);
                _local_7 = 0;
                while (_local_7 < _local_4.length)
                {
                    if (_local_3[(_local_7 + 1)] == 64) break;
                    _local_2.writeByte(_local_4[_local_7]);
                    _local_7++;
                };
                _local_5 = (_local_5 + 4);
            };
            _local_2.position = 0;
            return (_local_2);
        }


    }
}//package com.popchan.framework.utils
