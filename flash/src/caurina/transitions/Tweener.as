//Created by Action Script Viewer - http://www.buraks.com/asv
package caurina.transitions
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.utils.getTimer;
    import flash.display.*;

    public class Tweener 
    {

        private static var __tweener_controller__:MovieClip;
        private static var _engineExists:Boolean = false;
        private static var _inited:Boolean = false;
        private static var _currentTime:Number;
        private static var _currentTimeFrame:Number;
        private static var _tweenList:Array;
        private static var _timeScale:Number = 1;
        private static var _transitionList:Object;
        private static var _specialPropertyList:Object;
        private static var _specialPropertyModifierList:Object;
        private static var _specialPropertySplitterList:Object;
        public static var autoOverwrite:Boolean = true;

        public function Tweener()
        {
            trace("Tweener is a static class and should not be instantiated.");
        }

        public static function registerSpecialPropertyModifier(_arg_1:String, _arg_2:Function, _arg_3:Function):void
        {
            if (!_inited)
            {
                init();
            };
            var _local_4:SpecialPropertyModifier = new SpecialPropertyModifier(_arg_2, _arg_3);
            _specialPropertyModifierList[_arg_1] = _local_4;
        }

        public static function registerSpecialProperty(_arg_1:String, _arg_2:Function, _arg_3:Function, _arg_4:Array=null, _arg_5:Function=null):void
        {
            if (!_inited)
            {
                init();
            };
            var _local_6:SpecialProperty = new SpecialProperty(_arg_2, _arg_3, _arg_4, _arg_5);
            _specialPropertyList[_arg_1] = _local_6;
        }

        public static function init(... _args):void
        {
            _inited = true;
            _transitionList = new Object();
            Equations.init();
            _specialPropertyList = new Object();
            _specialPropertyModifierList = new Object();
            _specialPropertySplitterList = new Object();
        }

        private static function updateTweens():Boolean
        {
            var _local_1:int;
            if (_tweenList.length == 0)
            {
                return (false);
            };
            _local_1 = 0;
            while (_local_1 < _tweenList.length)
            {
                if ((((_tweenList[_local_1] == undefined)) || ((!(_tweenList[_local_1].isPaused)))))
                {
                    if (!updateTweenByIndex(_local_1))
                    {
                        removeTweenByIndex(_local_1);
                    };
                    if (_tweenList[_local_1] == null)
                    {
                        removeTweenByIndex(_local_1, true);
                        _local_1--;
                    };
                };
                _local_1++;
            };
            return (true);
        }

        public static function addCaller(_arg_1:Object=null, _arg_2:Object=null):Boolean
        {
            var _local_3:Number;
            var _local_4:Array;
            var _local_8:Function;
            var _local_9:TweenListObj;
            var _local_10:Number;
            var _local_11:String;
            if (!Boolean(_arg_1))
            {
                return (false);
            };
            if ((_arg_1 is Array))
            {
                _local_4 = _arg_1.concat();
            }
            else
            {
                _local_4 = [_arg_1];
            };
            var _local_5:Object = _arg_2;
            if (!_inited)
            {
                init();
            };
            if ((((!(_engineExists))) || ((!(Boolean(__tweener_controller__))))))
            {
                startEngine();
            };
            var _local_6:Number = ((isNaN(_local_5.time)) ? 0 : _local_5.time);
            var _local_7:Number = ((isNaN(_local_5.delay)) ? 0 : _local_5.delay);
            if (typeof(_local_5.transition) == "string")
            {
                _local_11 = _local_5.transition.toLowerCase();
                _local_8 = _transitionList[_local_11];
            }
            else
            {
                _local_8 = _local_5.transition;
            };
            if (!Boolean(_local_8))
            {
                _local_8 = _transitionList["easeoutexpo"];
            };
            _local_3 = 0;
            while (_local_3 < _local_4.length)
            {
                if (_local_5.useFrames == true)
                {
                    _local_9 = new TweenListObj(_local_4[_local_3], (_currentTimeFrame + (_local_7 / _timeScale)), (_currentTimeFrame + ((_local_7 + _local_6) / _timeScale)), true, _local_8, _local_5.transitionParams);
                }
                else
                {
                    _local_9 = new TweenListObj(_local_4[_local_3], (_currentTime + ((_local_7 * 1000) / _timeScale)), (_currentTime + (((_local_7 * 1000) + (_local_6 * 1000)) / _timeScale)), false, _local_8, _local_5.transitionParams);
                };
                _local_9.properties = null;
                _local_9.onStart = _local_5.onStart;
                _local_9.onUpdate = _local_5.onUpdate;
                _local_9.onComplete = _local_5.onComplete;
                _local_9.onOverwrite = _local_5.onOverwrite;
                _local_9.onStartParams = _local_5.onStartParams;
                _local_9.onUpdateParams = _local_5.onUpdateParams;
                _local_9.onCompleteParams = _local_5.onCompleteParams;
                _local_9.onOverwriteParams = _local_5.onOverwriteParams;
                _local_9.onStartScope = _local_5.onStartScope;
                _local_9.onUpdateScope = _local_5.onUpdateScope;
                _local_9.onCompleteScope = _local_5.onCompleteScope;
                _local_9.onOverwriteScope = _local_5.onOverwriteScope;
                _local_9.onErrorScope = _local_5.onErrorScope;
                _local_9.isCaller = true;
                _local_9.count = _local_5.count;
                _local_9.waitFrames = _local_5.waitFrames;
                _tweenList.push(_local_9);
                if ((((_local_6 == 0)) && ((_local_7 == 0))))
                {
                    _local_10 = (_tweenList.length - 1);
                    updateTweenByIndex(_local_10);
                    removeTweenByIndex(_local_10);
                };
                _local_3++;
            };
            return (true);
        }

        public static function pauseAllTweens():Boolean
        {
            var _local_2:uint;
            if (!Boolean(_tweenList))
            {
                return (false);
            };
            var _local_1:Boolean;
            _local_2 = 0;
            while (_local_2 < _tweenList.length)
            {
                pauseTweenByIndex(_local_2);
                _local_1 = true;
                _local_2++;
            };
            return (_local_1);
        }

        public static function removeTweens(_arg_1:Object, ... _args):Boolean
        {
            var _local_4:uint;
            var _local_5:SpecialPropertySplitter;
            var _local_6:Array;
            var _local_7:uint;
            var _local_3:Array = new Array();
            _local_4 = 0;
            while (_local_4 < _args.length)
            {
                if ((((typeof(_args[_local_4]) == "string")) && ((_local_3.indexOf(_args[_local_4]) == -1))))
                {
                    if (_specialPropertySplitterList[_args[_local_4]])
                    {
                        _local_5 = _specialPropertySplitterList[_args[_local_4]];
                        _local_6 = _local_5.splitValues(_arg_1, null);
                        _local_7 = 0;
                        while (_local_7 < _local_6.length)
                        {
                            _local_3.push(_local_6[_local_7].name);
                            _local_7++;
                        };
                    }
                    else
                    {
                        _local_3.push(_args[_local_4]);
                    };
                };
                _local_4++;
            };
            return (affectTweens(removeTweenByIndex, _arg_1, _local_3));
        }

        public static function updateFrame():void
        {
            _currentTimeFrame++;
        }

        public static function splitTweens(_arg_1:Number, _arg_2:Array):uint
        {
            var _local_5:uint;
            var _local_6:String;
            var _local_7:Boolean;
            var _local_3:TweenListObj = _tweenList[_arg_1];
            var _local_4:TweenListObj = _local_3.clone(false);
            _local_5 = 0;
            while (_local_5 < _arg_2.length)
            {
                _local_6 = _arg_2[_local_5];
                if (Boolean(_local_3.properties[_local_6]))
                {
                    _local_3.properties[_local_6] = undefined;
                    delete _local_3.properties[_local_6];
                };
                _local_5++;
            };
            for (_local_6 in _local_4.properties)
            {
                _local_7 = false;
                _local_5 = 0;
                while (_local_5 < _arg_2.length)
                {
                    if (_arg_2[_local_5] == _local_6)
                    {
                        _local_7 = true;
                        break;
                    };
                    _local_5++;
                };
                if (!_local_7)
                {
                    _local_4.properties[_local_6] = undefined;
                    delete _local_4.properties[_local_6];
                };
            };
            _tweenList.push(_local_4);
            return ((_tweenList.length - 1));
        }

        public static function resumeTweenByIndex(_arg_1:Number):Boolean
        {
            var _local_2:TweenListObj = _tweenList[_arg_1];
            if ((((_local_2 == null)) || ((!(_local_2.isPaused)))))
            {
                return (false);
            };
            var _local_3:Number = getCurrentTweeningTime(_local_2);
            _local_2.timeStart = (_local_2.timeStart + (_local_3 - _local_2.timePaused));
            _local_2.timeComplete = (_local_2.timeComplete + (_local_3 - _local_2.timePaused));
            _local_2.timePaused = undefined;
            _local_2.isPaused = false;
            return (true);
        }

        public static function getVersion():String
        {
            return ("AS3 1.33.74");
        }

        public static function onEnterFrame(_arg_1:Event):void
        {
            updateTime();
            updateFrame();
            var _local_2:Boolean;
            _local_2 = updateTweens();
            if (!_local_2)
            {
                stopEngine();
            };
        }

        public static function updateTime():void
        {
            _currentTime = getTimer();
        }

        private static function updateTweenByIndex(i:Number):Boolean
        {
            var tTweening:TweenListObj;
            var mustUpdate:Boolean;
            var nv:Number;
            var t:Number;
            var b:Number;
            var c:Number;
            var d:Number;
            var pName:String;
            var eventScope:Object;
            var tScope:Object;
            var tProperty:Object;
            var pv:Number;
            tTweening = _tweenList[i];
            if ((((tTweening == null)) || ((!(Boolean(tTweening.scope))))))
            {
                return (false);
            };
            var isOver:Boolean;
            var cTime:Number = getCurrentTweeningTime(tTweening);
            if (cTime >= tTweening.timeStart)
            {
                tScope = tTweening.scope;
                if (tTweening.isCaller)
                {
                    do 
                    {
                        t = (((tTweening.timeComplete - tTweening.timeStart) / tTweening.count) * (tTweening.timesCalled + 1));
                        b = tTweening.timeStart;
                        c = (tTweening.timeComplete - tTweening.timeStart);
                        d = (tTweening.timeComplete - tTweening.timeStart);
                        nv = tTweening.transition(t, b, c, d);
                        if (cTime >= nv)
                        {
                            if (Boolean(tTweening.onUpdate))
                            {
                                eventScope = ((Boolean(tTweening.onUpdateScope)) ? tTweening.onUpdateScope : tScope);
                                try
                                {
                                    tTweening.onUpdate.apply(eventScope, tTweening.onUpdateParams);
                                }
                                catch(e1:Error)
                                {
                                    handleError(tTweening, e1, "onUpdate");
                                };
                            };
                            tTweening.timesCalled++;
                            if (tTweening.timesCalled >= tTweening.count)
                            {
                                isOver = true;
                                break;
                            };
                            if (tTweening.waitFrames) break;
                        };
                    } while (cTime >= nv);
                }
                else
                {
                    mustUpdate = (((((tTweening.skipUpdates < 1)) || ((!(tTweening.skipUpdates))))) || ((tTweening.updatesSkipped >= tTweening.skipUpdates)));
                    if (cTime >= tTweening.timeComplete)
                    {
                        isOver = true;
                        mustUpdate = true;
                    };
                    if (!tTweening.hasStarted)
                    {
                        if (Boolean(tTweening.onStart))
                        {
                            eventScope = ((Boolean(tTweening.onStartScope)) ? tTweening.onStartScope : tScope);
                            try
                            {
                                tTweening.onStart.apply(eventScope, tTweening.onStartParams);
                            }
                            catch(e2:Error)
                            {
                                handleError(tTweening, e2, "onStart");
                            };
                        };
                        for (pName in tTweening.properties)
                        {
                            if (tTweening.properties[pName].isSpecialProperty)
                            {
                                if (Boolean(_specialPropertyList[pName].preProcess))
                                {
                                    tTweening.properties[pName].valueComplete = _specialPropertyList[pName].preProcess(tScope, _specialPropertyList[pName].parameters, tTweening.properties[pName].originalValueComplete, tTweening.properties[pName].extra);
                                };
                                pv = _specialPropertyList[pName].getValue(tScope, _specialPropertyList[pName].parameters, tTweening.properties[pName].extra);
                            }
                            else
                            {
                                pv = tScope[pName];
                            };
                            tTweening.properties[pName].valueStart = ((isNaN(pv)) ? tTweening.properties[pName].valueComplete : pv);
                        };
                        mustUpdate = true;
                        tTweening.hasStarted = true;
                    };
                    if (mustUpdate)
                    {
                        for (pName in tTweening.properties)
                        {
                            tProperty = tTweening.properties[pName];
                            if (isOver)
                            {
                                nv = tProperty.valueComplete;
                            }
                            else
                            {
                                if (tProperty.hasModifier)
                                {
                                    t = (cTime - tTweening.timeStart);
                                    d = (tTweening.timeComplete - tTweening.timeStart);
                                    nv = tTweening.transition(t, 0, 1, d, tTweening.transitionParams);
                                    nv = tProperty.modifierFunction(tProperty.valueStart, tProperty.valueComplete, nv, tProperty.modifierParameters);
                                }
                                else
                                {
                                    t = (cTime - tTweening.timeStart);
                                    b = tProperty.valueStart;
                                    c = (tProperty.valueComplete - tProperty.valueStart);
                                    d = (tTweening.timeComplete - tTweening.timeStart);
                                    nv = tTweening.transition(t, b, c, d, tTweening.transitionParams);
                                };
                            };
                            if (tTweening.rounded)
                            {
                                nv = Math.round(nv);
                            };
                            if (tProperty.isSpecialProperty)
                            {
                                _specialPropertyList[pName].setValue(tScope, nv, _specialPropertyList[pName].parameters, tTweening.properties[pName].extra);
                            }
                            else
                            {
                                tScope[pName] = nv;
                            };
                        };
                        tTweening.updatesSkipped = 0;
                        if (Boolean(tTweening.onUpdate))
                        {
                            eventScope = ((Boolean(tTweening.onUpdateScope)) ? tTweening.onUpdateScope : tScope);
                            try
                            {
                                tTweening.onUpdate.apply(eventScope, tTweening.onUpdateParams);
                            }
                            catch(e3:Error)
                            {
                                handleError(tTweening, e3, "onUpdate");
                            };
                        };
                    }
                    else
                    {
                        tTweening.updatesSkipped++;
                    };
                };
                if (((isOver) && (Boolean(tTweening.onComplete))))
                {
                    eventScope = ((Boolean(tTweening.onCompleteScope)) ? tTweening.onCompleteScope : tScope);
                    try
                    {
                        tTweening.onComplete.apply(eventScope, tTweening.onCompleteParams);
                    }
                    catch(e4:Error)
                    {
                        handleError(tTweening, e4, "onComplete");
                    };
                };
                return ((!(isOver)));
            };
            return (true);
        }

        public static function setTimeScale(_arg_1:Number):void
        {
            var _local_2:Number;
            var _local_3:Number;
            if (isNaN(_arg_1))
            {
                _arg_1 = 1;
            };
            if (_arg_1 < 1E-5)
            {
                _arg_1 = 1E-5;
            };
            if (_arg_1 != _timeScale)
            {
                if (_tweenList != null)
                {
                    _local_2 = 0;
                    while (_local_2 < _tweenList.length)
                    {
                        _local_3 = getCurrentTweeningTime(_tweenList[_local_2]);
                        _tweenList[_local_2].timeStart = (_local_3 - (((_local_3 - _tweenList[_local_2].timeStart) * _timeScale) / _arg_1));
                        _tweenList[_local_2].timeComplete = (_local_3 - (((_local_3 - _tweenList[_local_2].timeComplete) * _timeScale) / _arg_1));
                        if (_tweenList[_local_2].timePaused != undefined)
                        {
                            _tweenList[_local_2].timePaused = (_local_3 - (((_local_3 - _tweenList[_local_2].timePaused) * _timeScale) / _arg_1));
                        };
                        _local_2++;
                    };
                };
                _timeScale = _arg_1;
            };
        }

        public static function resumeAllTweens():Boolean
        {
            var _local_2:uint;
            if (!Boolean(_tweenList))
            {
                return (false);
            };
            var _local_1:Boolean;
            _local_2 = 0;
            while (_local_2 < _tweenList.length)
            {
                resumeTweenByIndex(_local_2);
                _local_1 = true;
                _local_2++;
            };
            return (_local_1);
        }

        private static function handleError(pTweening:TweenListObj, pError:Error, pCallBackName:String):void
        {
            var eventScope:Object;
            if (((Boolean(pTweening.onError)) && ((pTweening.onError is Function))))
            {
                eventScope = ((Boolean(pTweening.onErrorScope)) ? pTweening.onErrorScope : pTweening.scope);
                try
                {
                    pTweening.onError.apply(eventScope, [pTweening.scope, pError]);
                }
                catch(metaError:Error)
                {
                    printError(((((String(pTweening.scope) + " raised an error while executing the 'onError' handler. Original error:\n ") + pError.getStackTrace()) + "\nonError error: ") + metaError.getStackTrace()));
                };
            }
            else
            {
                if (!Boolean(pTweening.onError))
                {
                    printError(((((String(pTweening.scope) + " raised an error while executing the '") + pCallBackName) + "'handler. \n") + pError.getStackTrace()));
                };
            };
        }

        private static function startEngine():void
        {
            _engineExists = true;
            _tweenList = new Array();
            __tweener_controller__ = new MovieClip();
            __tweener_controller__.addEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
            _currentTimeFrame = 0;
            updateTime();
        }

        public static function removeAllTweens():Boolean
        {
            var _local_2:uint;
            if (!Boolean(_tweenList))
            {
                return (false);
            };
            var _local_1:Boolean;
            _local_2 = 0;
            while (_local_2 < _tweenList.length)
            {
                removeTweenByIndex(_local_2);
                _local_1 = true;
                _local_2++;
            };
            return (_local_1);
        }

        public static function addTween(_arg_1:Object=null, _arg_2:Object=null):Boolean
        {
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:String;
            var _local_6:Array;
            var _local_13:Function;
            var _local_14:Object;
            var _local_15:TweenListObj;
            var _local_16:Number;
            var _local_17:Array;
            var _local_18:Array;
            var _local_19:Array;
            var _local_20:String;
            if (!Boolean(_arg_1))
            {
                return (false);
            };
            if ((_arg_1 is Array))
            {
                _local_6 = _arg_1.concat();
            }
            else
            {
                _local_6 = [_arg_1];
            };
            var _local_7:Object = TweenListObj.makePropertiesChain(_arg_2);
            if (!_inited)
            {
                init();
            };
            if ((((!(_engineExists))) || ((!(Boolean(__tweener_controller__))))))
            {
                startEngine();
            };
            var _local_8:Number = ((isNaN(_local_7.time)) ? 0 : _local_7.time);
            var _local_9:Number = ((isNaN(_local_7.delay)) ? 0 : _local_7.delay);
            var _local_10:Array = new Array();
            var _local_11:Object = {
                "overwrite":true,
                "time":true,
                "delay":true,
                "useFrames":true,
                "skipUpdates":true,
                "transition":true,
                "transitionParams":true,
                "onStart":true,
                "onUpdate":true,
                "onComplete":true,
                "onOverwrite":true,
                "onError":true,
                "rounded":true,
                "onStartParams":true,
                "onUpdateParams":true,
                "onCompleteParams":true,
                "onOverwriteParams":true,
                "onStartScope":true,
                "onUpdateScope":true,
                "onCompleteScope":true,
                "onOverwriteScope":true,
                "onErrorScope":true
            };
            var _local_12:Object = new Object();
            for (_local_5 in _local_7)
            {
                if (!_local_11[_local_5])
                {
                    if (_specialPropertySplitterList[_local_5])
                    {
                        _local_17 = _specialPropertySplitterList[_local_5].splitValues(_local_7[_local_5], _specialPropertySplitterList[_local_5].parameters);
                        _local_3 = 0;
                        while (_local_3 < _local_17.length)
                        {
                            if (_specialPropertySplitterList[_local_17[_local_3].name])
                            {
                                _local_18 = _specialPropertySplitterList[_local_17[_local_3].name].splitValues(_local_17[_local_3].value, _specialPropertySplitterList[_local_17[_local_3].name].parameters);
                                _local_4 = 0;
                                while (_local_4 < _local_18.length)
                                {
                                    _local_10[_local_18[_local_4].name] = {
                                        "valueStart":undefined,
                                        "valueComplete":_local_18[_local_4].value,
                                        "arrayIndex":_local_18[_local_4].arrayIndex,
                                        "isSpecialProperty":false
                                    };
                                    _local_4++;
                                };
                            }
                            else
                            {
                                _local_10[_local_17[_local_3].name] = {
                                    "valueStart":undefined,
                                    "valueComplete":_local_17[_local_3].value,
                                    "arrayIndex":_local_17[_local_3].arrayIndex,
                                    "isSpecialProperty":false
                                };
                            };
                            _local_3++;
                        };
                    }
                    else
                    {
                        if (_specialPropertyModifierList[_local_5] != undefined)
                        {
                            _local_19 = _specialPropertyModifierList[_local_5].modifyValues(_local_7[_local_5]);
                            _local_3 = 0;
                            while (_local_3 < _local_19.length)
                            {
                                _local_12[_local_19[_local_3].name] = {
                                    "modifierParameters":_local_19[_local_3].parameters,
                                    "modifierFunction":_specialPropertyModifierList[_local_5].getValue
                                };
                                _local_3++;
                            };
                        }
                        else
                        {
                            _local_10[_local_5] = {
                                "valueStart":undefined,
                                "valueComplete":_local_7[_local_5]
                            };
                        };
                    };
                };
            };
            for (_local_5 in _local_10)
            {
                if (_specialPropertyList[_local_5] != undefined)
                {
                    _local_10[_local_5].isSpecialProperty = true;
                }
                else
                {
                    if (_local_6[0][_local_5] == undefined)
                    {
                        printError((((("The property '" + _local_5) + "' doesn't seem to be a normal object property of ") + String(_local_6[0])) + " or a registered special property."));
                    };
                };
            };
            for (_local_5 in _local_12)
            {
                if (_local_10[_local_5] != undefined)
                {
                    _local_10[_local_5].modifierParameters = _local_12[_local_5].modifierParameters;
                    _local_10[_local_5].modifierFunction = _local_12[_local_5].modifierFunction;
                };
            };
            if (typeof(_local_7.transition) == "string")
            {
                _local_20 = _local_7.transition.toLowerCase();
                _local_13 = _transitionList[_local_20];
            }
            else
            {
                _local_13 = _local_7.transition;
            };
            if (!Boolean(_local_13))
            {
                _local_13 = _transitionList["easeoutexpo"];
            };
            _local_3 = 0;
            while (_local_3 < _local_6.length)
            {
                _local_14 = new Object();
                for (_local_5 in _local_10)
                {
                    _local_14[_local_5] = new PropertyInfoObj(_local_10[_local_5].valueStart, _local_10[_local_5].valueComplete, _local_10[_local_5].valueComplete, _local_10[_local_5].arrayIndex, {}, _local_10[_local_5].isSpecialProperty, _local_10[_local_5].modifierFunction, _local_10[_local_5].modifierParameters);
                };
                if (_local_7.useFrames == true)
                {
                    _local_15 = new TweenListObj(_local_6[_local_3], (_currentTimeFrame + (_local_9 / _timeScale)), (_currentTimeFrame + ((_local_9 + _local_8) / _timeScale)), true, _local_13, _local_7.transitionParams);
                }
                else
                {
                    _local_15 = new TweenListObj(_local_6[_local_3], (_currentTime + ((_local_9 * 1000) / _timeScale)), (_currentTime + (((_local_9 * 1000) + (_local_8 * 1000)) / _timeScale)), false, _local_13, _local_7.transitionParams);
                };
                _local_15.properties = _local_14;
                _local_15.onStart = _local_7.onStart;
                _local_15.onUpdate = _local_7.onUpdate;
                _local_15.onComplete = _local_7.onComplete;
                _local_15.onOverwrite = _local_7.onOverwrite;
                _local_15.onError = _local_7.onError;
                _local_15.onStartParams = _local_7.onStartParams;
                _local_15.onUpdateParams = _local_7.onUpdateParams;
                _local_15.onCompleteParams = _local_7.onCompleteParams;
                _local_15.onOverwriteParams = _local_7.onOverwriteParams;
                _local_15.onStartScope = _local_7.onStartScope;
                _local_15.onUpdateScope = _local_7.onUpdateScope;
                _local_15.onCompleteScope = _local_7.onCompleteScope;
                _local_15.onOverwriteScope = _local_7.onOverwriteScope;
                _local_15.onErrorScope = _local_7.onErrorScope;
                _local_15.rounded = _local_7.rounded;
                _local_15.skipUpdates = _local_7.skipUpdates;
                if ((((_local_7.overwrite == undefined)) ? autoOverwrite : _local_7.overwrite))
                {
                    removeTweensByTime(_local_15.scope, _local_15.properties, _local_15.timeStart, _local_15.timeComplete);
                };
                _tweenList.push(_local_15);
                if ((((_local_8 == 0)) && ((_local_9 == 0))))
                {
                    _local_16 = (_tweenList.length - 1);
                    updateTweenByIndex(_local_16);
                    removeTweenByIndex(_local_16);
                };
                _local_3++;
            };
            return (true);
        }

        public static function registerTransition(_arg_1:String, _arg_2:Function):void
        {
            if (!_inited)
            {
                init();
            };
            _transitionList[_arg_1] = _arg_2;
        }

        public static function printError(_arg_1:String):void
        {
            trace(("## [Tweener] Error: " + _arg_1));
        }

        private static function affectTweens(_arg_1:Function, _arg_2:Object, _arg_3:Array):Boolean
        {
            var _local_5:uint;
            var _local_6:Array;
            var _local_7:uint;
            var _local_8:uint;
            var _local_9:uint;
            var _local_4:Boolean;
            if (!Boolean(_tweenList))
            {
                return (false);
            };
            _local_5 = 0;
            while (_local_5 < _tweenList.length)
            {
                if (((_tweenList[_local_5]) && ((_tweenList[_local_5].scope == _arg_2))))
                {
                    if (_arg_3.length == 0)
                    {
                        (_arg_1(_local_5));
                        _local_4 = true;
                    }
                    else
                    {
                        _local_6 = new Array();
                        _local_7 = 0;
                        while (_local_7 < _arg_3.length)
                        {
                            if (Boolean(_tweenList[_local_5].properties[_arg_3[_local_7]]))
                            {
                                _local_6.push(_arg_3[_local_7]);
                            };
                            _local_7++;
                        };
                        if (_local_6.length > 0)
                        {
                            _local_8 = AuxFunctions.getObjectLength(_tweenList[_local_5].properties);
                            if (_local_8 == _local_6.length)
                            {
                                (_arg_1(_local_5));
                                _local_4 = true;
                            }
                            else
                            {
                                _local_9 = splitTweens(_local_5, _local_6);
                                (_arg_1(_local_9));
                                _local_4 = true;
                            };
                        };
                    };
                };
                _local_5++;
            };
            return (_local_4);
        }

        public static function getTweens(_arg_1:Object):Array
        {
            var _local_2:uint;
            var _local_3:String;
            if (!Boolean(_tweenList))
            {
                return ([]);
            };
            var _local_4:Array = new Array();
            _local_2 = 0;
            while (_local_2 < _tweenList.length)
            {
                if (((Boolean(_tweenList[_local_2])) && ((_tweenList[_local_2].scope == _arg_1))))
                {
                    for (_local_3 in _tweenList[_local_2].properties)
                    {
                        _local_4.push(_local_3);
                    };
                };
                _local_2++;
            };
            return (_local_4);
        }

        public static function isTweening(_arg_1:Object):Boolean
        {
            var _local_2:uint;
            if (!Boolean(_tweenList))
            {
                return (false);
            };
            _local_2 = 0;
            while (_local_2 < _tweenList.length)
            {
                if (((Boolean(_tweenList[_local_2])) && ((_tweenList[_local_2].scope == _arg_1))))
                {
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }

        public static function pauseTweenByIndex(_arg_1:Number):Boolean
        {
            var _local_2:TweenListObj = _tweenList[_arg_1];
            if ((((_local_2 == null)) || (_local_2.isPaused)))
            {
                return (false);
            };
            _local_2.timePaused = getCurrentTweeningTime(_local_2);
            _local_2.isPaused = true;
            return (true);
        }

        public static function getCurrentTweeningTime(_arg_1:Object):Number
        {
            return (((_arg_1.useFrames) ? _currentTimeFrame : _currentTime));
        }

        public static function getTweenCount(_arg_1:Object):Number
        {
            var _local_2:uint;
            if (!Boolean(_tweenList))
            {
                return (0);
            };
            var _local_3:Number = 0;
            _local_2 = 0;
            while (_local_2 < _tweenList.length)
            {
                if (((Boolean(_tweenList[_local_2])) && ((_tweenList[_local_2].scope == _arg_1))))
                {
                    _local_3 = (_local_3 + AuxFunctions.getObjectLength(_tweenList[_local_2].properties));
                };
                _local_2++;
            };
            return (_local_3);
        }

        private static function stopEngine():void
        {
            _engineExists = false;
            _tweenList = null;
            _currentTime = 0;
            _currentTimeFrame = 0;
            __tweener_controller__.removeEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
            __tweener_controller__ = null;
        }

        public static function removeTweensByTime(p_scope:Object, p_properties:Object, p_timeStart:Number, p_timeComplete:Number):Boolean
        {
            var removedLocally:Boolean;
            var i:uint;
            var pName:String;
            var eventScope:Object;
            var removed:Boolean;
            var tl:uint = _tweenList.length;
            i = 0;
            while (i < tl)
            {
                if (((Boolean(_tweenList[i])) && ((p_scope == _tweenList[i].scope))))
                {
                    if ((((p_timeComplete > _tweenList[i].timeStart)) && ((p_timeStart < _tweenList[i].timeComplete))))
                    {
                        removedLocally = false;
                        for (pName in _tweenList[i].properties)
                        {
                            if (Boolean(p_properties[pName]))
                            {
                                if (Boolean(_tweenList[i].onOverwrite))
                                {
                                    eventScope = ((Boolean(_tweenList[i].onOverwriteScope)) ? _tweenList[i].onOverwriteScope : _tweenList[i].scope);
                                    try
                                    {
                                        _tweenList[i].onOverwrite.apply(eventScope, _tweenList[i].onOverwriteParams);
                                    }
                                    catch(e:Error)
                                    {
                                        handleError(_tweenList[i], e, "onOverwrite");
                                    };
                                };
                                _tweenList[i].properties[pName] = undefined;
                                delete _tweenList[i].properties[pName];
                                removedLocally = true;
                                removed = true;
                            };
                        };
                        if (removedLocally)
                        {
                            if (AuxFunctions.getObjectLength(_tweenList[i].properties) == 0)
                            {
                                removeTweenByIndex(i);
                            };
                        };
                    };
                };
                i++;
            };
            return (removed);
        }

        public static function registerSpecialPropertySplitter(_arg_1:String, _arg_2:Function, _arg_3:Array=null):void
        {
            if (!_inited)
            {
                init();
            };
            var _local_4:SpecialPropertySplitter = new SpecialPropertySplitter(_arg_2, _arg_3);
            _specialPropertySplitterList[_arg_1] = _local_4;
        }

        public static function removeTweenByIndex(_arg_1:Number, _arg_2:Boolean=false):Boolean
        {
            _tweenList[_arg_1] = null;
            if (_arg_2)
            {
                _tweenList.splice(_arg_1, 1);
            };
            return (true);
        }

        public static function resumeTweens(_arg_1:Object, ... _args):Boolean
        {
            var _local_4:uint;
            var _local_3:Array = new Array();
            _local_4 = 0;
            while (_local_4 < _args.length)
            {
                if ((((typeof(_args[_local_4]) == "string")) && ((_local_3.indexOf(_args[_local_4]) == -1))))
                {
                    _local_3.push(_args[_local_4]);
                };
                _local_4++;
            };
            return (affectTweens(resumeTweenByIndex, _arg_1, _local_3));
        }

        public static function pauseTweens(_arg_1:Object, ... _args):Boolean
        {
            var _local_4:uint;
            var _local_3:Array = new Array();
            _local_4 = 0;
            while (_local_4 < _args.length)
            {
                if ((((typeof(_args[_local_4]) == "string")) && ((_local_3.indexOf(_args[_local_4]) == -1))))
                {
                    _local_3.push(_args[_local_4]);
                };
                _local_4++;
            };
            return (affectTweens(pauseTweenByIndex, _arg_1, _local_3));
        }


    }
}//package caurina.transitions
