//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import starling.display.Sprite;
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;

    public class Stone extends Sprite 
    {

        public static var pool:BasePool = new BasePool(Stone, 20);

        public var row:int;
        public var col:int;
        private var stone1:Image;
        private var stone2:Image;
        private var _life:int;
        private var _tileID:int;

        public function Stone()
        {
            this.stone2 = ToolKit.createImage(this, Core.texturesManager.getTexture("stone1"), 0, 0, true);
            this.stone1 = ToolKit.createImage(this, Core.texturesManager.getTexture("stone2"), 0, 0, true);
        }

        public function get tileID():int
        {
            return (this._tileID);
        }

        public function set tileID(_arg_1:int):void
        {
            this._tileID = _arg_1;
            this.setLife(2);
        }

        public function get life():int
        {
            return (this._life);
        }

        public function setLife(_arg_1:int, _arg_2:Boolean=false):void
        {
            var _local_3:IceBombEffect;
            this._life = _arg_1;
            if (this._life == 2)
            {
                this.stone1.visible = false;
                this.stone2.visible = true;
            }
            else
            {
                if (this._life == 1)
                {
                    this.stone1.visible = true;
                    this.stone2.visible = false;
                };
            };
            if (_arg_2)
            {
                _local_3 = new IceBombEffect();
                _local_3.play();
                this.parent.addChild(_local_3);
                _local_3.x = x;
                _local_3.y = y;
            };
        }


    }
}//package com.popchan.sugar.modules.game.view
