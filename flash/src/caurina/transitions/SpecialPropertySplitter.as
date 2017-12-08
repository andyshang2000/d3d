//Created by Action Script Viewer - http://www.buraks.com/asv
package caurina.transitions
{
    public class SpecialPropertySplitter 
    {

        public var parameters:Array;
        public var splitValues:Function;

        public function SpecialPropertySplitter(_arg_1:Function, _arg_2:Array)
        {
            splitValues = _arg_1;
            parameters = _arg_2;
        }

        public function toString():String
        {
            var _local_1 = "";
            _local_1 = (_local_1 + "[SpecialPropertySplitter ");
            _local_1 = (_local_1 + ("splitValues:" + String(splitValues)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("parameters:" + String(parameters)));
            return ((_local_1 + "]"));
        }


    }
}//package caurina.transitions
