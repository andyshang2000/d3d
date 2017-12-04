//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.customerstates
{
	import flash.geom.Point;

	import diary.shop.fsm.Result;

	public class EnterShop extends CustomerState
	{

		private var _pathToEntrance:Array;
		private var _spawnInsideShop:Boolean;

		public function EnterShop(_arg_1:CustomerAgent)
		{
			super(_arg_1);
		}

		override public function transitionInto(_arg_1:Boolean = false):void
		{
			var _local_4:AStarNode;
			super.transitionInto(_arg_1);
			var _local_2:int = (agent.visitingCustomer.leave_tick - agent.visitingCustomer.enter_tick);
			var _local_3:int = (_local_2 / 3);
			this._spawnInsideShop = (player.day_tick > (agent.visitingCustomer.enter_tick + _local_3));
			if (this._spawnInsideShop)
			{
				agent.findPOI();
				agent.poi.reserved = true;
				agent.characterView.setInitialPosition(new Point(agent.poi.point.x, agent.poi.point.y), agent.scene);
				(agent.characterView as CustomerView).inShop = true;
				agent.lookAtCamera();
				(agent.characterView as CustomerView).canInteract = true;
			}
			else
			{
				this._pathToEntrance = client.player.pathsToEntrance[Utils.randomUint(0, (client.player.pathsToEntrance.length - 1))];
				_local_4 = (this._pathToEntrance[0] as AStarNode);
				agent.characterView.setInitialPosition(_local_4.point, agent.scene);
			}
			agent.addToScene();
			agent.characterView.fadeIn();
		}

		override public function loop(_arg_1:Boolean = false)
		{
			var _local_2:* = super.loop(_arg_1);
			if (_local_2 != null)
			{
				return (_local_2);
			}
			if (agent.player.day_tick >= agent.visitingCustomer.leave_tick)
			{
				return (new Result(Result.TRANSITION, new WalkToExit(agent)));
			}
			if (this._spawnInsideShop)
			{
				return (new Result(Result.TRANSITION, new Idle(agent)));
			}
			return (new Result(Result.TRANSITION, new WalkToShop(agent, this._pathToEntrance)));
		}

		override public function transitionOut(_arg_1:Boolean = false):void
		{
			super.transitionOut(_arg_1);
		}

	}
} //package com.edgebee.shopr2.controller.agent.customerstates
