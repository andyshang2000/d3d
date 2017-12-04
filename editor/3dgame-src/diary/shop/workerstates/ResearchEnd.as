//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import com.edgebee.shopr2.controller.agent.ShopWorkerAgent;
    import com.edgebee.atlas.util.fsm.Result;
    import com.edgebee.atlas.ui.UIGlobals;

    public class ResearchEnd extends WorkerState 
    {

        public function ResearchEnd(_arg_1:ShopWorkerAgent)
        {
            super(_arg_1);
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            agent.poi.reserved = false;
            this.endTask();
        }

        override public function loop(_arg_1:Boolean=false)
        {
            var _local_2:* = super.loop(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            return (new Result(Result.TRANSITION, new Idle(agent, true, true, 3)));
        }

        override public function transitionOut(_arg_1:Boolean=false):void
        {
            super.transitionOut(_arg_1);
        }

        public function endTask():void
        {
            UIGlobals.playSound(shopr2_flash.ItemDropWav);
            agent.workerInstance.isBusy = false;
            agent.workerInstance.is_researching = false;
            var _local_1:uint = 1;
            if (agent.isCritical)
            {
                _local_1 = (_local_1 + 1);
                agent.isCritical = false;
            };
            player.findTaskForWorkers();
        }


    }
}//package com.edgebee.shopr2.controller.agent.workerstates
