package diary.avatar
{
	import com.popchan.framework.core.MsgDispatcher;
	import com.popchan.sugar.core.Model;
	import com.popchan.sugar.core.events.GameEvents;

	import flare.core.IComponent;
	import flare.core.Pivot3D;

	import starling.animation.IAnimatable;
	import starling.core.Starling;

	public class MatchRespond implements IComponent, IAnimatable
	{
		private var avatar:Avatar;

		public function MatchRespond()
		{
			MsgDispatcher.add(GameEvents.SCORE_CHANGE, onScoreChange);
			MsgDispatcher.add(GameEvents.OPEN_GAME_END_UI, onGameOver);
		}

		public function advanceTime(time:Number):void
		{
			if (!avatar)
				return;
		}

		public function added(target:Pivot3D):Boolean
		{
			Starling.juggler.add(this);
			avatar = target as Avatar;
			return true;
		}

		public function removed():Boolean
		{
			Starling.juggler.remove(this);
			MsgDispatcher.remove(GameEvents.SCORE_CHANGE, this.onScoreChange);
			MsgDispatcher.remove(GameEvents.OPEN_GAME_END_UI, onGameOver);
			return true;
		}

		private function onGameOver():void
		{
			if (Model.gameModel.isSuccess)
			{
			}
		}

		private function onScoreChange():void
		{
//			avatar.updatePose();
		}
	}
}
