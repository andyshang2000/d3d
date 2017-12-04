//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.fsm
{
    import com.edgebee.atlas.interfaces.IExecutable;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.getTimer;

    public class Machine extends EventDispatcher implements IExecutable 
    {

        public static const STOPPED:String = "STOPPED";

        private var _active:Boolean;
        private var _current:State;
        private var _timer:uint;
        public var debug:Boolean;

        public function Machine()
        {
            this._active = false;
            this._current = null;
            this._timer = 0;
            this.debug = false;
        }

        public function get currentState():State
        {
            return (this._current);
        }

        public function start(_arg_1:State):void
        {
            this._active = true;
            this._current = _arg_1;
            this._timer = 0;
            this._current.transitionInto(this.debug);
        }

        public function transitionTo(_arg_1:State):void
        {
            if (this._current)
            {
                this._current.transitionOut(this.debug);
            };
            this._current = _arg_1;
            this._current.transitionInto(this.debug);
            this.execute();
        }

        public function execute():void
        {
            var _local_1:*;
            var _local_2:uint;
            if (this._active)
            {
                if (!this.waiting)
                {
                    _local_1 = this._current.loop(this.debug);
                    if ((_local_1 is Result))
                    {
                        _local_2 = _local_1.type;
                    }
                    else
                    {
                        if ((_local_1 is uint))
                        {
                            _local_2 = _local_1;
                            if (_local_2 == Result.TRANSITION)
                            {
                                throw (Error("Must return a Result object for state transitions!"));
                            };
                        };
                    };
                    switch (_local_2)
                    {
                        case Result.CONTINUE:
                        default:
                            return;
                        case Result.STOP:
                            this.stop();
                            return;
                        case Result.TRANSITION:
                            this.transitionTo(_local_1.state);
                    };
                };
            };
        }

        public function stop():void
        {
            this._active = false;
            this._current.transitionOut(this.debug);
            dispatchEvent(new Event(STOPPED));
        }

        public function get active():Boolean
        {
            return (this._active);
        }

        public function set active(_arg_1:Boolean):void
        {
            this._active = _arg_1;
        }

        private function get waiting():Boolean
        {
            return ((this._timer >= getTimer()));
        }

        public function set wait(_arg_1:uint):void
        {
            this._timer = (getTimer() + _arg_1);
        }


    }
}//package com.edgebee.atlas.util.fsm
