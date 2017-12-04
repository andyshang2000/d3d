package sui
{
	import sui.plugins.PluginManager;
	import sui.skinning.flash.flashSkinning;
	import sui.skinning.starlingswf.stlAutoLabel;
	import sui.skinning.starlingswf.stlGuiSound;
	import sui.skinning.starlingswf.stlSkinning;

	public class Settings
	{

		public static function init(... _args):void
		{
			if (_args.length == 0)
			{
				applyDefaultSettings();
			}
			else
			{
				applySettings(_args);
			}
		}

		private static function applyDefaultSettings():void
		{
//			PluginManager.add(new flashSkinning);
			PluginManager.add(new stlSkinning);
			PluginManager.add(new stlGuiSound);
			PluginManager.add(new stlAutoLabel);
		}

		private static function applySettings(_arg1:Array):void
		{
		}
	}
}
