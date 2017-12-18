//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.ds.BasePool;
	import com.popchan.framework.manager.SoundManager;

	import fairygui.GImage;

	public class Lock extends XImage
	{

		public static var pool:BasePool = new BasePool(Lock, 10);

		public var row:int;
		public var col:int;
		private var _life:int;
		private var _lockID:int;
		private var _vx:Number;
		private var _vr:Number;
		private var _vy:Number;
		private var _count:int;

		public function Lock()
		{
			texture2 = ("lock");
			this.scaleX = 1.25;
			this.scaleY = 1.25;
		}

		public function doAnimation():void
		{
			SoundManager.instance.playSound("lockboom");
			var _local_1:int = -1;
			if (this.col >= 4)
			{
				_local_1 = 1;
			}
			;
			this._vx = 3;
			this._vr = 0.1;
			if (_local_1 == -1)
			{
				this._vx = -3;
				this._vr = -0.1;
			}
			this._count = 0;
			this._vy = (Math.random() * -4);
			Core.timerManager.add(this, this.update, 16);
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
