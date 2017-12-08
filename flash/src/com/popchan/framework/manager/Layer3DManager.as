//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.framework.manager
{
    import com.popchan.framework.ds.Dict;
    import starling.core.Starling;
    import starling.display.Sprite;
    import com.popchan.framework.core.Core;
    import starling.display.DisplayObject;

    public class Layer3DManager 
    {

        public static const MAP_BACK:String = "MAP_BACK";
        public static const CLICK_LAYER:String = "CLICK_LAYER";
        public static const ELEMENT:String = "ELEMENT";
        public static const MAP_FRONT:String = "MAP_FRONT";
        public static const FAKE_SCENE:String = "FAKE_SCENE";
        public static const UI:String = "UI";
        public static const WINDOW:String = "WINDOW";
        public static const PUPOP:String = "PUPOP";
        public static const DIALOG:String = "DIALOG";
        public static const PROGRESS:String = "PROGRESS";
        public static const BROADCAST:String = "BROADCAST";
        public static const RIGHTLIST:String = "RIGHTLIST";
        public static const TIP:String = "TIP";
        public static const DRAG:String = "DRAG";
        public static const ALERT:String = "ALERT";
        public static const BARRAGE:String = "BARRAGE";
        public static const VERY_FRONT:String = "VERY_FRONT";
        public static const DEBUG:String = "DEBUG";
        public static const DEFAULT_ORDER:Array = [MAP_BACK, ELEMENT, MAP_FRONT, CLICK_LAYER, FAKE_SCENE, UI, WINDOW, PUPOP, DIALOG, PROGRESS, BROADCAST, RIGHTLIST, TIP, DRAG, BARRAGE, ALERT, VERY_FRONT, DEBUG];

        private var _dict:Dict;

        public function Layer3DManager()
        {
            this._dict = new Dict();
        }

        public function setup():void
        {
            if (((Starling.current) && (Starling.current.stage)))
            {
                this.setOrder(DEFAULT_ORDER);
                this.take(ELEMENT).touchable = false;
                this.take(BROADCAST).touchable = false;
                this.take(BROADCAST).touchable = false;
                this.take(MAP_FRONT).touchable = false;
                this.take(UI).touchable = false;
                this.take(ALERT).touchable = false;
                this.take(BROADCAST).touchable = false;
                this.take(RIGHTLIST).touchable = false;
                this.take(PUPOP).touchable = false;
                this.take(PROGRESS).touchable = false;
            };
        }

        public function setOrder(_arg_1:Array):void
        {
            var _local_2:Sprite;
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (!this.contains(_arg_1[_local_3]))
                {
                    this.put(_arg_1[_local_3]);
                };
                _local_2 = this.take(_arg_1[_local_3]);
                Core.stage3DManager.canvas.setChildIndex(_local_2, _local_3);
                _local_3++;
            };
        }

        public function put(_arg_1:String):void
        {
            var _local_2:Sprite = new Sprite();
            this._dict.put(_arg_1, _local_2);
            Core.stage3DManager.canvas.addChild(_local_2);
        }

        public function take(_arg_1:String):Sprite
        {
            return (this._dict.take(_arg_1));
        }

        public function contains(_arg_1:String):Boolean
        {
            return (this._dict.contains(_arg_1));
        }

        public function addChild(_arg_1:DisplayObject, _arg_2:String):void
        {
            var _local_3:Sprite;
            _local_3 = this._dict.take(_arg_2);
            _local_3.addChild(_arg_1);
        }

        public function removeChild(_arg_1:DisplayObject, _arg_2:String):void
        {
            var _local_3:Sprite;
            _local_3 = this._dict.take(_arg_2);
            if (_local_3.contains(_arg_1))
            {
                _local_3.removeChild(_arg_1);
            };
        }

        public function removeLayer(_arg_1:String):void
        {
            var _local_2:Sprite;
            _local_2 = this._dict.take(_arg_1);
            if (this.contains(_arg_1))
            {
                Core.stage3DManager.canvas.removeChild(_local_2);
            };
        }

        public function addLayer(_arg_1:String):void
        {
            var _local_2:Sprite;
            _local_2 = this._dict.take(_arg_1);
            var _local_3:int = DEFAULT_ORDER.indexOf(_arg_1);
            Core.stage3DManager.canvas.addChildAt(_local_2, _local_3);
        }


    }
}//package com.popchan.framework.manager
