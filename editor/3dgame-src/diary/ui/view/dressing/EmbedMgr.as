package diary.ui.view.dressing
{

	public class EmbedMgr extends AbstractAssets
	{
		[Embed(source = "/embedded/effect.atf", mimeType = "application/octet-stream")]
		private var btnClkAni_png:Class;
		[Embed(source = "/embedded/effect.xml", mimeType = "application/octet-stream")]
		private var btnClkAni_xml:Class;
		[Embed(source = "/embedded/dressEff1.pex", mimeType = "application/octet-stream")]
		private var dressPex:Class;
		[Embed(source = "/embedded/flowerEff.pex", mimeType = "application/octet-stream")]
		private var hanabiraPex:Class;

		private static var instance:EmbedMgr = null;

		override protected function enqueue():void
		{
			assetManager.enqueueWithName(btnClkAni_png, "effect");
			assetManager.enqueueWithName(btnClkAni_xml, "effect.xml");
			addXML(XML(new dressPex), "img_starparticle");
			addXML(XML(new hanabiraPex), "img_flowerEff");
		}
		
		public static function Instance():EmbedMgr
		{
			if (instance == null)
			{
				instance = new EmbedMgr();
			}
			return instance;
		}

		public static function dispose():void
		{
			instance.assetManager.dispose();
			instance = null;
		}
	}
}
