package diary.ui.view
{
	import flash.filesystem.File;
	
	import diary.avatar.Avatar;
	import diary.avatar.AvatarBoy;
	import diary.avatar.AvatarGirl;
	import diary.avatar.RotationComponent;
	import diary.res.ResManager;
	import diary.res.ZF3D;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	import zzsdk.utils.FileUtil;

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
			FileUtil.dir = File.applicationDirectory;
			ResManager.getResAsync("scene.zf3d", ZF3D, function(zf3d:ZF3D):void
			{
				scene.addChild(zf3d.content);
				zf3d.content.z = 140;
				zf3d.content.rotateY(12);
			});
			FileUtil.dir = File.applicationStorageDirectory;
			scene.addChild(avatar);
			scene.camera
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
