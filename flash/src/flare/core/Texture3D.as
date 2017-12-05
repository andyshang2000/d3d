package flare.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import flare.basic.Scene3D;
	import flare.system.Device3D;
	import flare.system.ILibraryExternalItem;
	
	public class Texture3D extends EventDispatcher implements ILibraryExternalItem 
	{
		
		private static var temp:BitmapData;
		private static var tempTimeout:uint;
		public static const FORMAT_RGBA:int = 0;
		public static const FORMAT_COMPRESSED:int = 1;
		public static const FORMAT_COMPRESSED_ALPHA:int = 2;
		public static const FORMAT_BGR_PACKED:int = 3;
		public static const FORMAT_BGRA_PACKED:int = 4;
		public static const FORMAT_RGBA_HALF_FLOAT:int = 5;
		public static const FILTER_NEAREST:int = 0;
		public static const FILTER_LINEAR:int = 1;
		public static const FILTER_ANISOTROPIC2X:int = 2;
		public static const FILTER_ANISOTROPIC4X:int = 3;
		public static const FILTER_ANISOTROPIC8X:int = 4;
		public static const FILTER_ANISOTROPIC16X:int = 5;
		public static const WRAP_CLAMP:int = 0;
		public static const WRAP_REPEAT:int = 1;
		public static const WRAP_CLAMP_U:int = 2;
		public static const WRAP_CLAMP_V:int = 3;
		public static const TYPE_2D:int = 0;
		public static const TYPE_CUBE:int = 1;
		public static const TYPE_RECTANGLE:int = 2;
		public static const MIP_NONE:int = 0;
		public static const MIP_NEAREST:int = 1;
		public static const MIP_LINEAR:int = 2;
		
		public var bitmapData:BitmapData;
		public var texture:TextureBase;
		private var _request;
		private var _bytes:ByteArray;
		private var _loader:Loader;
		private var _urlLoader:URLLoader;
		private var _bytesTotal:uint;
		private var _bytesLoaded:uint;
		private var _loaded:Boolean = false;
		private var _optimizeForRenderToTexture:Boolean;
		private var _isATF:Boolean;
		private var _width:int;
		private var _height:int;
		private var _typeMode:int = 0;
		private var _format:int;
		public var allowRuntimeCompression:int;
		public var scene:Scene3D;
		public var filterMode:int = 1;
		public var wrapMode:int = 1;
		private var _mipMode:int = 2;
		public var bias:int = 0;
		public var byteFormat:int;
		public var name:String = "";
		public var options:int = 0;
		public var releaseBitmapData:Boolean;
		
		public function Texture3D(request:*=null, optimizeForRenderToTexture:Boolean=false, format:int=0, _arg_4:int=0)
		{
			var i:int;
			this.allowRuntimeCompression = Device3D.allowRuntimeTextureCompression;
			this.releaseBitmapData = Device3D.releaseTextureBitmaps;
			super();
			this._optimizeForRenderToTexture = optimizeForRenderToTexture;
			if (Device3D.dynamicSamplerState)
			{
				this.options = (this.options | 4);
			};
			this.typeMode = _arg_4;
			if ((request is String))
			{
				this.name = request;
				i = this.name.lastIndexOf("/");
				if (i > -1)
				{
					this.name = this.name.substr((i + 1));
				};
			};
			this.format = format;
			this.request = request;
		}
		
		public function get mipMode():int
		{
			return MIP_NONE;
		}

		public function set mipMode(value:int):void
		{
			_mipMode = MIP_NONE;
		}

		public function clone():Texture3D
		{
			var t:Texture3D = new Texture3D(this.request, this.optimizeForRenderToTexture, this.format, this._typeMode);
			t.allowRuntimeCompression = this.allowRuntimeCompression;
			t.releaseBitmapData = this.releaseBitmapData;
			t.filterMode = this.filterMode;
			t.wrapMode = this.wrapMode;
			t.mipMode = this.mipMode;
			t.bias = this.bias;
			t.options = this.options;
			t.name = this.name;
			t.scene = this.scene;
			return (t);
		}
		
		public function get request()
		{
			return (this._request);
		}
		
		public function set request(value:*):void
		{
			var d:DisplayObject;
			var r:Rectangle;
			var m:Matrix;
			var isOk:Boolean;
			var i:int;
			this.loaded = false;
			this._bytesLoaded = 0;
			this._bytesTotal = 0;
			this._bytes = null;
			this._loader = null;
			this._urlLoader = null;
			this._request = value;
			if (this._bytes)
			{
				this._bytes.clear();
				this._bytes = null;
			};
			if (!(this._request is String))
			{
				if ((this._request is ByteArray))
				{
					this._bytes = this._request;
					this._bytes.endian = Endian.LITTLE_ENDIAN;
					this._bytes.position = 0;
					if (this.validATF())
					{
						this.loaded = true;
					};
				}
				else
				{
					if ((this._request is Point))
					{
						this._width = this._request.x;
						this._height = this._request.y;
						this._optimizeForRenderToTexture = true;
						this.loaded = true;
						if ((((!(this.isPowerOfTwo(this._width)))) || ((!(this.isPowerOfTwo(this._height))))))
						{
							throw (new Error("Texture size must be power of two."));
						};
					}
					else
					{
						if ((this._request is Rectangle))
						{
							this._width = this._request.width;
							this._height = this._request.height;
							this._optimizeForRenderToTexture = true;
							this.typeMode = TYPE_RECTANGLE;
							this.mipMode = MIP_NONE;
							this.wrapMode = WRAP_CLAMP;
							this.loaded = true;
						}
						else
						{
							if ((this._request is BitmapData))
							{
								this.bitmapData = this._request;
								this.loaded = true;
								this._width = this.bitmapData.width;
								this._height = this.bitmapData.height;
							}
							else
							{
								if ((this._request is Bitmap))
								{
									this.bitmapData = this._request.bitmapData;
									this.loaded = true;
									this._width = this.bitmapData.width;
									this._height = this.bitmapData.height;
								}
								else
								{
									if ((this._request is DisplayObject))
									{
										d = this._request;
										r = d.getBounds(d);
										m = new Matrix(1, 0, 0, 1, -(r.x), -(r.y));
										this.bitmapData = new BitmapData(((r.width) || (1)), ((r.height) || (1)), true, 0);
										this.bitmapData.draw(d, m);
										this.loaded = true;
										this._width = this.bitmapData.width;
										this._height = this.bitmapData.height;
									}
									else
									{
										if ((this._request is Array))
										{
											isOk = true;
											i = 0;
											while (i < this._request.length)
											{
												if (((((this._request[i] is BitmapData) == false)) && (((this._request[i] is Bitmap) == false))))
												{
													isOk = false;
												};
												if ((this._request[i] is Bitmap))
												{
													this._request[i] = this._request[i].bitmapData;
												};
												if (this._request[i] == null)
												{
													throw (new Error(("BitmapData can not be null at index " + i)));
												};
												i++;
											};
											if ((((!(isOk))) || ((!((this._request.length == 6))))))
											{
												throw (new Error("Cubemaps texture must have 6 BitmapData ot Bitmap objects."));
											};
											this.loaded = true;
											this.wrapMode = WRAP_CLAMP;
											this.typeMode = TYPE_CUBE;
											this._width = this._request[0].width;
											this._height = this._request[0].height;
										}
										else
										{
											throw (new Error(("Unknown texture object. " + this._request)));
										};
									};
								};
							};
						};
					};
				};
			};
		}
		
		public function load():void
		{
			if (((((this.loaded) || (this._loader))) || (this._urlLoader)))
			{
				return;
			};
			if (this._bytes)
			{
				this.completeEvent();
			}
			else
			{
				this._urlLoader = new URLLoader();
				this._urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				this._urlLoader.addEventListener("complete", this.completeEvent);
				this._urlLoader.addEventListener("progress", this.progressEvent);
				this._urlLoader.addEventListener("ioError", this.ioErrorEvent);
				this._urlLoader.load(new URLRequest(this._request));
			};
		}
		
		private function ioErrorEvent(e:IOErrorEvent):void
		{
			this.bitmapData = Device3D.nullBitmapData;
			this.loaded = true;
			this._width = this.bitmapData.width;
			this._height = this.bitmapData.height;
			this._loader = null;
			this._urlLoader = null;
			if (((this.scene) && (this.scene.context)))
			{
				this.contextEvent();
			};
			trace(e);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function progressEvent(e:ProgressEvent):void
		{
			this._bytesLoaded = e.bytesLoaded;
			this._bytesTotal = e.bytesTotal;
			dispatchEvent(e);
		}
		
		private function completeEvent(e:Event=null):void
		{
			var context:LoaderContext;
			if ((!(this._bytes)))
			{
				this._bytes = this._urlLoader.data;
			};
			if (this._urlLoader)
			{
				this._urlLoader.removeEventListener("complete", this.completeEvent);
				this._urlLoader.removeEventListener("progress", this.progressEvent);
				this._urlLoader.removeEventListener("ioError", this.ioErrorEvent);
				this._urlLoader.close();
				this._urlLoader = null;
			};
			if (this.validATF())
			{
				this.loaded = true;
				if (((this.scene) && (this.scene.context)))
				{
					this.contextEvent();
				};
				dispatchEvent(((e) || (new Event(Event.COMPLETE))));
			}
			else
			{
				context = new LoaderContext();
				this._loader = new Loader();
				this._loader.contentLoaderInfo.addEventListener("complete", this.completeLoaderEvent);
				this._loader.contentLoaderInfo.addEventListener("ioError", this.ioErrorEvent);
				this._loader.loadBytes(this._bytes, context);
			};
		}
		
		private function completeLoaderEvent(e:Event):void
		{
			this.loaded = true;
			this.bitmapData = Bitmap(this._loader.content).bitmapData;
			this._width = this.bitmapData.width;
			this._height = this.bitmapData.height;
			this._loader.contentLoaderInfo.removeEventListener("complete", this.completeLoaderEvent);
			this._loader.contentLoaderInfo.removeEventListener("ioError", this.ioErrorEvent);
			this._loader.unloadAndStop();
			this._loader = null;
			if (((this.scene) && (this.scene.context)))
			{
				this.contextEvent();
			};
			dispatchEvent(e);
		}
		
		private function contextEvent(e:Event=null):void
		{
			var w:int;
			var h:int;
			var i:int;
			var size:int;
			if ((!(this.loaded)))
			{
				return;
			};
			if (this.texture)
			{
				this.texture.dispose();
			};
			this.texture = null;
			try
			{
				if (this.typeMode == TYPE_RECTANGLE)
				{
					if (this._isATF)
					{
						this.texture = this.scene.context.createTexture(this._width, this._height, this.stringFormat, this.optimizeForRenderToTexture);
						Texture(this.texture).uploadCompressedTextureFromByteArray(this._bytes, 0);
					}
					else
					{
						if ((this._request is Point))
						{
							this.texture = this.scene.context.createRectangleTexture(this._request.x, this._request.y, this.stringFormat, this.optimizeForRenderToTexture);
						}
						else
						{
							if ((this._request is Rectangle))
							{
								this.texture = this.scene.context.createRectangleTexture(this._request.width, this._request.height, this.stringFormat, this.optimizeForRenderToTexture);
							}
							else
							{
								if ((!(this.bitmapData)))
								{
									this.loaded = false;
									this.load();
									return;
								};
								if ((((this.format == FORMAT_COMPRESSED)) || ((this.format == FORMAT_COMPRESSED_ALPHA))))
								{
									this.format = 0;
								};
								this.texture = this.scene.context.createRectangleTexture(this.bitmapData.width, this.bitmapData.height, this.stringFormat, this.optimizeForRenderToTexture);
								Object(this.texture).uploadFromBitmapData(this.bitmapData);
							};
						};
					};
				};
			}
			catch(err)
			{
				trace(name, err);
				typeMode = TYPE_2D;
			};
			try
			{
				if (this.typeMode == TYPE_2D)
				{
					if (this._isATF)
					{
						this.texture = this.scene.context.createTexture(this._width, this._height, this.stringFormat, this.optimizeForRenderToTexture);
						Texture(this.texture).uploadCompressedTextureFromByteArray(this._bytes, 0);
					}
					else
					{
						if ((this._request is Point))
						{
							this.texture = this.scene.context.createTexture(this._request.x, this._request.y, this.stringFormat, this.optimizeForRenderToTexture);
						}
						else
						{
							if ((!(this.bitmapData)))
							{
								this.loaded = false;
								this.load();
								return;
							};
							w = this.nearPowerOfTwo(this.width);
							h = this.nearPowerOfTwo(this.height);
							if (w > Device3D.maxTextureSize)
							{
								w = Device3D.maxTextureSize;
							};
							if (h > Device3D.maxTextureSize)
							{
								h = Device3D.maxTextureSize;
							};
							if (w < 4)
							{
								w = 4;
							};
							if (h < 4)
							{
								h = 4;
							};
							this.texture = this.scene.context.createTexture(w, h, this.stringFormat, this.optimizeForRenderToTexture);
							this.uploadTexture(this.bitmapData);
						};
					};
				};
			}
			catch(err)
			{
				trace(name, err);
				texture = scene.context.createTexture(4, 4, stringFormat, optimizeForRenderToTexture);
				uploadTexture(new BitmapData(4, 4, false, 0xFF0000));
			};
			if (this.typeMode == TYPE_CUBE)
			{
				if (this._isATF)
				{
					this.texture = this.scene.context.createCubeTexture(this._width, this.stringFormat, this.optimizeForRenderToTexture);
					CubeTexture(this.texture).uploadCompressedTextureFromByteArray(this._bytes, 0);
				}
				else
				{
					if ((this._request is Point))
					{
						this.texture = this.scene.context.createCubeTexture(this._request.x, this.stringFormat, this.optimizeForRenderToTexture);
					}
					else
					{
						if ((this._request is Array))
						{
							this.texture = this.scene.context.createCubeTexture(this.nearPowerOfTwo(this._width), this.stringFormat, this.optimizeForRenderToTexture);
							i = 0;
							while (i < 6)
							{
								this.uploadTexture(this._request[i], i);
								i = (i + 1);
							};
						}
						else
						{
							if ((!(this.bitmapData)))
							{
								this.loaded = false;
								this.load();
								return;
							};
							if (this.width == this.height)
							{
								size = this.width;
							}
							else
							{
								if (this.width > this.height)
								{
									size = (this.width / 4);
								}
								else
								{
									size = (this.width / 3);
								};
							};
							if (size > 0x0400)
							{
								size = 0x0400;
							};
							this.texture = this.scene.context.createCubeTexture(this.nearPowerOfTwo(size), this.stringFormat, this.optimizeForRenderToTexture);
							i = 0;
							while (i < 6)
							{
								this.uploadTexture(this.extractCubeMap(this.bitmapData, i), i);
								i = (i + 1);
							};
						};
					};
				};
			};
			if ((((this._request is Point)) || ((this._request is Rectangle))))
			{
				this.scene.context.setRenderToTexture(this.texture);
				this.scene.context.clear();
				this.scene.context.setRenderToBackBuffer();
			};
			if (((((((this.releaseBitmapData) && (this._bytes))) && (this.bitmapData))) && ((!((this.bitmapData == Device3D.nullBitmapData))))))
			{
				this.bitmapData.dispose();
				this.bitmapData = null;
			};
			if (((((Device3D.releaseBytes) || ((this._request is String)))) && (this._bytes)))
			{
				this._bytes.clear();
				this._bytes = null;
			};
		}
		
		public function close():void
		{
			try
			{
				if (this._loader)
				{
					this._loader.close();
				};
				if (this._urlLoader)
				{
					this._urlLoader.close();
				};
			}
			catch(e)
			{
			};
		}
		
		public function dispose():void
		{
			this.download();
			if (this._loader)
			{
				this._loader.unloadAndStop(false);
				this._loader = null;
			};
			if (this._urlLoader)
			{
				this._urlLoader = null;
			};
			if (this.bitmapData)
			{
				if (this.bitmapData != Device3D.nullBitmapData)
				{
					this.bitmapData.dispose();
				};
				this.bitmapData = null;
			};
			if (this._bytes)
			{
				this._bytes.clear();
			};
			this._request = null;
			this._bytes = null;
		}
		
		public function upload(scene:Scene3D):void
		{
			if (this.scene)
			{
				return;
			};
			this.scene = scene;
			if (this.scene.textures.indexOf(this) == -1)
			{
				this.scene.textures.push(this);
			};
			if ((!(this.loaded)))
			{
				this.load();
			};
			if (this.scene.context)
			{
				this.contextEvent();
			};
			this.scene.addEventListener(Event.CONTEXT3D_CREATE, this.contextEvent);
		}
		
		public function get stringFormat():String
		{
			this.byteFormat = 0;
			if ((((((((!(this._isATF))) && ((!((this.typeMode == TYPE_RECTANGLE)))))) && ((this.format == FORMAT_RGBA)))) && ((!((this.allowRuntimeCompression == 0))))))
			{
				this.byteFormat = this.allowRuntimeCompression;
				if (this.allowRuntimeCompression == 1)
				{
					return ("compressed");
				};
				if (this.allowRuntimeCompression == 2)
				{
					return ("compressedAlpha");
				};
			};
			switch (this.format)
			{
				case FORMAT_RGBA:
					return ("bgra");
				case FORMAT_COMPRESSED:
					this.byteFormat = 1;
					return ("compressed");
				case FORMAT_COMPRESSED_ALPHA:
					this.byteFormat = 2;
					return ("compressedAlpha");
				case FORMAT_BGR_PACKED:
					return ("bgrPacked565");
				case FORMAT_BGRA_PACKED:
					return ("bgraPacked4444");
				case FORMAT_RGBA_HALF_FLOAT:
					return ("rgbaHalfFloat");
				default:
					return (Context3DTextureFormat.BGRA);
			};
		}
		
		public function download():void
		{
			if (this.texture)
			{
				this.texture.dispose();
				this.texture = null;
			};
			if (this.scene)
			{
				this.scene.removeEventListener(Event.CONTEXT3D_CREATE, this.contextEvent);
				this.scene.textures.splice(this.scene.textures.indexOf(this), 1);
				this.scene = null;
			};
		}
		
		public function get bytesTotal():uint
		{
			return (this._bytesTotal);
		}
		
		public function get bytesLoaded():uint
		{
			return (this._bytesLoaded);
		}
		
		public function get optimizeForRenderToTexture():Boolean
		{
			return (this._optimizeForRenderToTexture);
		}
		
		public function get width():int
		{
			return (this._width);
		}
		
		public function set width(value:int):void
		{
			this._width = value;
		}
		
		public function get height():int
		{
			return (this._height);
		}
		
		public function set height(value:int):void
		{
			this._height = this._height;
		}
		
		public function get typeMode():int
		{
			return (this._typeMode);
		}
		
		public function set typeMode(value:int):void
		{
			this._typeMode = value;
			if (value == TYPE_CUBE)
			{
				this.wrapMode = WRAP_CLAMP;
			};
			if (value == TYPE_RECTANGLE)
			{
				this.wrapMode = WRAP_CLAMP;
				this.mipMode = MIP_NONE;
			};
		}
		
		public function get loaded():Boolean
		{
			return (this._loaded);
		}
		
		public function set loaded(value:Boolean):void
		{
			this._loaded = value;
		}
		
		public function get bytes():ByteArray
		{
			return (this._bytes);
		}
		
		public function get isATF():Boolean
		{
			return (this._isATF);
		}
		
		public function get format():int
		{
			return (this._format);
		}
		
		public function set format(value:int):void
		{
			this._format = value;
			switch (this._format)
			{
				case FORMAT_COMPRESSED:
					this.byteFormat = 1;
					break;
				case FORMAT_COMPRESSED_ALPHA:
					this.byteFormat = 2;
					break;
				default:
					this.byteFormat = 0;
			};
		}
		
		public function uploadTexture(source:BitmapData=null, side:int=0):void
		{
			if ((!(this.scene)))
			{
				throw (new Error("The texture is not linked to any scene, you may need to call to Texture3D.upload method before."));
			};
			var bitmapData:BitmapData = ((source) || (this.bitmapData));
			var w:int = this.nearPowerOfTwo(bitmapData.width);
			var h:int = this.nearPowerOfTwo(bitmapData.height);
			if (w > Device3D.maxTextureSize)
			{
				w = Device3D.maxTextureSize;
			};
			if (h > Device3D.maxTextureSize)
			{
				h = Device3D.maxTextureSize;
			};
			if (w < 4)
			{
				w = 4;
			};
			if (h < 4)
			{
				h = 4;
			};
			var transparent:Boolean = bitmapData.transparent;
			var transform:Matrix = new Matrix((w / bitmapData.width), 0, 0, (h / bitmapData.height));
			var mipRect:Rectangle = new Rectangle();
			var level:int;
			var max:int = (Device3D.maxTextureSize * 0.5);
			if ((((!((w == bitmapData.width)))) && ((bitmapData.width > max))))
			{
				max = Device3D.maxTextureSize;
			};
			if ((((!((h == bitmapData.height)))) && ((bitmapData.height > max))))
			{
				max = Device3D.maxTextureSize;
			};
			if ((!(temp)))
			{
				temp = new BitmapData(max, max, true, 0);
			}
			else
			{
				if ((((temp.width < max)) || ((temp.height < max))))
				{
					temp.dispose();
					temp = new BitmapData(max, max, true, 0);
				};
			};
			if (tempTimeout)
			{
				clearTimeout(tempTimeout);
			};
			tempTimeout = setTimeout(this.disposeTempBitmapData, 5000);
			while ((((w >= 1)) || ((h >= 1))))
			{
				if ((((w == bitmapData.width)) && ((h == bitmapData.height))))
				{
					if (this.typeMode == TYPE_2D)
					{
						Texture(this.texture).uploadFromBitmapDataAsync(bitmapData, level);
					}
					else
					{
						if (this.typeMode == TYPE_CUBE)
						{
							CubeTexture(this.texture).uploadFromBitmapData(bitmapData, side, level);
						};
					};
				}
				else
				{
					mipRect.width = w;
					mipRect.height = h;
					if (transparent)
					{
						temp.fillRect(mipRect, 0);
					};
					temp.draw(bitmapData, transform, null, null, mipRect, true);
					if (this.typeMode == TYPE_2D)
					{
						Texture(this.texture).uploadFromBitmapData(temp, level);
					}
					else
					{
						if (this.typeMode == TYPE_CUBE)
						{
							CubeTexture(this.texture).uploadFromBitmapData(temp, side, level);
						};
					};
				};
				transform.a = (transform.a * 0.5);
				transform.d = (transform.d * 0.5);
				w = (w >> 1);
				h = (h >> 1);
				level++;
				if ((((this.mipMode == MIP_NONE)) && ((this.typeMode == TYPE_2D))))
				{
					break;
				};
			};
		}
		
		private function disposeTempBitmapData():void
		{
			temp.dispose();
			temp = null;
		}
		
		private function validATF():Boolean
		{
			var flag:int;
			var isCube:int;
			if (((this._bytes) && ((this._bytes.length >= 3))))
			{
				this._bytes.position = 0;
				if (this._bytes.readUTFBytes(3) == "ATF")
				{
					if (this._bytes[6] == 0xFF)
					{
						this._bytes.position = 12;
					}
					else
					{
						this._bytes.position = 6;
					};
					flag = this._bytes.readUnsignedByte();
					isCube = (flag >> 7);
					switch ((flag & 127))
					{
						case 0:
						case 1:
							this.format = FORMAT_RGBA;
							break;
						case 2:
						case 3:
							this.format = FORMAT_COMPRESSED;
							break;
						case 4:
						case 5:
							this.format = FORMAT_COMPRESSED_ALPHA;
							break;
					};
					if (isCube == 0)
					{
						this.typeMode = TYPE_2D;
					}
					else
					{
						this.typeMode = TYPE_CUBE;
						this.wrapMode = WRAP_CLAMP;
					};
					this._width = (1 << this._bytes.readUnsignedByte());
					this._height = (1 << this._bytes.readUnsignedByte());
					this._isATF = true;
				};
			};
			return (this._isATF);
		}
		
		private function extractCubeMap(bmp:BitmapData, side:int):BitmapData
		{
			var data:Array;
			var b:BitmapData;
			var images:Array = [];
			var m:Matrix = new Matrix();
			var size:int = (((bmp.width > bmp.height)) ? (bmp.width / 4) : (bmp.width / 3));
			if (bmp.width > bmp.height)
			{
				data = [2, 1, 0, 0, 1, 0, 1, 0, 0, 1, 2, 0, 1, 1, 0, 3, 1, 0];
			}
			else
			{
				data = [2, 1, 0, 0, 1, 0, 1, 0, 0, 1, 2, 0, 1, 1, 0, 2, 4, Math.PI];
			};
			if (bmp.width == bmp.height)
			{
				b = bmp;
			}
			else
			{
				b = new BitmapData(size, size, bmp.transparent, 0);
				m.identity();
				m.translate((-(size) * data[(side * 3)]), (-(size) * data[((side * 3) + 1)]));
				m.rotate(data[((side * 3) + 2)]);
				b.fillRect(b.rect, 0);
				b.draw(bmp, m);
			};
			return (b);
		}
		
		private function isPowerOfTwo(x:int):Boolean
		{
			return (((x & (x - 1)) == 0));
		}
		
		private function nearPowerOfTwo(x:int):int
		{
			var w:int = 1;
			while ((w << 1) <= x)
			{
				w = (w << 1);
			};
			return (w);
		}
		
		override public function toString():String
		{
			return ((("[object Texture3D name:" + this.name) + "]"));
		}
		
		
	}
}//package flare.core