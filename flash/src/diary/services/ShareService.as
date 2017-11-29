package diary.services
{
	import flash.utils.setTimeout;
	
	import diary.ui.RenderManager;
	import diary.ui.view.ScreenManager;

	public class ShareService
	{
		private static var _inst:ShareService;
		private var renderMgr:RenderManager;
		private var successHandler:Function;
		private var failedHandler:Function;
		
		public static function get inst():ShareService
		{
			if(_inst)
				return _inst;
			_inst = new ShareService;
			return _inst;
		}
		
		public function initialize(obj:ScreenManager):void
		{
			this.renderMgr = obj.renderManager;
		}
		
		public static function share():ShareService
		{
			return inst.share();
		}
		
		public function share():ShareService
		{
			//do share
			setTimeout(function():void
			{
				if(Math.random() > 0.3)
				{
					if(successHandler != null)
					{
						successHandler();
					}
					else if(failedHandler != null)
					{
						failedHandler();
					}
				}
			},1000)
			return this;
		}
		
		public function onSuccess(func:Function):ShareService
		{
			successHandler = func;
			return this;
		}
		
		public function onFailed(func:Function):ShareService
		{
			failedHandler = func;
			return this;
		}
	}
}