//Created by Action Script Viewer - http://www.buraks.com/asv
package sui.reflect {

    public class Property extends TypeEntry {

        public function Property(_arg1:XML){
            super(String(_arg1.@name), String(_arg1.@type));
            parseMetadata(_arg1.metadata);
        }
    }
}//package sui.reflect 
