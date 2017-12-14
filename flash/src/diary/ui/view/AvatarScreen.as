package diary.ui.view
{
	import diary.avatar.Avatar;
	import diary.avatar.AvatarBoy;
	import diary.avatar.AvatarGirl;
	import diary.avatar.RotationComponent;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class AvatarScreen extends GScreen
	{
		private var avatarlist:Object = {};

		protected var back:Sprite
		protected var backImage:Image;
		protected var rotationComp:RotationComponent;

		override final public function createLayer(name:String):*
		{
			if (name == "front")
				return super.createLayer(name);
			else if (name == "back")
			{
				if (back == null)
				{
					back = new Sprite;
					backImage = new Image(Texture.empty(480, 800));
					back.addChild(backImage);
				}
				return back;
			}
		}

		public function addAvatar(name:String, gender:String = "girl"):Avatar
		{
			if (avatarlist[name] != null)
				return avatarlist[name];
			var avatar:Avatar = gender == "girl" ? new AvatarGirl : new AvatarBoy;

			scene.addChild(avatar);
			avatarlist[name] = avatar;

			return avatar;
		}

		public function getAvatar(name):Avatar
		{
			return avatarlist[name]
		}

		public function updatePart(id:String):void
		{
			getAvatar("girl").updatePart(id, true);
		}

		override public function dispose():void
		{
			super.dispose();
			for (var key:String in avatarlist)
			{
				avatarlist[key].dispose();
			}
			avatarlist = {};
			backImage.dispose();
			back.dispose();
		}
	}
}
