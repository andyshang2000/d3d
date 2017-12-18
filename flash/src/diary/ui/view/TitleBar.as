package diary.ui.view
{
	import com.popchan.sugar.core.Model;

	import diary.ui.util.GViewSupport;

	import fairygui.GComponent;
	import fairygui.GTextField;

	public class TitleBar extends GComponent
	{
		[G]
		public var m1:GTextField;
		[G]
		public var m2:GTextField;
		[G]
		public var m3:GTextField;
		[G]
		public var m4:GTextField;
		[G]
		public var m5:GTextField;

		override protected function constructFromXML(xml:XML):void
		{
			super.constructFromXML(xml);
			GViewSupport.assign(this);

			Model.money.addEventListener("change", function():void
			{
				sync();
			});
			sync();
		}

		private function sync():void
		{
			m1.text = Model.money.m1 + "";
			m2.text = Model.money.m2 + "";
			m3.text = Model.money.m3 + "";
			m4.text = Model.money.m4 + "";
			m5.text = Model.money.m5 + "";
		}
	}
}
