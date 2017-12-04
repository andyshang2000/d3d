package sui.core.starlingswf
{

	import starling.display.Sprite;
	
	import sui.core.sui_internal;
	import sui.reflect.Metadata;
	import sui.utils.NameUtil;
	import sui.utils.stlSWFUtil;

	public class stlSkinnable extends Sprite
	{

		sui_internal var skin:*;
		private var _arg1:*

		public function stlSkinnable(_arg1)
		{
			this._arg1 = _arg1;
		}

		public function get skin():*
		{
			if (!sui_internal::skin)
			{
				if (_arg1 == null)
				{
				}
				else if (_arg1 is Class)
				{
					_arg1 = new (_arg1);
				}
				else if (_arg1 is String)
				{
					_arg1 = stlSWFUtil.createSWF(_arg1);
				}
				this.sui_internal::skin = _arg1;
			}
			return (sui_internal::skin);
		}

		sui_internal function setVariableSkin(_arg1:String, _arg2, _arg3:Metadata):void
		{
			this[_arg1] = _arg2;
			if ((_arg2 is stlSkinnable))
			{
				stlSkinnable(_arg2).setMetadata(_arg3);
			}
		}

		protected function setMetadata(_arg1:Metadata):void
		{
		}

		public function toString():String
		{
			return (NameUtil.displayObjectToString(this));
		}
	}
}
