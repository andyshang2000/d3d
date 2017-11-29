package diary.game
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class AvatarModel extends EventDispatcher
	{
		public var partList:Object = {};
		private var defaultParts:Object = {};

		public function AvatarModel()
		{
			defaultParts = { //
					j: Item.getItem("g2015_j_dod"), //
					p: Item.getItem("g2015_p_dod"), //
					s: Item.getItem("g0030_s_dod"), //
					h: Item.getItem("g2023_h_dod") //
			}
			for (var key:String in defaultParts)
			{
				partList[key] = defaultParts[key]
			}
		}

		public function updatePart(item:Item):void
		{
			var parts:String = getModelParts(item)
			takeOff(parts);
			for (var i:int = 0; i < parts.length; i++)
			{
				partList[parts.charAt(i)] = item;
			}
			for (var part:String in partList)
			{
				if (partList[part] == null)
					partList[part] = defaultParts[part];
			}

			dispatchEvent(new Event("change"));
		}

		private function takeOff(part:String):void
		{
			for (var i:int = 0; i < part.length; i++)
			{
				var p:String = part.charAt(i);
				var item:Item = partList[p];
				partList[p] = null;
				if (item)
				{
					takeOff(getModelParts(item))
				}
			}
		}

		private function getModelParts(item:Item):String
		{
			var f3d:String = item.model;
			var match:Array = /(g|b)\d{4}_(\w+)_dod/.exec(f3d + "");
			return match[2];
		}
	}
}
