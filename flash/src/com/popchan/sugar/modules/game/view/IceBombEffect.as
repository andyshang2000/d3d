//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.ds.BasePool;

	public class IceBombEffect extends GEffect
	{

		public static var pool:BasePool = new BasePool(IceBombEffect, 10);

		public function IceBombEffect()
		{
			super("zz3d.m3.gui", "iceboom");
		}
	}
} //package com.popchan.sugar.modules.game.view
