//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.ds.BasePool;
	import com.popchan.sugar.core.data.TileConst;

	import fairygui.GImage;

	import starling.textures.Texture;

	public class Brick extends XImage
	{

		public static var pool:BasePool = new BasePool(Brick, 50);

		private var _brickID:int;
		private var _life:int;
		public var row:int;
		public var col:int;

		public function get life():int
		{
			return (this._life);
		}

		public function get brickID():int
		{
			return (this._brickID);
		}

		public function set brickID(_arg_1:int):void
		{
			var _local_2:Texture;
			this._brickID = _arg_1;
			if (_arg_1 == TileConst.BRICK)
			{
				texture2 = ("brick1")
				this._life = 1;
			}
			else if (_arg_1 == TileConst.BRICK2)
			{
				texture2 = ("brick2")
				this._life = 2;
			}
			try
			{
				this.pivotX = (this.texture.width >> 1);
				this.pivotY = (this.texture.height >> 1);
			}
			catch (err:Error)
			{
			}
		}

		public function loseLife():void
		{
			var _local_2:BrickExp;
			var _local_1:int = -1;
			if (this.col >= 4)
			{
				_local_1 = 1;
			}
			if (this._life == 2)
			{
				this.texture2 = ("brick1");
				_local_2 = (BrickExp.pool.take() as BrickExp);
				_local_2.setInfo(2, _local_1);
				_local_2.x = x;
				_local_2.y = y;
				this.parent.parent.addChild(_local_2);
			}
			else if (this._life == 1)
			{
				_local_2 = (BrickExp.pool.take() as BrickExp);
				_local_2.setInfo(1, _local_1);
				_local_2.x = x;
				_local_2.y = y;
				this.parent.parent.addChild(_local_2);
			}
			this._life = (this._life - 1);
		}

	}
} //package com.popchan.sugar.modules.game.view
