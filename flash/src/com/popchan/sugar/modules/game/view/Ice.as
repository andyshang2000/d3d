//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import com.popchan.sugar.core.data.TileConst;

    public class Ice extends Element 
    {

        public static var pool:BasePool = new BasePool(Ice, 20);

        public var row:int;
        public var col:int;
        private var ice1:Image;
        private var ice2:Image;
        private var ice3:Image;
        private var _life:int;
        private var _tileID:int;

        public function Ice()
        {
            this.ice1 = ToolKit.createImage(this, Core.texturesManager.getTexture("sprite2"), 0, 0, true);
            this.ice2 = ToolKit.createImage(this, Core.texturesManager.getTexture("spritemid"), 0, 0, true);
            this.ice3 = ToolKit.createImage(this, Core.texturesManager.getTexture("sprite1"), 0, 0, true);
            this.ice1.scaleX = (this.ice1.scaleY = 1.2);
            this.ice2.scaleX = (this.ice2.scaleY = 1.2);
            this.ice3.scaleX = (this.ice3.scaleY = 1.2);
        }

        public function get tileID():int
        {
            return (this._tileID);
        }

        public function set tileID(_arg_1:int):void
        {
            this._tileID = _arg_1;
            if (_arg_1 == TileConst.ICE1)
            {
                this.setLife(1);
            }
            else
            {
                if (_arg_1 == TileConst.ICE2)
                {
                    this.setLife(2);
                }
                else
                {
                    if (_arg_1 == TileConst.ICE3)
                    {
                        this.setLife(3);
                    };
                };
            };
        }

        public function get life():int
        {
            return (this._life);
        }

        public function setLife(_arg_1:int, _arg_2:Boolean=false):void
        {
            var _local_3:IceBombEffect;
            this._life = _arg_1;
            if (this._life == 3)
            {
                this.ice1.visible = false;
                this.ice2.visible = false;
                this.ice3.visible = true;
            }
            else
            {
                if (this._life == 2)
                {
                    this.ice1.visible = false;
                    this.ice2.visible = true;
                    this.ice3.visible = false;
                }
                else
                {
                    if (this._life == 1)
                    {
                        this.ice1.visible = true;
                        this.ice2.visible = false;
                        this.ice3.visible = false;
                    };
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
