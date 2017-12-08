//Created by Action Script Viewer - http://www.buraks.com/asv
package caurina.transitions
{
    public class Equations 
    {

        public function Equations()
        {
            trace("Equations is a static class and should not be instantiated.");
        }

        public static function easeOutBounce(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = (_arg_1 / _arg_4);
            if (_arg_1 < (1 / 2.75))
            {
                return (((_arg_3 * ((7.5625 * _arg_1) * _arg_1)) + _arg_2));
            };
            if (_arg_1 < (2 / 2.75))
            {
                _arg_1 = (_arg_1 - (1.5 / 2.75));
                return (((_arg_3 * (((7.5625 * _arg_1) * _arg_1) + 0.75)) + _arg_2));
            };
            if (_arg_1 < (2.5 / 2.75))
            {
                _arg_1 = (_arg_1 - (2.25 / 2.75));
                return (((_arg_3 * (((7.5625 * _arg_1) * _arg_1) + 0.9375)) + _arg_2));
            };
            _arg_1 = (_arg_1 - (2.625 / 2.75));
            return (((_arg_3 * (((7.5625 * _arg_1) * _arg_1) + 0.984375)) + _arg_2));
        }

        public static function easeInOutElastic(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            var _local_7:Number;
            if (_arg_1 == 0)
            {
                return (_arg_2);
            };
            _arg_1 = (_arg_1 / (_arg_4 / 2));
            if (_arg_1 == 2)
            {
                return ((_arg_2 + _arg_3));
            };
            var _local_6:Number = (((((!(Boolean(_arg_5)))) || (isNaN(_arg_5.period)))) ? (_arg_4 * (0.3 * 1.5)) : _arg_5.period);
            var _local_8:Number = (((((!(Boolean(_arg_5)))) || (isNaN(_arg_5.amplitude)))) ? 0 : _arg_5.amplitude);
            if ((((!(Boolean(_local_8)))) || ((_local_8 < Math.abs(_arg_3)))))
            {
                _local_8 = _arg_3;
                _local_7 = (_local_6 / 4);
            }
            else
            {
                _local_7 = ((_local_6 / (2 * Math.PI)) * Math.asin((_arg_3 / _local_8)));
            };
            if (_arg_1 < 1)
            {
                return (((-0.5 * ((_local_8 * Math.pow(2, (10 * --_arg_1))) * Math.sin(((((_arg_1 * _arg_4) - _local_7) * (2 * Math.PI)) / _local_6)))) + _arg_2));
            };
            return ((((((_local_8 * Math.pow(2, (-10 * --_arg_1))) * Math.sin(((((_arg_1 * _arg_4) - _local_7) * (2 * Math.PI)) / _local_6))) * 0.5) + _arg_3) + _arg_2));
        }

        public static function easeInOutQuad(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = (_arg_1 / (_arg_4 / 2));
            if (_arg_1 < 1)
            {
                return (((((_arg_3 / 2) * _arg_1) * _arg_1) + _arg_2));
            };
            return ((((-(_arg_3) / 2) * ((--_arg_1 * (_arg_1 - 2)) - 1)) + _arg_2));
        }

        public static function easeInOutBounce(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            if (_arg_1 < (_arg_4 / 2))
            {
                return (((easeInBounce((_arg_1 * 2), 0, _arg_3, _arg_4) * 0.5) + _arg_2));
            };
            return ((((easeOutBounce(((_arg_1 * 2) - _arg_4), 0, _arg_3, _arg_4) * 0.5) + (_arg_3 * 0.5)) + _arg_2));
        }

        public static function easeInOutBack(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            var _local_6:Number = (((((!(Boolean(_arg_5)))) || (isNaN(_arg_5.overshoot)))) ? 1.70158 : _arg_5.overshoot);
            _arg_1 = (_arg_1 / (_arg_4 / 2));
            if (_arg_1 < 1)
            {
                _local_6 = (_local_6 * 1.525);
                return ((((_arg_3 / 2) * ((_arg_1 * _arg_1) * (((_local_6 + 1) * _arg_1) - _local_6))) + _arg_2));
            };
            _arg_1 = (_arg_1 - 2);
            _local_6 = (_local_6 * 1.525);
            return ((((_arg_3 / 2) * (((_arg_1 * _arg_1) * (((_local_6 + 1) * _arg_1) + _local_6)) + 2)) + _arg_2));
        }

        public static function easeOutInCubic(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            if (_arg_1 < (_arg_4 / 2))
            {
                return (easeOutCubic((_arg_1 * 2), _arg_2, (_arg_3 / 2), _arg_4, _arg_5));
            };
            return (easeInCubic(((_arg_1 * 2) - _arg_4), (_arg_2 + (_arg_3 / 2)), (_arg_3 / 2), _arg_4, _arg_5));
        }

        public static function easeNone(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            return ((((_arg_3 * _arg_1) / _arg_4) + _arg_2));
        }

        public static function easeOutBack(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            var _local_6:Number = (((((!(Boolean(_arg_5)))) || (isNaN(_arg_5.overshoot)))) ? 1.70158 : _arg_5.overshoot);
            _arg_1 = ((_arg_1 / _arg_4) - 1);
            return (((_arg_3 * (((_arg_1 * _arg_1) * (((_local_6 + 1) * _arg_1) + _local_6)) + 1)) + _arg_2));
        }

        public static function easeInOutSine(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            return ((((-(_arg_3) / 2) * (Math.cos(((Math.PI * _arg_1) / _arg_4)) - 1)) + _arg_2));
        }

        public static function easeInBack(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            var _local_6:Number = (((((!(Boolean(_arg_5)))) || (isNaN(_arg_5.overshoot)))) ? 1.70158 : _arg_5.overshoot);
            _arg_1 = (_arg_1 / _arg_4);
            return (((((_arg_3 * _arg_1) * _arg_1) * (((_local_6 + 1) * _arg_1) - _local_6)) + _arg_2));
        }

        public static function easeInQuart(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = (_arg_1 / _arg_4);
            return ((((((_arg_3 * _arg_1) * _arg_1) * _arg_1) * _arg_1) + _arg_2));
        }

        public static function easeOutInQuint(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            if (_arg_1 < (_arg_4 / 2))
            {
                return (easeOutQuint((_arg_1 * 2), _arg_2, (_arg_3 / 2), _arg_4, _arg_5));
            };
            return (easeInQuint(((_arg_1 * 2) - _arg_4), (_arg_2 + (_arg_3 / 2)), (_arg_3 / 2), _arg_4, _arg_5));
        }

        public static function easeOutInBounce(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            if (_arg_1 < (_arg_4 / 2))
            {
                return (easeOutBounce((_arg_1 * 2), _arg_2, (_arg_3 / 2), _arg_4, _arg_5));
            };
            return (easeInBounce(((_arg_1 * 2) - _arg_4), (_arg_2 + (_arg_3 / 2)), (_arg_3 / 2), _arg_4, _arg_5));
        }

        public static function init():void
        {
            Tweener.registerTransition("easenone", easeNone);
            Tweener.registerTransition("linear", easeNone);
            Tweener.registerTransition("easeinquad", easeInQuad);
            Tweener.registerTransition("easeoutquad", easeOutQuad);
            Tweener.registerTransition("easeinoutquad", easeInOutQuad);
            Tweener.registerTransition("easeoutinquad", easeOutInQuad);
            Tweener.registerTransition("easeincubic", easeInCubic);
            Tweener.registerTransition("easeoutcubic", easeOutCubic);
            Tweener.registerTransition("easeinoutcubic", easeInOutCubic);
            Tweener.registerTransition("easeoutincubic", easeOutInCubic);
            Tweener.registerTransition("easeinquart", easeInQuart);
            Tweener.registerTransition("easeoutquart", easeOutQuart);
            Tweener.registerTransition("easeinoutquart", easeInOutQuart);
            Tweener.registerTransition("easeoutinquart", easeOutInQuart);
            Tweener.registerTransition("easeinquint", easeInQuint);
            Tweener.registerTransition("easeoutquint", easeOutQuint);
            Tweener.registerTransition("easeinoutquint", easeInOutQuint);
            Tweener.registerTransition("easeoutinquint", easeOutInQuint);
            Tweener.registerTransition("easeinsine", easeInSine);
            Tweener.registerTransition("easeoutsine", easeOutSine);
            Tweener.registerTransition("easeinoutsine", easeInOutSine);
            Tweener.registerTransition("easeoutinsine", easeOutInSine);
            Tweener.registerTransition("easeincirc", easeInCirc);
            Tweener.registerTransition("easeoutcirc", easeOutCirc);
            Tweener.registerTransition("easeinoutcirc", easeInOutCirc);
            Tweener.registerTransition("easeoutincirc", easeOutInCirc);
            Tweener.registerTransition("easeinexpo", easeInExpo);
            Tweener.registerTransition("easeoutexpo", easeOutExpo);
            Tweener.registerTransition("easeinoutexpo", easeInOutExpo);
            Tweener.registerTransition("easeoutinexpo", easeOutInExpo);
            Tweener.registerTransition("easeinelastic", easeInElastic);
            Tweener.registerTransition("easeoutelastic", easeOutElastic);
            Tweener.registerTransition("easeinoutelastic", easeInOutElastic);
            Tweener.registerTransition("easeoutinelastic", easeOutInElastic);
            Tweener.registerTransition("easeinback", easeInBack);
            Tweener.registerTransition("easeoutback", easeOutBack);
            Tweener.registerTransition("easeinoutback", easeInOutBack);
            Tweener.registerTransition("easeoutinback", easeOutInBack);
            Tweener.registerTransition("easeinbounce", easeInBounce);
            Tweener.registerTransition("easeoutbounce", easeOutBounce);
            Tweener.registerTransition("easeinoutbounce", easeInOutBounce);
            Tweener.registerTransition("easeoutinbounce", easeOutInBounce);
        }

        public static function easeOutExpo(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            return ((((_arg_1)==_arg_4) ? (_arg_2 + _arg_3) : (((_arg_3 * 1.001) * (-(Math.pow(2, ((-10 * _arg_1) / _arg_4))) + 1)) + _arg_2)));
        }

        public static function easeOutInBack(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            if (_arg_1 < (_arg_4 / 2))
            {
                return (easeOutBack((_arg_1 * 2), _arg_2, (_arg_3 / 2), _arg_4, _arg_5));
            };
            return (easeInBack(((_arg_1 * 2) - _arg_4), (_arg_2 + (_arg_3 / 2)), (_arg_3 / 2), _arg_4, _arg_5));
        }

        public static function easeInExpo(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            return ((((_arg_1)==0) ? _arg_2 : (((_arg_3 * Math.pow(2, (10 * ((_arg_1 / _arg_4) - 1)))) + _arg_2) - (_arg_3 * 0.001))));
        }

        public static function easeInCubic(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = (_arg_1 / _arg_4);
            return (((((_arg_3 * _arg_1) * _arg_1) * _arg_1) + _arg_2));
        }

        public static function easeInQuint(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = (_arg_1 / _arg_4);
            return (((((((_arg_3 * _arg_1) * _arg_1) * _arg_1) * _arg_1) * _arg_1) + _arg_2));
        }

        public static function easeInOutCirc(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = (_arg_1 / (_arg_4 / 2));
            if (_arg_1 < 1)
            {
                return ((((-(_arg_3) / 2) * (Math.sqrt((1 - (_arg_1 * _arg_1))) - 1)) + _arg_2));
            };
            _arg_1 = (_arg_1 - 2);
            return ((((_arg_3 / 2) * (Math.sqrt((1 - (_arg_1 * _arg_1))) + 1)) + _arg_2));
        }

        public static function easeInQuad(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = (_arg_1 / _arg_4);
            return ((((_arg_3 * _arg_1) * _arg_1) + _arg_2));
        }

        public static function easeInBounce(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            return (((_arg_3 - easeOutBounce((_arg_4 - _arg_1), 0, _arg_3, _arg_4)) + _arg_2));
        }

        public static function easeOutInExpo(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            if (_arg_1 < (_arg_4 / 2))
            {
                return (easeOutExpo((_arg_1 * 2), _arg_2, (_arg_3 / 2), _arg_4, _arg_5));
            };
            return (easeInExpo(((_arg_1 * 2) - _arg_4), (_arg_2 + (_arg_3 / 2)), (_arg_3 / 2), _arg_4, _arg_5));
        }

        public static function easeOutQuart(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = ((_arg_1 / _arg_4) - 1);
            return (((-(_arg_3) * ((((_arg_1 * _arg_1) * _arg_1) * _arg_1) - 1)) + _arg_2));
        }

        public static function easeInSine(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            return ((((-(_arg_3) * Math.cos(((_arg_1 / _arg_4) * (Math.PI / 2)))) + _arg_3) + _arg_2));
        }

        public static function easeInOutQuart(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = (_arg_1 / (_arg_4 / 2));
            if (_arg_1 < 1)
            {
                return (((((((_arg_3 / 2) * _arg_1) * _arg_1) * _arg_1) * _arg_1) + _arg_2));
            };
            _arg_1 = (_arg_1 - 2);
            return ((((-(_arg_3) / 2) * ((((_arg_1 * _arg_1) * _arg_1) * _arg_1) - 2)) + _arg_2));
        }

        public static function easeOutQuad(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = (_arg_1 / _arg_4);
            return ((((-(_arg_3) * _arg_1) * (_arg_1 - 2)) + _arg_2));
        }

        public static function easeOutInElastic(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            if (_arg_1 < (_arg_4 / 2))
            {
                return (easeOutElastic((_arg_1 * 2), _arg_2, (_arg_3 / 2), _arg_4, _arg_5));
            };
            return (easeInElastic(((_arg_1 * 2) - _arg_4), (_arg_2 + (_arg_3 / 2)), (_arg_3 / 2), _arg_4, _arg_5));
        }

        public static function easeInElastic(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            var _local_7:Number;
            if (_arg_1 == 0)
            {
                return (_arg_2);
            };
            _arg_1 = (_arg_1 / _arg_4);
            if (_arg_1 == 1)
            {
                return ((_arg_2 + _arg_3));
            };
            var _local_6:Number = (((((!(Boolean(_arg_5)))) || (isNaN(_arg_5.period)))) ? (_arg_4 * 0.3) : _arg_5.period);
            var _local_8:Number = (((((!(Boolean(_arg_5)))) || (isNaN(_arg_5.amplitude)))) ? 0 : _arg_5.amplitude);
            if ((((!(Boolean(_local_8)))) || ((_local_8 < Math.abs(_arg_3)))))
            {
                _local_8 = _arg_3;
                _local_7 = (_local_6 / 4);
            }
            else
            {
                _local_7 = ((_local_6 / (2 * Math.PI)) * Math.asin((_arg_3 / _local_8)));
            };
            return ((-(((_local_8 * Math.pow(2, (10 * --_arg_1))) * Math.sin(((((_arg_1 * _arg_4) - _local_7) * (2 * Math.PI)) / _local_6)))) + _arg_2));
        }

        public static function easeOutCubic(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = ((_arg_1 / _arg_4) - 1);
            return (((_arg_3 * (((_arg_1 * _arg_1) * _arg_1) + 1)) + _arg_2));
        }

        public static function easeOutQuint(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = ((_arg_1 / _arg_4) - 1);
            return (((_arg_3 * (((((_arg_1 * _arg_1) * _arg_1) * _arg_1) * _arg_1) + 1)) + _arg_2));
        }

        public static function easeOutInQuad(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            if (_arg_1 < (_arg_4 / 2))
            {
                return (easeOutQuad((_arg_1 * 2), _arg_2, (_arg_3 / 2), _arg_4, _arg_5));
            };
            return (easeInQuad(((_arg_1 * 2) - _arg_4), (_arg_2 + (_arg_3 / 2)), (_arg_3 / 2), _arg_4, _arg_5));
        }

        public static function easeOutSine(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            return (((_arg_3 * Math.sin(((_arg_1 / _arg_4) * (Math.PI / 2)))) + _arg_2));
        }

        public static function easeInOutCubic(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = (_arg_1 / (_arg_4 / 2));
            if (_arg_1 < 1)
            {
                return ((((((_arg_3 / 2) * _arg_1) * _arg_1) * _arg_1) + _arg_2));
            };
            _arg_1 = (_arg_1 - 2);
            return ((((_arg_3 / 2) * (((_arg_1 * _arg_1) * _arg_1) + 2)) + _arg_2));
        }

        public static function easeInOutQuint(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = (_arg_1 / (_arg_4 / 2));
            if (_arg_1 < 1)
            {
                return ((((((((_arg_3 / 2) * _arg_1) * _arg_1) * _arg_1) * _arg_1) * _arg_1) + _arg_2));
            };
            _arg_1 = (_arg_1 - 2);
            return ((((_arg_3 / 2) * (((((_arg_1 * _arg_1) * _arg_1) * _arg_1) * _arg_1) + 2)) + _arg_2));
        }

        public static function easeInCirc(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = (_arg_1 / _arg_4);
            return (((-(_arg_3) * (Math.sqrt((1 - (_arg_1 * _arg_1))) - 1)) + _arg_2));
        }

        public static function easeOutInSine(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            if (_arg_1 < (_arg_4 / 2))
            {
                return (easeOutSine((_arg_1 * 2), _arg_2, (_arg_3 / 2), _arg_4, _arg_5));
            };
            return (easeInSine(((_arg_1 * 2) - _arg_4), (_arg_2 + (_arg_3 / 2)), (_arg_3 / 2), _arg_4, _arg_5));
        }

        public static function easeInOutExpo(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            if (_arg_1 == 0)
            {
                return (_arg_2);
            };
            if (_arg_1 == _arg_4)
            {
                return ((_arg_2 + _arg_3));
            };
            _arg_1 = (_arg_1 / (_arg_4 / 2));
            if (_arg_1 < 1)
            {
                return (((((_arg_3 / 2) * Math.pow(2, (10 * (_arg_1 - 1)))) + _arg_2) - (_arg_3 * 0.0005)));
            };
            return (((((_arg_3 / 2) * 1.0005) * (-(Math.pow(2, (-10 * --_arg_1))) + 2)) + _arg_2));
        }

        public static function easeOutElastic(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            var _local_7:Number;
            if (_arg_1 == 0)
            {
                return (_arg_2);
            };
            _arg_1 = (_arg_1 / _arg_4);
            if (_arg_1 == 1)
            {
                return ((_arg_2 + _arg_3));
            };
            var _local_6:Number = (((((!(Boolean(_arg_5)))) || (isNaN(_arg_5.period)))) ? (_arg_4 * 0.3) : _arg_5.period);
            var _local_8:Number = (((((!(Boolean(_arg_5)))) || (isNaN(_arg_5.amplitude)))) ? 0 : _arg_5.amplitude);
            if ((((!(Boolean(_local_8)))) || ((_local_8 < Math.abs(_arg_3)))))
            {
                _local_8 = _arg_3;
                _local_7 = (_local_6 / 4);
            }
            else
            {
                _local_7 = ((_local_6 / (2 * Math.PI)) * Math.asin((_arg_3 / _local_8)));
            };
            return (((((_local_8 * Math.pow(2, (-10 * _arg_1))) * Math.sin(((((_arg_1 * _arg_4) - _local_7) * (2 * Math.PI)) / _local_6))) + _arg_3) + _arg_2));
        }

        public static function easeOutCirc(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            _arg_1 = ((_arg_1 / _arg_4) - 1);
            return (((_arg_3 * Math.sqrt((1 - (_arg_1 * _arg_1)))) + _arg_2));
        }

        public static function easeOutInQuart(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            if (_arg_1 < (_arg_4 / 2))
            {
                return (easeOutQuart((_arg_1 * 2), _arg_2, (_arg_3 / 2), _arg_4, _arg_5));
            };
            return (easeInQuart(((_arg_1 * 2) - _arg_4), (_arg_2 + (_arg_3 / 2)), (_arg_3 / 2), _arg_4, _arg_5));
        }

        public static function easeOutInCirc(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Object=null):Number
        {
            if (_arg_1 < (_arg_4 / 2))
            {
                return (easeOutCirc((_arg_1 * 2), _arg_2, (_arg_3 / 2), _arg_4, _arg_5));
            };
            return (easeInCirc(((_arg_1 * 2) - _arg_4), (_arg_2 + (_arg_3 / 2)), (_arg_3 / 2), _arg_4, _arg_5));
        }


    }
}//package caurina.transitions
