//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.ds.BasePool;
	
	import fairygui.GImage;

	public class Stone extends XImage
	{

		public static var pool:BasePool = new BasePool(Stone, 20);

		public var row:int;
		public var col:int;
		private var _life:int;
		private var _tileID:int;

		public function get tileID():int
		{
			return (this._tileID);
		}

		public function set tileID(_arg_1:int):void
		{
			this._tileID = _arg_1;
			this.setLife(2);
		}

		public function get life():int
		{
			return (this._life);
		}

		public function setLife(_arg_1:int, _arg_2:Boolean = false):void
		{
			var _local_3:IceBombEffect;
			this._life = _arg_1;
			if (this._life == 2)
			{
				texture2 = ("stone1")
			}
			else if (this._life == 1)
			{
				texture2 = ("stone1")
			}
			if (_arg_2)
			{
				_local_3 = new IceBombEffect();
				_local_3.play();
				this.parent.addChild(_local_3);
				_local_3.x = x;
				_local_3.y = y;
			}
		}

	}
} //package com.popchan.sugar.modules.game.view
