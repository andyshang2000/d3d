//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import com.popchan.framework.manager.SoundManager;
    import caurina.transitions.Tweener;

    public class Eat extends Element 
    {

        public static var pool:BasePool = new BasePool(Eat, 10);

        public var row:int;
        public var col:int;
        private var _vx:Number;
        private var _vr:Number;
        private var _vy:Number;
        private var _count:int;

        public function Eat()
        {
            ToolKit.createImage(this, Core.getTexture("eat"), 0, 0, true);
        }

        public function doAnimation():void
        {
            var _local_1:int = -1;
            if (this.col >= 4)
            {
                _local_1 = 1;
            };
            this._vx = 3;
            this._vr = 0.1;
            if (_local_1 == -1)
            {
                this._vx = -3;
                this._vr = -0.1;
            };
            this._count = 0;
            this._vy = (Math.random() * -4);
            Core.timerManager.add(this, this.update, 16);
            SoundManager.instance.playSound("brickthrow");
        }

        public function zoom():void
        {
        }

        public function zoomOutIn():void
        {
            var t:Eat;
            t = this;
            Tweener.addTween(this, {
                "time":0.1,
                "scaleX":0,
                "scaleY":0,
                "transition":"linear",
                "onComplete":function ():void
                {
                    Tweener.addTween(t, {
                        "time":0.1,
                        "scaleX":1,
                        "scaleY":1,
                        "transition":"linear"
                    });
                }
            });
        }

        public function zoomIn():void
        {
            this.scaleX = 0;
            this.scaleY = 0;
            Tweener.addTween(this, {
                "time":0.2,
                "scaleX":1,
                "scaleY":1,
                "transition":"linear"
            });
        }

        private function update():void
        {
            x = (x + this._vx);
            y = (y + this._vy);
            this._vy = (this._vy + 0.5);
            rotation = (rotation + this._vr);
            this._count++;
            if (this._count > 60)
            {
                Core.timerManager.remove(this, this.update);
                pool.put(this);
                this.removeFromParent();
            };
        }

        override public function reset():void
        {
            rotation = 0;
        }


    }
}//package com.popchan.sugar.modules.game.view
