//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.astar
{
    import flash.utils.Dictionary;
    import com.edgebee.atlas.util.Utils;

    public class AStarSearch 
    {

        private static const weight:Number = 1;

        private var start:AStarNode;
        private var end:AStarNode;
        private var closedSet:Array;
        private var openSet:PriorityQueue;
        private var contained:Dictionary;

        public function AStarSearch(_arg_1:AStarNode, _arg_2:AStarNode)
        {
            this.closedSet = new Array();
            this.openSet = new PriorityQueue(this.compare, 1000, this.print);
            this.contained = new Dictionary();
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
            this.end = _arg_2;
            _arg_1.costFromStart = 0;
            var _local_3:Number = this.estimateDistance(_arg_1);
            _arg_1.estimatedToEnd = (_arg_1.estimatedTotal = _local_3);
            _arg_1.cameFrom = null;
            this.openSet.enqueue(_arg_1);
        }

        public function cost():Number
        {
            return (this.end.costFromStart);
        }

        public function perform():Array
        {
            var _local_1:uint;
            var _local_2:uint;
            var _local_3:AStarNode;
            var _local_4:AStarNode;
            var _local_5:AStarConnection;
            var _local_6:AStarNode;
            var _local_7:int;
            var _local_8:Number;
            var _local_9:AStarNode;
            while (!(this.openSet.isEmpty()))
            {
                _local_3 = this.findBest();
                if (_local_3 == this.end)
                {
                    return (this.reconstructPath(this.end));
                };
                this.closedSet[_local_3.key] = _local_3;
                _local_4 = _local_3.cameFrom;
                _local_1 = 0;
                while (_local_1 < AStarNode.INVALID_AXIS)
                {
                    _local_2 = AStarNode.OPPOSITE_DIRECTION[_local_1];
                    _local_5 = _local_3.connections[_local_1];
                    if (_local_5.connected)
                    {
                        _local_6 = _local_5.node;
                        _local_7 = _local_6.key;
                        if (this.closedSet[_local_7] == undefined)
                        {
                            _local_8 = ((_local_3.costFromStart + weight) + _local_6.weight);
                            _local_9 = _local_3.connections[_local_2].node;
                            if (((((!((_local_4 == null))) && (!((_local_9 == null))))) && ((_local_4.key == _local_9.key))))
                            {
                                _local_8 = (_local_8 - 0.01);
                            };
                            if (this.contained[_local_7])
                            {
                                if (_local_8 < _local_6.costFromStart)
                                {
                                    _local_6.cameFrom = _local_3;
                                    _local_6.costFromStart = _local_8;
                                    _local_6.estimatedToEnd = this.estimateDistance(_local_6);
                                    _local_6.estimatedTotal = (_local_6.costFromStart + _local_6.estimatedToEnd);
                                };
                            }
                            else
                            {
                                _local_6.cameFrom = _local_3;
                                _local_6.costFromStart = _local_8;
                                _local_6.estimatedToEnd = this.estimateDistance(_local_6);
                                _local_6.estimatedTotal = (_local_6.costFromStart + _local_6.estimatedToEnd);
                                this.openSet.enqueue(_local_6);
                                this.contained[_local_7] = true;
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
            while (_local_3.cameFrom != null)
            {
                _local_3 = _local_3.cameFrom;
                _local_2.unshift(_local_3);
            };
            return (_local_2);
        }

        private function findBest():AStarNode
        {
            return ((this.openSet.dequeue() as AStarNode));
        }

        private function estimateDistance(_arg_1:AStarNode):Number
        {
            var _local_2:Number = (this.end.point.x - _arg_1.point.x);
            var _local_3:Number = (this.end.point.y - _arg_1.point.y);
            return (Math.sqrt(((_local_2 * _local_2) + (_local_3 * _local_3))));
        }

        private function compare(_arg_1:AStarNode, _arg_2:AStarNode):Boolean
        {
            return ((_arg_1.estimatedTotal < _arg_2.estimatedTotal));
        }

        private function print(_arg_1:*):String
        {
            var _local_2:AStarNode = (_arg_1 as AStarNode);
            return (Utils.formatString("EstimatedTotal:{estimatedTotal} X:{x} Y:{y}", {
                "estimatedTotal":_local_2.estimatedTotal,
                "x":_local_2.point.x,
                "y":_local_2.point.y
            }));
        }


    }
}//package com.edgebee.atlas.astar
