//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.astar
{
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import com.edgebee.atlas.events.PropertyChangeEvent;

    public class AStarNode extends EventDispatcher 
    {

        public static const SOUTH:uint = 0;
        public static const NORTH:uint = 1;
        public static const EAST:uint = 2;
        public static const WEST:uint = 3;
        public static const INVALID_AXIS:uint = 4;
        public static const KEY_MULTIPLIER:int = 1000;
        public static const OPPOSITE_DIRECTION:Array = [NORTH, SOUTH, WEST, EAST];

        private var _point:Point;
        public var key:int;
        private var _connections:Array;
        private var _weight:Number;
        public var _type:uint;
        public var costFromStart:Number;
        public var estimatedToEnd:Number;
        public var estimatedTotal:Number;
        public var cameFrom:AStarNode;

        public function AStarNode(_arg_1:Number, _arg_2:Number, _arg_3:uint=0)
        {
            this._connections = [];
            super();
            this._point = new Point(_arg_1, _arg_2);
            this.key = ((_arg_1 * KEY_MULTIPLIER) + _arg_2);
            this._weight = 1;
            this._type = _arg_3;
            this._connections[SOUTH] = new AStarConnection();
            this._connections[NORTH] = new AStarConnection();
            this._connections[EAST] = new AStarConnection();
            this._connections[WEST] = new AStarConnection();
        }

        public function get point():Point
        {
            return (this._point);
        }

        public function get weight():Number
        {
            return (this._weight);
        }

        public function set weight(_arg_1:Number):void
        {
            var _local_2:uint = this._weight;
            this._weight = _arg_1;
            dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, this, "weight", _local_2, this._weight));
        }

        public function isConnected(_arg_1:uint):Boolean
        {
            var _local_2:AStarConnection = this._connections[_arg_1];
            return (((_local_2) && (_local_2.connected)));
        }

        public function get south():AStarNode
        {
            return (this.getNode(SOUTH));
        }

        public function set south(_arg_1:AStarNode):void
        {
            this.setConnection(SOUTH, _arg_1);
        }

        public function get north():AStarNode
        {
            return (this.getNode(NORTH));
        }

        public function set north(_arg_1:AStarNode):void
        {
            this.setConnection(NORTH, _arg_1);
        }

        public function get east():AStarNode
        {
            return (this.getNode(EAST));
        }

        public function set east(_arg_1:AStarNode):void
        {
            this.setConnection(EAST, _arg_1);
        }

        public function get west():AStarNode
        {
            return (this.getNode(WEST));
        }

        public function set west(_arg_1:AStarNode):void
        {
            this.setConnection(WEST, _arg_1);
        }

        public function getConnections(_arg_1:AStarNode):Array
        {
            var _local_3:AStarConnection;
            var _local_2:Array = new Array();
            for each (_local_3 in this.connections)
            {
                if (_local_3.node == _arg_1)
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        private function getNode(_arg_1:uint):AStarNode
        {
            var _local_2:AStarConnection = this._connections[_arg_1];
            if (_local_2)
            {
                return (_local_2.node);
            };
            return (null);
        }

        private function setConnection(_arg_1:uint, _arg_2:AStarNode):void
        {
            if ((((_arg_2 == null)) && ((this._connections[_arg_1].connected == true))))
            {
                throw (Error("null node."));
            };
            this._connections[_arg_1].node = _arg_2;
        }

        public function get connections():Array
        {
            return (this._connections);
        }

        override public function toString():String
        {
            return (((((("x: " + this._point.x.toString()) + " y: ") + this._point.y.toString()) + " cost: ") + this._weight));
        }


    }
}//package com.edgebee.atlas.astar
