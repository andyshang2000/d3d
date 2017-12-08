//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.CMovieClip;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import starling.events.Event;

    public class BombNormalEffect extends Element 
    {

        public static var pool:BasePool = new BasePool(BombNormalEffect, 10);

        private var animation:CMovieClip;

        public function BombNormalEffect()
        {
            this.animation = ToolKit.createMovieClip(this, Core.texturesManager.getTextures("boomcommon_"));
            this.animation.frameRate = 10;
            this.animation.loops = 1;
            this.animation.scaleX = (this.animation.scaleY = 1.5);
        }

        public function play():void
        {
            this.animation.addEventListener(Event.COMPLETE, this.onAnimationEnd);
            this.animation.gotoAndPlay(1);
        }

        private function onAnimationEnd(_arg_1:Event):void
        {
            this.animation.removeEventListener(Event.COMPLETE, this.onAnimationEnd);
            this.removeFromParent();
            pool.put(this);
        }


    }
}//package com.popchan.sugar.modules.game.view
