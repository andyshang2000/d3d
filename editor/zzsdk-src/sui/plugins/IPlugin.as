package sui.plugins
{
	import sui.reflect.SType;

	public interface IPlugin
	{
		function onConstruct(_arg1:*, _arg2:SType):void;
		function postConstruct(_arg1:*, _arg2:SType):void;
	}
}
