//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import flash.events.TimerEvent;
    
    import diary.shop.fsm.Result;

    public class Idle extends WorkerState 
    {

        private static const MIN_BLINK_INTERVAL:Number = 1500;
        private static const BLINK_INTERVAL_RANDOM:Number = 1500;

        private var _lookAtCamera:Boolean;
        private var _leaveIfPOIIsReserved:Boolean;
        private var _delayBeforeLeaving:Number;
        private var _timeToLeave:Boolean;
        private var _showTutorial:Boolean;
        private var _blinkTimer:ClockTimer;
        private var _timeToLeaveTimer:ClockTimer;
        private var _showIdleBubbleTimer:ClockTimer;
        private var _showTutorialTimer:ClockTimer;

        public function Idle(_arg_1:ShopWorkerAgent, _arg_2:Boolean, _arg_3:Boolean, _arg_4:Number=-1)
        {
            super(_arg_1);
            this._lookAtCamera = _arg_2;
            this._leaveIfPOIIsReserved = _arg_3;
            this._delayBeforeLeaving = _arg_4;
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            super.transitionInto(_arg_1);
            if (this._lookAtCamera)
            {
                agent.lookAtCamera();
                agent.characterView.idle();
            }
            else
            {
                agent.characterView.idle();
            };
            this._blinkTimer = new ClockTimer(UIGlobals.root.client.mainClock, (MIN_BLINK_INTERVAL + (Math.random() * BLINK_INTERVAL_RANDOM)), 1);
            this._blinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onBlinkTimer);
            this._blinkTimer.start();
            if (((!((agent is ShopWorkerAgent))) || ((player.level < 25))))
            {
                this._showIdleBubbleTimer = new ClockTimer(client.mainClock, (500 / client.timeMultiplier), 1);
                this._showIdleBubbleTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onIdleBubbleTimerDone);
                this._showIdleBubbleTimer.start();
            };
            if (this._delayBeforeLeaving > 0)
            {
                this._timeToLeaveTimer = new ClockTimer(UIGlobals.root.client.mainClock, (this._delayBeforeLeaving * 1000), 1);
                this._timeToLeaveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimeToLeaveTimer);
                this._timeToLeaveTimer.start();
            };
            if ((((agent is ShopWorkerAgent)) && (!(player.isTutorialDone(Player.TUTORIAL_SHOPKEEPER_IDLE)))))
            {
                this._showTutorialTimer = new ClockTimer(UIGlobals.root.client.mainClock, 3000, 1);
                this._showTutorialTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onShowTutorialTimer);
                this._showTutorialTimer.start();
            };
        }

        override public function loop(_arg_1:Boolean=false)
        {
            var _local_3:PointOfInterest;
            var _local_4:GameView;
            var _local_2:* = super.loop(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            if (agent.workerInstance.isFetching)
            {
                if (agent.poi != null)
                {
                    agent.leave();
                };
                if (agent.workerInstance.queueSlot.is_research)
                {
                    return (new Result(Result.TRANSITION, new FindWorkstation(agent)));
                };
                return (new Result(Result.TRANSITION, new GatherComponents(agent)));
            };
            if (((this._timeToLeave) || (((((this._leaveIfPOIIsReserved) && (!((agent.poi == null))))) && (agent.poi.reserved)))))
            {
                agent.poi = null;
                if (agent.isAvatar)
                {
                    return (new Result(Result.TRANSITION, new GoToCounter(agent)));
                };
                _local_3 = agent.scene.generatedPOIs.getRandomPOI();
                if (_local_3 != null)
                {
                    agent.poi = _local_3;
                    return (new Result(Result.TRANSITION, new WalkTo(agent, new Idle(agent, true, false))));
                };
                return (new Result(Result.TRANSITION, new GoToCounter(agent)));
            };
            if (((this._showTutorial) && (!(player.isTutorialDone(Player.TUTORIAL_SHOPKEEPER_IDLE)))))
            {
                this._showTutorial = false;
                _local_4 = (UIGlobals.gameView as GameView);
                _local_4.tutorialView.tutorialInfo = TutorialInfo.getInstanceByUid("shopkeeper_idle");
                _local_4.sceneView.resetCameraPosition();
            };
            return (Result.CONTINUE);
        }

        override public function transitionOut(_arg_1:Boolean=false):void
        {
            super.transitionOut(_arg_1);
            this._blinkTimer.stop();
            if (this._showIdleBubbleTimer != null)
            {
                this._showIdleBubbleTimer.stop();
            };
            agent.setBubbleType(BubbleView.NONE);
        }

        private function onIdleBubbleTimerDone(_arg_1:TimerEvent):void
        {
            if (agent.isAvatar)
            {
                agent.setBubbleType(BubbleView.WAIT);
            }
            else
            {
                if (Math.random() < 0.5)
                {
                    agent.setBubbleType(BubbleView.COFFEE);
                }
                else
                {
                    agent.setBubbleType(BubbleView.HOURGLASS);
                };
            };
        }

        private function onTimeToLeaveTimer(_arg_1:TimerEvent):void
        {
            this._timeToLeave = true;
        }

        private function onShowTutorialTimer(_arg_1:TimerEvent):void
        {
            this._showTutorial = true;
        }

        private function onBlinkTimer(_arg_1:TimerEvent):void
        {
            this._blinkTimer.reset();
            this._blinkTimer.delay = (MIN_BLINK_INTERVAL + (Math.random() * BLINK_INTERVAL_RANDOM));
            this._blinkTimer.repeatCount = 1;
            this._blinkTimer.start();
            (agent.characterView as WorkerView).blink(this.onBlinkEnd);
        }

        private function onBlinkEnd():void
        {
            agent.characterView.idle();
        }


    }
}//package com.edgebee.shopr2.controller.agent.workerstates
