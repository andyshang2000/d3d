//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.ds.BasePool;

	public class TileBg extends XImage
	{

		public static var pool:BasePool = new BasePool(TileBg, 81);

		public function TileBg()
		{
			texture2 = ("cube");
		}
	}
} //package com.popchan.sugar.modules.game.view
