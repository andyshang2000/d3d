//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.framework.core
{
	import com.popchan.framework.manager.Stage3DManager;
	import com.popchan.framework.manager.StageManager;
	import com.popchan.framework.manager.TimerManager;
	
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import fairygui.UIPackage;
	
	import starling.textures.Texture;

	public class Core
	{

		public static var timerManager:TimerManager = new TimerManager();
		public static var stageManager:StageManager = new StageManager();
		public static var stage3DManager:Stage3DManager = new Stage3DManager();

		public static function init(_arg_1:Stage):void
		{
			stageManager.setup(_arg_1, new Rectangle(0, 0, _arg_1.stageWidth, _arg_1.stageHeight));
			stage3DManager.setup(_arg_1, new Rectangle(0, 0, _arg_1.stageWidth, _arg_1.stageHeight));
		}

		public static function getTexture(name:String):Texture
		{
			var res:Texture = UIPackage.getByName("zz3d.m3.gui").getImage(name);
			if (res == null)
			{
				trace(name);
			}
			return res;
//			return texturesManager.getTexture(name);
		}

		public static function getTextures(name:String):Vector.<Texture>
		{
//			....
			return null;
		}
	}
}
