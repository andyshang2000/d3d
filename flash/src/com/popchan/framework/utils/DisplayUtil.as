//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.framework.utils
{
    import flash.events.MouseEvent;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.ColorTransform;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    import flash.display.PixelSnapping;
    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import flash.display.Graphics;
    import flash.filters.ColorMatrixFilter;

    public class DisplayUtil 
    {

        private static const MOUSE_EVENT_LIST:Array = [MouseEvent.CLICK, MouseEvent.DOUBLE_CLICK, MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_MOVE, MouseEvent.MOUSE_OUT, MouseEvent.MOUSE_OVER, MouseEvent.MOUSE_UP, MouseEvent.MOUSE_WHEEL, MouseEvent.ROLL_OUT, MouseEvent.ROLL_OVER];

        private var indexNum:int = 0;


        public static function stopAllMovieClip(_arg_1:DisplayObjectContainer, _arg_2:uint=0):void
        {
            var _local_3:DisplayObjectContainer;
            var _local_4:MovieClip = (_arg_1 as MovieClip);
            if (_local_4 != null)
            {
                if (_arg_2 != 0)
                {
                    _local_4.gotoAndStop(_arg_2);
                }
                else
                {
                    _local_4.gotoAndStop(1);
                };
                _local_4 = null;
            };
            var _local_5:int = (_arg_1.numChildren - 1);
            if (_local_5 < 0)
            {
                return;
            };
            var _local_6:int = _local_5;
            while (_local_6 >= 0)
            {
                _local_3 = (_arg_1.getChildAt(_local_6) as DisplayObjectContainer);
                if (_local_3 != null)
                {
                    stopAllMovieClip(_local_3, _arg_2);
                };
                _local_6--;
            };
        }

        public static function playAllMovieClip(_arg_1:DisplayObjectContainer):void
        {
            var _local_2:DisplayObjectContainer;
            var _local_3:MovieClip = (_arg_1 as MovieClip);
            if (_local_3 != null)
            {
                _local_3.gotoAndPlay(1);
                _local_3 = null;
            };
            var _local_4:int = (_arg_1.numChildren - 1);
            if (_local_4 < 0)
            {
                return;
            };
            var _local_5:int = _local_4;
            while (_local_5 >= 0)
            {
                _local_2 = (_arg_1.getChildAt(_local_5) as DisplayObjectContainer);
                if (_local_2 != null)
                {
                    playAllMovieClip(_local_2);
                };
                _local_5--;
            };
        }

        public static function removeAllChild(_arg_1:DisplayObjectContainer):void
        {
            var _local_2:DisplayObjectContainer;
            if (_arg_1 == null)
            {
                return;
            };
            while (_arg_1.numChildren > 0)
            {
                _local_2 = (_arg_1.removeChildAt(0) as DisplayObjectContainer);
                if (_local_2 != null)
                {
                    stopAllMovieClip(_local_2);
                    _local_2 = null;
                };
            };
        }

        public static function removeForParent(_arg_1:DisplayObject, _arg_2:Boolean=false):void
        {
            var _local_3:DisplayObjectContainer;
            var _local_4:Bitmap;
            if (_arg_1 == null)
            {
                return;
            };
            if (_arg_1.parent == null)
            {
                return;
            };
            if (!_arg_1.parent.contains(_arg_1))
            {
                return;
            };
            if (_arg_2)
            {
                _local_3 = (_arg_1 as DisplayObjectContainer);
                if (_local_3)
                {
                    stopAllMovieClip(_local_3, 1);
                    _local_3 = null;
                };
                _local_4 = (_arg_1 as Bitmap);
                if (_local_4)
                {
                    if (_local_4.bitmapData)
                    {
                        _local_4.bitmapData.dispose();
                    };
                };
            };
            _arg_1.parent.removeChild(_arg_1);
        }

        public static function removeBitampFormParent(_arg_1:Bitmap, _arg_2:Boolean=true):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            if (_arg_1.parent == null)
            {
                return;
            };
            if (!_arg_1.parent.contains(_arg_1))
            {
                return;
            };
            if (_arg_2)
            {
                if (_arg_1.bitmapData)
                {
                    _arg_1.bitmapData.dispose();
                };
                _arg_1 = null;
            };
        }

        public static function disposeBitamp(_arg_1:Bitmap):void
        {
            if (((_arg_1) && (_arg_1.bitmapData)))
            {
                _arg_1.bitmapData.dispose();
            };
            _arg_1 = null;
        }

        public static function hasParent(_arg_1:DisplayObject):Boolean
        {
            if (_arg_1.parent == null)
            {
                return (false);
            };
            return (_arg_1.parent.contains(_arg_1));
        }

        public static function localToLocal(_arg_1:DisplayObject, _arg_2:DisplayObject, _arg_3:Point=null):Point
        {
            if (_arg_3 == null)
            {
                _arg_3 = new Point(0, 0);
            };
            _arg_3 = _arg_1.localToGlobal(_arg_3);
            return (_arg_2.globalToLocal(_arg_3));
        }

        public static function FillColor(_arg_1:DisplayObject, _arg_2:uint):void
        {
            var _local_3:ColorTransform = new ColorTransform();
            _local_3.color = _arg_2;
            _arg_1.transform.colorTransform = _local_3;
        }

        public static function getColor(_arg_1:DisplayObject, _arg_2:uint=0, _arg_3:uint=0, _arg_4:Boolean=false):uint
        {
            var _local_5:BitmapData = new BitmapData(_arg_1.width, _arg_1.height);
            _local_5.draw(_arg_1);
            var _local_6:uint = ((_arg_4) ? _local_5.getPixel32(int(_arg_2), int(_arg_3)) : _local_5.getPixel(int(_arg_2), int(_arg_3)));
            _local_5.dispose();
            return (_local_6);
        }

        public static function uniformScale(_arg_1:DisplayObject, _arg_2:Number):void
        {
            if (_arg_1.width >= _arg_1.height)
            {
                _arg_1.width = _arg_2;
                _arg_1.scaleY = _arg_1.scaleX;
            }
            else
            {
                _arg_1.height = _arg_2;
                _arg_1.scaleX = _arg_1.scaleY;
            };
        }

        public static function copyDisplayAsBmp(_arg_1:DisplayObject, _arg_2:Boolean=true):Bitmap
        {
            var _local_3:Number;
            var _local_4:Number;
            _local_4 = _arg_1.scaleY;
            _local_3 = _arg_1.scaleX;
            var _local_5:BitmapData = new BitmapData(_arg_1.width, _arg_1.height, true, 0);
            var _local_6:Rectangle = _arg_1.getRect(_arg_1);
            var _local_7:Matrix = new Matrix();
            if (_local_3 < 0)
            {
                _arg_1.scaleX = -(_arg_1.scaleX);
            };
            if (_local_4 < 0)
            {
                _arg_1.scaleY = -(_arg_1.scaleY);
            };
            _local_7.createBox(_arg_1.scaleX, _arg_1.scaleY, 0, (-(_local_6.x) * _arg_1.scaleX), (-(_local_6.y) * _arg_1.scaleY));
            _local_5.draw(_arg_1, _local_7);
            _arg_1.scaleX = _local_3;
            _arg_1.scaleY = _local_4;
            var _local_8:Bitmap = new Bitmap(_local_5, PixelSnapping.AUTO, _arg_2);
            if (_local_3 < 0)
            {
                _local_8.scaleX = -1;
            };
            if (_local_4 < 0)
            {
                _local_8.scaleY = -1;
            };
            _local_8.x = (_local_6.x * _arg_1.scaleX);
            _local_8.y = (_local_6.y * _arg_1.scaleY);
            return (_local_8);
        }

        public static function mouseEnabledAll(target:InteractiveObject, isAll:Boolean=false):void
        {
            var i:int;
            var child:InteractiveObject;
            var b:Boolean = MOUSE_EVENT_LIST.some(function (_arg_1:String, _arg_2:int, _arg_3:Array):Boolean
            {
                if (target.hasEventListener(_arg_1))
                {
                    return (true);
                };
                return (false);
            });
            if (!b)
            {
                if (target.name.indexOf("instance") != -1)
                {
                    target.mouseEnabled = false;
                };
            };
            var container:DisplayObjectContainer = (target as DisplayObjectContainer);
            if (container)
            {
                i = (container.numChildren - 1);
                while (i >= 0)
                {
                    child = (container.getChildAt(i) as InteractiveObject);
                    if (child)
                    {
                        mouseEnabledAll(child);
                    };
                    i--;
                };
            };
        }

        public static function makeRectangle(_arg_1:Number, _arg_2:Number, _arg_3:uint=0, _arg_4:uint=0, _arg_5:Number=1):Sprite
        {
            var _local_6:Sprite = new Sprite();
            _local_6.graphics.lineStyle(1, _arg_3);
            _local_6.graphics.beginFill(_arg_4);
            _local_6.graphics.drawRect(0, 0, _arg_1, _arg_2);
            _local_6.graphics.endFill();
            _local_6.alpha = _arg_5;
            return (_local_6);
        }

        public static function makeCircle(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:uint=0, _arg_5:uint=0, _arg_6:Number=1):Sprite
        {
            var _local_7:Sprite = new Sprite();
            _local_7.graphics.lineStyle(1, _arg_4);
            _local_7.graphics.beginFill(_arg_5);
            _local_7.graphics.drawCircle(_arg_1, _arg_2, _arg_3);
            _local_7.graphics.endFill();
            _local_7.alpha = _arg_6;
            return (_local_7);
        }

        public static function cutBitmap(_arg_1:uint, _arg_2:uint, _arg_3:BitmapData):Array
        {
            var _local_4:int;
            var _local_5:BitmapData;
            var _local_6:Bitmap;
            var _local_10:int;
            var _local_7:uint = Math.ceil((_arg_3.width / _arg_1));
            var _local_8:uint = Math.ceil((_arg_3.height / _arg_2));
            var _local_9:Array = new Array();
            while (_local_10 < _arg_1)
            {
                _local_4 = 0;
                while (_local_4 < _arg_2)
                {
                    _local_5 = new BitmapData(_local_7, _local_8);
                    _local_5.copyPixels(_arg_3, new Rectangle((_local_10 * _local_7), (_local_4 * _local_8), _local_7, _local_8), new Point());
                    _local_6 = new Bitmap(_local_5);
                    _local_6.x = (_local_10 * _local_7);
                    _local_6.y = (_local_4 * _local_8);
                    _local_9.push(_local_6);
                    _local_4++;
                };
                _local_10++;
            };
            return (_local_9);
        }

        public static function cutBitmapByWH(_arg_1:uint, _arg_2:uint, _arg_3:BitmapData):Array
        {
            var _local_4:int;
            var _local_5:BitmapData;
            var _local_6:Bitmap;
            var _local_10:int;
            var _local_7:uint = Math.ceil((_arg_3.width / _arg_1));
            if (_arg_1 == 0)
            {
                _arg_1 = _arg_3.width;
                _local_7 = 1;
            };
            var _local_8:uint = Math.ceil((_arg_3.height / _arg_2));
            if (_arg_2 == 0)
            {
                _arg_2 = _arg_3.height;
                _local_8 = 1;
            };
            var _local_9:Array = new Array();
            while (_local_10 < _local_7)
            {
                _local_4 = 0;
                while (_local_4 < _local_8)
                {
                    _local_5 = new BitmapData(_arg_1, _arg_2);
                    _local_5.copyPixels(_arg_3, new Rectangle((_local_10 * _arg_1), (_local_4 * _arg_2), _arg_1, _arg_2), new Point());
                    _local_6 = new Bitmap(_local_5);
                    _local_6.x = _local_10;
                    _local_6.y = _local_4;
                    _local_9.push(_local_6);
                    _local_4++;
                };
                _local_10++;
            };
            return (_local_9);
        }

        public static function getBezier(_arg_1:Point, _arg_2:Point, _arg_3:Point, _arg_4:uint):Array
        {
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number = 0;
            var _local_8:Number = (1 / _arg_4);
            var _local_9:Number = 0;
            var _local_10:Array = new Array();
            var _local_11:Number = 0;
            while (_local_11 < 1)
            {
                _local_9 = (1 - _local_7);
                _local_5 = ((((_local_9 * _local_9) * _arg_1.x) + (((2 * _local_7) * _local_9) * _arg_3.x)) + ((_local_7 * _local_7) * _arg_2.x));
                _local_6 = ((((_local_9 * _local_9) * _arg_1.y) + (((2 * _local_7) * _local_9) * _arg_3.y)) + ((_local_7 * _local_7) * _arg_2.y));
                _local_7 = _local_11;
                _local_10.push(new Point(uint(_local_5), uint(_local_6)));
                _local_11 = (_local_11 + _local_8);
            };
            _local_10.push(new Point(uint(_arg_2.x), uint(_arg_2.y)));
            return (_local_10);
        }

        public static function getLine(_arg_1:Point, _arg_2:Point, _arg_3:uint):Array
        {
            var _local_4:Boolean;
            var _local_5:Boolean;
            var _local_6:Number;
            var _local_7:Number;
            var _local_11:int;
            var _local_8:Array = new Array();
            var _local_9:uint = Math.abs((_arg_1.x - _arg_2.x));
            var _local_10:uint = Math.abs((_arg_1.y - _arg_2.y));
            if (_arg_1.x < _arg_2.x)
            {
                _local_4 = true;
            };
            if (_arg_1.y < _arg_2.y)
            {
                _local_5 = true;
            };
            while (_local_11 < _arg_3)
            {
                if (_local_4)
                {
                    _local_6 = (_arg_1.x + ((_local_11 / _arg_3) * _local_9));
                }
                else
                {
                    _local_6 = (_arg_1.x - ((_local_11 / _arg_3) * _local_9));
                };
                if (_local_5)
                {
                    _local_7 = (_arg_1.y + ((_local_11 / _arg_3) * _local_10));
                }
                else
                {
                    _local_7 = (_arg_1.y - ((_local_11 / _arg_3) * _local_10));
                };
                _local_8.push(new Point(uint(_local_6), uint(_local_7)));
                _local_11++;
            };
            _local_8.push(new Point(uint(_arg_2.x), uint(_arg_2.y)));
            return (_local_8);
        }

        public static function drawDashedLine(_arg_1:Graphics, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int=5):void
        {
            var _local_14:Number;
            var _local_15:Number;
            var _local_16:Number;
            var _local_17:Number;
            var _local_7:Number = (_arg_4 - _arg_2);
            var _local_8:Number = (_arg_5 - _arg_3);
            var _local_9:Number = Math.sqrt(((_local_7 * _local_7) + (_local_8 * _local_8)));
            var _local_10:int = Math.round((((_local_9 / _arg_6) + 1) / 2));
            var _local_11:Number = (_local_7 / _local_10);
            var _local_12:Number = (_local_8 / _local_10);
            var _local_13:uint;
            while (_local_13 < _local_10)
            {
                _local_14 = (_arg_2 + (_local_13 * _local_11));
                _local_15 = (_arg_3 + (_local_13 * _local_12));
                _local_16 = (_local_14 + (_local_11 * 0.5));
                _local_17 = (_local_15 + (_local_12 * 0.5));
                _arg_1.moveTo(Math.round(_local_14), Math.round(_local_15));
                _arg_1.lineTo(Math.round(_local_16), Math.round(_local_17));
                _local_13++;
            };
        }

        public static function drawSector(_arg_1:Sprite, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number):void
        {
            _arg_1.graphics.clear();
            _arg_1.graphics.lineStyle(0, _arg_8);
            _arg_1.graphics.beginFill(_arg_9);
            var _local_10:Number = (Math.PI / 180);
            _arg_2 = (_arg_2 * _local_10);
            _arg_3 = (_arg_3 * _local_10);
            _arg_7 = (_arg_7 * _local_10);
            _arg_1.graphics.moveTo(_arg_5, _arg_6);
            var _local_11:Number = _arg_2;
            while (_local_11 < _arg_3)
            {
                _arg_1.graphics.lineTo((_arg_5 + (_arg_4 * Math.cos(_local_11))), (_arg_6 + (_arg_4 * Math.sin(_local_11))));
                _local_11 = (_local_11 + Math.min(_arg_7, (_arg_3 - _local_11)));
            };
            _arg_1.graphics.lineTo((_arg_5 + (_arg_4 * Math.cos(_arg_3))), (_arg_6 + (_arg_4 * Math.sin(_arg_3))));
            _arg_1.graphics.lineTo(_arg_5, _arg_6);
        }

        public static function isMouseInSpt(_arg_1:DisplayObject, _arg_2:DisplayObjectContainer=null):Boolean
        {
            if (!_arg_2)
            {
                _arg_2 = _arg_1.parent;
            };
            if (!_arg_1.parent)
            {
                return (false);
            };
            var _local_3:BitmapData = new BitmapData(_arg_1.width, _arg_1.height, true, 0);
            var _local_4:Matrix = new Matrix();
            var _local_5:Rectangle = _arg_1.getBounds(_arg_2);
            _local_4.tx = -((_local_5.x - _arg_1.x));
            _local_4.ty = -((_local_5.y - _arg_1.y));
            _local_3.draw(_arg_1, _local_4);
            var _local_6:uint = _local_3.getPixel32((_local_4.tx + _arg_1.mouseX), (_local_4.ty + _arg_1.mouseY));
            return ((!((_local_6 == 0))));
        }

        public static function setBrightness(_arg_1:DisplayObject, _arg_2:Number):void
        {
            var _local_3:ColorTransform = _arg_1.transform.colorTransform;
            var _local_4:* = _arg_1.filters;
            if (_arg_2 >= 0)
            {
                _local_3.blueMultiplier = (1 - _arg_2);
                _local_3.redMultiplier = (1 - _arg_2);
                _local_3.greenMultiplier = (1 - _arg_2);
                _local_3.redOffset = (0xFF * _arg_2);
                _local_3.greenOffset = (0xFF * _arg_2);
                _local_3.blueOffset = (0xFF * _arg_2);
            }
            else
            {
                _arg_2 = Math.abs(_arg_2);
                _local_3.blueMultiplier = (1 - _arg_2);
                _local_3.redMultiplier = (1 - _arg_2);
                _local_3.greenMultiplier = (1 - _arg_2);
                _local_3.redOffset = 0;
                _local_3.greenOffset = 0;
                _local_3.blueOffset = 0;
            };
            _arg_1.transform.colorTransform = _local_3;
            _arg_1.filters = _local_4;
        }

        public static function createSaturationFilter(_arg_1:Number):ColorMatrixFilter
        {
            return (new ColorMatrixFilter([((0.3086 * (1 - _arg_1)) + _arg_1), (0.6094 * (1 - _arg_1)), (0.082 * (1 - _arg_1)), 0, 0, (0.3086 * (1 - _arg_1)), ((0.6094 * (1 - _arg_1)) + _arg_1), (0.082 * (1 - _arg_1)), 0, 0, (0.3086 * (1 - _arg_1)), (0.6094 * (1 - _arg_1)), ((0.082 * (1 - _arg_1)) + _arg_1), 0, 0, 0, 0, 0, 1, 0]));
        }

        public static function createContrastFilter(_arg_1:Number):ColorMatrixFilter
        {
            return (new ColorMatrixFilter([_arg_1, 0, 0, 0, (128 * (1 - _arg_1)), 0, _arg_1, 0, 0, (128 * (1 - _arg_1)), 0, 0, _arg_1, 0, (128 * (1 - _arg_1)), 0, 0, 0, 1, 0]));
        }

        public static function createBrightnessFilter(_arg_1:Number):ColorMatrixFilter
        {
            return (new ColorMatrixFilter([1, 0, 0, 0, _arg_1, 0, 1, 0, 0, _arg_1, 0, 0, 1, 0, _arg_1, 0, 0, 0, 1, 0]));
        }

        public static function createInversionFilter():ColorMatrixFilter
        {
            return (new ColorMatrixFilter([-1, 0, 0, 0, 0xFF, 0, -1, 0, 0, 0xFF, 0, 0, -1, 0, 0xFF, 0, 0, 0, 1, 0]));
        }

        public static function createHueFilter(_arg_1:Number):ColorMatrixFilter
        {
            var _local_2:Number = Math.cos(((_arg_1 * Math.PI) / 180));
            var _local_3:Number = Math.sin(((_arg_1 * Math.PI) / 180));
            var _local_4:Number = 0.213;
            var _local_5:Number = 0.715;
            var _local_6:Number = 0.072;
            return (new ColorMatrixFilter([((_local_4 + (_local_2 * (1 - _local_4))) + (_local_3 * (0 - _local_4))), ((_local_5 + (_local_2 * (0 - _local_5))) + (_local_3 * (0 - _local_5))), ((_local_6 + (_local_2 * (0 - _local_6))) + (_local_3 * (1 - _local_6))), 0, 0, ((_local_4 + (_local_2 * (0 - _local_4))) + (_local_3 * 0.143)), ((_local_5 + (_local_2 * (1 - _local_5))) + (_local_3 * 0.14)), ((_local_6 + (_local_2 * (0 - _local_6))) + (_local_3 * -0.283)), 0, 0, ((_local_4 + (_local_2 * (0 - _local_4))) + (_local_3 * (0 - (1 - _local_4)))), ((_local_5 + (_local_2 * (0 - _local_5))) + (_local_3 * _local_5)), ((_local_6 + (_local_2 * (1 - _local_6))) + (_local_3 * _local_6)), 0, 0, 0, 0, 0, 1, 0]));
        }

        public static function createThresholdFilter(_arg_1:Number):ColorMatrixFilter
        {
            return (new ColorMatrixFilter([(0.3086 * 0x0100), (0.6094 * 0x0100), (0.082 * 0x0100), 0, (-256 * _arg_1), (0.3086 * 0x0100), (0.6094 * 0x0100), (0.082 * 0x0100), 0, (-256 * _arg_1), (0.3086 * 0x0100), (0.6094 * 0x0100), (0.082 * 0x0100), 0, (-256 * _arg_1), 0, 0, 0, 1, 0]));
        }

        public static function setLithification(_arg_1:DisplayObject):void
        {
            _arg_1.filters = [DisplayUtil.createBrightnessFilter(-10), DisplayUtil.createContrastFilter(0.8), DisplayUtil.createSaturationFilter(0)];
        }

        public static function setPoison(_arg_1:DisplayObject):void
        {
            var _local_2:ColorTransform = new ColorTransform(0.5, 0.5, 0.5, 1, 0, 85, 0, 0);
            _arg_1.transform.colorTransform = _local_2;
        }


        public function getTotalChildNumber(tar:DisplayObjectContainer):void
        {
            var child:DisplayObjectContainer;
            var len:int = tar.numChildren;
            this.indexNum = (this.indexNum + tar.numChildren);
            while (len > 0)
            {
                try
                {
                    child = (tar.getChildAt((len - 1)) as DisplayObjectContainer);
                }
                catch(e:Error)
                {
                    child = null;
                };
                if (((child) && (child.numChildren)))
                {
                    this.getTotalChildNumber(child);
                };
                len = (len - 1);
            };
        }

        public function getTotalChildren(_arg_1:DisplayObjectContainer):int
        {
            var _local_3:int;
            var _local_5:DisplayObjectContainer;
            var _local_2:int;
            var _local_4:Array = [_arg_1];
            while (_local_4.length)
            {
                _arg_1 = _local_4.pop();
                _local_3 = _arg_1.numChildren;
                _local_2 = (_local_2 + _local_3);
                while (_local_3--)
                {
                    try
                    {
                        _local_5 = (_arg_1.getChildAt(_local_3) as DisplayObjectContainer);
                        ((_local_5) && (_local_4.push(_local_5)));
                    }
                    catch(e:Error)
                    {
                    };
                };
            };
            return (_local_2);
        }


    }
}//package com.popchan.framework.utils
