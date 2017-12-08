//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
    import com.popchan.framework.ds.BasePool;
    import starling.display.CMovieClip;
    import com.popchan.framework.utils.ToolKit;
    import com.popchan.framework.core.Core;
    import com.popchan.sugar.core.data.TileConst;

    public class TransportDoor extends Element 
    {

        public static var pool:BasePool = new BasePool(TransportDoor, 10);

        private var animation:CMovieClip;
        private var _tileID:int;
        public var row:int;
        public var col:int;

        public function TransportDoor()
        {
            this.animation = ToolKit.createMovieClip(this, Core.texturesManager.getTextures("chuansong_"));
            this.animation.frameRate = 5;
            this.animation.loops = -1;
        }

        public function start():void
        {
            this.animation.gotoAndPlay(1);
        }

        public function get tileID():int
        {
            return (this._tileID);
        }

        public function set tileID(_arg_1:int):void
        {
            this._tileID = _arg_1;
            if ((((_arg_1 >= TileConst.T_DOOR_ENTRY1)) && ((_arg_1 <= TileConst.T_DOOR_ENTRY9))))
            {
                this.animation.y = 30;
            }
            else
            {
                if ((((_arg_1 >= TileConst.T_DOOR_EXIT1)) && ((_arg_1 <= TileConst.T_DOOR_EXIT9))))
                {
                    this.animation.y = -30;
                };
            };
        }

        override public function dispose():void
        {
        }


    }
}//package com.popchan.sugar.modules.game.view
