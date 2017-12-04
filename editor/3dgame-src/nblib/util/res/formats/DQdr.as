package nblib.util.res.formats
{
	import flash.events.Event;

	import deng.fzip.FZip;

	public class DQdr extends BundleRes
	{
		private static var clazzArr:Array;
		private static var used:int = 0;

		public static function withParser(parser):Class
		{
			if (!clazzArr)
			{
				clazzArr = [Q1, Q2, Q3, Q4];
			}
			if (used == clazzArr.length)
			{
				throw new Error("too many DQdr instances");
			}
			var res:Class = clazzArr[used++];
			res.prototype.parser = parser;
			return res;
		}
	}
}
import flash.events.Event;

import deng.fzip.FZip;

import nblib.util.res.formats.BundleRes;
import nblib.util.res.formats.DQdr;

class _DQdr extends BundleRes
{
	protected var parser:*;

	public function _DQdr(path:String)
	{
		super(path);
	}

	override protected function parseZip(zip:FZip):void
	{
		parser = this["constructor"].parser
		parser.parse(zip, function():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		});
	}
}

class Q1 extends DQdr
{
}

class Q2 extends DQdr
{
}

class Q3 extends DQdr
{
}

class Q4 extends DQdr
{
	public static var parser:*
}
