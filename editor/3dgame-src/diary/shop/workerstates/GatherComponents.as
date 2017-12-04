//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import com.edgebee.shopr2.data.item.RecipeComponent;
    import com.edgebee.shopr2.controller.agent.ShopWorkerAgent;
    import com.edgebee.atlas.util.fsm.Result;
    import com.edgebee.atlas.astar.PointOfInterest;
    import com.edgebee.shopr2.data.shop.ModuleInstance;
    import com.edgebee.shopr2.data.shop.Module;

    public class GatherComponents extends WorkerState 
    {

        private var neededComponents:Array;

        public function GatherComponents(_arg_1:ShopWorkerAgent)
        {
            var _local_2:RecipeComponent;
            super(_arg_1);
            this.neededComponents = [];
            for each (_local_2 in agent.workerInstance.fetchingRecipe.components)
            {
                this.neededComponents.push(_local_2);
            };
        }

        override public function loop(_arg_1:Boolean=false)
        {
            var _local_7:String;
            var _local_8:uint;
            var _local_9:RecipeComponent;
            var _local_10:RecipeComponent;
            var _local_11:Array;
            var _local_12:Boolean;
            var _local_2:* = super.loop(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            if (this.neededComponents.length == 0)
            {
                return (new Result(Result.TRANSITION, new FindWorkstation(agent)));
            };
            var _local_3:Number = Number.MAX_VALUE;
            var _local_4:PointOfInterest;
            var _local_5:RecipeComponent;
            var _local_6:ModuleInstance;
            for each (_local_10 in this.neededComponents)
            {
                if (_local_10.resource_id)
                {
                    _local_11 = agent.getClosestBinPOI(_local_10.resource, player.module_instances);
                    if (_local_11[0] == null)
                    {
                        _local_12 = _local_11[3];
                        if (!_local_12)
                        {
                            _local_11 = agent.getClosestPOI(Module.TYPE_CHEST, player.module_instances);
                        };
                    };
                    if (((!((_local_11[0] == null))) && ((_local_3 > _local_11[1]))))
                    {
                        _local_4 = _local_11[0];
                        _local_5 = _local_10;
                        _local_3 = _local_11[1];
                        _local_6 = _local_11[2];
                        _local_9 = _local_10;
                        _local_7 = _local_10.resource.image;
                        _local_8 = _local_10.quantity;
                    };
                }
                else
                {
                    if (_local_10.item_id)
                    {
                        _local_11 = agent.getClosestPOI(Module.TYPE_CHEST, player.module_instances);
                        if (((!((_local_11[0] == null))) && ((_local_3 > _local_11[1]))))
                        {
                            _local_4 = _local_11[0];
                            _local_5 = _local_10;
                            _local_3 = _local_11[1];
                            _local_6 = _local_11[2];
                            _local_9 = _local_10;
                            _local_7 = _local_10.item.image;
                            _local_8 = _local_10.quantity;
                        };
                    };
                };
            };
            if (_local_4 != null)
            {
                this.neededComponents.splice(this.neededComponents.indexOf(_local_5), 1);
                agent.leave();
                agent.poi = _local_4;
                agent.poi.reserved = true;
                return (new Result(Result.TRANSITION, new GoToPOI(agent, _local_6, _local_4, this, _local_7, _local_8, _local_9, true)));
            };
        }


    }
}//package com.edgebee.shopr2.controller.agent.workerstates
