package 
{
	import flash.display.Bitmap;
	import starling.textures.Texture;
	/**
	 * @author damrem
	 */
	public class Embeds 
	{
		public static var verbose:Boolean;
		
		[Embed(source = 'assets/textures/Yellow.png')]
		public static const Yellow:Class;
		[Embed(source = 'assets/textures/Yellow_h.png')]
		public static const Yellow_h:Class;
		[Embed(source = 'assets/textures/Yellow_v.png')]
		public static const Yellow_v:Class;
		[Embed(source = 'assets/textures/Yellow_x.png')]
		public static const Yellow_x:Class;
		
		[Embed(source = 'assets/textures/Red.png')]
		public static const Red:Class;
		[Embed(source = 'assets/textures/Red_h.png')]
		public static const Red_h:Class;
		[Embed(source = 'assets/textures/Red_v.png')]
		public static const Red_v:Class;
		[Embed(source = 'assets/textures/Red_x.png')]
		public static const Red_x:Class;
		
		[Embed(source = 'assets/textures/Black.png')]
		public static const Black:Class;
		[Embed(source = 'assets/textures/Black_h.png')]
		public static const Black_h:Class;
		[Embed(source = 'assets/textures/Black_v.png')]
		public static const Black_v:Class;
		[Embed(source = 'assets/textures/Black_x.png')]
		public static const Black_x:Class;
		
		[Embed(source = 'assets/textures/Purple.png')]
		public static const Purple:Class;
		[Embed(source = 'assets/textures/Purple_h.png')]
		public static const Purple_h:Class;
		[Embed(source = 'assets/textures/Purple_v.png')]
		public static const Purple_v:Class;
		[Embed(source = 'assets/textures/Purple_x.png')]
		public static const Purple_x:Class;
		
		[Embed(source = 'assets/textures/Green.png')]
		public static const Green:Class;
		[Embed(source = 'assets/textures/Green_h.png')]
		public static const Green_h:Class;
		[Embed(source = 'assets/textures/Green_v.png')]
		public static const Green_v:Class;
		[Embed(source = 'assets/textures/Green_x.png')]
		public static const Green_x:Class;
		
		[Embed(source = 'assets/textures/Blue.png')]
		public static const Blue:Class;
		[Embed(source = 'assets/textures/Blue_h.png')]
		public static const Blue_h:Class;
		[Embed(source = 'assets/textures/Blue_v.png')]
		public static const Blue_v:Class;
		[Embed(source = 'assets/textures/Blue_x.png')]
		public static const Blue_x:Class;
		
		[Embed(source = 'assets/textures/Special.png')]
		public static const Special_x:Class;
		
		
		
		public static var gemTextures:Vector.<Texture>;
		
		public static function init():void
		{
			if (verbose)	trace(Embeds+"init(" + arguments);
			
			gemTextures = new <Texture>[];
			gemTextures.push(Texture.fromBitmap(new Yellow() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Red() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Purple() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Green() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Blue() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Black() as Bitmap));
			
			gemTextures.push(Texture.fromBitmap(new Yellow_h() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Red_h() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Purple_h() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Green_h() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Blue_h() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Black_h() as Bitmap));
			
			gemTextures.push(Texture.fromBitmap(new Yellow_v() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Red_v() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Purple_v() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Green_v() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Blue_v() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Black_v() as Bitmap));
			
			gemTextures.push(Texture.fromBitmap(new Yellow_x() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Red_x() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Purple_x() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Green_x() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Blue_x() as Bitmap));
			gemTextures.push(Texture.fromBitmap(new Black_x() as Bitmap));
			
			gemTextures.push(Texture.fromBitmap(new Special_x() as Bitmap));
			
		}
		
	}
}
