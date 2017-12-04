//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.astar
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import com.edgebee.atlas.util.Utils;
    import flash.geom.Point;
    import __AS3__.vec.*;

    public class AStarMultipleSearch 
    {

        private static const weight:Number = 1;

        private var start:AStarNode;
        private var ends:Vector.<AStarNode>;
        private var endsFound:Vector.<Boolean>;
        private var closedSet:Array;
        private var openSet:PriorityQueue;
        private var costFromStart:Array;
        private var estimatedToEnd:Array;
        private var estimatedTotal:Array;
        private var cameFrom:Array;

        public function AStarMultipleSearch(_arg_1:AStarNode, _arg_2:Vector.<AStarNode>)
        {
            var _local_3:AStarNode;
            var _local_4:Number;
            this.closedSet = new Array();
            this.openSet = new PriorityQueue(this.compare, 1000, this.print);
            this.costFromStart = new Array();
            this.estimatedToEnd = new Array();
            this.estimatedTotal = new Array();
            this.cameFrom = new Array();
            super();
            if (_arg_1 == null)
            {
                throw (Error("Invalid start node."));
            };
            if (_arg_2 == null)
            {
                throw (Error("Invalid end node."));
            };
            this.start = _arg_1;
            this.ends = _arg_2;
            this.endsFound = new Vector.<Boolean>();
            for each (_local_3 in _arg_2)
            {
                this.endsFound.push(false);
            };
            this.costFromStart[_arg_1.key] = 0;
            _local_4 = this.estimateDistance(_arg_1);
            this.estimatedToEnd[_arg_1.key] = _local_4;
            this.estimatedTotal[_arg_1.key] = _local_4;
            this.openSet.enqueue(_arg_1);
        }

        public function costs():Dictionary
        {
            var _local_2:AStarNode;
            var _local_1:Dictionary = new Dictionary();
            for each (_local_2 in this.ends)
            {
                _local_1[_local_2.key] = this.costFromStart[_local_2.key];
            };
            return (_local_1);
        }

        public function perform():Array
        {
            var _local_1:uint;
            var _local_2:uint;
            var _local_3:int;
            var _local_4:AStarNode;
            var _local_5:Boolean;
            var _local_6:AStarNode;
            var _local_7:AStarNode;
            var _local_8:Array;
            var _local_9:AStarConnection;
            var _local_10:AStarNode;
            var _local_11:Number;
            var _local_12:AStarNode;
            var _local_13:Boolean;
            while (!(this.openSet.isEmpty()))
            {
                _local_4 = this.findBest();
                _local_5 = false;
                _local_3 = 0;
                while (_local_3 < this.ends.length)
                {
                    if (!this.endsFound[_local_3])
                    {
                        _local_7 = this.ends[_local_3];
                        if (_local_4 == _local_7)
                        {
                            this.endsFound[_local_3] = true;
                        }
                        else
                        {
                            _local_5 = true;
                        };
                    };
                    _local_3++;
                };
                if (!_local_5)
                {
                    _local_8 = [];
                    _local_3 = 0;
                    while (_local_3 < this.ends.length)
                    {
                        _local_8.push(this.reconstructPath(this.ends[_local_3]));
                        _local_3++;
                    };
                    return (_local_8);
                };
                this.closedSet[_local_4.key] = _local_4;
                _local_6 = this.cameFrom[_local_4.key];
                _local_1 = 0;
                while (_local_1 < AStarNode.INVALID_AXIS)
                {
                    _local_2 = AStarNode.OPPOSITE_DIRECTION[_local_1];
                    _local_9 = _local_4.connections[_local_1];
                    if (_local_9.connected)
                    {
                        _local_10 = _local_9.node;
                        if (this.closedSet[_local_10.key] == undefined)
                        {
                            _local_11 = ((this.costFromStart[_local_4.key] + weight) + _local_10.weight);
                            _local_12 = _local_4.connections[_local_2].node;
                            if (((((!((_local_6 == null))) && (!((_local_12 == null))))) && ((_local_6.key == _local_12.key))))
                            {
                                _local_11 = (_local_11 - 0.01);
                            };
                            _local_13 = this.openSet.contains(_local_10);
                            if (((!(_local_13)) || ((_local_11 < this.costFromStart[_local_10.key]))))
                            {
                                if (_local_13)
                                {
                                    this.openSet.remove(_local_10);
                                };
                                this.cameFrom[_local_10.key] = _local_4;
                                this.costFromStart[_local_10.key] = _local_11;
                                this.estimatedToEnd[_local_10.key] = this.estimateDistance(_local_10);
                                this.estimatedTotal[_local_10.key] = (this.costFromStart[_local_10.key] + this.estimatedToEnd[_local_10.key]);
                                this.openSet.enqueue(_local_10);
                            };
                        };
                    };
                    _local_1++;
                };
            };
            throw (new Error("Could not find path."));
        }

        private function reconstructPath(_arg_1:AStarNode):Array
        {
            var _local_2:Array = new Array();
            _local_2.unshift(_arg_1);
            var _local_3:AStarNode = _arg_1;
            while (this.cameFrom[_local_3.key] != undefined)
            {
                _local_3 = this.cameFrom[_local_3.key];
                _local_2.unshift(_local_3);
            };
            return (_local_2);
        }

        private function findBest():AStarNode
        {
            return ((this.openSet.dequeue() as AStarNode));
        }

        private function compare(_arg_1:*, _arg_2:*):Boolean
        {
            return ((this.estimatedTotal[(_arg_1 as AStarNode).key] < this.estimatedTotal[(_arg_2 as AStarNode).key]));
        }

        private function print(_arg_1:*):String
        {
            return (Utils.formatString("EstimatedTotal:{estimatedTotal} X:{x} Y:{y}", {
                "estimatedTotal":this.estimatedTotal[(_arg_1 as AStarNode).key],
                "x":(_arg_1 as AStarNode).point.x,
                "y":(_arg_1 as AStarNode).point.y
            }));
        }

        private function estimateDistance(_arg_1:AStarNode):Number
        {
            var _local_2:Point = this.ends[0].point.subtract(_arg_1.point);
            return (_local_2.length);
        }


    }
}//package com.edgebee.atlas.astar
