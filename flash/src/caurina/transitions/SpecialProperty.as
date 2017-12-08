//Created by Action Script Viewer - http://www.buraks.com/asv
package caurina.transitions
{
    public class SpecialProperty 
    {

        public var parameters:Array;
        public var getValue:Function;
        public var preProcess:Function;
        public var setValue:Function;

        public function SpecialProperty(_arg_1:Function, _arg_2:Function, _arg_3:Array=null, _arg_4:Function=null)
        {
            getValue = _arg_1;
            setValue = _arg_2;
            parameters = _arg_3;
            preProcess = _arg_4;
        }

        public function toString():String
        {
            var _local_1 = "";
            _local_1 = (_local_1 + "[SpecialProperty ");
            _local_1 = (_local_1 + ("getValue:" + String(getValue)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("setValue:" + String(setValue)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("parameters:" + String(parameters)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("preProcess:" + String(preProcess)));
            return ((_local_1 + "]"));
        }


    }
}//package caurina.transitions
