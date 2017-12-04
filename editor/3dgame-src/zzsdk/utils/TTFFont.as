package zzsdk.utils
{
	import flash.text.Font;

	public class TTFFont
	{
		private static var _defaultFont:Font = new Font;

		public static function get defaultFont():Font
		{
			return _defaultFont;
		}

		public static function set defaultFont(value:Font):void
		{
			_defaultFont = value;
		}

	}
}