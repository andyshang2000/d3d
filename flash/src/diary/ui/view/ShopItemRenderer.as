package diary.ui.view
{
	import com.popchan.sugar.core.Model;

	import diary.ui.util.GViewSupport;

	import fairygui.GButton;
	import fairygui.GComponent;
	import fairygui.GImage;
	import fairygui.GTextField;

	public class ShopItemRenderer extends GComponent
	{
		[G]
		public var image:GImage;
		[G]
		public var title:GTextField;
		[G]
		public var free:GTextField;
		[G]
		public var freePlayButton:GImage;
		[G]
		public var coin:GImage;
		[G]
		public var price:GTextField;
		[G]
		public var shopButton:GButton;

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);
		}

		public function setItem(cat:String, item:*):void
		{
//			var image:GImage = renderer.getChild("image").asImage;
			image.texture = Model.iconAtlas.getTexture(item);
			free.visible = false;
			freePlayButton.visible = false;
			var itemObj = Model.shop.getItem(cat, item);
			price.text = itemObj.cost + "";
		}
	}
}
