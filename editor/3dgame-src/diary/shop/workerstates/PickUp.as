//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.workerstates
{
    import com.edgebee.atlas.util.ClockTimer;
    import com.edgebee.atlas.astar.PointOfInterest;
    import com.edgebee.shopr2.data.item.RecipeComponent;
    import com.edgebee.shopr2.data.shop.ModuleInstance;
    import com.edgebee.shopr2.controller.agent.ShopWorkerAgent;
    import com.edgebee.shopr2.ui.item.ItemPopUpView;
    import com.edgebee.atlas.ui.UIGlobals;
    import com.edgebee.atlas.util.fsm.Result;

    public class PickUp extends WorkerState 
    {

        private var _timer:ClockTimer;
        private var _poi:PointOfInterest;
        private var _nextState:WorkerState;
        private var _componentTextureName:String;
        private var _componentQuantity:uint;
        private var _component:RecipeComponent;
        private var _moduleInstance:ModuleInstance;
        private var _up:Boolean;
        private var callback:Function;

        public function PickUp(_arg_1:ShopWorkerAgent, _arg_2:ModuleInstance, _arg_3:PointOfInterest, _arg_4:WorkerState, _arg_5:String, _arg_6:uint, _arg_7:RecipeComponent, _arg_8:Boolean, _arg_9:Function=null)
        {
            super(_arg_1);
            this._poi = _arg_3;
            this._nextState = _arg_4;
            this._componentTextureName = _arg_5;
            this._componentQuantity = _arg_6;
            this._component = _arg_7;
            this._moduleInstance = _arg_2;
            this._up = _arg_8;
            this.callback = _arg_9;
        }

        override public function transitionInto(_arg_1:Boolean=false):void
        {
            var _local_2:Number;
            super.transitionInto(_arg_1);
            agent.characterView.idle(this._poi.observedPoint);
            this._timer = new ClockTimer(client.mainClock, (500 / client.timeMultiplier), 1);
            this._timer.start();
            if (this._componentTextureName != null)
            {
                _local_2 = 0;
                if (((this._component) && (this._component.item_id)))
                {
                    _local_2 = this._component.item.hue;
                };
                new ItemPopUpView(this._componentTextureName, this._componentQuantity, this._moduleInstance.moduleController.childISRO[0].isro, this._up, _local_2);
            };
            if (this._component)
            {
                if (this._component.resource_id)
                {
                    switch (this._component.resource.codename)
                    {
                        case "raw_iron":
                            UIGlobals.playSound(shopr2_flash.IronWav);
                            break;
                        case "raw_wood":
                            UIGlobals.playSound(shopr2_flash.WoodWav);
                            break;
                        case "raw_herbs":
                            UIGlobals.playSound(shopr2_flash.HerbsWav);
                            break;
                        case "raw_leather":
                            UIGlobals.playSound(shopr2_flash.LeatherWav);
                            break;
                        case "raw_fabric":
                            UIGlobals.playSound(shopr2_flash.FabricWav);
                            break;
                        case "raw_elfwood":
                            UIGlobals.playSound(shopr2_flash.ElfwoodWav);
                            break;
                        case "raw_powder":
                            UIGlobals.playSound(shopr2_flash.SandWav);
                            break;
                        case "raw_dyes":
                            UIGlobals.playSound(shopr2_flash.DyeWav);
                            break;
                        case "raw_glass":
                            UIGlobals.playSound(shopr2_flash.GlassWav);
                            break;
                        case "raw_oil":
                            UIGlobals.playSound(shopr2_flash.OilWav);
                            break;
                        case "raw_steel":
                            UIGlobals.playSound(shopr2_flash.SteelWav);
                            break;
                        case "raw_ironwood":
                            UIGlobals.playSound(shopr2_flash.IronwoodWav);
                            break;
                        case "raw_crystal":
                            UIGlobals.playSound(shopr2_flash.CrystalWav);
                            break;
                        case "raw_gems":
                            UIGlobals.playSound(shopr2_flash.GemsWav);
                            break;
                        case "raw_mithril":
                            UIGlobals.playSound(shopr2_flash.MithrilWav);
                            break;
                    };
                }
                else
                {
                    if (this._component.item_id)
                    {
                        UIGlobals.playSound(shopr2_flash.PaperWav);
                    };
                };
            };
            if (this.callback != null)
            {
                this.callback();
            };
        }

        override public function loop(_arg_1:Boolean=false)
        {
            var _local_2:* = super.loop(_arg_1);
            if (_local_2 != null)
            {
                return (_local_2);
            };
            if (!this._timer.running)
            {
                return (new Result(Result.TRANSITION, this._nextState));
            };
        }

        override public function transitionOut(_arg_1:Boolean=false):void
        {
            super.transitionOut(_arg_1);
        }


    }
}//package com.edgebee.shopr2.controller.agent.workerstates
