//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import com.edgebee.atlas.astar.PointOfInterest;
    import com.edgebee.shopr2.data.item.RecipeComponent;
    import com.edgebee.shopr2.data.shop.ModuleInstance;
    import com.edgebee.shopr2.controller.agent.ShopWorkerAgent;
    import com.edgebee.shopr2.controller.agent.Agent;
    import com.edgebee.atlas.util.fsm.Result;
    import flash.events.Event;

    public class GoToPOI extends WorkerState 
    {

        private var _done:Boolean;
        private var _poi:PointOfInterest;
        private var _nextState:WorkerState;
        private var _componentTextureName:String;
        private var _componentQuantity:uint;
        private var _component:RecipeComponent;
        private var _moduleInstance:ModuleInstance;
        private var _up:Boolean;
        private var callback:Function;

        public function GoToPOI(_arg_1:ShopWorkerAgent, _arg_2:ModuleInstance, _arg_3:PointOfInterest, _arg_4:WorkerState, _arg_5:String, _arg_6:uint, _arg_7:RecipeComponent, _arg_8:Boolean, _arg_9:Function=null)
        {
            super(_arg_1);
            this._poi = _arg_3;
            this._nextState = _arg_4;
            this._componentTextureName = _arg_5;
            this._componentQuantity = _arg_6;
            this._component = _arg_7;
            this._moduleInstance = _arg_2;
            this._up = _arg_8;
            this.callback = _arg_9;
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            agent.addEventListener(Agent.REACHED_FINAL_DESTINATION, this.onReachedDestination);
            agent.walkTo(this._poi.point.x, this._poi.point.y);
        }

        override public function loop(_arg_1:Boolean=false)
        {
            var _local_2:* = super.loop(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            if (this._done)
            {
                return (new Result(Result.TRANSITION, new PickUp(agent, this._moduleInstance, this._poi, this._nextState, this._componentTextureName, this._componentQuantity, this._component, this._up, this.callback)));
            };
        }

        override public function transitionOut(_arg_1:Boolean=false):void
        {
            super.transitionOut(_arg_1);
            agent.removeEventListener(Agent.REACHED_FINAL_DESTINATION, this.onReachedDestination);
        }

        private function onReachedDestination(_arg_1:Event):void
        {
            this._done = true;
        }


    }
}//package com.edgebee.shopr2.controller.agent.workerstates
