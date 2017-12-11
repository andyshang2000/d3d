package com.popchan.sugar.modules.game.view
{
	import fairygui.GImage;
	import fairygui.PackageItem;
	import fairygui.UIPackage;

	public class XImage extends GImage
	{
		public function XImage()
		{
		}

		public function set texture2(name:String):void
		{
			var t;
			var item = UIPackage.getByName("zz3d.m3.gui").getItemByName(name);
			if (item != null)
				t = item.texture;
			else
				trace("????????????" + name)
			if (t != null)
			{
				texture = t;
				onTextureSet();
			}
			else
			{
				UIPackage.getByName("zz3d.m3.gui").addCallback(name, function(i:PackageItem):void
				{
					if (i == null)
					{
						i = item;
					}
					if (i != null)
					{
						texture = i.texture;
						onTextureSet();
					}
				});
			}
		}

		protected function onTextureSet():void
		{
//			this.pivotX = (texture.width >> 1);
//			this.pivotY = (texture.height >> 1);
		}
	}
}
