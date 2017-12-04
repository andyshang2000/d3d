//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.customerstates
{
	import flash.events.TimerEvent;
	
	import diary.shop.fsm.Result;

	public class Idle extends CustomerState
	{

		private static const MIN_BLINK_INTERVAL:Number = 1500;
		private static const BLINK_INTERVAL_RANDOM:Number = 1500;

		private var inHurry:Boolean = false;
		private var _blinkTimer:ClockTimer;
		private var _showTutorial:Boolean;
		private var _showTutorialTimer:ClockTimer;

		public function Idle(_arg_1:CustomerAgent)
		{
			super(_arg_1);
		}

		override public function transitionInto(_arg_1:Boolean = false):void
		{
			super.transitionInto(_arg_1);
			agent.characterView.idle();
			if ((((agent.visitingCustomer.type == VisitingCustomer.TYPE_QUEST_INTRO)) || ((agent.visitingCustomer.type == VisitingCustomer.TYPE_NEW_HUNT))))
			{
				agent.setBubbleType(BubbleView.QUEST);
			}
			else
			{
				if ((((agent.visitingCustomer.type == VisitingCustomer.TYPE_QUEST_ENDING)) || ((agent.visitingCustomer.type == VisitingCustomer.TYPE_RETURNING_FROM_HUNT))))
				{
					agent.setBubbleType(BubbleView.STAR);
				}
				else
				{
					if (agent.visitingCustomer.type == VisitingCustomer.TYPE_SELL_ITEM)
					{
						agent.setBubbleType(BubbleView.GOLD);
					}
					else
					{
						if (agent.visitingCustomer.type == VisitingCustomer.TYPE_RETURNING_FROM_WAR)
						{
							agent.setBubbleType(BubbleView.WAR);
						}
						else
						{
							if (agent.visitingCustomer.type == VisitingCustomer.TYPE_WAR_ANNOUNCMENT)
							{
								agent.setBubbleType(BubbleView.WAR);
							}
							else
							{
								agent.setBubbleType(BubbleView.QUESTION);
							}
							;
						}
						;
					}
					;
				}
				;
			}
			;
			if (((agent.visitingCustomer.customer) && (!((agent.visitingCustomer.wantedItem == null)))))
			{
				agent.setBubbleType(BubbleView.EMPTY);
				agent.setBubbleSubImageTextureName(agent.visitingCustomer.wantedItem.image, 0, agent.visitingCustomer.wantedItem.hue);
			}
			;
			if (!player.isTutorialDone(Player.TUTORIAL_CUSTOMER_IDLE))
			{
				this._showTutorialTimer = new ClockTimer(UIGlobals.root.client.mainClock, 3000, 1);
				this._showTutorialTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onShowTutorialTimer);
				this._showTutorialTimer.start();
			}
			;
			this._blinkTimer = new ClockTimer(UIGlobals.root.client.mainClock, (MIN_BLINK_INTERVAL + (Math.random() * BLINK_INTERVAL_RANDOM)), 1);
			this._blinkTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onBlinkTimer);
			this._blinkTimer.start();
		}

		override public function loop(_arg_1:Boolean = false)
		{
			var _local_3:GameView;
			var _local_4:uint;
			var _local_2:* = super.loop(_arg_1);
			if (_local_2 != null)
			{
				return (_local_2);
			}
			;
			if (((this._showTutorial) && (!(player.isTutorialDone(Player.TUTORIAL_CUSTOMER_IDLE)))))
			{
				this._showTutorial = false;
				_local_3 = (UIGlobals.gameView as GameView);
				_local_3.tutorialView.tutorialInfo = TutorialInfo.getInstanceByUid("customer_idle");
				_local_3.sceneView.resetCameraPosition();
			}
			;
			if (((!(this.inHurry)) && (((agent.visitingCustomer.leave_tick - agent.player.day_tick) < 100))))
			{
				agent.hurry();
				this.inHurry = true;
			}
			;
			if ((((agent.player.day_tick >= agent.visitingCustomer.leave_tick)) && (agent.customerInstance)))
			{
				_local_4 = CustomerInfoDisplay.getAffinityLevel(agent.customerInstance.shop_affinity);
				if (_local_4 == CustomerInfoDisplay.AFFINITY_BAD)
				{
					agent.setBubbleType(BubbleView.ANGRY);
				}
				else
				{
					if (_local_4 == CustomerInfoDisplay.AFFINITY_POOR)
					{
						agent.setBubbleType(BubbleView.SAD);
					}
					else
					{
						agent.setBubbleType(BubbleView.NEUTRAL);
					}
					;
				}
				;
				return (new Result(Result.TRANSITION, new WalkToExit(agent)));
			}
			;
			if (agent.visitingCustomer.hasBeenServed)
			{
				return (new Result(Result.TRANSITION, new WalkToExit(agent)));
			}
			;
			return (Result.CONTINUE);
		}

		override public function transitionOut(_arg_1:Boolean = false):void
		{
			super.transitionOut(_arg_1);
			this._blinkTimer.stop();
		}

		private function onShowTutorialTimer(_arg_1:TimerEvent):void
		{
			this._showTutorial = true;
		}

		private function onBlinkTimer(_arg_1:TimerEvent):void
		{
			this._blinkTimer.reset();
			this._blinkTimer.delay = (MIN_BLINK_INTERVAL + (Math.random() * BLINK_INTERVAL_RANDOM));
			this._blinkTimer.repeatCount = 1;
			this._blinkTimer.start();
			(agent.characterView as CustomerView).blink(this.onBlinkEnd);
		}

		private function onBlinkEnd():void
		{
			agent.characterView.idle();
		}

	}
} //package com.edgebee.shopr2.controller.agent.customerstates
