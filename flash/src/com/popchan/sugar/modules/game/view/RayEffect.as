//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.ds.BasePool;

	import fairygui.GImage;

	public class RayEffect extends XImage
	{

		public static var pool:BasePool = new BasePool(RayEffect, 20);

		public function RayEffect()
		{
			texture2 = ("sun");
		}
	}
} //package com.popchan.sugar.modules.game.view
