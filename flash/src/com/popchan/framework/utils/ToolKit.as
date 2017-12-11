//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.framework.utils
{
	import __AS3__.vec.Vector;
	
	import starling.display.Button;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.TextSprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class ToolKit
	{

		public static function createImage(_arg_1:DisplayObjectContainer, _arg_2:Texture, _arg_3:int = 0, _arg_4:int = 0, _arg_5:Boolean = false, _arg_6:Boolean = true):Image
		{
			var _local_7:Image = new Image(_arg_2);
			_local_7.x = _arg_3;
			_local_7.y = _arg_4;
			_local_7.touchable = _arg_6;
			_arg_1.addChild(_local_7);
			if (_arg_5)
			{
				_local_7.pivotX = (_local_7.width >> 1);
				_local_7.pivotY = (_local_7.height >> 1);
			}
			;
			return (_local_7);
		}

		public static function createMovieClip(_arg_1:DisplayObjectContainer, _arg_2:Vector.<Texture>, _arg_3:int = 0, _arg_4:int = 0):MovieClip
		{
			var _local_5:MovieClip = new MovieClip(_arg_2);
			_local_5.x = _arg_3;
			_local_5.y = _arg_4;
			_arg_1.addChild(_local_5);
			_local_5.stop();
			return (_local_5);
		}

		public static function createTextSprite(_arg_1:DisplayObjectContainer, _arg_2:Vector.<Texture>, _arg_3:int = 0, _arg_4:int = 0, _arg_5:int = 10, _arg_6:String = "0123456789", _arg_7:int = 10):TextSprite
		{
			var _local_8:TextSprite = new TextSprite(_arg_2, _arg_5, _arg_6, _arg_7);
			_arg_1.addChild(_local_8);
			_local_8.x = _arg_3;
			_local_8.y = _arg_4;
			return (_local_8);
		}

		public static function createTextField(_arg_1:DisplayObjectContainer, _arg_2:int = 50, _arg_3:int = 30, _arg_4:int = 0, _arg_5:int = 0, _arg_6:int = 30, _arg_7:int = 0xFFFFFF, _arg_8:String = "", _arg_9:String = "center", _arg_10:String = "center"):TextField
		{
			var _local_11:TextField = new TextField(_arg_2, _arg_3, "");
			_local_11.x = _arg_4;
			_local_11.y = _arg_5;
			_arg_1.addChild(_local_11);
			_local_11.touchable = false;
			return (_local_11);
		}

		public static function createButton(_arg_1:DisplayObjectContainer, _arg_2:Texture, _arg_3:int, _arg_4:int, _arg_5:Function = null):Button
		{
			var _local_6:Button = new Button(_arg_2);
			_local_6.x = _arg_3;
			_local_6.y = _arg_4;
			if (_arg_5 != null)
			{
				_local_6.addEventListener(Event.TRIGGERED, _arg_5);
			}
			;
			_arg_1.addChild(_local_6);
			return (_local_6);
		}
	}
} //package com.popchan.framework.utils
