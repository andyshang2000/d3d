//Created by Action Script Viewer - http://www.buraks.com/asv
package starling.display
{
    import __AS3__.vec.Vector;
    import starling.textures.Texture;

    public class TextSprite extends Sprite 
    {

        private var _txt:String;
        private var _textures:Vector.<Texture>;
        private var _offset:int;
        private var _queue:String;
        private var _hAlign:String = "left";
        private var _charW:int;

        public function TextSprite(_arg_1:Vector.<Texture>, _arg_2:int=0, _arg_3:String="0123456789", _arg_4:int=10)
        {
            this._textures = _arg_1;
            this._offset = _arg_2;
            this._queue = _arg_3;
            this._charW = _arg_4;
            touchable = false;
        }

        public function get hAlign():String
        {
            return (this._hAlign);
        }

        public function set hAlign(_arg_1:String):void
        {
            this._hAlign = _arg_1;
        }

        public function get text():String
        {
            return (this._txt);
        }

        public function set text(_arg_1:String):void
        {
            var _local_5:int;
            var _local_6:Image;
            this._txt = _arg_1;
            while (this.numChildren > 0)
            {
                this.removeChildAt(0, true);
            };
            var _local_2:int = _arg_1.length;
            var _local_3:Number = ((_local_2 * this._charW) + ((_local_2 - 1) * (this._offset - this._charW)));
            var _local_4:int;
            while (_local_4 < _local_2)
            {
                _local_5 = this._queue.indexOf(_arg_1.charAt(_local_4));
                _local_6 = new Image(this._textures[_local_5]);
                if (this._hAlign == "center")
                {
                    _local_6.x = ((_local_4 * this._offset) - (_local_3 * 0.5));
                }
                else
                {
                    _local_6.x = (_local_4 * this._offset);
                };
                addChild(_local_6);
                _local_4++;
            };
        }

        public function easeToTarget(_arg_1:Number, _arg_2:Number):void
        {
        }


    }
}//package starling.display
