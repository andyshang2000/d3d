//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.customerstates
{
	import flash.events.Event;

	import diary.shop.fsm.Result;

	public class WalkHome extends CustomerState
	{

		private var done:Boolean;
		private var startedToFade:Boolean;

		public function WalkHome(_arg_1:CustomerAgent)
		{
			super(_arg_1);
		}

		override public function transitionInto(_arg_1:Boolean = false):void
		{
			super.transitionInto(_arg_1);
			agent.continueUsingPath(client.player.pathsToHome[Utils.randomUint(0, (client.player.pathsToHome.length - 1))]);
			agent.addEventListener(Agent.REACHED_FINAL_DESTINATION, this.onReachedDestination);
			(agent.characterView as CustomerView).inShop = false;
		}

		override public function loop(_arg_1:Boolean = false)
		{
			var _local_2:* = super.loop(_arg_1);
			if (_local_2 != null)
			{
				return (_local_2);
			}
			;
			if (!this.startedToFade)
			{
				if ((((agent.characterView.getIsoX() >= 30)) || ((agent.characterView.getIsoY() >= 30))))
				{
					this.startedToFade = true;
					agent.characterView.fadeOut();
				}
				;
			}
			;
			if (this.done)
			{
				return (new Result(Result.TRANSITION, new ExitShop(agent)));
			}
			;
			return (Result.CONTINUE);
		}

		override public function transitionOut(_arg_1:Boolean = false):void
		{
			super.transitionOut(_arg_1);
		}

		private function onReachedDestination(_arg_1:Event):void
		{
			this.done = true;
		}

	}
} //package com.edgebee.shopr2.controller.agent.customerstates
