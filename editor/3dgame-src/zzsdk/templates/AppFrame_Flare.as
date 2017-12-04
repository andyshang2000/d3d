package zzsdk.templates
{
	import flash.events.Event;
	
	import ands.Context;
	import ands.core.App;
	import ands.core.IPlugin;
	import ands.plugins.CompositeRenderMgr;
	import ands.plugins.PScene;
	import ands.plugins.PTimer;

	[Event(name = "appStart", type = "flash.events.Event")]
	public class AppFrame_Flare extends AppFrameBase
	{
		private var app:App;
		private var context:Context;

		public function AppFrame_Flare(context:Context)
		{
			this.context = context;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			app = new App(context, this);
			addPlugin(new PTimer);
			addPlugin(new PScene(this));
			addPlugin(new CompositeRenderMgr);
			if (dispatchEvent(new Event("appStart", false, true)))
			{
				app.start();
			}
		}

		public function addPlugin(plugin:IPlugin):void
		{
			app.install(plugin);
		}
	}
}

