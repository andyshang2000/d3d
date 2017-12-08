//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import starling.display.Image;

    public class RayEffect extends Element 
    {

        public static var pool:BasePool = new BasePool(RayEffect, 20);

        public function RayEffect()
        {
            var _local_1:Image = ToolKit.createImage(this, Core.texturesManager.getTexture("sun"), 0, 0, true);
        }

    }
}//package com.popchan.sugar.modules.game.view
