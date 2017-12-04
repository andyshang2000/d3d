//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.customerstates
{
    import diary.shop.fsm.State;
    
    import zzsdk.editor.utils.Client;

    public class CustomerState extends State
    {

        public function CustomerState(_arg_1:CustomerAgent)
        {
            super(_arg_1);
        }

        protected function get agent():CustomerAgent
        {
            return ((machine as CustomerAgent));
        }

        protected function get visitingCustomer():VisitingCustomer
        {
            return (this.agent.visitingCustomer);
        }

        protected function get customerInstance():CustomerInstance
        {
            return (this.agent.customerInstance);
        }

        protected function get client():Client
        {
            return (this.agent.client);
        }

        protected function get player():Player
        {
            return (this.agent.player);
        }

        override public function loop(_arg_1:Boolean=false)
        {
        }


    }
}//package com.edgebee.shopr2.controller.agent.customerstates
