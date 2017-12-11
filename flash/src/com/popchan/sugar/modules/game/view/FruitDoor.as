//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.core.Core;
    import com.popchan.framework.ds.BasePool;
    
    import fairygui.GImage;

    public class FruitDoor extends XImage 
    {
        public static var pool:BasePool = new BasePool(FruitDoor, 20);

        public function FruitDoor()
        {
            texture2 = ("downP");
        }
    }
}//package com.popchan.sugar.modules.game.view
