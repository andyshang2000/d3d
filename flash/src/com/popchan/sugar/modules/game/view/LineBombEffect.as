//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import caurina.transitions.Tweener;

    public class LineBombEffect extends Element 
    {

        public static var pool:BasePool = new BasePool(LineBombEffect, 10);

        private var img1:Image;
        private var img2:Image;

        public function LineBombEffect()
        {
            this.img1 = ToolKit.createImage(this, Core.getTexture("hengshu"));
            this.img1.pivotX = (this.img1.width >> 1);
            this.img1.pivotY = (this.img1.height >> 1);
            this.img2 = ToolKit.createImage(this, Core.getTexture("hengshu"));
            this.img2.pivotX = (this.img2.width >> 1);
            this.img2.pivotY = (this.img2.height >> 1);
        }

        public function play(type:int):void
        {
            var t1:Number;
            var t2:Number;
            var t:Number;
            this.img1.x = (this.img2.x = 0);
            this.img1.y = (this.img2.y = 0);
            this.img1.visible = (this.img2.visible = true);
            this.img1.scaleX = (this.img1.scaleY = 1);
            if (type == 1)
            {
                this.img1.rotation = 0;
                this.img1.pivotX = this.img1.width;
                this.img2.rotation = 0;
                this.img2.pivotX = 0;
                this.img1.scaleX = (this.img2.scaleX = 0.2);
                this.img1.scaleY = (this.img2.scaleY = 0.7);
                t1 = Math.abs(((-(x) - this.img1.width) * 0.001));
                Tweener.addTween(this.img1, {
                    "time":t1,
                    "scaleX":2.5,
                    "transition":"linear",
                    "onComplete":function ():void
                    {
                        img1.visible = false;
                    }
                });
                t2 = Math.abs((((Core.stage3DManager.canvasWidth + 100) - x) * 0.001));
                Tweener.addTween(this.img2, {
                    "time":t2,
                    "scaleX":2.5,
                    "transition":"linear",
                    "onComplete":function ():void
                    {
                        img2.visible = false;
                    }
                });
                t = Math.max(t1, t2);
                Tweener.addCaller(this, {
                    "count":1,
                    "time":t,
                    "onComplete":this.onActionEnd
                });
            }
            else
            {
                this.img1.rotation = (-(Math.PI) / 2);
                this.img1.pivotX = 0;
                this.img2.rotation = (Math.PI / 2);
                this.img2.pivotX = 0;
                this.img1.scaleX = (this.img2.scaleX = 0.2);
                this.img1.scaleY = (this.img2.scaleY = 0.7);
                t1 = (Math.abs((0 - y)) * 0.001);
                Tweener.addTween(this.img1, {
                    "time":(t1 * 0.5),
                    "scaleX":2.5,
                    "transition":"linear",
                    "onComplete":function ():void
                    {
                        img1.visible = false;
                    }
                });
                t2 = ((Core.stage3DManager.canvasHeight - y) * 0.001);
                Tweener.addTween(this.img2, {
                    "time":(t2 * 0.5),
                    "scaleX":2.5,
                    "transition":"linear",
                    "onComplete":function ():void
                    {
                        img2.visible = false;
                    }
                });
                t = Math.max(t1, t2);
                Tweener.addCaller(this, {
                    "count":1,
                    "time":t,
                    "onComplete":this.onActionEnd
                });
            };
        }

        private function onActionEnd():void
        {
            this.removeFromParent();
            pool.put(this);
        }


    }
}//package com.popchan.sugar.modules.game.view
