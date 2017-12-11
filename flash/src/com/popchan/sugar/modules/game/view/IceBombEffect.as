//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.ds.BasePool;
	import com.popchan.framework.utils.ToolKit;

	import starling.display.MovieClip;
	import starling.events.Event;

	public class IceBombEffect extends Element
	{

		public static var pool:BasePool = new BasePool(IceBombEffect, 10);

		private var animation:MovieClip;

		public function IceBombEffect()
		{
			this.animation = ToolKit.createMovieClip(this, Core.getTextures("iceboom_"));
			this.animation.fps = 10;
			this.animation.loop = true;
			this.animation.scaleX = (this.animation.scaleY = 1.5);
			this.animation.stop();
		}

		public function play():void
		{
			this.animation.addEventListener(Event.COMPLETE, this.onAnimationEnd);
			this.animation.play();
		}

		private function onAnimationEnd(_arg_1:Event):void
		{
			this.animation.removeEventListener(Event.COMPLETE, this.onAnimationEnd);
			this.removeFromParent();
			pool.put(this);
		}

	}
} //package com.popchan.sugar.modules.game.view
