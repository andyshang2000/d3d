//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.manager.SoundManager;

	import caurina.transitions.Tweener;

	import fairygui.GImage;

	public class NoSwapTip extends XImage
	{

		private var end:Function;

		public function NoSwapTip()
		{
			texture2 = ("nomatch");
		}

		public function doAniamtion(callBack:Function):void
		{
			var ins:NoSwapTip;
			this.end = callBack;
			y = ((Core.stage3DManager.canvasHeight >> 1) + 40);
			x = (Core.stage3DManager.canvasWidth + 100);
			ins = this;
			SoundManager.instance.playSound("nomatch");
			Tweener.addTween(ins, {"x": (Core.stage3DManager.canvasWidth >> 1), "time": 0.4, "transition": "easeOutBack", "onComplete": function():void
			{
				Tweener.addTween(ins, {"x": -100, "time": 0.4, "delay": 0.4, "transition": "easeInBack", "onComplete": function():void
				{
					ins.removeFromParent();
					if (end != null)
					{
						end();
					}
				}});
			}});
		}

	}
} //package com.popchan.sugar.modules.game.view
