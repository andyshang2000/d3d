//Created by Action Script Viewer - http://www.buraks.com/asv
package caurina.transitions
{
    public class TweenListObj 
    {

        public var hasStarted:Boolean;
        public var onUpdate:Function;
        public var useFrames:Boolean;
        public var count:Number;
        public var onOverwriteParams:Array;
        public var timeStart:Number;
        public var timeComplete:Number;
        public var onStartParams:Array;
        public var onUpdateScope:Object;
        public var rounded:Boolean;
        public var onUpdateParams:Array;
        public var properties:Object;
        public var onComplete:Function;
        public var transitionParams:Object;
        public var updatesSkipped:Number;
        public var onStart:Function;
        public var onOverwriteScope:Object;
        public var skipUpdates:Number;
        public var onStartScope:Object;
        public var scope:Object;
        public var isCaller:Boolean;
        public var timePaused:Number;
        public var transition:Function;
        public var onCompleteParams:Array;
        public var onError:Function;
        public var timesCalled:Number;
        public var onErrorScope:Object;
        public var onOverwrite:Function;
        public var isPaused:Boolean;
        public var waitFrames:Boolean;
        public var onCompleteScope:Object;

        public function TweenListObj(_arg_1:Object, _arg_2:Number, _arg_3:Number, _arg_4:Boolean, _arg_5:Function, _arg_6:Object)
        {
            scope = _arg_1;
            timeStart = _arg_2;
            timeComplete = _arg_3;
            useFrames = _arg_4;
            transition = _arg_5;
            transitionParams = _arg_6;
            properties = new Object();
            isPaused = false;
            timePaused = undefined;
            isCaller = false;
            updatesSkipped = 0;
            timesCalled = 0;
            skipUpdates = 0;
            hasStarted = false;
        }

        public static function makePropertiesChain(_arg_1:Object):Object
        {
            var _local_3:Object;
            var _local_4:Object;
            var _local_5:Object;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_2:Object = _arg_1.base;
            if (_local_2)
            {
                _local_3 = {};
                if ((_local_2 is Array))
                {
                    _local_4 = [];
                    _local_8 = 0;
                    while (_local_8 < _local_2.length)
                    {
                        _local_4.push(_local_2[_local_8]);
                        _local_8++;
                    };
                }
                else
                {
                    _local_4 = [_local_2];
                };
                _local_4.push(_arg_1);
                _local_6 = _local_4.length;
                _local_7 = 0;
                while (_local_7 < _local_6)
                {
                    if (_local_4[_local_7]["base"])
                    {
                        _local_5 = AuxFunctions.concatObjects(makePropertiesChain(_local_4[_local_7]["base"]), _local_4[_local_7]);
                    }
                    else
                    {
                        _local_5 = _local_4[_local_7];
                    };
                    _local_3 = AuxFunctions.concatObjects(_local_3, _local_5);
                    _local_7++;
                };
                if (_local_3["base"])
                {
                    delete _local_3["base"];
                };
                return (_local_3);
            };
            return (_arg_1);
        }


        public function clone(_arg_1:Boolean):TweenListObj
        {
            var _local_3:String;
            var _local_2:TweenListObj = new TweenListObj(scope, timeStart, timeComplete, useFrames, transition, transitionParams);
            _local_2.properties = new Array();
            for (_local_3 in properties)
            {
                _local_2.properties[_local_3] = properties[_local_3].clone();
            };
            _local_2.skipUpdates = skipUpdates;
            _local_2.updatesSkipped = updatesSkipped;
            if (!_arg_1)
            {
                _local_2.onStart = onStart;
                _local_2.onUpdate = onUpdate;
                _local_2.onComplete = onComplete;
                _local_2.onOverwrite = onOverwrite;
                _local_2.onError = onError;
                _local_2.onStartParams = onStartParams;
                _local_2.onUpdateParams = onUpdateParams;
                _local_2.onCompleteParams = onCompleteParams;
                _local_2.onOverwriteParams = onOverwriteParams;
                _local_2.onStartScope = onStartScope;
                _local_2.onUpdateScope = onUpdateScope;
                _local_2.onCompleteScope = onCompleteScope;
                _local_2.onOverwriteScope = onOverwriteScope;
                _local_2.onErrorScope = onErrorScope;
            };
            _local_2.rounded = rounded;
            _local_2.isPaused = isPaused;
            _local_2.timePaused = timePaused;
            _local_2.isCaller = isCaller;
            _local_2.count = count;
            _local_2.timesCalled = timesCalled;
            _local_2.waitFrames = waitFrames;
            _local_2.hasStarted = hasStarted;
            return (_local_2);
        }

        public function toString():String
        {
            var _local_3:String;
            var _local_1 = "\n[TweenListObj ";
            _local_1 = (_local_1 + ("scope:" + String(scope)));
            _local_1 = (_local_1 + ", properties:");
            var _local_2:Boolean = true;
            for (_local_3 in properties)
            {
                if (!_local_2)
                {
                    _local_1 = (_local_1 + ",");
                };
                _local_1 = (_local_1 + ("[name:" + properties[_local_3].name));
                _local_1 = (_local_1 + (",valueStart:" + properties[_local_3].valueStart));
                _local_1 = (_local_1 + (",valueComplete:" + properties[_local_3].valueComplete));
                _local_1 = (_local_1 + "]");
                _local_2 = false;
            };
            _local_1 = (_local_1 + (", timeStart:" + String(timeStart)));
            _local_1 = (_local_1 + (", timeComplete:" + String(timeComplete)));
            _local_1 = (_local_1 + (", useFrames:" + String(useFrames)));
            _local_1 = (_local_1 + (", transition:" + String(transition)));
            _local_1 = (_local_1 + (", transitionParams:" + String(transitionParams)));
            if (skipUpdates)
            {
                _local_1 = (_local_1 + (", skipUpdates:" + String(skipUpdates)));
            };
            if (updatesSkipped)
            {
                _local_1 = (_local_1 + (", updatesSkipped:" + String(updatesSkipped)));
            };
            if (Boolean(onStart))
            {
                _local_1 = (_local_1 + (", onStart:" + String(onStart)));
            };
            if (Boolean(onUpdate))
            {
                _local_1 = (_local_1 + (", onUpdate:" + String(onUpdate)));
            };
            if (Boolean(onComplete))
            {
                _local_1 = (_local_1 + (", onComplete:" + String(onComplete)));
            };
            if (Boolean(onOverwrite))
            {
                _local_1 = (_local_1 + (", onOverwrite:" + String(onOverwrite)));
            };
            if (Boolean(onError))
            {
                _local_1 = (_local_1 + (", onError:" + String(onError)));
            };
            if (onStartParams)
            {
                _local_1 = (_local_1 + (", onStartParams:" + String(onStartParams)));
            };
            if (onUpdateParams)
            {
                _local_1 = (_local_1 + (", onUpdateParams:" + String(onUpdateParams)));
            };
            if (onCompleteParams)
            {
                _local_1 = (_local_1 + (", onCompleteParams:" + String(onCompleteParams)));
            };
            if (onOverwriteParams)
            {
                _local_1 = (_local_1 + (", onOverwriteParams:" + String(onOverwriteParams)));
            };
            if (onStartScope)
            {
                _local_1 = (_local_1 + (", onStartScope:" + String(onStartScope)));
            };
            if (onUpdateScope)
            {
                _local_1 = (_local_1 + (", onUpdateScope:" + String(onUpdateScope)));
            };
            if (onCompleteScope)
            {
                _local_1 = (_local_1 + (", onCompleteScope:" + String(onCompleteScope)));
            };
            if (onOverwriteScope)
            {
                _local_1 = (_local_1 + (", onOverwriteScope:" + String(onOverwriteScope)));
            };
            if (onErrorScope)
            {
                _local_1 = (_local_1 + (", onErrorScope:" + String(onErrorScope)));
            };
            if (rounded)
            {
                _local_1 = (_local_1 + (", rounded:" + String(rounded)));
            };
            if (isPaused)
            {
                _local_1 = (_local_1 + (", isPaused:" + String(isPaused)));
            };
            if (timePaused)
            {
                _local_1 = (_local_1 + (", timePaused:" + String(timePaused)));
            };
            if (isCaller)
            {
                _local_1 = (_local_1 + (", isCaller:" + String(isCaller)));
            };
            if (count)
            {
                _local_1 = (_local_1 + (", count:" + String(count)));
            };
            if (timesCalled)
            {
                _local_1 = (_local_1 + (", timesCalled:" + String(timesCalled)));
            };
            if (waitFrames)
            {
                _local_1 = (_local_1 + (", waitFrames:" + String(waitFrames)));
            };
            if (hasStarted)
            {
                _local_1 = (_local_1 + (", hasStarted:" + String(hasStarted)));
            };
            return ((_local_1 + "]\n"));
        }


    }
}//package caurina.transitions
