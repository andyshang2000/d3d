//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.fsm
{
    import com.edgebee.atlas.ui.UIGlobals;
    import flash.events.TimerEvent;

    public class AutomaticMachine extends Machine 
    {


        override public function start(_arg_1:State):void
        {
            super.start(_arg_1);
            UIGlobals.twentyfiveMsTimer.addEventListener(TimerEvent.TIMER, this.onTimer);
        }

        override public function stop():void
        {
            super.stop();
            UIGlobals.twentyfiveMsTimer.removeEventListener(TimerEvent.TIMER, this.onTimer);
        }

        private function onTimer(_arg_1:TimerEvent):void
        {
            execute();
        }


    }
}//package com.edgebee.atlas.util.fsm
