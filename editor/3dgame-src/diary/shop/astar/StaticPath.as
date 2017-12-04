//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.astar
{
    public class StaticPath 
    {

        private var nodes:Array;
        private var nextNodeIndex:uint;

        public function StaticPath(_arg_1:Array)
        {
            this.nodes = _arg_1;
        }

        public function getNextNode():AStarNode
        {
            var _local_1:AStarNode = this.nodes[this.nextNodeIndex];
            this.nextNodeIndex++;
            return (_local_1);
        }

        public function done():Boolean
        {
            return ((this.nextNodeIndex == this.nodes.length));
        }


    }
}//package com.edgebee.atlas.astar
