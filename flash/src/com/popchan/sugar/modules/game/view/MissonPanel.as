//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.core.Core;
    import com.popchan.framework.manager.SoundManager;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.sugar.core.Model;
    import com.popchan.sugar.core.cfg.Config;
    import com.popchan.sugar.core.cfg.levels.LevelCO;
    import com.popchan.sugar.core.data.AimType;
    import com.popchan.sugar.modules.BasePanel3D;
    
    import flash.utils.Dictionary;
    
    import caurina.transitions.Tweener;
    
    import starling.display.Image;
    import starling.display.TextSprite;
    import starling.events.Event;
    import starling.textures.Texture;

    public class MissonPanel extends BasePanel3D 
    {

        private var aimLabelDict:Dictionary;
        private var aimIconDict:Dictionary;
        private var levelTxt:TextSprite;

        public function MissonPanel()
        {
            this.aimLabelDict = new Dictionary();
            this.aimIconDict = new Dictionary();
            super();
        }

        override public function close():void
        {
            super.close();
        }

        override public function hide():void
        {
            super.hide();
        }

        override public function init():void
        {
            var _local_1:Image = ToolKit.createImage(this, Core.texturesManager.getTexture("missionbg"));
            this.levelTxt = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("font1_"), 0, 0, 16, "0123456789/x+-", 24);
            this.levelTxt.hAlign = "center";
            this.levelTxt.x = 320;
            this.levelTxt.y = 28;
            addChild(this.levelTxt);
            this.levelTxt.text = (Model.levelModel.selectedLevel + "");
        }

        private function onBtnTouch(_arg_1:Event):void
        {
            this.close();
        }

        override public function show(data:*):void
        {
            var icon:Image;
            var key:* = undefined;
            var posX:int;
            var target:MissonPanel;
            var label:TextSprite;
            var aimArr:Array;
            var aimType:int;
            var aimValue:int;
            var aimLabel:TextSprite;
            super.show(data);
            var info:LevelCO = Config.levelConfig.getLevel(Model.levelModel.selectedLevel);
            for (key in this.aimIconDict)
            {
                icon = this.aimIconDict[key];
                icon.removeFromParent(true);
                icon = null;
                delete this.aimIconDict[key];
            };
            for (key in this.aimLabelDict)
            {
                label = this.aimLabelDict[key];
                label.removeFromParent(true);
                label = null;
                delete this.aimLabelDict[key];
            };
            posX = 0;
            if (info.aim.length == 1)
            {
                posX = 300;
            }
            else
            {
                if (info.aim.length == 2)
                {
                    posX = 240;
                }
                else
                {
                    if (info.aim.length == 3)
                    {
                        posX = 200;
                    };
                };
            };
            var i:int;
            while (i < info.aim.length)
            {
                aimArr = info.aim[i].split(",");
                aimType = int(aimArr[0]);
                aimValue = int(aimArr[1]);
                icon = new Image(Texture.fromTexture(Core.texturesManager.getTexture(AimType.AIM_ICONS[aimType])));
                icon.pivotY = (icon.height >> 1);
                if (aimType != AimType.SCORE)
                {
                    icon.pivotX = (icon.width >> 1);
                    icon.scaleX = (icon.scaleY = 0.6);
                }
                else
                {
                    icon.pivotX = icon.width;
                };
                icon.x = (posX + (i * 80));
                icon.y = 117;
                this.addChild(icon);
                this.aimIconDict[aimType] = icon;
                aimLabel = ToolKit.createTextSprite(this, Core.texturesManager.getTextures("font1_"), 0, 0, 16, "0123456789/x+-");
                addChild(aimLabel);
                aimLabel.text = (aimValue + "");
                aimLabel.x = ((posX + 20) + (i * 80));
                aimLabel.y = 105;
                this.aimLabelDict[aimType] = aimLabel;
                i = (i + 1);
            };
            this.x = 0;
            this.y = -200;
            target = this;
            Tweener.addCaller(this, {
                "time":0.1,
                "delay":1,
                "count":1,
                "onComplete":function ():void
                {
                    SoundManager.instance.playSound("boxmove", false);
                }
            });
            Tweener.addCaller(this, {
                "time":0.1,
                "delay":2.7,
                "count":1,
                "onComplete":function ():void
                {
                    SoundManager.instance.playSound("boxmove", false);
                }
            });
            Tweener.addTween(this, {
                "time":0.6,
                "delay":1,
                "y":((Core.stage3DManager.canvasHeight - this.height) >> 1),
                "transition":"easeOutBack",
                "onComplete":function ():void
                {
                    Tweener.addTween(target, {
                        "time":0.6,
                        "delay":1,
                        "y":-200,
                        "transition":"easeInBack",
                        "onComplete":function ():void
                        {
                            close();
                        }
                    });
                }
            });
        }

        override public function updateData(_arg_1:*):void
        {
            super.updateData(_arg_1);
        }


    }
}//package com.popchan.sugar.modules.game.view
