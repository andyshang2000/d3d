//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.customerstates
{
	import diary.shop.fsm.Result;

	public class WaitingToEnter extends CustomerState
	{

		public function WaitingToEnter(_arg_1:CustomerAgent)
		{
			super(_arg_1);
		}

		override public function transitionInto(_arg_1:Boolean = false):void
		{
			(agent.characterView as CustomerView).canInteract = false;
			super.transitionInto(_arg_1);
		}

		override public function loop(_arg_1:Boolean = false)
		{
			var _local_2:* = super.loop(_arg_1);
			if (_local_2 != null)
			{
				return (_local_2);
			}
			;
			if (player.day_tick >= visitingCustomer.enter_tick)
			{
				return (new Result(Result.TRANSITION, new EnterShop(agent)));
			}
			;
			return (Result.CONTINUE);
		}

		override public function transitionOut(_arg_1:Boolean = false):void
		{
			super.transitionOut(_arg_1);
		}

	}
} //package com.edgebee.shopr2.controller.agent.customerstates
