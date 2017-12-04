//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    

    public class ItemDropped
    {

        private var itemInstance:ItemInstance;
        private var itemDropped:Boolean;
        private var agent:ShopWorkerAgent;
        private var player:Player;

        public function ItemDropped(_arg_1:ShopWorkerAgent, _arg_2:ItemInstance, _arg_3:Player)
        {
            this.agent = _arg_1;
            this.itemInstance = _arg_2;
            this.player = _arg_3;
            _arg_1.itemDropped = this;
        }

        public function dropItem():void
        {
            var _local_1:uint;
            if (!this.itemDropped)
            {
                this.itemDropped = true;
                this.agent.workerInstance.isBusy = false;
                this.agent.poi.reserved = false;
                _local_1 = 1;
                if (this.agent.isCritical)
                {
                    _local_1 = (_local_1 + 1);
                    this.agent.isCritical = false;
                };
                this.itemInstance.crafted = (this.itemInstance.crafted + _local_1);
                this.itemInstance.count = (this.itemInstance.count + _local_1);
                this.agent.itemDropped = null;
                this.player.findTaskForWorkers();
            };
        }


    }
}//package com.edgebee.shopr2.controller.agent.workerstates
