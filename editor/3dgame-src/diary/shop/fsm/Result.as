//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.fsm
{
    public class Result 
    {

        public static const CONTINUE:uint = 0;
        public static const STOP:uint = 1;
        public static const TRANSITION:uint = 2;

        private var _type:uint;
        private var _next:State;

        public function Result(_arg_1:uint=0, _arg_2:State=null)
        {
            this._type = _arg_1;
            this._next = _arg_2;
        }

        public function get type():uint
        {
            return (this._type);
        }

        public function get state():State
        {
            return (this._next);
        }


    }
}//package com.edgebee.atlas.util.fsm
