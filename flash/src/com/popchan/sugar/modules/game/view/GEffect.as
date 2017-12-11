package com.popchan.sugar.modules.game.view
{
	import fairygui.GComponent;
	import fairygui.GMovieClip;
	import fairygui.UIPackage;

	public class GEffect extends GComponent
	{
		private var animation:GMovieClip;

		public function GEffect(pkg, res)
		{
			animation = UIPackage.createObject(pkg, res).asMovieClip;
			animation.playing = false;
			addChild(animation);
		}

		public function play():void
		{
			animation.playing = true;
			animation.setPlaySettings(0, -1, 1, -1, onAnimationEnd);
		}

		private function onAnimationEnd():void
		{
			animation.playing = false;
			this.removeFromParent();
			this["constructor"].pool.put(this);
		}
	}
}
