//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import flash.events.TimerEvent;
    
    import __AS3__.vec.Vector;
    
    import diary.shop.fsm.Result;

    public class FindWorkstation extends WorkerState 
    {

        private var _timer:ClockTimer;

        public function FindWorkstation(_arg_1:ShopWorkerAgent)
        {
            super(_arg_1);
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            this._timer = new ClockTimer(client.mainClock, (500 / client.timeMultiplier), 1);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerDone);
            this._timer.start();
        }

        override public function loop(_arg_1:Boolean=false)
        {
            var _local_6:ModuleInstance;
            var _local_9:int;
            var _local_10:int;
            var _local_11:ModuleInstance;
            var _local_12:Number;
            var _local_13:Array;
            var _local_2:* = super.loop(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            var _local_3:Array = agent.workerInstance.fetchingRecipe.module.moduleIDs;
            var _local_4:uint = agent.workerInstance.fetchingRecipe.module_level;
            var _local_5:Vector.<ModuleInstance> = new Vector.<ModuleInstance>();
            var _local_7:uint = uint.MAX_VALUE;
            var _local_8:uint = uint.MAX_VALUE;
            for each (_local_6 in client.player.module_instances)
            {
                if (((((!(_local_6.isBuilding)) || (_local_6.module.parent_id))) && ((_local_6.usedBy == null))))
                {
                    _local_9 = _local_3.indexOf(_local_6.module_id);
                    if (_local_9 != -1)
                    {
                        if ((((_local_9 > 0)) || ((_local_6.level >= _local_4))))
                        {
                            _local_5.push(_local_6);
                            if (_local_9 == _local_8)
                            {
                                _local_7 = Math.min(_local_7, _local_6.globalLevel);
                            }
                            else
                            {
                                if (_local_9 < _local_8)
                                {
                                    _local_8 = _local_9;
                                    _local_7 = _local_6.globalLevel;
                                };
                            };
                        };
                    };
                };
            };
            if (_local_5.length > 0)
            {
                _local_10 = (_local_5.length - 1);
                while ((((_local_10 >= 0)) && ((_local_5.length > 1))))
                {
                    if (_local_5[_local_10].globalLevel > _local_7)
                    {
                        _local_5.splice(_local_10, 1);
                    };
                    _local_10--;
                };
                agent.leave();
                _local_12 = Number.MAX_VALUE;
                if (_local_5.length > 1)
                {
                    for each (_local_6 in _local_5)
                    {
                        _local_13 = agent.getDistanceFromModuleInstance(_local_6);
                        if (_local_12 > _local_13[1])
                        {
                            _local_12 = (_local_13[1] as Number);
                            _local_11 = _local_6;
                        };
                    };
                }
                else
                {
                    _local_11 = _local_5[0];
                };
                agent.reserveWorkstation(_local_11);
                return (new Result(Result.TRANSITION, new WalkTo(agent, new StartWorking(agent))));
            };
            return (Result.CONTINUE);
        }

        override public function transitionOut(_arg_1:Boolean=false):void
        {
            super.transitionOut(_arg_1);
            this._timer.stop();
            agent.setBubbleType(BubbleView.NONE);
        }

        private function onTimerDone(_arg_1:TimerEvent):void
        {
            agent.setBubbleType(BubbleView.EMPTY);
            var _local_2:Recipe = agent.workerInstance.fetchingRecipe;
            agent.setBubbleSubImageTextureName((_local_2.module.scene_objects[0] as SceneObject).image_path, _local_2.module_level);
        }


    }
}//package com.edgebee.shopr2.controller.agent.workerstates
