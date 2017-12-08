package diary.ui.view
{
	import diary.avatar.AnimationTicker;
	import diary.avatar.Avatar;
	import diary.avatar.AvatarBoy;
	import diary.avatar.AvatarGirl;
	import diary.avatar.RotationComponent;
	import diary.ui.Carousel;
	
	import flare.core.Camera3D;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class AvatarScreen extends GScreen
	{
		private var avatarlist:Object = {};
		
		
		protected var back:Sprite
		protected var backImage:Image;
				
		override final public function createLayer(name:String):*
		{
			if(name == "front")
				return super.createLayer(name);
			else if(name == "back")
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

		public function addAvatar(name:String, gender:String = "girl"):void
		{
			if (avatarlist[name] != null)
				return;
			var avatar:Avatar = gender == "girl" ? new AvatarGirl : new AvatarBoy;

			avatar.addComponent(new RotationComponent);
			avatar.addComponent(new AnimationTicker);

			scene.addChild(avatar);
			scene.camera.setPosition(0, 195, -450);
			scene.camera.setRotation(12, 0, 0);
			scene.camera.fovMode = Camera3D.FOV_VERTICAL;
			scene.camera.fieldOfView = 28;

			avatarlist[name] = avatar
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
