package zzsdk.templates
{
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.UncaughtErrorEvent;

	import mx.utils.StringUtil;

	public class AppBase extends MovieClip
	{
		public function AppBase()
		{
			stop();
			try
			{
				trace("what is the problem?");
				if (loaderInfo != null)
				{
					loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function(event:UncaughtErrorEvent):void
					{
						if (event.error is Error)
						{
							trace(event.error.getStackTrace());
						}
						else if (event.error is ErrorEvent)
						{
							trace(StringUtil.substitute("error occured: [{0}] ,{1}", ErrorEvent(event.error).errorID), event)
						}
					});
				}
			}
			catch (err:Error)
			{
			}
		}
	}
}
