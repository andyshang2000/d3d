package sui.core.flash
{
	import flash.events.Event;

	import sui.core.sui_internal;
	import sui.plugins.PluginManager;

	public class Component extends SkinnableComponent
	{

		private var mgr:PluginManager;

		public function Component(_arg1)
		{
			this.mgr = PluginManager.getInstance();
			super(_arg1);
			this.preConstruct()
			this.construct();
			this.postConstruct()
		}
		
		protected function preConstruct():void
		{
		}
		
		protected function postConstruct():void
		{
			mgr.sui_internal::postConstruct(this);
		}

		protected function construct():void
		{
			mgr.sui_internal::onConstruct(this);
		}

		override protected function renderHandler(_arg1:Event):void
		{
			mgr.sui_internal::onRender(this);
		}
	}
}
