﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.customerstates
{
    import flash.events.Event;
    
    import diary.shop.fsm.Result;

    public class WalkToExit extends CustomerState
    {

        private var done:Boolean;

        public function WalkToExit(_arg_1:CustomerAgent)
        {
            super(_arg_1);
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            (agent.characterView as CustomerView).canInteract = false;
            if (agent.poi != null)
            {
                agent.poi.reserved = false;
                agent.walkBackFromPOI(agent.poi);
                agent.poi = null;
            };
            agent.addEventListener(Agent.REACHED_FINAL_DESTINATION, this.onReachedDestination);
        }

        override public function loop(_arg_1:Boolean=false)
        {
            var _local_2:* = super.loop(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            if (this.done)
            {
                return (new Result(Result.TRANSITION, new WalkHome(agent)));
            };
            return (Result.CONTINUE);
        }

        override public function transitionOut(_arg_1:Boolean=false):void
        {
            super.transitionOut(_arg_1);
        }

        private function onReachedDestination(_arg_1:Event):void
        {
            this.done = true;
        }


    }
}//package com.edgebee.shopr2.controller.agent.customerstates
