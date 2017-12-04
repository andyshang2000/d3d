//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import com.edgebee.atlas.astar.PointOfInterest;
    import com.edgebee.shopr2.controller.agent.ShopWorkerAgent;
    import flash.geom.Point;
    import com.edgebee.shopr2.controller.agent.Agent;
    import com.edgebee.atlas.util.fsm.Result;
    import flash.events.Event;

    public class WalkTo extends WorkerState 
    {

        private var done:Boolean;
        private var nextState:WorkerState;
        private var poi:PointOfInterest;

        public function WalkTo(_arg_1:ShopWorkerAgent, _arg_2:WorkerState, _arg_3:PointOfInterest=null)
        {
            super(_arg_1);
            this.nextState = _arg_2;
            if (_arg_3 != null)
            {
                this.poi = _arg_3;
            }
            else
            {
                if (agent.poi != null)
                {
                    this.poi = agent.poi;
                }
                else
                {
                    throw (new Error("Must have a poi"));
                };
            };
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            var _local_2:Point = this.poi.point;
            agent.addEventListener(Agent.REACHED_FINAL_DESTINATION, this.onReachedDestination);
            agent.walkTo(_local_2.x, _local_2.y);
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
                if (this.nextState != null)
                {
                    return (new Result(Result.TRANSITION, this.nextState));
                };
                agent.characterView.idle(this.poi.observedPoint);
                return (Result.STOP);
            };
            return (Result.CONTINUE);
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
