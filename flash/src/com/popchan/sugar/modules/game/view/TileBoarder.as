//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import flash.utils.Dictionary;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import starling.display.Sprite;

    public class TileBoarder extends Element 
    {

        public static var pool:BasePool = new BasePool(TileBoarder, 100);
        public static const x_border_heng_shang:int = 1;
        public static const x_border_heng_xia:int = 2;
        public static const x_border_left_down:int = 3;
        public static const x_border_left_down_x:int = 4;
        public static const x_border_left_up:int = 5;
        public static const x_border_left_up_x:int = 6;
        public static const x_border_right_down:int = 7;
        public static const x_border_right_down_x:int = 8;
        public static const x_border_right_up:int = 9;
        public static const x_border_right_up_x:int = 10;
        public static const x_border_shu_you:int = 11;
        public static const x_border_shu_zuo:int = 12;

        private var resDict:Dictionary;

        public function TileBoarder()
        {
            this.resDict = new Dictionary();
            super();
            this.resDict[1] = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_heng_shang"));
            this.resDict[2] = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_heng_xia"));
            this.resDict[3] = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_left_down"));
            this.resDict[4] = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_left_down_x"));
            this.resDict[5] = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_left_up"));
            this.resDict[6] = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_left_up_x"));
            this.resDict[7] = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_right_down"));
            this.resDict[8] = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_right_down_x"));
            this.resDict[9] = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_right_up"));
            this.resDict[10] = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_right_up_x"));
            this.resDict[11] = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_shu_you"));
            this.resDict[12] = ToolKit.createImage(this, Core.texturesManager.getTexture("x_border_shu_zuo"));
        }

        public function setType(_arg_1:int, _arg_2:Sprite, _arg_3:int, _arg_4:int):void
        {
            var _local_5:*;
            _arg_2.addChild(this);
            for (_local_5 in this.resDict)
            {
                this.resDict[_local_5].visible = false;
            };
            this.x = _arg_3;
            this.y = _arg_4;
            this.resDict[_arg_1].visible = true;
        }


    }
}//package com.popchan.sugar.modules.game.view
