//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.fsm
{
    import com.edgebee.atlas.util.ClockTimer;
    import flash.events.TimerEvent;

    public class AutomaticClockMachine extends Machine 
    {

        private var timer:ClockTimer;

        public function AutomaticClockMachine(_arg_1:ClockTimer)
        {
            this.timer = _arg_1;
        }

        override public function start(_arg_1:State):void
        {
            super.start(_arg_1);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
        }

        override public function stop():void
        {
            super.stop();
            this.timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
        }

        private function onTimer(_arg_1:TimerEvent):void
        {
            execute();
        }


    }
}//package com.edgebee.atlas.util.fsm
