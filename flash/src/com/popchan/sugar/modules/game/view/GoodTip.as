//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import starling.display.Image;
    import com.popchan.framework.manager.SoundManager;
    import caurina.transitions.Tweener;

    public class GoodTip extends Element 
    {

        public static var pool:BasePool = new BasePool(GoodTip, 3);

        private var tips:Array;

        public function GoodTip()
        {
            this.tips = [null];
            this.tips.push(ToolKit.createImage(this, Core.getTexture("good"), 0, 0, true));
            this.tips.push(ToolKit.createImage(this, Core.getTexture("excellent"), 0, 0, true));
            this.tips.push(ToolKit.createImage(this, Core.getTexture("prefect"), 0, 0, true));
        }

        public function setType(_arg_1:int):void
        {
            var _local_2:Image;
            SoundManager.instance.playSound("great");
            for each (_local_2 in this.tips)
            {
                if (_local_2 != null)
                {
                    _local_2.visible = false;
                };
            };
            this.tips[_arg_1].visible = true;
            this.doAction();
        }

        private function doAction():void
        {
            this.scaleX = (this.scaleY = 0);
            Tweener.addTween(this, {
                "time":0.4,
                "scaleX":1,
                "scaleY":1,
                "transition":"easeBackout"
            });
            Tweener.addTween(this, {
                "time":1,
                "delay":0.2,
                "onComplete":this.onActionEnd,
                "transition":"linear"
            });
            Tweener.addTween(this, {
                "time":0.6,
                "delay":0.4,
                "y":(y - 80),
                "transition":"linear"
            });
        }

        private function onActionEnd():void
        {
            Tweener.removeTweens(this);
            pool.put(this);
            this.removeFromParent();
        }


    }
}//package com.popchan.sugar.modules.game.view
