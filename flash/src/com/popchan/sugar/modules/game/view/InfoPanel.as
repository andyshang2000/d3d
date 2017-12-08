//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.core.Core;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.sugar.core.Model;
    import com.popchan.sugar.core.cfg.levels.LevelCO;
    import com.popchan.sugar.core.data.AimType;
    import com.popchan.sugar.core.data.GameMode;
    import com.popchan.sugar.core.events.GameEvents;
    
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.display.TextSprite;
    import starling.textures.Texture;

    public class InfoPanel extends Sprite 
    {
        private var score_txt:TextSprite;
        private var stepLabel:TextSprite;
        private var timeLabel:TextSprite;
        private var levelLabel:TextSprite;
        private var pause_btn:Button;
        private var timeIcon:Image;
        private var stepIcon:Image;
        private var progress:HProgressBar;
        private var aimLabelDict:Dictionary;
        private var aimIconDict:Dictionary;
        private var scoreAim:int;

        public function InfoPanel()
        {
            this.aimLabelDict = new Dictionary();
            this.aimIconDict = new Dictionary();
            super();
            this.progress = new HProgressBar(Core.texturesManager.getTexture("progressBg"), Core.texturesManager.getTexture("progressBar"));
            this.progress.x = 412;
            this.progress.y = 67;
            this.addChild(this.progress);
            this.progress.ratio = 0;
            this.pause_btn = ToolKit.createButton(this, Core.texturesManager.getTexture("pause_btn"), 589, 70, this.onPause);
            ToolKit.createImage(this, Core.texturesManager.getTexture("infopanel"), 0, 0, false, false);
            this.stepIcon = ToolKit.createImage(this, Core.texturesManager.getTexture("step"), 104, 20, true, false);
            this.timeIcon = ToolKit.createImage(this, Core.texturesManager.getTexture("clock"), 104, 23, true, false);
            ToolKit.createImage(this, Core.texturesManager.getTexture("score"), 539, 20, true, false);
            this.stepLabel = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("font1_"), 104, 30, 16, "0123456789/x+-", 24);
            this.stepLabel.hAlign = "center";
            this.timeLabel = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("font1_"), 104, 30, 16, "0123456789/x+-", 24);
            this.timeLabel.hAlign = "center";
            this.score_txt = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("font1_"), 539, 30, 16, "0123456789/x+-", 24);
            this.score_txt.hAlign = "center";
            this.score_txt.text = "0";
            ToolKit.createImage(this, Core.texturesManager.getTexture("levelimg"), 316, 80, true, false);
            this.levelLabel = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("glevel_"), 378, 68, 18, "0123456789", 27);
            this.levelLabel.hAlign = "center";
            MsgDispatcher.add(GameEvents.AIMS_CHANGE, this.onAimChange);
            MsgDispatcher.add(GameEvents.SCORE_CHANGE, this.onScoreChange);
            MsgDispatcher.add(GameEvents.STEP_CHANGE, this.onStepChange);
            MsgDispatcher.add(GameEvents.TIME_CHANGE, this.onTimeChange);
        }

        private function onTimeChange():void
        {
            this.timeLabel.text = (Model.gameModel.time + "");
        }

        private function onPause():void
        {
            MsgDispatcher.execute(GameEvents.OPEN_PAUSE_UI);
        }

        private function onAimChange(_arg_1:Object):void
        {
            if (_arg_1.type == AimType.SCORE)
            {
                return;
            };
            this.aimLabelDict[_arg_1.type].text = ((_arg_1.orgValue - _arg_1.value) + "");
        }

        private function onScoreChange():void
        {
            this.score_txt.text = (Model.gameModel.score + "");
            this.progress.ratio = (Model.gameModel.score / (this.scoreAim * 6));
        }

        private function onStepChange():void
        {
            this.stepLabel.text = (Model.gameModel.step + "");
        }

        public function setInfo(_arg_1:LevelCO):void
        {
            var _local_2:Image;
            var _local_3:*;
            var _local_6:TextSprite;
            var _local_7:Array;
            var _local_8:int;
            var _local_9:int;
            var _local_10:TextSprite;
            this.scoreAim = _arg_1.needScore;
            this.levelLabel.text = (Model.levelModel.selectedLevel + "");
            for (_local_3 in this.aimIconDict)
            {
                _local_2 = this.aimIconDict[_local_3];
                _local_2.removeFromParent(true);
                _local_2 = null;
                delete this.aimIconDict[_local_3];
            };
            for (_local_3 in this.aimLabelDict)
            {
                _local_6 = this.aimLabelDict[_local_3];
                _local_6.removeFromParent(true);
                _local_6 = null;
                delete this.aimLabelDict[_local_3];
            };
            if (_arg_1.mode == GameMode.NORMAL)
            {
                this.stepLabel.visible = true;
                this.timeLabel.visible = false;
                Model.gameModel.step = (_arg_1.step + 10);
                this.stepIcon.visible = true;
                this.timeIcon.visible = false;
            }
            else
            {
                if (_arg_1.mode == GameMode.TIME)
                {
                    this.stepLabel.visible = false;
                    this.timeLabel.visible = true;
                    Model.gameModel.time = (_arg_1.step + 15);
                    this.stepIcon.visible = false;
                    this.timeIcon.visible = true;
                };
            };
            var _local_4:int;
            if (_arg_1.aim.length == 1)
            {
                _local_4 = 300;
            }
            else
            {
                if (_arg_1.aim.length == 2)
                {
                    _local_4 = 240;
                }
                else
                {
                    if (_arg_1.aim.length == 3)
                    {
                        _local_4 = 200;
                    };
                };
            };
            var _local_5:int;
            while (_local_5 < _arg_1.aim.length)
            {
                _local_7 = _arg_1.aim[_local_5].split(",");
                _local_8 = int(_local_7[0]);
                _local_9 = int(_local_7[1]);
                Model.gameModel.addAim(_local_8, _local_9);
                _local_2 = new Image(Texture.fromTexture(Core.texturesManager.getTexture(AimType.AIM_ICONS[_local_8])));
                _local_2.pivotY = (_local_2.height >> 1);
                if (_local_8 != AimType.SCORE)
                {
                    _local_2.pivotX = (_local_2.width >> 1);
                    _local_2.scaleX = (_local_2.scaleY = 0.6);
                }
                else
                {
                    _local_2.pivotX = _local_2.width;
                };
                _local_2.x = ((_local_4 + (_local_5 * 80)) + 30);
                _local_2.y = 31;
                this.addChild(_local_2);
                this.aimIconDict[_local_8] = _local_2;
                _local_10 = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("font1_"), 0, 0, 16, "0123456789/x+-");
                addChild(_local_10);
                _local_10.text = (_local_9 + "");
                _local_10.x = ((_local_4 + 45) + (_local_5 * 80));
                _local_10.y = 23;
                this.aimLabelDict[_local_8] = _local_10;
                _local_5++;
            };
        }

        public function getIconPos(_arg_1:int):Point
        {
            if (this.aimIconDict[_arg_1] != undefined)
            {
                return (new Point(this.aimIconDict[_arg_1].x, this.aimIconDict[_arg_1].y));
            };
            return (null);
        }

        override public function dispose():void
        {
            var _local_1:*;
            var _local_2:Image;
            var _local_3:TextSprite;
            super.dispose();
            MsgDispatcher.remove(GameEvents.AIMS_CHANGE, this.onAimChange);
            MsgDispatcher.remove(GameEvents.SCORE_CHANGE, this.onScoreChange);
            MsgDispatcher.remove(GameEvents.STEP_CHANGE, this.onStepChange);
            MsgDispatcher.remove(GameEvents.TIME_CHANGE, this.onTimeChange);
            for (_local_1 in this.aimIconDict)
            {
                _local_2 = this.aimIconDict[_local_1];
                _local_2.removeFromParent(true);
                _local_2 = null;
                delete this.aimIconDict[_local_1];
            };
            for (_local_1 in this.aimLabelDict)
            {
                _local_3 = this.aimLabelDict[_local_1];
                _local_3.removeFromParent(true);
                _local_3 = null;
                delete this.aimLabelDict[_local_1];
            };
        }


    }
}//package com.popchan.sugar.modules.game.view
