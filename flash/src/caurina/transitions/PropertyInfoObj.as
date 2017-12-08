//Created by Action Script Viewer - http://www.buraks.com/asv
package caurina.transitions
{
    public class PropertyInfoObj 
    {

        public var modifierParameters:Array;
        public var isSpecialProperty:Boolean;
        public var valueComplete:Number;
        public var modifierFunction:Function;
        public var extra:Object;
        public var valueStart:Number;
        public var hasModifier:Boolean;
        public var arrayIndex:Number;
        public var originalValueComplete:Object;

        public function PropertyInfoObj(_arg_1:Number, _arg_2:Number, _arg_3:Object, _arg_4:Number, _arg_5:Object, _arg_6:Boolean, _arg_7:Function, _arg_8:Array)
        {
            valueStart = _arg_1;
            valueComplete = _arg_2;
            originalValueComplete = _arg_3;
            arrayIndex = _arg_4;
            extra = _arg_5;
            isSpecialProperty = _arg_6;
            hasModifier = Boolean(_arg_7);
            modifierFunction = _arg_7;
            modifierParameters = _arg_8;
        }

        public function toString():String
        {
            var _local_1 = "\n[PropertyInfoObj ";
            _local_1 = (_local_1 + ("valueStart:" + String(valueStart)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("valueComplete:" + String(valueComplete)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("originalValueComplete:" + String(originalValueComplete)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("arrayIndex:" + String(arrayIndex)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("extra:" + String(extra)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("isSpecialProperty:" + String(isSpecialProperty)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("hasModifier:" + String(hasModifier)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("modifierFunction:" + String(modifierFunction)));
            _local_1 = (_local_1 + ", ");
            _local_1 = (_local_1 + ("modifierParameters:" + String(modifierParameters)));
            return ((_local_1 + "]\n"));
        }

        public function clone():PropertyInfoObj
        {
            return (new PropertyInfoObj(valueStart, valueComplete, originalValueComplete, arrayIndex, extra, isSpecialProperty, modifierFunction, modifierParameters));
        }


    }
}//package caurina.transitions
