//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.astar
{
    public class AStarConnection 
    {

        public var node:AStarNode;
        public var connected:Boolean;
        public var weight:Number;

        public function AStarConnection()
        {
            this.node = null;
            this.connected = false;
            this.weight = 0;
        }

    }
}//package com.edgebee.atlas.astar
