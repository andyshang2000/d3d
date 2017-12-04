package sui.core.starlingswf
{
	import starling.events.Event;
	
	import sui.core.IScreen;
	import sui.core.sui_internal;
	import sui.plugins.PluginManager;

	public class stlComponent extends stlSkinnable
	{
		private var mgr:PluginManager;

		public function stlComponent(_arg1:*)
		{
			this.mgr = PluginManager.getInstance();
			super(_arg1);
			if(this is IScreen)
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
			else
			{
				onAddedToStage(null);
			}
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			mgr.sui_internal::onConstruct(this);
			initialize();
		}
		
		protected function initialize():void
		{	
		}
	}
}
