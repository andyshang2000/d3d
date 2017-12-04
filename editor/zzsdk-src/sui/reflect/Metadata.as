//Created by Action Script Viewer - http://www.buraks.com/asv
package sui.reflect {

    public class Metadata {

        public var name:String;
        public var args:Object;

        public function Metadata(_arg1:String){
            this.args = {};
            super();
            this.name = _arg1;
        }
        public function get(_arg1:String):*{
            return (this.args[_arg1]);
        }
        public function has(_arg1:String):Boolean{
            return (!((this.args[_arg1] == null)));
        }
        public function parseArgs(_arg1:XMLList):void{
            var _local2:XML;
            var _local3:String;
            var _local4:String;
            for each (_local2 in _arg1) {
                _local3 = _local2.@key;
                _local4 = String(_local2.@value);
                if (_local4 == "true"){
                    this.args[_local3] = true;
                } else {
                    if (_local4 == "false"){
                        this.args[_local3] = false;
                    } else {
                        this.args[_local3] = _local4;
                    };
                };
            };
        }

    }
}//package sui.reflect 
