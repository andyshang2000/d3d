package nblib.util.res.formats
{
	import flash.events.Event;

	import deng.fzip.FZip;

	import nblib.util.res.formats.qdrx.QdrParser;

	public class Qdrx extends BundleRes
	{
		public function Qdrx(path:String)
		{
			super(path);
		}

		override protected function parseZip(zip:FZip):void
		{
			QdrParser.parse(zip, function():void
			{
				dispatchEvent(new Event(Event.COMPLETE));
			});
		}
	}
}