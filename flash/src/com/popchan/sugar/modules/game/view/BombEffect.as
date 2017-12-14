//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.ds.BasePool;

	public class BombEffect extends GEffect
	{

		public static var pool:BasePool = new BasePool(BombEffect, 10);

		public function BombEffect()
		{
			super("zz3d.m3.gui", "candybomb");
		}
	}
} //package com.popchan.sugar.modules.game.view
