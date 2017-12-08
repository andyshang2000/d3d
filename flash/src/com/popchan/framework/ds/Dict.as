//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.framework.ds
{
    import flash.utils.Dictionary;

    public class Dict 
    {

        public var result:Array;
        private var _weak:Boolean;
        private var _dict:Dictionary;
        private var _size:int;

        public function Dict(_arg_1:Boolean=false)
        {
            this.result = new Array();
            super();
            this._dict = new Dictionary(_arg_1);
            this._size = 0;
            this._weak = _arg_1;
        }

        public function put(_arg_1:*, _arg_2:*):void
        {
            if (_arg_2 === undefined)
            {
                return;
            };
            if (this._dict[_arg_1] === undefined)
            {
                this._size++;
            };
            this._dict[_arg_1] = _arg_2;
        }

        public function take(_arg_1:*)
        {
            return (this._dict[_arg_1]);
        }

        public function remove(_arg_1:*)
        {
            if (this._dict[_arg_1] !== undefined)
            {
                this._size--;
            };
            var _local_2:* = this._dict[_arg_1];
            delete this._dict[_arg_1];
            return (_local_2);
        }

        public function clear():void
        {
            this._dict = new Dictionary(this._weak);
            this._size = 0;
        }

        public function dispose():void
        {
            this._dict = null;
        }

        public function get size():int
        {
            var _local_1:int;
            var _local_2:*;
            if (this._weak)
            {
                for (_local_2 in this._dict)
                {
                    _local_1++;
                };
                return (_local_1);
            };
            return (this._size);
        }

        public function isEmpty():Boolean
        {
            var _local_1:*;
            if (this._weak)
            {
                for (_local_1 in this._dict)
                {
                    return (false);
                };
                return (true);
            };
            return ((this._size == 0));
        }

        public function contains(_arg_1:*):Boolean
        {
            return ((!((this._dict[_arg_1] === undefined))));
        }

        public function toArray():Array
        {
            var _local_2:*;
            var _local_1:Array = new Array();
            for each (_local_2 in this._dict)
            {
                _local_1.push(_local_2);
            };
            return (_local_1);
        }

        public function copy():Dict
        {
            var _local_1:Dict = new Dict();
            _local_1._dict = this._dict;
            _local_1._size = this._size;
            _local_1._weak = _local_1._weak;
            return (_local_1);
        }

        public function clone(_arg_1:Boolean=false):Dict
        {
            var _local_3:*;
            var _local_2:Dict = new Dict(_arg_1);
            for (_local_3 in this._dict)
            {
                _local_2.put(_local_3, this._dict[_local_3]);
            };
            return (_local_2);
        }

        public function get dict():Dictionary
        {
            return (this._dict);
        }

        public function set dict(_arg_1:Dictionary):void
        {
            var _local_2:int;
            var _local_3:*;
            this._dict = _arg_1;
            for (_local_3 in this._dict)
            {
                _local_2++;
            };
            this._size = _local_2;
        }


    }
}//package com.popchan.framework.ds
