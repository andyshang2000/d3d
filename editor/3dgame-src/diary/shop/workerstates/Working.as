//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import diary.shop.fsm.Result;

    public class Working extends WorkerState 
    {

        private var isItemCraftedLooped:Boolean = false;

        public function Working(_arg_1:ShopWorkerAgent)
        {
            super(_arg_1);
            if (!_arg_1)
            {
                throw (new Error("must have a worker agent"));
            };
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            agent.workerView.work(agent.poi.observedPoint);
        }

        override public function loop(_arg_1:Boolean=false)
        {
            var _local_2:* = super.loop(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            if (this.isItemCrafted)
            {
                this.isItemCraftedLooped = true;
                if (!agent.workerInstance.isCrafting)
                {
                    throw (new Error("Can't stop working if not currently crafting."));
                };
                return (new Result(Result.TRANSITION, new StopWorking(agent)));
            };
            return (Result.CONTINUE);
        }

        override public function transitionOut(_arg_1:Boolean=false):void
        {
            var _local_2:ItemDropped;
            super.transitionOut(_arg_1);
            if (((this.isItemCrafted) && (!(this.isItemCraftedLooped))))
            {
                _local_2 = StopWorking.endCrafting(agent.workerInstance.recipe.item, agent, player, null);
                if (_local_2)
                {
                    _local_2.dropItem();
                };
            };
        }

        private function get isItemCrafted():Boolean
        {
            return (agent.workerInstance.isCompleted(player.day_index, player.day_tick));
        }


    }
}//package com.edgebee.shopr2.controller.agent.workerstates
