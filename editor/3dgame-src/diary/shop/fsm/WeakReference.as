//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.fsm
{
    import flash.utils.Dictionary;

    public class WeakReference 
    {

        private var dictionary:Dictionary;
        private var restricted:Class;
        private var isSet:Boolean;

        public function WeakReference(_arg_1:*=null, _arg_2:Class=null)
        {
            this.restricted = _arg_2;
            this.reset(_arg_1);
        }

        public function get():Object
        {
            var _local_1:Object;
            if (this.isSet)
            {
                for (_local_1 in this.dictionary)
                {
                    return (_local_1);
                };
            };
            return (null);
        }

        public function reset(_arg_1:*):void
        {
            if (((((_arg_1) && (this.restricted))) && (!((_arg_1 is this.restricted)))))
            {
                throw (new Error((("WeakReference is configured only to store type " + Utils.getClassName(this.restricted)) + ".")));
            };
            if (_arg_1)
            {
                this.isSet = true;
                this.dictionary = new Dictionary(true);
                this.dictionary[_arg_1] = null;
            }
            else
            {
                this.isSet = false;
                this.dictionary = new Dictionary(true);
            };
        }


    }
}//package com.edgebee.atlas.util
