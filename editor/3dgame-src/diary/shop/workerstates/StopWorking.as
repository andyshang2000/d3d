//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import diary.shop.fsm.Result;
    import diary.game.Item;

    public class StopWorking extends WorkerState 
    {

        private var _done:Boolean;
        private var _item:Item;
        private var itemDropped:ItemDropped;

        public function StopWorking(_arg_1:ShopWorkerAgent)
        {
            super(_arg_1);
            if (!_arg_1)
            {
                throw (new Error("must have a worker agent"));
            };
        }

        public static function endCrafting(_arg_1:Item, _arg_2:ShopWorkerAgent, _arg_3:Player, _arg_4:Function):ItemDropped
        {
            _arg_1 = _arg_2.workerInstance.recipe.item;
            _arg_2.stopWork(_arg_2.poi.observedPoint, _arg_4);
            if (_arg_2.workerInstance.is_researching)
            {
                return (null);
            };
            var _local_5:ItemInstance = (_arg_3.item_instances.findItemByProperty("item_id", _arg_1.id) as ItemInstance);
            var _local_6:ItemDropped = new ItemDropped(_arg_2, _local_5, _arg_3);
            return (_local_6);
        }


        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            if (agent.workerInstance == null)
            {
                throw (new Error("Agent has no workerInstance"));
            };
            if (agent.workerInstance.recipe == null)
            {
                throw (new Error("WorkerInstance has no recipe"));
            };
            if (agent.workerInstance.recipe.item == null)
            {
                throw (new Error("Recipe has no item"));
            };
            this._item = agent.workerInstance.recipe.item;
            this.itemDropped = endCrafting(this._item, agent, player, this.onAnimationEnd);
            UIGlobals.playSound(shopr2_flash.WorkerTaskFinishedWav);
        }

        override public function loop(_arg_1:Boolean=false)
        {
            var _local_3:Array;
            var _local_4:PointOfInterest;
            var _local_5:WorkerState;
            var _local_2:* = super.loop(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            if (this._done)
            {
                if (agent.workerInstance.is_researching)
                {
                    return (new Result(Result.TRANSITION, new ResearchEnd(agent)));
                };
                _local_3 = agent.getClosestPOI(Module.TYPE_CHEST, player.module_instances);
                _local_4 = _local_3[0];
                _local_5 = new Idle(agent, true, true, 7);
                if (_local_4 == null)
                {
                    this.itemDropped.dropItem();
                    return (new Result(Result.TRANSITION, _local_5));
                };
                agent.poi = _local_4;
                agent.poi.reserved = true;
                agent.workerInstance.isBusy = true;
                if (agent.isCritical)
                {
                    return (new Result(Result.TRANSITION, new GoToPOI(agent, _local_3[2], agent.poi, _local_5, this._item.image, 2, null, false, this.itemDropped.dropItem)));
                };
                return (new Result(Result.TRANSITION, new GoToPOI(agent, _local_3[2], agent.poi, _local_5, this._item.image, 1, null, false, this.itemDropped.dropItem)));
            };
            return (Result.CONTINUE);
        }

        override public function transitionOut(_arg_1:Boolean=false):void
        {
            super.transitionOut(_arg_1);
        }

        private function onAnimationEnd():void
        {
            this._done = true;
        }


    }
}//package com.edgebee.shopr2.controller.agent.workerstates
