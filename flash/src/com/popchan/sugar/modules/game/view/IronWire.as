//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.ds.BasePool;
	
	import fairygui.GImage;

	public class IronWire extends XImage
	{

		public static var pool:BasePool = new BasePool(IronWire, 20);

		public var row:int;
		public var col:int;
		private var _dir:int;

		public function get dir():int
		{
			return (this._dir);
		}

		public function set dir(_arg_1:int):void
		{
			this._dir = _arg_1;
			if(_arg_1 == 1)
				texture2 = ("ironWire");
			else 
				texture2 = ("ironWire2");
		}
	}
} //package com.popchan.sugar.modules.game.view
