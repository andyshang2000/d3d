//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import com.edgebee.shopr2.controller.agent.ShopWorkerAgent;
    import com.edgebee.atlas.util.fsm.Result;

    public class EnterShop extends WorkerState 
    {

        private var isWorking:Boolean = false;
        private var isFetching:Boolean = false;

        public function EnterShop(_arg_1:ShopWorkerAgent)
        {
            super(_arg_1);
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            this.isWorking = agent.workerInstance.isCrafting;
            this.isFetching = agent.workerInstance.isFetching;
        }

        override public function loop(_arg_1:Boolean=false)
        {
            var _local_3:Boolean;
            var _local_2:* = super.loop(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            if (this.isWorking)
            {
                return (new Result(Result.TRANSITION, new StartWorking(agent, true)));
            };
            if (this.isFetching)
            {
                agent.leave();
                if (agent.workerInstance.queueSlot.is_research)
                {
                    return (new Result(Result.TRANSITION, new FindWorkstation(agent)));
                };
                return (new Result(Result.TRANSITION, new GatherComponents(agent)));
            };
            _local_3 = false;
            if (((!((agent.poi == null))) && (!(agent.poi.reserved))))
            {
                _local_3 = true;
            };
            return (new Result(Result.TRANSITION, new Idle(agent, true, _local_3)));
        }

        override public function transitionOut(_arg_1:Boolean=false):void
        {
            super.transitionOut(_arg_1);
        }


    }
}//package com.edgebee.shopr2.controller.agent.workerstates
