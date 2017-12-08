//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;

    public class LaserEffect extends Element 
    {

        public static var pool:BasePool = new BasePool(LaserEffect, 20);

        private var suns:Array;

        public function LaserEffect()
        {
            var _local_2:Image;
            super();
            this.suns = [];
            var _local_1:int;
            while (_local_1 < 6)
            {
                _local_2 = ToolKit.createImage(this, Core.texturesManager.getTexture("sun"));
                addChild(_local_2);
                this.suns.push(_local_2);
                _local_1++;
            };
        }

        public function setData(_arg_1:Number):void
        {
            var _local_3:Image;
            var _local_4:Number;
            var _local_5:Number;
            var _local_2:int;
            while (_local_2 < 6)
            {
                _local_3 = this.suns[_local_2];
                _local_3.scaleX = (0.6 - (_local_2 * 0.05));
                _local_3.scaleY = (0.6 - (_local_2 * 0.05));
                _local_3.pivotX = (_local_3.width >> 1);
                _local_3.pivotY = (_local_3.height >> 1);
                _local_4 = ((Math.cos((Math.PI + _arg_1)) * _local_2) * 20);
                _local_5 = ((Math.sin((Math.PI + _arg_1)) * _local_2) * 20);
                _local_3.x = _local_4;
                _local_3.y = _local_5;
                this.suns.push(_local_3);
                _local_2++;
            };
        }


    }
}//package com.popchan.sugar.modules.game.view
