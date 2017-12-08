//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.framework.manager
{
    import com.popchan.framework.core.Core;
    
    import flash.display.Stage;
    import flash.geom.Rectangle;
    
    import fairygui.GRoot;
    
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;

    public class Stage3DManager 
    {

        private var _stage:Stage;
        private var _canvas:Sprite;
        private var _canvasRect:Rectangle;
        private var _resizeRect:Rectangle;

        public function Stage3DManager()
        {
            this._canvas = new Sprite();
            this._canvasRect = new Rectangle();
            super();
        }

        public function setup(_arg_1:Stage, _arg_2:Rectangle=null):void
        {
            this._stage = _arg_1;
            if (((Starling.current) && (Starling.current.stage)))
            {
                Starling.current.stage.addChildAt(this._canvas, 0);
                Starling.current.stage.addEventListener(Event.RESIZE, this.resize);
                if (_arg_2)
                {
                    this._resizeRect = _arg_2;
                };
                this.resize();
            };
        }

        private function onResize(_arg_1:Event):void
        {
            this.resize();
        }

        private function resize():void
        {
            var _local_1:int;
            var _local_2:int;
            if (this.stageWidth >= this._resizeRect.width)
            {
                _local_1 = this._resizeRect.width;
            }
            else
            {
                if (this.stageWidth <= this._resizeRect.x)
                {
                    _local_1 = this._resizeRect.x;
                }
                else
                {
                    _local_1 = this.stageWidth;
                };
            };
            if (this.stageHeight >= this._resizeRect.height)
            {
                _local_2 = this._resizeRect.height;
            }
            else
            {
                if (this.stageHeight <= this._resizeRect.y)
                {
                    _local_2 = this._resizeRect.y;
                }
                else
                {
                    _local_2 = this.stageHeight;
                };
            };
            if (this._canvasRect.width != _local_1)
            {
                this._canvasRect.width = _local_1;
            };
            if (this._canvasRect.height != _local_2)
            {
                this._canvasRect.height = _local_2;
            };
            if (this.stageWidth > _local_1)
            {
                this._canvasRect.x = ((this.stageWidth - _local_1) >> 1);
            }
            else
            {
                this._canvasRect.x = 0;
            };
            if (this.stageHeight > _local_2)
            {
                this._canvasRect.y = ((this.stageHeight - _local_2) >> 1);
            }
            else
            {
                this._canvasRect.y = 0;
            };
        }

        public function get stage():Stage
        {
            return (this._stage);
        }

        public function get stageWidth():int
        {
            return (this._stage.stageWidth);
        }

        public function get stageHeight():int
        {
            return (this._stage.stageHeight);
        }

        public function get canvas():Sprite
        {
            return (this._canvas);
        }

        public function get canvasRect():Rectangle
        {
            return (this._canvasRect);
        }

        public function get canvasX():Number
        {
            return (this._canvasRect.x);
        }

        public function get canvasY():Number
        {
            return (this._canvasRect.y);
        }

        public function get canvasWidth():Number
        {
            return (_canvasRect.width);
        }

        public function get canvasHeight():Number
        {
            return (_canvasRect.height)
        }


    }
}//package com.popchan.framework.manager
