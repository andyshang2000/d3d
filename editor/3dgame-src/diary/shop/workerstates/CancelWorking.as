//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import flash.system.WorkerState;
    
    import diary.shop.fsm.Result;
    import diary.shop.customerstates.Idle;

    public class CancelWorking extends WorkerState 
    {

        public function CancelWorking(_arg_1:ShopWorkerAgent)
        {
            super(_arg_1);
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            agent.stopWork(null, null, true);
        }

        override public function loop(_arg_1:Boolean=false)
        {
            var _local_2:* = super.loop(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            return (new Result(Result.TRANSITION, new Idle(agent, true, true)));
        }

        override public function transitionOut(_arg_1:Boolean=false):void
        {
            super.transitionOut(_arg_1);
            player.findTaskForWorkers();
        }


    }
}//package com.edgebee.shopr2.controller.agent.workerstates
