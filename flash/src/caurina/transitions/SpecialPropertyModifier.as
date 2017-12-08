//Created by Action Script Viewer - http://www.buraks.com/asv
package caurina.transitions
{
    public class SpecialPropertyModifier 
    {

        public var getValue:Function;
        public var modifyValues:Function;

        public function SpecialPropertyModifier(_arg_1:Function, _arg_2:Function)
        {
            modifyValues = _arg_1;
            getValue = _arg_2;
        }

        public function toString():String
        {
            var _local_1 = "";
            _local_1 = (_local_1 + "[SpecialPropertyModifier ");
            _local_1 = (_local_1 + ("modifyValues:" + String(modifyValues)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("getValue:" + String(getValue)));
            return ((_local_1 + "]"));
        }


    }
}//package caurina.transitions
