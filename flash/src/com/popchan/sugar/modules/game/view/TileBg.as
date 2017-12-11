//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.Image;
    import starling.textures.Texture;
    import com.popchan.framework.core.Core;

    public class TileBg extends Element 
    {

        public static var pool:BasePool = new BasePool(TileBg, 81);

        public function TileBg()
        {
            var _local_1:Image = new Image(Texture.fromTexture(Core.getTexture("cube")));
            _local_1.pivotX = (_local_1.width >> 1);
            _local_1.pivotY = (_local_1.height >> 1);
            this.addChild(_local_1);
        }

        override public function reset():void
        {
        }


    }
}//package com.popchan.sugar.modules.game.view
