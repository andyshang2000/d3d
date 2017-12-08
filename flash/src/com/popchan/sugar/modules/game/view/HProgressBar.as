//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import starling.display.Sprite;
    import flash.geom.Rectangle;
    import starling.display.Image;
    import starling.textures.Texture;

    public class HProgressBar extends Sprite 
    {

        private var mBar:Sprite;
        private var rect:Rectangle;
        private var barOffsetX:int;

        public function HProgressBar(_arg_1:Texture, _arg_2:Texture, _arg_3:int=0, _arg_4:int=0, _arg_5:Boolean=true)
        {
            var _local_7:Image;
            super();
            this.barOffsetX = _arg_3;
            if (_arg_1)
            {
                _local_7 = new Image(_arg_1);
                addChild(_local_7);
            };
            this.mBar = new Sprite();
            var _local_6:Image = new Image(_arg_2);
            this.mBar.x = _arg_3;
            this.mBar.y = _arg_4;
            this.mBar.addChild(_local_6);
            if (_arg_5)
            {
                addChildAt(this.mBar, 0);
            }
            else
            {
                addChild(this.mBar);
            };
            this.rect = new Rectangle(0, 0, _arg_2.width, (_arg_2.height + 50));
        }

        public function get ratio():Number
        {
            return (this.mBar.scaleX);
        }

        public function set ratio(_arg_1:Number):void
        {
            if (_arg_1 > 1)
            {
                _arg_1 = 1;
            };
            this.rect.x = (((_arg_1 - 1) * this.rect.width) + 0);
//            this.mBar.clipRect = this.rect;
        }

        override public function dispose():void
        {
            this.mBar.dispose();
            this.mBar = null;
            this.rect = null;
            removeChildren(0, -1, true);
            super.dispose();
        }


    }
}//package com.popchan.sugar.modules.game.view
