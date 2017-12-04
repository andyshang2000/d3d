//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import com.edgebee.atlas.astar.PointOfInterest;
    import com.edgebee.shopr2.controller.agent.ShopWorkerAgent;
    import com.edgebee.shopr2.controller.agent.Agent;
    import com.edgebee.atlas.util.fsm.Result;
    import flash.events.Event;

    public class GoToCounter extends WorkerState 
    {

        private var done:Boolean;
        private var destination:PointOfInterest;

        public function GoToCounter(_arg_1:ShopWorkerAgent)
        {
            super(_arg_1);
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            if (agent.poi == null)
            {
                if (agent.isAvatar)
                {
                    this.destination = player.counterPOI;
                }
                else
                {
                    agent.poi = agent.getAlmostClosestPOI(agent.scene.generatedPOIs.counterPOIs, 20);
                    agent.poi.reserved = true;
                    this.destination = agent.poi;
                };
            };
            agent.addEventListener(Agent.REACHED_FINAL_DESTINATION, this.onReachedDestination);
            agent.walkTo(this.destination.point.x, this.destination.point.y);
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
                agent.characterView.lookAtPoint(this.destination.observedPoint);
                return (new Result(Result.TRANSITION, new Idle(agent, false, false)));
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
}//package com.edgebee.shopr2.controller.agent.workerstates
