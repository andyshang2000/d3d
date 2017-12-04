//Created by Action Script Viewer - http://www.buraks.com/asv
package sui.plugins
{
	import __AS3__.vec.Vector;

	import sui.Settings;
	import sui.core.sui_internal;
	import sui.reflect.SType;

	public class PluginManager
	{

		private var plugins:Vector.<IPlugin>;

		private static var _instance:PluginManager;

		public function PluginManager()
		{
			this.plugins = new Vector.<IPlugin>();
		}

		sui_internal function postConstruct(_arg1:*):void
		{
			var _local3:IPlugin;
			var _local2:SType = SType.get(_arg1);
			for each (_local3 in this.plugins)
			{
				_local3.postConstruct(_arg1, _local2);
			}
		}

		sui_internal function onConstruct(_arg1:*):void
		{
			var _local3:IPlugin;
			var _local2:SType = SType.get(_arg1);
			for each (_local3 in this.plugins)
			{
				_local3.onConstruct(_arg1, _local2);
			}
			;
		}

		sui_internal function onRender(_arg1:*):void
		{
		}

		private function add(_arg1:IPlugin):void
		{
			this.plugins.push(_arg1);
		}

		public static function getInstance():PluginManager
		{
			if (_instance == null)
			{
				_instance = new (PluginManager);
				Settings.init();
			}
			;
			return (_instance);
		}

		public static function add(_arg1:IPlugin):void
		{
			getInstance().add(_arg1);
		}

	}
} //package sui.plugins 
