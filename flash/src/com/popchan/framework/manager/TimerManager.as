//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.framework.manager
{
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    import flash.events.Event;
    import com.popchan.framework.core.Core;

    public class TimerManager 
    {

        private static var _instance:TimerManager;

        private var _listeners:Dictionary;
        private var _count:int;
        private var _isRunning:Boolean;

        public function TimerManager()
        {
            this._listeners = new Dictionary();
            super();
        }

        public function add(_arg_1:*, _arg_2:Function, _arg_3:int, _arg_4:int=-1, _arg_5:Object=null):void
        {
            var _local_7:TimeModel;
            var _local_8:TimeModel;
            var _local_6:Array = this._listeners[_arg_1];
            if (_local_6 == null)
            {
                _local_6 = [];
            }
            else
            {
                for each (_local_8 in _local_6)
                {
                    if (_local_8.callBack == _arg_2)
                    {
                        return;
                    };
                };
            };
            _local_7 = new TimeModel();
            _local_7.callBack = _arg_2;
            _local_7.target = _arg_1;
            _local_7.delay = _arg_3;
            _local_7.repeatCount = _arg_4;
            _local_7.params = _arg_5;
            _local_7.currentCount = 0;
            _local_7.currentTime = getTimer();
            _local_7.offset = 0;
            _local_6.push(_local_7);
            this._listeners[_arg_1] = _local_6;
            this._count++;
            this.resume();
        }

        public function remove(_arg_1:*, _arg_2:Function):void
        {
            var _local_3:Array = this._listeners[_arg_1];
            if (_local_3 == null)
            {
                return;
            };
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                if (_local_3[_local_4].callBack == _arg_2)
                {
                    _local_3[_local_4].isRemoved = true;
                    _local_3.splice(_local_4, 1);
                    this._count--;
                    _local_4--;
                };
                _local_4++;
            };
            if (this._count == 0)
            {
                this.pause();
            };
        }

        protected function onEnterFrame(_arg_1:Event):void
        {
            var _local_2:*;
            var _local_3:Array;
            var _local_4:TimeModel;
            var _local_5:int;
            for (_local_2 in this._listeners)
            {
                _local_3 = this._listeners[_local_2];
                for each (_local_4 in _local_3)
                {
                    _local_5 = (getTimer() - _local_4.currentTime);
                    _local_4.offset = (_local_4.offset + _local_5);
                    _local_4.currentTime = getTimer();
                    if (_local_4.offset >= _local_4.delay)
                    {
                        while (_local_4.offset >= _local_4.delay)
                        {
                            if (_local_4.isRemoved) break;
                            _local_4.offset = (_local_4.offset - _local_4.delay);
                            _local_4.currentCount++;
                            if (_local_4.repeatCount > 0)
                            {
                                if (_local_4.params == null)
                                {
                                    _local_4.callBack();
                                }
                                else
                                {
                                    _local_4.callBack(_local_4.params);
                                };
                                if (_local_4.currentCount == _local_4.repeatCount)
                                {
                                    this.remove(_local_4.target, _local_4.callBack);
                                    break;
                                };
                            }
                            else
                            {
                                if (_local_4.params == null)
                                {
                                    _local_4.callBack();
                                }
                                else
                                {
                                    _local_4.callBack(_local_4.params);
                                };
                            };
                        };
                    };
                };
            };
        }

        public function pause():void
        {
            if (this._isRunning)
            {
                this._isRunning = false;
                Core.stageManager.stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            };
        }

        public function resume():void
        {
            if ((((!(this._isRunning))) && ((this._count > 0))))
            {
                this._isRunning = true;
                Core.stageManager.stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
            };
        }


    }
}//package com.popchan.framework.manager

class TimeModel 
{

    public var callBack:Function;
    public var target;
    public var params:Object;
    public var delay:int;
    public var repeatCount:int;
    public var offset:int;
    public var currentTime:int;
    public var currentCount:int;
    public var isRemoved:Boolean;


}
class Single 
{


}
