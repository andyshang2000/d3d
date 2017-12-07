package diary.avatar

{
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import diary.res.ResManager;
	import diary.res.ZF3D;
	
	import flare.core.Label3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Surface3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureMapFilter;
	import flare.utils.Pivot3DUtils;

	public class AvatarGirl extends Avatar
	{
		public static var ACT_NORMAL:String = "g_dod_idle";
		public static var platform:String = "android";
		private var defaultF:String = "g0001_f_dod";
		private var defaultJ:String = "g2015_j_dod";
		private var defaultP:String = "g2015_p_dod";
		private var defaultS:String = "g2016_s_dod";
		private var defaultH:String = "g2015_h_dod";
		private var acts:Array = [ //
			"g_dod_body", //0
			"g_dod_clothes", //1
			"g_dod_clothes01", //2
			"g_dod_hair01", //3
			"g_dod_idlea", //4
			"g_dod_idle01", //5
			"g_dod_idle02", //6
			"g_dod_idlea", //7
			"g_dod_shoes", //9
			"g_dod_shoes01", //10
			"g_dod_hair" //11
			];

		public function AvatarGirl(name:String = "")
		{
			super(name, defaultF,//
				defaultJ,
				defaultP,
				defaultS,
				defaultH
			);
		}

		override protected function getPoseByPart(part:String):String
		{
			if (part == "j")
			{
				return (acts[1]);
			}
			else if (part == "h")
			{
				if (Math.random() > 0.5)
				{
					return (acts[3]);
				}
				else
				{
					return (acts[10]);
				}
				
			}
			else if (part == "p")
			{
				return (acts[0]);
			}
			else if (part == "s")
			{
				if (Math.random() > 0.5)
				{
					return (acts[9]);
				}
				else
				{
					return (acts[10]);
				}
			}
			return acts[1];
		}
	}
}
