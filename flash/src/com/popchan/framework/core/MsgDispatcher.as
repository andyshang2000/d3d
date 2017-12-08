//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.framework.core
{
    import com.popchan.framework.ds.Dict;
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class MsgDispatcher 
    {

        private static var dict:Dict = new Dict();


        public static function add(_arg_1:*, _arg_2:Function):void
        {
            var _local_3:Vector.<Function> = dict.take(_arg_1);
            if (_local_3)
            {
                if (_local_3.indexOf(_arg_2) != -1)
                {
                    return;
                };
            }
            else
            {
                _local_3 = new Vector.<Function>();
                dict.put(_arg_1, _local_3);
            };
            _local_3.push(_arg_2);
        }

        public static function remove(_arg_1:*, _arg_2:Function):void
        {
            if (!dict.contains(_arg_1))
            {
                return;
            };
            var _local_3:Vector.<Function> = dict.take(_arg_1);
            if (!_local_3)
            {
                return;
            };
            var _local_4:int = _local_3.indexOf(_arg_2);
            if (_local_4 != -1)
            {
                _local_3.splice(_local_4, 1);
            };
            if (_local_3.length <= 0)
            {
                dict.remove(_arg_1);
            };
        }

        public static function execute(_arg_1:*, ... _args):void
        {
            var _local_4:Function;
            var _local_3:Vector.<Function> = dict.take(_arg_1);
            if (_local_3 != null)
            {
                _local_3 = _local_3.concat();
            };
            for each (_local_4 in _local_3)
            {
                _local_4.apply(null, _args);
            };
        }
    }
}//package com.popchan.framework.core
