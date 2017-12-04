//Created by Action Script Viewer - http://www.buraks.com/asv
package sui.reflect {

    public class Method extends TypeEntry {

        public var parameters:Array;

        public function Method(_arg1:XML){
            this.parameters = [];
            super(String(_arg1.@name), String(_arg1.@returnType));
            parseMetadata(_arg1.metadata);
            this.parseParameter(_arg1.parameter);
        }
        protected function parseParameter(_arg1:XMLList):void{
            var _local2:XML;
            for each (_local2 in _arg1) {
                this.parameters[(int(_local2.@index) - 1)] = String(_local2.@type);
            };
        }

    }
}//package sui.reflect 
