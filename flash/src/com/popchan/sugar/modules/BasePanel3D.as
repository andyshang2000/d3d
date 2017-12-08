//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules
{
    import starling.display.Sprite;
    import com.popchan.sugar.core.manager.WindowManager3D;

    public class BasePanel3D extends Sprite 
    {

        private var _winName:String;
        public var destoryAfterClose:Boolean = true;


        public function get winName():String
        {
            return (this._winName);
        }

        public function set winName(_arg_1:String):void
        {
            this._winName = _arg_1;
        }

        public function init():void
        {
        }

        public function show(_arg_1:*):void
        {
        }

        public function hide():void
        {
        }

        public function updateData(_arg_1:*):void
        {
        }

        public function close():void
        {
            WindowManager3D.getInstance().removeWindow(this.winName);
        }

        public function destory():void
        {
        }


    }
}//package com.popchan.sugar.modules
