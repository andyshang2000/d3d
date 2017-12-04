//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.astar
{
    import com.edgebee.atlas.events.PropertyChangeEvent;
    
    import flash.events.EventDispatcher;
    import flash.geom.Point;

    public class PointOfInterest extends EventDispatcher 
    {
        private var _removed:Boolean = false;
        private var _reserved:Boolean;
        private var _point:Point;
        private var _observedPoint:Point;
        private var _pathFromEntrance:Array;
        private var _pathFromEntranceCost:Number;
        private var _pathToExit:Array;
        private var _pathToExitCost:Number;
        private var _dict:Object;

        public function PointOfInterest(_arg_1:Point, _arg_2:Point, _arg_3:Object)
        {
            this._point = _arg_1;
            this._observedPoint = _arg_2;
            this._reserved = false;
            if ((((_arg_1.x > 1000)) || ((_arg_1.y > 1000))))
            {
                throw (new Error("poi point values are way out!"));
            };
            this._dict = _arg_3;
            _arg_3[this.key] = this;
        }

        public static function createKey(_arg_1:Number, _arg_2:Number):String
        {
            return (((_arg_1.toString() + ":") + _arg_2.toString()));
        }


        public function get key():String
        {
            if (this._removed)
            {
                throw (new Error("has been removed"));
            };
            return (createKey(this._point.x, this._point.y));
        }

        public function remove():void
        {
            this._dict[this.key] = null;
            this._removed = true;
        }

        public function get reserved():Boolean
        {
            if (this._removed)
            {
                throw (new Error("has been removed"));
            };
            return (this._reserved);
        }

        public function set reserved(_arg_1:Boolean):void
        {
            if (this._removed)
            {
                throw (new Error("has been removed"));
            };
            if (((_arg_1) && (this.reserved)))
            {
                throw (Error("Can't reserve the same point of interest twice!"));
            };
            var _local_2:Boolean = this._reserved;
            this._reserved = _arg_1;
            if (_local_2 != this._reserved)
            {
                dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, this, "reserved", _local_2, this._reserved));
            };
        }

        public function get point():Point
        {
            if (this._removed)
            {
                throw (new Error("has been removed"));
            };
            return (this._point);
        }

        public function get observedPoint():Point
        {
            if (this._removed)
            {
                throw (new Error("has been removed"));
            };
            return (this._observedPoint);
        }

        public function getCost(_arg_1:Number, _arg_2:Number, _arg_3:Number):Number
        {
            if (this._removed)
            {
                throw (new Error("has been removed"));
            };
            var _local_4:PointOfInterest = (this._dict[createKey((this._point.x + _arg_1), (this._point.y + _arg_2))] as PointOfInterest);
            if (((!((_local_4 == null))) && (_local_4.reserved)))
            {
                return (_arg_3);
            };
            return (0);
        }

        public function get cost():Number
        {
            if (this._removed)
            {
                throw (new Error("has been removed"));
            };
            var _local_1:Number = 0;
            _local_1 = (_local_1 + this.getCost(1, 0, 50));
            _local_1 = (_local_1 + this.getCost(-1, 0, 50));
            _local_1 = (_local_1 + this.getCost(0, 1, 50));
            _local_1 = (_local_1 + this.getCost(0, -1, 50));
            _local_1 = (_local_1 + this.getCost(1, 1, 80));
            _local_1 = (_local_1 + this.getCost(-1, -1, 80));
            _local_1 = (_local_1 + this.getCost(-1, 1, 25));
            _local_1 = (_local_1 + this.getCost(1, -1, 25));
            _local_1 = (_local_1 + this.getCost(1, 2, 30));
            _local_1 = (_local_1 + this.getCost(1, -2, 30));
            _local_1 = (_local_1 + this.getCost(-1, 2, 30));
            _local_1 = (_local_1 + this.getCost(-1, -2, 30));
            _local_1 = (_local_1 + this.getCost(2, 1, 30));
            _local_1 = (_local_1 + this.getCost(2, -1, 30));
            _local_1 = (_local_1 + this.getCost(-2, 1, 30));
            _local_1 = (_local_1 + this.getCost(-2, -1, 30));
            _local_1 = (_local_1 + this.getCost(2, 0, 30));
            _local_1 = (_local_1 + this.getCost(-2, 0, 30));
            _local_1 = (_local_1 + this.getCost(0, 2, 30));
            return ((_local_1 + this.getCost(0, -2, 30)));
        }

        public function resetPrecalculatedPaths(_arg_1:AStarNode, _arg_2:AStarNode):void
        {
            var _local_3:AStarNode = this._pathFromEntrance[0];
            var _local_4:AStarNode = this._pathFromEntrance[(this._pathFromEntrance.length - 1)];
            if (((((((!((_local_4.point.x == this._point.x))) || (!((_local_4.point.y == this._point.y))))) || (!((_local_3.point.x == _arg_1.point.x))))) || (!((_local_3.point.y == _arg_1.point.y)))))
            {
                this._pathFromEntrance = null;
            };
            _local_4 = this._pathToExit[0];
            var _local_5:AStarNode = this._pathToExit[(this._pathToExit.length - 1)];
            if (((((((!((_local_4.point.x == this._point.x))) || (!((_local_4.point.y == this._point.y))))) || (!((_local_5.point.x == _arg_2.point.x))))) || (!((_local_5.point.y == _arg_2.point.y)))))
            {
                this._pathToExit = null;
            };
        }

        public function getPathFromEntrance(_arg_1:AStarNode, _arg_2:AStarMap):Array
        {
            var _local_3:AStarNode;
            var _local_4:AStarNode;
            var _local_5:AStarSearch;
            if (this._removed)
            {
                throw (new Error("has been removed"));
            };
            if (this._pathFromEntrance == null)
            {
                _local_3 = _arg_2.getNode(_arg_1.point.x, _arg_1.point.y);
                _local_4 = _arg_2.getNode(this._point.x, this._point.y);
                _local_5 = new AStarSearch(_local_3, _local_4);
                this._pathFromEntrance = _local_5.perform();
                this._pathFromEntranceCost = _local_5.cost();
            };
            return (this._pathFromEntrance);
        }

        public function getPathFromEntranceCost(_arg_1:AStarNode, _arg_2:AStarMap):Number
        {
            if (this._removed)
            {
                throw (new Error("has been removed"));
            };
            if (this._pathFromEntrance == null)
            {
                this.getPathFromEntrance(_arg_1, _arg_2);
            };
            return (this._pathFromEntranceCost);
        }

        public function getPathToExit(_arg_1:AStarNode, _arg_2:AStarMap):Array
        {
            var _local_3:AStarNode;
            var _local_4:AStarNode;
            var _local_5:AStarSearch;
            if (this._removed)
            {
                throw (new Error("has been removed"));
            };
            if (this._pathToExit == null)
            {
                _local_3 = _arg_2.getNode(this._point.x, this._point.y);
                _local_4 = _arg_2.getNode(_arg_1.point.x, _arg_1.point.y);
                _local_5 = new AStarSearch(_local_3, _local_4);
                this._pathToExit = _local_5.perform();
                this._pathToExitCost = _local_5.cost();
            };
            return (this._pathToExit);
        }

        public function getPathToExitCost(_arg_1:AStarNode, _arg_2:AStarMap):Number
        {
            if (this._removed)
            {
                throw (new Error("has been removed"));
            };
            if (this._pathToExit == null)
            {
                this.getPathToExit(_arg_1, _arg_2);
            };
            return (this._pathToExitCost);
        }


    }
}//package com.edgebee.atlas.astar
