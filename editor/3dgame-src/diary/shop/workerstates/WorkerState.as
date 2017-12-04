//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import diary.shop.fsm.Result;
    import diary.shop.fsm.State;
    
    import zzsdk.editor.utils.Client;

    public class WorkerState extends State 
    {

        public function WorkerState(_arg_1:ShopWorkerAgent)
        {
            super(_arg_1);
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
        }

        override public function loop(_arg_1:Boolean=false)
        {
            super.loop(_arg_1);
            if (this.agent.workIsCanceled)
            {
                return (new Result(Result.TRANSITION, new CancelWorking(this.agent)));
            };
        }

        override public function transitionOut(_arg_1:Boolean=false):void
        {
            super.transitionOut(_arg_1);
        }

        protected function get agent():ShopWorkerAgent
        {
            return ((machine as ShopWorkerAgent));
        }

        protected function get client():Client
        {
            return (this.agent.client);
        }

        protected function get player():Player
        {
            return (this.agent.player);
        }


    }
}//package com.edgebee.shopr2.controller.agent.workerstates
