//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.ds.BasePool;
	import com.popchan.framework.utils.ToolKit;
	import com.popchan.sugar.core.data.TileConst;
	
	import starling.display.MovieClip;

	public class TransportDoor extends Element
	{

		public static var pool:BasePool = new BasePool(TransportDoor, 10);

		private var animation:MovieClip;
		private var _tileID:int;
		public var row:int;
		public var col:int;

		public function TransportDoor()
		{
//			this.animation = ToolKit.createMovieClip(this, Core.getTextures("chuansong_"));
			this.animation.fps = 5;
			this.animation.loop = true;
		}

		public function start():void
		{
			this.animation.play();
		}

		public function get tileID():int
		{
			return (this._tileID);
		}

		public function set tileID(_arg_1:int):void
		{
			this._tileID = _arg_1;
			if ((((_arg_1 >= TileConst.T_DOOR_ENTRY1)) && ((_arg_1 <= TileConst.T_DOOR_ENTRY9))))
			{
				this.animation.y = 30;
			}
			else
			{
				if ((((_arg_1 >= TileConst.T_DOOR_EXIT1)) && ((_arg_1 <= TileConst.T_DOOR_EXIT9))))
				{
					this.animation.y = -30;
				}
			}
		}

		override public function dispose():void
		{
		}

	}
} //package com.popchan.sugar.modules.game.view
