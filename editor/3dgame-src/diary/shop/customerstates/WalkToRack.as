//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.customerstates
{
    import flash.events.Event;
    
    import diary.shop.fsm.Result;

    public class WalkToRack extends CustomerState
    {

        private var done:Boolean;
        private var wait:Boolean;

        public function WalkToRack(_arg_1:CustomerAgent)
        {
            super(_arg_1);
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            if (agent.poi != null)
            {
                agent.continueFromEntranceToPOI(agent.poi);
                agent.addEventListener(Agent.REACHED_FINAL_DESTINATION, this.onReachedDestination);
            }
            else
            {
                this.wait = true;
            };
            (agent.characterView as CustomerView).inShop = true;
        }

        override public function loop(_arg_1:Boolean=false)
        {
            var _local_2:* = super.loop(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            if (((this.wait) || (this.done)))
            {
                agent.lookAtCamera();
                (agent.characterView as CustomerView).canInteract = true;
                return (new Result(Result.TRANSITION, new Idle(agent)));
            };
            if (agent.player.day_tick >= agent.visitingCustomer.leave_tick)
            {
                return (new Result(Result.TRANSITION, new WalkToExit(agent)));
            };
            if (agent.visitingCustomer.hasBeenServed)
            {
                return (new Result(Result.TRANSITION, new WalkToExit(agent)));
            };
        }

        override public function transitionOut(_arg_1:Boolean=false):void
        {
            super.transitionOut(_arg_1);
            agent.removeEventListener(Agent.REACHED_FINAL_DESTINATION, this.onReachedDestination);
        }

        private function onReachedDestination(_arg_1:Event):void
        {
            this.done = true;
        }


    }
}//package com.edgebee.shopr2.controller.agent.customerstates
