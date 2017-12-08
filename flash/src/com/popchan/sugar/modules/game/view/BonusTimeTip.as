//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import starling.display.Sprite;
    import com.popchan.framework.ds.BasePool;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import com.popchan.framework.manager.SoundManager;
    import caurina.transitions.Tweener;

    public class BonusTimeTip extends Sprite 
    {

        public static var pool:BasePool = new BasePool(BonusTimeTip, 10);

        public function BonusTimeTip()
        {
            ToolKit.createImage(this, Core.texturesManager.getTexture("bonustime"), 0, 0, true);
        }

        public function doAniamtion():void
        {
            var ins:BonusTimeTip;
            y = ((Core.stage3DManager.canvasHeight >> 1) + 40);
            x = -100;
            ins = this;
            SoundManager.instance.playSound("finaltry");
            Tweener.addTween(ins, {
                "x":(Core.stage3DManager.canvasWidth >> 1),
                "time":0.4,
                "transition":"easeOutBack",
                "onComplete":function ():void
                {
                    Tweener.addTween(ins, {
                        "x":(Core.stage3DManager.canvasWidth + 100),
                        "time":0.4,
                        "delay":0.4,
                        "transition":"easeInBack",
                        "onComplete":function ():void
                        {
                            ins.removeFromParent();
                            pool.put(ins);
                        }
                    });
                }
            });
        }


    }
}//package com.popchan.sugar.modules.game.view
