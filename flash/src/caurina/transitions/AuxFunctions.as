//Created by Action Script Viewer - http://www.buraks.com/asv
package caurina.transitions
{
    public class AuxFunctions 
    {


        public static function getObjectLength(_arg_1:Object):uint
        {
            var _local_3:String;
            var _local_2:uint;
            for (_local_3 in _arg_1)
            {
                _local_2++;
            };
            return (_local_2);
        }

        public static function numberToG(_arg_1:Number):Number
        {
            return (((_arg_1 & 0xFF00) >> 8));
        }

        public static function numberToB(_arg_1:Number):Number
        {
            return ((_arg_1 & 0xFF));
        }

        public static function numberToR(_arg_1:Number):Number
        {
            return (((_arg_1 & 0xFF0000) >> 16));
        }

        public static function concatObjects(... _args):Object
        {
            var _local_3:Object;
            var _local_5:String;
            var _local_2:Object = {};
            var _local_4:int;
            while (_local_4 < _args.length)
            {
                _local_3 = _args[_local_4];
                for (_local_5 in _local_3)
                {
                    if (_local_3[_local_5] == null)
                    {
                        delete _local_2[_local_5];
                    }
                    else
                    {
                        _local_2[_local_5] = _local_3[_local_5];
                    };
                };
                _local_4++;
            };
            return (_local_2);
        }


    }
}//package caurina.transitions
