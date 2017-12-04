//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.customerstates
{
	import flash.events.Event;

	import diary.shop.fsm.Result;

	public class WalkToShop extends CustomerState
	{
		private var done:Boolean;
		private var _pathToEntrance:Array;

		public function WalkToShop(_arg_1:CustomerAgent, _arg_2:Array)
		{
			super(_arg_1);
			this._pathToEntrance = _arg_2;
		}

		override public function transitionInto(_arg_1:Boolean = false):void
		{
			super.transitionInto(_arg_1);
			agent.walkUsingPath(this._pathToEntrance);
			agent.addEventListener(Agent.REACHED_FINAL_DESTINATION, this.onReachedDestination);
			agent.findPOI();
			if (agent.poi != null)
			{
				agent.poi.reserved = true;
			}
		}

		override public function loop(_arg_1:Boolean = false)
		{
			var _local_2:* = super.loop(_arg_1);
			if (_local_2 != null)
			{
				return (_local_2);
			}
			if (this.done)
			{
				return (new Result(Result.TRANSITION, new WalkToRack(agent)));
			}
		}

		override public function transitionOut(_arg_1:Boolean = false):void
		{
			super.transitionOut(_arg_1);
			agent.removeEventListener(Agent.REACHED_FINAL_DESTINATION, this.onReachedDestination);
		}

		private function onReachedDestination(_arg_1:Event):void
		{
			this.done = true;
		}
	}
} //package com.edgebee.shopr2.controller.agent.customerstates
