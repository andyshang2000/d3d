//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.processors
{
    import com.edgebee.atlas.util.ClockTimer;
    import flash.events.TimerEvent;
    import com.edgebee.atlas.interfaces.IExecutable;
    import com.edgebee.atlas.data.events.ScheduledEvent;
    import com.edgebee.atlas.util.Cursor;

    public class ScheduledProcessor extends BaseProcessor 
    {

        private var timer:ClockTimer;

        public function ScheduledProcessor()
        {
            this.timer = client.createClockTimer(25);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.timer.start();
        }

        override public function add(_arg_1:IExecutable):void
        {
            var _local_2:IExecutable;
            for each (_local_2 in executables)
            {
                if (_local_2 == _arg_1)
                {
                    throw (Error("Event already scheduled."));
                };
            };
            super.add(_arg_1);
        }

        private function onTimer(_arg_1:TimerEvent):void
        {
            var _local_3:ScheduledEvent;
            var _local_2:Cursor = new Cursor(executables);
            while (_local_2.valid)
            {
                _local_3 = (_local_2.current as ScheduledEvent);
                if (_local_3.conditionFunc())
                {
                    _local_3.execute();
                    _local_2.remove();
                }
                else
                {
                    _local_2.next();
                };
            };
        }


    }
}//package com.edgebee.atlas.managers.processors
