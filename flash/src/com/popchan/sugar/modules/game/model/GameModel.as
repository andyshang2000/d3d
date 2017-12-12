//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.model
{
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.framework.manager.SoundManager;
    import com.popchan.sugar.core.data.AimType;
    import com.popchan.sugar.core.events.GameEvents;
    
    import flash.utils.Dictionary;

    public class GameModel 
    {

        private var aim:Dictionary;
        private var aimOrg:Dictionary;
        private var _step:int;
        private var _time:int;
        private var _score:int;
        public var highScore:int;
        public var isSuccess:Boolean;
        public var isTest:Boolean = false;
		public var failReason:int = -1;

        public function GameModel()
        {
            this.aim = new Dictionary();
            this.aimOrg = new Dictionary();
            super();
        }

        public function get score():int
        {
            return (this._score);
        }

        public function set score(_arg_1:int):void
        {
            this._score = _arg_1;
            MsgDispatcher.execute(GameEvents.SCORE_CHANGE);
        }

        public function get time():int
        {
            return (this._time);
        }

        public function set time(_arg_1:int):void
        {
            this._time = _arg_1;
            MsgDispatcher.execute(GameEvents.TIME_CHANGE);
            if ((((_arg_1 <= 10)) && ((_arg_1 > 0))))
            {
                SoundManager.instance.playSound("warningtime");
            };
        }

        public function get step():int
        {
            return (this._step);
        }

        public function set step(_arg_1:int):void
        {
            this._step = _arg_1;
            if ((((this._step <= 5)) && ((this._step > 0))))
            {
                SoundManager.instance.playSound("warningmove");
            };
            MsgDispatcher.execute(GameEvents.STEP_CHANGE);
        }

        public function reset():void
        {
            var _local_1:*;
            for (_local_1 in this.aim)
            {
                delete this.aim[_local_1];
            };
            for (_local_1 in this.aimOrg)
            {
                delete this.aimOrg[_local_1];
            };
            this.isSuccess = false;
            this.score = 0;
			failReason = -1;
        }

        public function addAim(_arg_1:int, _arg_2:int):void
        {
            this.aim[_arg_1] = 0;
            this.aimOrg[_arg_1] = _arg_2;
        }

        public function offsetAim(_arg_1:int, _arg_2:int):void
        {
            if (this.aim[_arg_1] != undefined)
            {
                this.aim[_arg_1] = (this.aim[_arg_1] + _arg_2);
                if (this.aim[_arg_1] >= this.aimOrg[_arg_1])
                {
                    this.aim[_arg_1] = this.aimOrg[_arg_1];
                };
                MsgDispatcher.execute(GameEvents.AIMS_CHANGE, {
                    "type":_arg_1,
                    "value":this.aim[_arg_1],
                    "orgValue":this.aimOrg[_arg_1]
                });
            };
        }

        public function getLeftFruitAim(_arg_1:Array):Array
        {
            var _local_3:int;
            var _local_4:*;
            var _local_5:int;
            var _local_2:Array = [];
            for (_local_4 in this.aim)
            {
                if ((((((_local_4 == AimType.FRUIT1)) || ((_local_4 == AimType.FRUIT2)))) || ((_local_4 == AimType.FRUIT3))))
                {
                    _local_3 = 0;
                    while (_local_3 < (this.aimOrg[_local_4] - this.aim[_local_4]))
                    {
                        _local_2.push(_local_4);
                        _local_3++;
                    };
                };
            };
            _local_3 = 0;
            while (_local_3 < _arg_1.length)
            {
                _local_5 = (_local_2.length - 1);
                while (_local_5 >= 0)
                {
                    if (_local_2[_local_5] == _arg_1[_local_3])
                    {
                        _local_2.splice(_local_5, 1);
                    };
                    _local_5--;
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function checkAimComplete():Boolean
        {
            var _local_2:*;
            var _local_1:Boolean = true;
            for (_local_2 in this.aim)
            {
                if (this.aim[_local_2] < this.aimOrg[_local_2])
                {
                    _local_1 = false;
                    break;
                };
            };
            return (_local_1);
        }

        public function isScoreAimLevel():Boolean
        {
            var _local_1:*;
            for (_local_1 in this.aim)
            {
                if (_local_1 == AimType.SCORE)
                {
                    return (true);
                };
            };
            return (false);
        }


    }
}//package com.popchan.sugar.modules.game.model
