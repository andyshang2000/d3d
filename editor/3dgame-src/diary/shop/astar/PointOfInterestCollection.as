//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.astar
{
    import com.edgebee.atlas.events.PropertyChangeEvent;

    public class PointOfInterestCollection 
    {

        private var _freePointOfInterests:Array;
        private var _pointInterests:Array;

        public function PointOfInterestCollection()
        {
            this._freePointOfInterests = new Array();
            this._pointInterests = new Array();
        }

        public function add(_arg_1:PointOfInterest):void
        {
            if (!_arg_1.reserved)
            {
                this._freePointOfInterests.push(_arg_1);
            };
            this._pointInterests.push(_arg_1);
            _arg_1.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.onPoiReserved, false, 0, true);
        }

        public function remove(_arg_1:PointOfInterest):void
        {
            var _local_2:uint;
            if (_arg_1.reserved)
            {
                _local_2 = this._freePointOfInterests.indexOf(_arg_1);
                this._freePointOfInterests.splice(_local_2, 1);
            };
            _local_2 = this._pointInterests.indexOf(_arg_1);
            this._pointInterests.splice(_local_2, 1);
            _arg_1.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this.onPoiReserved);
        }

        public function addCollection(_arg_1:PointOfInterestCollection):void
        {
            var _local_2:PointOfInterest;
            for each (_local_2 in _arg_1.pointOfInterests)
            {
                this.add(_local_2);
            };
        }

        public function removeCollection(_arg_1:PointOfInterestCollection):void
        {
            var _local_2:PointOfInterest;
            for each (_local_2 in _arg_1.pointOfInterests)
            {
                this.remove(_local_2);
            };
        }

        public function get freePointOfInterests():Array
        {
            return (this._freePointOfInterests);
        }

        public function get pointOfInterests():Array
        {
            return (this._pointInterests);
        }

        private function onPoiReserved(_arg_1:PropertyChangeEvent):void
        {
            var _local_3:uint;
            var _local_2:PointOfInterest = (_arg_1.source as PointOfInterest);
            if ((_arg_1.source as PointOfInterest).reserved)
            {
                _local_3 = this._freePointOfInterests.indexOf(_local_2);
                this._freePointOfInterests.splice(_local_3, 1);
            }
            else
            {
                this._freePointOfInterests.push(_local_2);
            };
        }


    }
}//package com.edgebee.atlas.astar
