//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.astar
{
    import com.edgebee.atlas.events.PropertyChangeEvent;

    public class AStarMap 
    {

        private var nodes:Object;
        private var _dirty:Boolean;

        public function AStarMap()
        {
            this.nodes = new Object();
            super();
        }

        public function linkNodes():void
        {
            var _local_1:AStarNode;
            var _local_2:AStarNode;
            if (this._dirty)
            {
                this._dirty = false;
                for each (_local_2 in this.nodes)
                {
                    _local_2.connections[AStarNode.SOUTH].connected = false;
                    _local_2.south = null;
                    _local_2.connections[AStarNode.NORTH].connected = false;
                    _local_2.north = null;
                    _local_2.connections[AStarNode.EAST].connected = false;
                    _local_2.east = null;
                    _local_2.connections[AStarNode.WEST].connected = false;
                    _local_2.west = null;
                    _local_1 = this.getNode(_local_2.point.x, (_local_2.point.y - 1));
                    if (((!((_local_1 == null))) && ((_local_1._type == _local_2._type))))
                    {
                        _local_2.connections[AStarNode.SOUTH].connected = true;
                        _local_2.south = _local_1;
                    };
                    _local_1 = this.getNode(_local_2.point.x, (_local_2.point.y + 1));
                    if (((!((_local_1 == null))) && ((_local_1._type == _local_2._type))))
                    {
                        _local_2.connections[AStarNode.NORTH].connected = true;
                        _local_2.north = _local_1;
                    };
                    _local_1 = this.getNode((_local_2.point.x + 1), _local_2.point.y);
                    if (((!((_local_1 == null))) && ((_local_1._type == _local_2._type))))
                    {
                        _local_2.connections[AStarNode.EAST].connected = true;
                        _local_2.east = _local_1;
                    };
                    _local_1 = this.getNode((_local_2.point.x - 1), _local_2.point.y);
                    if (((!((_local_1 == null))) && ((_local_1._type == _local_2._type))))
                    {
                        _local_2.connections[AStarNode.WEST].connected = true;
                        _local_2.west = _local_1;
                    };
                };
            };
        }

        public function addNode(_arg_1:AStarNode):void
        {
            if (this.nodes.hasOwnProperty(_arg_1.key))
            {
                throw (new Error("Not possible to have to A Star Node at the same place"));
            };
            this.nodes[_arg_1.key] = _arg_1;
            this._dirty = true;
            _arg_1.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.onPropertyChangeEvent);
        }

        public function removeNodeAt(_arg_1:int, _arg_2:int):AStarNode
        {
            var _local_3:int = ((_arg_1 * AStarNode.KEY_MULTIPLIER) + _arg_2);
            var _local_4:AStarNode = this.nodes[_local_3];
            _local_4.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.onPropertyChangeEvent);
            delete this.nodes[_local_3];
            this._dirty = true;
            return (_local_4);
        }

        public function removeNode(_arg_1:AStarNode):AStarNode
        {
            return (this.removeNodeAt(_arg_1.point.x, _arg_1.point.y));
        }

        public function getNode(_arg_1:int, _arg_2:int):AStarNode
        {
            return (this.nodes[((_arg_1 * AStarNode.KEY_MULTIPLIER) + _arg_2)]);
        }

        public function onPropertyChangeEvent(_arg_1:PropertyChangeEvent):void
        {
            this._dirty = true;
        }


    }
}//package com.edgebee.atlas.astar
