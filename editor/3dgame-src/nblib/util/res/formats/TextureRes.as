package nblib.util.res.formats
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import nblib.util.res.ResManager;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class TextureRes extends Res
	{
		private var _texture:Texture;
		private var _bitmapData:BitmapData;
		private var region:Rectangle;
		private var altasName:String;
		private var frame:Rectangle;

		private var originBitmapData:BitmapData;

		public function TextureRes(altasName:String, subTexture:XML)
		{
			super(subTexture.@name);
			this.altasName = altasName;
			region = new Rectangle(parseFloat(subTexture.@x), //
				parseFloat(subTexture.@y), //
				parseFloat(subTexture.@width), //
				parseFloat(subTexture.@height));
			frame = new Rectangle(parseFloat(subTexture.@frameX), //
				parseFloat(subTexture.@frameY), //
				parseFloat(subTexture.@frameWidth), //
				parseFloat(subTexture.@frameHeight));
			ResManager.addRes(this);
		}

		public function get bitmapData():BitmapData
		{
			if (!originBitmapData)
			{
				originBitmapData = ImageRes(ResManager.getRes(altasName)).bitmapData;
			}
			if (!_bitmapData)
			{
				_bitmapData = new BitmapData(region.width, region.height, true, 0);
				_bitmapData.draw(originBitmapData, new Matrix(1, 0, 0, 1, -region.x, -region.y));
			}
			return _bitmapData
		}

		public function get texture():Texture
		{
			if (!_texture)
			{
				var res:Res = ResManager.getRes(altasName);
				var textureAltas:TextureAtlas = TextureAtlas(res["texture"]);
				if (frame.width > 0 && frame.height > 0)
				{
					textureAltas.addRegion(path, region, frame, false);
				}
				else
				{
					textureAltas.addRegion(path, region);
				}
				_texture = textureAltas.getTexture(path);
			}
			return _texture;
		}
	}
}
