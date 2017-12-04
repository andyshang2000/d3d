//Created by Action Script Viewer - http://www.buraks.com/asv
package sui.reflect {
    import flash.utils.*;

    public class SType {

        public var variables:Object;
        public var accessors:Object;
        public var methods:Object;

        private static var descriptionCache:Dictionary = new Dictionary();

        public function SType(_arg1:Class){
            this.variables = {};
            this.accessors = {};
            this.methods = {};
            super();
            var _local2:XML = describeType(_arg1);
            this.parsePropertiy(this.accessors, _local2.factory.accessor);
            this.parsePropertiy(this.variables, _local2.factory.variable);
            this.parseMethod(_local2.factory.method);
        }
        private function parsePropertiy(_arg1:Object, _arg2:XMLList):void{
            var _local3:XML;
            var _local4:Property;
            for each (_local3 in _arg2) {
                _local4 = new Property(_local3);
                _arg1[_local4.name] = _local4;
            };
        }
        private function parseMethod(_arg1:XMLList):void{
            var _local2:XML;
            var _local3:Method;
            for each (_local2 in _arg1) {
                _local3 = new Method(_local2);
                this.methods[_local3.name] = _local3;
            };
        }

        public static function get(_arg1):SType{
            var _local2:Class;
            var _local3:SType;
            if ((_arg1 is Class)){
                _local2 = _arg1;
            } else {
                _local2 = _arg1.constructor;
            };
            if (descriptionCache[_local2] == null){
                _local3 = new SType(_local2);
                descriptionCache[_local2] = _local3;
            };
            return (descriptionCache[_local2]);
        }

    }
}//package sui.reflect 
