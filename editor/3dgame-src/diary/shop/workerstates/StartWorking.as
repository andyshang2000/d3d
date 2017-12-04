//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import com.edgebee.shopr2.controller.agent.ShopWorkerAgent;
    import com.edgebee.atlas.ui.UIGlobals;
    import com.edgebee.atlas.util.fsm.Result;

    public class StartWorking extends WorkerState 
    {

        private var _done:Boolean;
        private var isResume:Boolean;

        public function StartWorking(_arg_1:ShopWorkerAgent, _arg_2:Boolean=false)
        {
            super(_arg_1);
            this.isResume = _arg_2;
            if (!_arg_1)
            {
                throw (new Error("must have a worker agent"));
            };
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            agent.startWork(agent.poi.observedPoint, this.onAnimationEnd, this.isResume);
            switch (agent.workerInstance.codename)
            {
                case "worker":
                    UIGlobals.playSound(shopr2_flash.ItemReturnedWav);
                    return;
                case "blacksmith":
                case "armorer":
                case "tinkerer":
                    UIGlobals.playSound(shopr2_flash.AnvilWav);
                    return;
                case "carpenter":
                case "bowyer":
                case "luthier":
                    UIGlobals.playSound(shopr2_flash.SawingWav);
                    return;
                case "tailor":
                case "leatherworker":
                case "jeweler":
                    UIGlobals.playSound(shopr2_flash.SewingWav);
                    return;
                case "druid":
                case "sorceress":
                case "enchanter":
                    UIGlobals.playSound(shopr2_flash.OtherCompletedWav);
                    return;
            };
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
                return (new Result(Result.TRANSITION, new Working(agent)));
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
