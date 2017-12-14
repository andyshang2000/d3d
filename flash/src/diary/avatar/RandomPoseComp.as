package diary.avatar
{
	import flare.core.IComponent;
	import flare.core.Pivot3D;

	import starling.animation.IAnimatable;
	import starling.core.Starling;

	public class RandomPoseComp implements IComponent, IAnimatable
	{
		private var avatar:Avatar;

		public function advanceTime(time:Number):void
		{
			if (avatar)
				avatar.tick(time);
		}

		public function added(target:Pivot3D):Boolean
		{
			avatar = target as Avatar;
			if (!avatar)
				return false;

			Starling.juggler.add(this);
			return true;
		}

		public function removed():Boolean
		{
			Starling.juggler.remove(this);
			return true;
		}
	}
}

