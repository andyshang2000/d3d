//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.end.view
{
    import com.popchan.framework.core.Core;
    import com.popchan.framework.core.MsgDispatcher;
    import com.popchan.framework.manager.SoundManager;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.sugar.core.Model;
    import com.popchan.sugar.core.cfg.Config;
    import com.popchan.sugar.core.cfg.LevelConfig;
    import com.popchan.sugar.core.cfg.levels.LevelCO;
    import com.popchan.sugar.core.events.GameEvents;
    import com.popchan.sugar.core.manager.WindowManager3D;
    import com.popchan.sugar.modules.BasePanel3D;
    import com.popchan.sugar.modules.map.vo.LevelVO;
    
    import flash.utils.clearInterval;
    import flash.utils.setInterval;
    import flash.utils.setTimeout;
    
    import caurina.transitions.Tweener;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    public class GameEndPanel extends BasePanel3D 
    {
        private var node:Sprite;
        private var close_btn:Button;
        private var next_btn:Button;
        private var replay2_btn:Button;
        private var success:Image;
        private var failed:Image;
        private var scrollDelta:int;
        private var score:int;
        private var goldDelta:int;
        private var gold:int;
        private var getGold:int;
        private var starSoundIndex:int;
        private var scoreIntervalID:int;
        private var goldIntervalID:int;
        private var scoreLabel:TextField;
        private var highscoreLabel:TextField;
        private var goldLabel:TextField;

        public function GameEndPanel()
        {
            var getStar:int;
            var cfg:LevelCO;
            var i:int;
            var levelVO:LevelVO;
            var bigstar:Image;
            super();
            this.node = new Sprite();
            addChild(this.node);
            ToolKit.createImage(this.node, Core.texturesManager.getTexture("endPanel"), 0, 0);
            ToolKit.createImage(this.node, Core.texturesManager.getTexture("endscoreinfo"), 86, 216);
            this.success = ToolKit.createImage(this.node, Core.texturesManager.getTexture("success"), 165, 5);
            this.failed = ToolKit.createImage(this.node, Core.texturesManager.getTexture("failed"), 165, 5);
            this.next_btn = ToolKit.createButton(this.node, Core.texturesManager.getTexture("next_btn"), 177, 436, this.onBtnTouch);
            this.close_btn = ToolKit.createButton(this.node, Core.texturesManager.getTexture("close_btn"), 452, 24, this.onBtnTouch);
            this.replay2_btn = ToolKit.createButton(this.node, Core.texturesManager.getTexture("replay2_btn"), 177, 436, this.onBtnTouch);
            this.node.pivotX = 267;
            this.node.pivotY = 564;
            this.node.x = (Core.stage3DManager.canvasWidth >> 1);
            Tweener.addTween(this.node, {
                "time":0.3,
                "y":680,
                "transition":"easeOutBack"
            });
            Tweener.addTween(this.node, {
                "time":0.2,
                "delay":0.25,
                "scaleX":1.1,
                "scaleY":0.9,
                "onComplete":this.doUiAnimationEnd1,
                "transition":"linear"
            });
            this.scoreLabel = new TextField(200, 50, "");
            this.scoreLabel.x = 240;
            this.scoreLabel.y = 230;
            this.node.addChild(this.scoreLabel);
            this.goldLabel = new TextField(200, 50, "");
            this.goldLabel.x = 250;
            this.goldLabel.y = 313;
            this.node.addChild(this.goldLabel);
            this.highscoreLabel = new TextField(200, 50, "");
            this.highscoreLabel.x = 240;
            this.highscoreLabel.y = 314;
            this.node.addChild(this.highscoreLabel);
            if (Model.gameModel.score > Model.gameModel.highScore)
            {
                Model.gameModel.highScore = Model.gameModel.score;
            };
            this.highscoreLabel.text = (Model.gameModel.highScore + "");
            if (Model.gameModel.isSuccess)
            {
                SoundManager.instance.playSound("game_win");
                getStar = 0;
                cfg = Config.levelConfig.getLevel(Model.levelModel.selectedLevel);
                if (Model.gameModel.score >= (cfg.needScore * 6))
                {
                    getStar = 3;
                }
                else
                {
                    if (Model.gameModel.score >= (cfg.needScore * 3))
                    {
                        getStar = 2;
                    }
                    else
                    {
                        if (Model.gameModel.score >= cfg.needScore)
                        {
                            getStar = 1;
                        };
                    };
                };
                i = 0;
                while (i < getStar)
                {
                    bigstar = ToolKit.createImage(this.node, Core.texturesManager.getTexture("bigstar"), 91, -65);
                    bigstar.x = (167 + (i * 97));
                    bigstar.y = 131;
                    bigstar.scaleX = (bigstar.scaleY = 4);
                    bigstar.alpha = 0;
                    bigstar.pivotX = (78 >> 1);
                    bigstar.pivotY = (76 >> 1);
                    Tweener.addTween(bigstar, {
                        "delay":((i * 0.3) + 0.8),
                        "time":0.5,
                        "scaleX":1,
                        "scaleY":1,
                        "transition":"easeOutBack"
                    });
                    Tweener.addTween(bigstar, {
                        "delay":((i * 0.3) + 0.8),
                        "time":0.3,
                        "alpha":1,
                        "onCompleteParams":[bigstar],
                        "onComplete":function (_arg_1:Image):void
                        {
                        }
                    });
                    i = (i + 1);
                };
                this.success.visible = true;
                this.failed.visible = false;
                this.replay2_btn.visible = false;
                if (Model.levelModel.currentLevel == Model.levelModel.selectedLevel)
                {
                    Model.levelModel.currentLevel++;
                    if (Model.levelModel.currentLevel > Model.levelModel.totalLevel)
                    {
                        Model.levelModel.currentLevel = Model.levelModel.totalLevel;
                    };
                };
                levelVO = Model.levelModel.getLevelVO(Model.levelModel.selectedLevel);
                levelVO.star = getStar;
                levelVO.highscore = Model.gameModel.highScore;
            }
            else
            {
                this.success.visible = false;
                this.failed.visible = true;
                this.next_btn.visible = false;
                this.getGold = 0;
                SoundManager.instance.playSound("fail1");
            };
            setTimeout(this.delayToScroll, 400);
            this.starSoundIndex = 0;
            Model.levelModel.saveData();
        }

        override public function show(_arg_1:*):void
        {
            super.show(_arg_1);
        }

        private function onBtnTouch(_arg_1:Event):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_2:Button = (_arg_1.currentTarget as Button);
            SoundManager.instance.playSound("button_down", false);
            if (_local_2 == this.close_btn)
            {
                WindowManager3D.getInstance().removeAll();
//                MsgDispatcher.execute(GameEvents.OPEN_MAP_UI);
            }
            else
            {
                if (_local_2 == this.replay2_btn)
                {
                    WindowManager3D.getInstance().removeAll();
                    MsgDispatcher.execute(GameEvents.OPEN_GAME_UI);
                }
                else
                {
                    if (_local_2 == this.next_btn)
                    {
                        _local_3 = Model.levelModel.currentLevel;
                        _local_4 = Model.levelModel.selectedLevel;
                        WindowManager3D.getInstance().removeAll();
                        Model.levelModel.selectedLevel = Math.min((Model.levelModel.selectedLevel + 1), LevelConfig.TOTAL_LEVEL);
                        MsgDispatcher.execute(GameEvents.OPEN_GAME_UI);
                    };
                };
            };
        }

        private function delayToScroll():void
        {
            this.scrollDelta = (Model.gameModel.score / 60);
            if (this.scrollDelta == 0)
            {
                this.scrollDelta = 1;
            };
            this.scoreIntervalID = setInterval(this.scoreScroll, 16);
            this.score = 0;
            if (this.getGold > 0)
            {
                this.goldDelta = (this.getGold / 60);
                if (this.goldDelta == 0)
                {
                    this.goldDelta = 1;
                };
                this.goldIntervalID = setInterval(this.goldScroll, 16);
                this.gold = 0;
            };
        }

        private function scoreScroll():void
        {
            this.score = (this.score + this.scrollDelta);
            if (this.score >= Model.gameModel.score)
            {
                this.score = Model.gameModel.score;
                clearInterval(this.scoreIntervalID);
            };
            this.scoreLabel.text = (this.score + "");
        }

        private function goldScroll():void
        {
            this.gold = (this.gold + this.goldDelta);
            if (this.gold >= this.getGold)
            {
                this.gold = this.getGold;
                clearInterval(this.goldIntervalID);
            };
            this.goldLabel.text = (this.gold + "");
        }

        private function restartGame():void
        {
        }

        private function back():void
        {
        }

        private function doUiAnimationEnd1():void
        {
            Tweener.addTween(this.node, {
                "time":1,
                "scaleX":1,
                "scaleY":1,
                "transition":"easeOutElastic"
            });
        }


    }
}//package com.popchan.sugar.modules.end.view
