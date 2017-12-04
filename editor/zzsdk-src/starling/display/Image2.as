// =================================================================================================
//
//	Starling Framework
//	Copyright 2011-2014 Gamua. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import starling.core.RenderSupport;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.VertexData;

	/** An Image is a quad with a texture mapped onto it.
	 *
	 *  <p>The Image class is the Starling equivalent of Flash's Bitmap class. Instead of
	 *  BitmapData, Starling uses textures to represent the pixels of an image. To display a
	 *  texture, you have to map it onto a quad - and that's what the Image class is for.</p>
	 *
	 *  <p>As "Image" inherits from "Quad", you can give it a color. For each pixel, the resulting
	 *  color will be the result of the multiplication of the color of the texture with the color of
	 *  the quad. That way, you can easily tint textures with a certain color. Furthermore, images
	 *  allow the manipulation of texture coordinates. That way, you can move a texture inside an
	 *  image without changing any vertex coordinates of the quad. You can also use this feature
	 *  as a very efficient way to create a rectangular mask.</p>
	 *
	 *  @see starling.textures.Texture
	 *  @see Quad
	 */
	public class Image2 extends Quad
	{
		private var mTexture:Texture;
		private var mSmoothing:String;

		private var mVertexDataCache:VertexData;
		private var mVertexDataCacheInvalid:Boolean;

		private var centerY:Number = 0;
		private var frame:Rectangle;
		//
		private var _scrollV:Number;

		private var scrollable:Boolean = false;

		/** Creates a quad with a texture mapped onto it. */
		public function Image2(texture:Texture, frame:Rectangle)
		{
			if (texture)
			{
				var tW:int = texture.width;
				var tH:int = texture.height;
				var width:Number = frame.width;
				var height:Number = frame.height;
				var u:Number = width / tW;
				var v:Number = height / tH;
				var halfU:Number = u / 2;
				var pma:Boolean = texture.premultipliedAlpha;

				super(width, height, 0xffffff, pma);

				updateTexCoords(0, 0, u, v);

				mTexture = texture;
				mSmoothing = TextureSmoothing.BILINEAR;
				mVertexDataCache = new VertexData(8, pma);
				mVertexDataCacheInvalid = true;
			}
			else
			{
				throw new ArgumentError("Texture cannot be null");
			}
		}

		private function updateTexCoords(offsetU:int, offsetV:int, u:Number, v:Number):void
		{
			var wrapped:Boolean = false;
			var su:Number = offsetU;
			var sv:Number = offsetV;
			var ev:Number = offsetV + v;
			var cu:Number = su;
			var cv:Number = (su + sv) / 2;
			var cv2:Number = cv;

			var cp:Number = height / 2;

			if (offsetV + v > 1.0)
				wrapped = true;
			//
			if (wrapped)
			{
				mVertexData.setTexCoords(0, su, sv);
				mVertexData.setTexCoords(1, su + u, sv);
				mVertexData.setTexCoords(2, su, sv + offsetV);
				mVertexData.setTexCoords(3, su + u, sv + offsetV);
				mVertexData.setTexCoords(4, su, v - ev - offsetV);
				mVertexData.setTexCoords(5, su + u, v - ev - offsetV);
				mVertexData.setTexCoords(6, su, ev);
				mVertexData.setTexCoords(7, su + u, ev);
				//
				ev -= 1;
				cu += u;
				cv = v;
				cv2 = 0;
				mVertexData.setPosition(2, 0, cp);
				mVertexData.setPosition(3, width, cp);
				mVertexData.setPosition(4, 0, cp);
				mVertexData.setPosition(5, width, cp);
			}
			else
			{
				mVertexData.setPosition(2, 0, cp);
				mVertexData.setPosition(3, width, cp);
				mVertexData.setPosition(4, 0, cp);
				mVertexData.setPosition(5, width, cp);
			}
			mVertexData.setTexCoords(0, su, sv);
			mVertexData.setTexCoords(1, su + u, sv);
			mVertexData.setTexCoords(2, su, cv);
			mVertexData.setTexCoords(3, su + u, cv);
			mVertexData.setTexCoords(4, cu, cv2);
			mVertexData.setTexCoords(5, cu + u, cv2);
			mVertexData.setTexCoords(6, cu, ev);
			mVertexData.setTexCoords(7, cu + u, ev);
		}

		/** Creates an Image with a texture that is created from a bitmap object. */
		public static function fromBitmapData(bitmap:BitmapData, frame:Rectangle):Image2
		{
			var texture:Texture = Texture.fromBitmapData(bitmap, false);
			var image2:Image2 = new Image2(texture, frame);
			image2.frame = frame;
			return image2;
		}

		/** @inheritDoc */
		protected override function onVertexDataChanged():void
		{
			mVertexDataCacheInvalid = true;
		}

		public function set scrollV(value:Number):void
		{
			if (!scrollable)
			{
				_scrollV = 0;
				return;
			}
			_scrollV = value;
			if (_scrollV < 0)
			{
				_scrollV = 0;
			}
			//
			updateTexCoords(0, 0, u, v);
			//
			onVertexDataChanged();
		}

		/** Copies the raw vertex data to a VertexData instance.
		 *  The texture coordinates are already in the format required for rendering. */
		public override function copyVertexDataTo(targetData:VertexData, targetVertexID:int = 0):void
		{
			copyVertexDataTransformedTo(targetData, targetVertexID, null);
		}

		/** Transforms the vertex positions of the raw vertex data by a certain matrix
		 *  and copies the result to another VertexData instance.
		 *  The texture coordinates are already in the format required for rendering. */
		public override function copyVertexDataTransformedTo(targetData:VertexData, targetVertexID:int = 0, matrix:Matrix = null):void
		{
			if (mVertexDataCacheInvalid)
			{
				mVertexDataCacheInvalid = false;
				mVertexData.copyTo(mVertexDataCache);
				mTexture.adjustVertexData(mVertexDataCache, 0, 8);
			}

			mVertexDataCache.copyTransformedTo(targetData, targetVertexID, matrix, 0, 8);
		}

		/** The texture that is displayed on the quad. */
		public function get texture():Texture
		{
			return mTexture;
		}

		public function set texture(value:Texture):void
		{
			if (value == null)
			{
				throw new ArgumentError("Texture cannot be null");
			}
			else if (value != mTexture)
			{
				mTexture = value;
				mVertexData.setPremultipliedAlpha(mTexture.premultipliedAlpha);
				mVertexDataCache.setPremultipliedAlpha(mTexture.premultipliedAlpha, false);
				onVertexDataChanged();
			}
		}

		/** The smoothing filter that is used for the texture.
		 *   @default bilinear
		 *   @see starling.textures.TextureSmoothing */
		public function get smoothing():String
		{
			return mSmoothing;
		}

		public function set smoothing(value:String):void
		{
			if (TextureSmoothing.isValid(value))
				mSmoothing = value;
			else
				throw new ArgumentError("Invalid smoothing mode: " + value);
		}

		/** @inheritDoc */
		public override function render(support:RenderSupport, parentAlpha:Number):void
		{
			support.batchQuad(this, parentAlpha, mTexture, mSmoothing);
		}
	}
}

