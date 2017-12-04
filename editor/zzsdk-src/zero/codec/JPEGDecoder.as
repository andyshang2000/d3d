//http://code.google.com/p/as3-jpeg-decoder/downloads/detail?name=jpeg-decoder.zip&can=2&q=

/**
 * __    ___  __ ___   ___                   _           
   \ \  / _ \/__\ _ \ /   \___  ___ ___   __| | ___ _ __ 
    \ \/ /_)/_\/ /_\// /\ / _ \/ __/ _ \ / _` |/ _ \ '__|
 /\_/ / ___//__ /_\\/ /_//  __/ (__ (_) | (_| |  __/ |   
 \___/\/   \__\____/___,' \___|\___\___/ \__,_|\___|_|
 
 * This class lets you decode a JPEG stream in ActionScript 3 in Flash Player 10
 * @author Thibault Imbert (bytearray.org)
 * @version 0.2 - Removed unuseful setters.
 * @version 0.3 - If needed, stream can now be passed when JPEGDecoder is instanciated.
 * @version 0.4 - Check file header before processing it.
 */

package zero.codec
{
	import cmodule.jpegdecoder.CLibInit;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	public final class JPEGDecoder
	{
		private var loader:CLibInit;
		private var lib:Object;
		private var ns:Namespace;
		private var memory:ByteArray;
		private var infos:Array;
		private var position:uint;
		private var length:uint;
		private var buffer:ByteArray = new ByteArray();
		
		private var _pixels:Vector.<uint>;
		private var _width:uint;
		private var _height:uint;
		private var _numComponents:uint;
		private var _colorComponents:uint;
		
		public static const HEADER:int = 0xFFD8;
		
		public function JPEGDecoder ( stream:ByteArray=null )
		{
			if ( stream != null ) parse( stream );
		}
		
		/**
		 * Allows you to inject a JPEG stream to decode it. 
		 * @param stream
		 * @return 
		 */		
		public function parse ( stream:ByteArray ):Vector.<uint>
		{
			stream.position = 0;
			if ( stream.readUnsignedShort() != JPEGDecoder.HEADER )
				throw new Error ("Not a valid JPEG file.");
			loader = new CLibInit();
			loader.supplyFile("stream", stream);
			lib = loader.init();
			
			ns = new Namespace("cmodule.jpegdecoder");
			memory = (ns::gstate).ds;
			infos = lib.parseJPG ("stream");
			
			_width = infos[0];
			_height = infos[1];
			_numComponents = infos[2];
			_colorComponents = infos[3];
			position = infos[4];
			length = width*height*3;
			
			buffer.length = 0;
			buffer.writeBytes(memory, position, length);
			buffer.position = 0;
			
			var lng:uint = buffer.length;
			_pixels = new Vector.<uint>(lng/3, true);
			var count:int;
			
			for ( var i:int = 0; i< lng; i+=3 )
				pixels[int(count++)] = (255 << 24 | buffer[i] << 16 | buffer[int(i+1)] << 8 | buffer[int(i+2)]);
			
			return pixels;
		}
		
		//20120724
		public function parseAsBitmapData ( stream:ByteArray ):BitmapData
		{
			stream.position = 0;
			if ( stream.readUnsignedShort() != JPEGDecoder.HEADER )
				throw new Error ("Not a valid JPEG file.");
			loader = new CLibInit();
			loader.supplyFile("stream", stream);
			lib = loader.init();
			
			ns = new Namespace("cmodule.jpegdecoder");
			memory = (ns::gstate).ds;
			infos = lib.parseJPG ("stream");
			
			_width = infos[0];
			_height = infos[1];
			_numComponents = infos[2];
			_colorComponents = infos[3];
			position = infos[4];
			length = width*height*3;
			
			var bmdBytesId:int=0;
			var bmdBytes:ByteArray=new ByteArray();
			for(var offset:int=0;offset<length;offset+=3){
				bmdBytes[bmdBytesId++]=0xff;
				bmdBytes[bmdBytesId++]=memory[position+offset];
				bmdBytes[bmdBytesId++]=memory[position+offset+1];
				bmdBytes[bmdBytesId++]=memory[position+offset+2];
			}
			var bmd:BitmapData=new BitmapData(_width,_height,false);
			bmd.setPixels(bmd.rect,bmdBytes);
			return bmd;
		}

		public function get pixels():Vector.<uint>
		{
			return _pixels;
		}

		public function get colorComponents():uint
		{
			return _colorComponents;
		}

		public function get numComponents():uint
		{
			return _numComponents;
		}

		public function get height():uint
		{
			return _height;
		}

		public function get width():uint
		{
			return _width;
		}
	}
}