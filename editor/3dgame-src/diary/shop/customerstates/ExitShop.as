//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.customerstates
{
	import diary.shop.fsm.Result;

	public class ExitShop extends CustomerState
	{

		public function ExitShop(_arg_1:CustomerAgent)
		{
			super(_arg_1);
		}

		override public function transitionInto(_arg_1:Boolean = false):void
		{
			super.transitionInto(_arg_1);
			agent.dispose();
		}

		override public function loop(_arg_1:Boolean = false)
		{
			return (Result.STOP);
		}

		override public function transitionOut(_arg_1:Boolean = false):void
		{
			super.transitionOut(_arg_1);
		}

	}
} //package com.edgebee.shopr2.controller.agent.customerstates
