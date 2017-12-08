//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;

    public class IronWire extends Element 
    {

        public static var pool:BasePool = new BasePool(IronWire, 20);

        public var row:int;
        public var col:int;
        private var _dir:int;
        private var img1:Image;
        private var img2:Image;

        public function IronWire()
        {
            this.img1 = ToolKit.createImage(this, Core.texturesManager.getTexture("ironWire"), -37, -24);
            this.img2 = ToolKit.createImage(this, Core.texturesManager.getTexture("ironWire2"), -32, 30);
        }

        public function get dir():int
        {
            return (this._dir);
        }

        public function set dir(_arg_1:int):void
        {
            this._dir = _arg_1;
            this.img1.visible = (_arg_1 == 1);
            this.img2.visible = (_arg_1 == 2);
        }


    }
}//package com.popchan.sugar.modules.game.view
