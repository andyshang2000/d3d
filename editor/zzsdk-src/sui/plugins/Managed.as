package sui.plugins
{
	import flash.utils.Dictionary;

	public class Managed
	{
		private static var boxes:Array = [];
		private static var defaultVisibility:Boolean;
		private static var managedMap:Dictionary = new Dictionary;

		public static function add(displayObject:*, onShow:Function = null, onHide:Function = null):Boolean
		{
			boxes.push(displayObject);
			displayObject.visible = defaultVisibility;
			if(!managedMap[displayObject])
			{
				managedMap[displayObject] = {onShow: onShow, onHide: onHide};
				update(displayObject);
				return true;
			}
			return false;
		}

		private static function update(displayObject:*):void
		{
			if (displayObject)
			{
				var callback:Object = managedMap[displayObject];
				if (displayObject.visible)
				{
					if (callback.onShow)
						callback.onShow();
				}
				else
				{
					if (callback.onHide)
						callback.onHide();
				}
			}
		}

		public static function updateAll(visible:Boolean):void
		{
			defaultVisibility = visible;
			for each (var box:* in boxes)
			{
				box.visible = visible;
				update(box);
			}
		}
	}
}
