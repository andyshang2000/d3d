package nblib.util.res
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import nblib.util.res.event.ResEvent;

	public class ProgressClient implements IProgressClient
	{
		private var loader:ResLoader;

		private var progressBar:*;

		public function ProgressClient(progressBar:*)
		{
			this.progressBar = progressBar;
		}

		public function listen(loader:ResLoader):void
		{
			if (this.loader == loader)
			{
				return;
			}

			if (this.loader != null)
			{
				this.loader.removeEventListener(ResEvent.START, startHandler);
				this.loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				this.loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				this.loader.removeEventListener(Event.COMPLETE, completeHandler);
			}
			this.loader = loader;
			loader.addEventListener(ResEvent.START, startHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler);
		}

		protected function startHandler(event:Event):void
		{
			if (progressBar)
			{
				progressBar.startRes(event);
			}
		}

		protected function completeHandler(event:Event):void
		{
			if (progressBar)
			{
				progressBar.fadeOut();
			}
		}

		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			if (progressBar)
			{
				progressBar.error(event);
			}
		}

		protected function progressHandler(event:ProgressEvent):void
		{
			if (progressBar)
			{
				progressBar.update(event);
			}
		}
	}
}
