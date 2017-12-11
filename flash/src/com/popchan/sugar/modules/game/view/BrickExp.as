//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.ds.BasePool;
	import com.popchan.framework.manager.Debug;
	import com.popchan.framework.manager.SoundManager;

	import fairygui.GImage;

	import starling.display.Image;
	import starling.textures.Texture;

	public class BrickExp extends XImage
	{

		public static var pool:BasePool = new BasePool(BrickExp, 81);

		private var img:Image;
		private var _vx:Number;
		private var _vr:Number;
		private var _vy:Number;
		private var _count:int;

		public function setInfo(_arg_1:int, _arg_2:int):void
		{
			if (_arg_1 == 1)
			{
				this.texture2 = ("brick1");
			}
			else if (_arg_1 == 2)
			{
				this.texture2 = ("brick2");
			}
			this.pivotX = (this.texture.width >> 1);
			this.pivotY = (this.texture.height >> 1);
			this._vx = 6;
			this._vr = 0.1;
			if (_arg_2 == -1)
			{
				this._vx = -6;
				this._vr = -0.1;
			}
			this._count = 0;
			this._vy = (Math.random() * -6);
			Core.timerManager.add(this, this.update, 16);
			SoundManager.instance.playSound("brickthrow");
		}

		private function update():void
		{
			x = (x + this._vx);
			y = (y + this._vy);
			this._vy = (this._vy + 0.5);
			rotation = (rotation + this._vr);
			this._count++;
			if (this._count > 60)
			{
				Core.timerManager.remove(this, this.update);
				pool.put(this);
				this.removeFromParent();
			}
		}
	}
} //package com.popchan.sugar.modules.game.view
