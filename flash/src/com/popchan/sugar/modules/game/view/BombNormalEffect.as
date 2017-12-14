//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.ds.BasePool;

	public class BombNormalEffect extends GEffect
	{

		public static var pool:BasePool = new BasePool(BombNormalEffect, 10);

		public function BombNormalEffect()
		{
			super("zz3d.m3.gui", "makespshang");
			scaleX = 3;
			scaleY = 3;
		}

	}
} //package com.popchan.sugar.modules.game.view
