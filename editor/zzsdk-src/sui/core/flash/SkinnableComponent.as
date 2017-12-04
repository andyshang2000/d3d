package sui.core.flash
{
	import sui.core.sui_internal;
	import sui.reflect.Metadata;

	public class SkinnableComponent extends ComponentBase
	{
		sui_internal var skin:*;

		public function SkinnableComponent(_arg1)
		{
			if (_arg1 != null && _arg1 is Class)
			{
				_arg1 = new (_arg1);
			}
			this.sui_internal::skin = _arg1;
		}

		protected function get skin():*
		{
			return (sui_internal::skin);
		}

		sui_internal function setVariableSkin(_arg1:String, _arg2, _arg3:Metadata):void
		{
			this[_arg1] = _arg2;
			if ((_arg2 is SkinnableComponent))
			{
				SkinnableComponent(_arg2).setMetadata(_arg3);
			}
		}

		protected function setMetadata(_arg1:Metadata):void
		{
		}
	}
}
