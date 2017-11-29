package diary.avatar
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import flare.core.IComponent;
	import flare.core.Pivot3D;

	public class Wink implements IComponent
	{
		private var avatar:Avatar;
		private var tid:uint;

		public function added(target:Pivot3D):Boolean
		{
			this.avatar = target as Avatar;
			tid = setTimeout(wink, 5000);
			return true;
		}

		public function wink():void
		{
			avatar.playExpression("closeEye", 150);
			tid = setTimeout(function():void
			{
				clearTimeout(tid);
				wink();
			}, 5000 * Math.random() + 500);
		}

		public function removed():Boolean
		{
			clearTimeout(tid);
			return true;
		}
	}
}
