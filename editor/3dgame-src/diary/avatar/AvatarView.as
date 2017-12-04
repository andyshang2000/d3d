package diary.avatar
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import diary.game.AvatarModel;
	import diary.game.Item;
	import diary.res.ZF3D;
	
	import flare.core.Pivot3D;
	
	import nblib.util.res.ResManager;

	public class AvatarView extends Pivot3D
	{
		ResManager.mapResource("zf3d", ZF3D);
		ResManager.mapResource("f3d", ZF3D);

		public static var platform:String = "android"
		
		protected var lastItem:Item

		private var avatar:AvatarModel;
		private var parts:Dictionary;

		protected var toRemove:Array;
		private var numInQueue:int = 0;

		public function AvatarView()
		{
			parts = new Dictionary;
			addEventListener("complete", completeHandler);
		}

		public function setAvatar(avatar:AvatarModel):void
		{
			this.avatar = avatar;
			refresh(avatar.partList);
			avatar.addEventListener("change", modelChange);
		}

		private function modelChange(event:Event):void
		{
			refresh(avatar.partList);
		}

		private function refresh(partList:Object):void
		{
			toRemove = [];
			var partsOnModel:Dictionary = new Dictionary;
			for each (var item:Item in partList)
			{
				partsOnModel[item] = item;
				if (item in parts)
					continue;
				loadPart(item);
			}
			for (var pItem:Item in parts)
			{
				if (!(pItem in partsOnModel))
				{
					toRemove.push(pItem);
				}
			}
		}

		private function sizeof(parts:Dictionary):int
		{
			var i:int = 0;
			for each (var j:int in parts)
			{
				i++
			}
			return i;
		}

		protected function completeHandler(event:Event):void
		{
			removeUnused();
		}

		protected function removeUnused():void
		{
			for (var i:int = 0; i < toRemove.length; i++)
			{
				var item:Item = toRemove[i]
				var zf3d:ZF3D = parts[item];
				delete parts[item];
				zf3d.content.parent = null;
				ResManager.removeRes(zf3d.path);
			}
			toRemove = [];
		}

		private function loadPart(item:Item):void
		{
			numInQueue++;
			parts[item] = "pending";
			ResManager.getResAsync(Rating.resourceRoot + (Item.filelist[item.model]), function(zf3d:ZF3D):void
			{
				numInQueue--;
				parts[item] = zf3d;
				zf3d.content.hide();
				addChild(zf3d.content).name = item.model;
				lastItem = item;
				if (numInQueue == 0)
				{
					dispatchEvent(new Event("complete"));
				}
			});
		}

		override public function dispose():void
		{
			for (var item:Item in parts)
			{
				var zf3d:ZF3D = parts[item];
				zf3d.content.parent = null;
				ResManager.removeRes(zf3d.path);
				delete parts[item];
			}
			avatar.removeEventListener("change", modelChange);
			avatar = null
			super.dispose();
		}
	}
}
