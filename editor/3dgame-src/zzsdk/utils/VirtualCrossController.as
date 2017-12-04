package zzsdk.utils
{
	import flash.display.Bitmap;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	import nblib.util.callLater;

	import starling.events.Touch;

	public class VirtualCrossController extends Sprite
	{
		private static var instance:VirtualCrossController;

		private static var keyMap:Object;

		public static var WASD:Object = {"up": {"key": Keyboard.W, "char": 0}, //
				"down": {"key": Keyboard.W, "char": 0}, //
				"left": {"key": Keyboard.W, "char": 0}, //
				"right": {"key": Keyboard.W, "char": 0}, //
				"A": {"key": Keyboard.K, "char": 0}, //
				"B": {"key": Keyboard.J, "char": 0}, //
				"L1": {"key": Keyboard.U, "char": 0}, //
				"R1": {"key": Keyboard.I, "char": 0}, //
				"start": {"key": Keyboard.ENTER, "char": 0}, //
				"select": {"key": Keyboard.SPACE, "char": 0} //
			};

		public static var ARROW:Object = {"up": {"key": Keyboard.UP, "char": 0}, //
				"down": {"key": Keyboard.DOWN, "char": 0}, //
				"left": {"key": Keyboard.LEFT, "char": 0}, //
				"right": {"key": Keyboard.RIGHT, "char": 0}, //
				"A": {"key": Keyboard.Z, "char": 0}, //
				"B": {"key": Keyboard.X, "char": 0}, //
				"L1": {"key": Keyboard.C, "char": 0}, //
				"R1": {"key": Keyboard.V, "char": 0}, //
				"start": {"key": Keyboard.ENTER, "char": 0}, //
				"select": {"key": Keyboard.SPACE, "char": 0}};

		[Embed(source = "gamecontrol.xml", mimeType = "application/octet-stream")]
		public var gamecontrol_xml:Class;
		[Embed(source = "gamecontrol.png", mimeType = "image/png")]
		public var gamecontrol_png:Class;

		public var dotPosition:Point = new Point;
		public var center:Point = new Point;
		public var R:Number = 0;

		private var crossBitmap:Bitmap;
		private var circleBitmap:Bitmap;
		private var dot:Sprite;

		private var cross:Sprite;
		private var buttons:Sprite;

		private var altas:BitmapTextureAltas;

		private var AButton:Bitmap;

		private var BButton:Bitmap;

		private var LButton:Bitmap;

		private var RButton:Bitmap;

		private var buttonsArr:Array;
		private var _scaleX:Number;
		private var _scaleY:Number;

		private static var _stage:Stage;
		private static var defaultEnabled:Boolean = true;
		private var trustFocus:InteractiveObject;

		public static function enable():void
		{
			if (!instance)
			{
				defaultEnabled = true;
				return;
			}
			if (_stage)
			{
				instance.visible = true;
				instance.mouseEnabled = true;
				instance.mouseChildren = true;
				_stage.addChild(instance);
			}
		}

		public static function disable():void
		{
			if (!instance)
			{
				defaultEnabled = false;
				return;
			}
			if (_stage && instance.stage)
			{
				_stage.removeChild(instance);
			}
			else
			{
				instance.visible = false;
				instance.mouseEnabled = false;
				instance.mouseChildren = false;
			}
		}

		public static function setupStyle(style:Object = "ARROW"):void
		{
			if (style == "ARROW")
			{
				keyMap = ARROW;
			}
			else
			{
				keyMap = {};
				var order:Array = ["up", "down", "left", "right", //
					"A", "B", "L1", "R1", //
					"start", "select"];
				var cArr:Array = (style + "").split(",");
				for (var i:int = 0; i < cArr.length; i++)
				{
					if ((Keyboard as Object).hasOwnProperty([cArr[i]]))
					{
						var keyCode:int = Keyboard[cArr[i]]
						var char:String = String.fromCharCode(keyCode);
						var charCode:int = 0;
						if (char.length > 0)
							charCode = char.toLowerCase().charCodeAt(0);
						else
							charCode = 0;
						keyMap[order[i]] = {"key": Keyboard[cArr[i]], "char": charCode};
					}
					else
					{
						delete keyMap[order[i]];
					}
				}
				for (; i < order.length; i++)
				{
					delete keyMap[order[i]];
				}
			}
		}

		public function VirtualCrossController()
		{
			instance = this;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			setupStyle();
		}

		protected function addedToStageHandler(event:Event):void
		{
			_stage = stage;
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			//
			altas = new BitmapTextureAltas(new gamecontrol_png, XML(new gamecontrol_xml));
			//
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			trace("Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT")
			setupCross();
			setupButtons();

			if (!visible || !defaultEnabled)
			{
				disable();
			}
		}

		private function setupCross():void
		{
			cross = new Sprite;
			crossBitmap = altas.getBitmap("cross");
			circleBitmap = altas.getBitmap("circle");

			var dotBitmap:Bitmap = altas.getBitmap("dot")
			dot = new Sprite;
			dot.addChild(dotBitmap);
			dotBitmap.x = -dotBitmap.width / 2;
			dotBitmap.y = -dotBitmap.height / 2;

			crossBitmap.x = (circleBitmap.width - crossBitmap.width) / 2
			crossBitmap.y = (circleBitmap.height - crossBitmap.height) / 2

			R = circleBitmap.width / 2
			center.x = R;
			center.y = R;
			R -= dotBitmap.width / 2;

			cross.addChild(crossBitmap);
			addChild(cross);

			var aspectFull:Number = stage.fullScreenWidth / stage.fullScreenHeight;
			var aspectStage:Number = gDimenssion.width / gDimenssion.height;

			cross.height = gDimenssion.height / 4
			cross.width = cross.height * aspectStage / aspectFull;
			cross.y = gDimenssion.height - cross.height * 2 - 10;
			cross.x = 10;
			_scaleX = cross.scaleX
			_scaleY = cross.scaleY

			cross.addEventListener(TouchEvent.TOUCH_BEGIN, touchEvent);
		}

		private function setupButtons():void
		{
			var dotBitmap:Bitmap = altas.getBitmap("dot")
			var numButtons:int = 0;
			buttonsArr = [];
			buttons = new Sprite;
			if (keyMap.A)
			{
				AButton = new Bitmap(dotBitmap.bitmapData);
				AButton.name = "A";
				numButtons++;
				buttons.addChild(AButton);
				buttonsArr.push(AButton);
			}
			if (keyMap.B)
			{
				BButton = new Bitmap(dotBitmap.bitmapData);
				BButton.name = "B";
				numButtons++;
				buttons.addChild(BButton);
				buttonsArr.push(BButton);
			}
			if (keyMap.L1)
			{
				LButton = new Bitmap(dotBitmap.bitmapData);
				LButton.name = "L1";
				numButtons++;
				buttons.addChild(LButton);
				buttonsArr.push(LButton);
			}
			if (keyMap.R1)
			{
				RButton = new Bitmap(dotBitmap.bitmapData);
				RButton.name = "R1";
				numButtons++;
				buttons.addChild(RButton);
				buttonsArr.push(RButton);
			}
			buttons.addEventListener(TouchEvent.TOUCH_BEGIN, buttonDown);
			//
			//position
			var button:Bitmap;
			if (buttonsArr.length == 1)
			{
				button = buttonsArr[0];
				button.scaleX = _scaleX * 1.2;
				button.scaleY = _scaleY * 1.2;
				button.x = gDimenssion.width - 150;
				button.y = gDimenssion.height - 150;
			}
			if (buttonsArr.length == 2)
			{
				button = buttonsArr[0];
				button.scaleX = _scaleX * 1.1;
				button.scaleY = _scaleY * 1.1;
				button.x = gDimenssion.width - 105;
				button.y = gDimenssion.height - 175;

				button = buttonsArr[1];
				button.scaleX = _scaleX * 1.1;
				button.scaleY = _scaleY * 1.1;
				button.x = gDimenssion.width - 200;
				button.y = gDimenssion.height - 130;
			}
			if (buttonsArr.length == 3)
			{
				button = buttonsArr[2];
				button.scaleX = _scaleX;
				button.scaleY = _scaleY;
				button.x = gDimenssion.width - 80;
				button.y = gDimenssion.height - 160;

				button = buttonsArr[1];
				button.scaleX = _scaleX;
				button.scaleY = _scaleY;
				button.x = gDimenssion.width - 150;
				button.y = gDimenssion.height - 130;

				button = buttonsArr[0];
				button.scaleX = _scaleX;
				button.scaleY = _scaleY;
				button.x = gDimenssion.width - 220;
				button.y = gDimenssion.height - 100;
			}
			if (buttonsArr.length == 4)
			{
				button = buttonsArr[0];
				button.scaleX = _scaleX * .95;
				button.scaleY = _scaleY * .95;
				button.x = gDimenssion.width - button.width - 90;
				button.y = gDimenssion.height - button.height - 140;

				button = buttonsArr[1];
				button.scaleX = _scaleX * .95;
				button.scaleY = _scaleY * .95;
				button.x = gDimenssion.width - button.width - 150;
				button.y = gDimenssion.height - button.height - 80;

				button = buttonsArr[2];
				button.scaleX = _scaleX * .95;
				button.scaleY = _scaleY * .95;
				button.x = gDimenssion.width - button.width - 90;
				button.y = gDimenssion.height - button.height - 30;

				button = buttonsArr[3];
				button.scaleX = _scaleX * .95;
				button.scaleY = _scaleY * .95;
				button.x = gDimenssion.width - button.width - 30;
				button.y = gDimenssion.height - button.height - 80;
			}
			addChild(buttons);
		}

		protected function buttonDown(event:TouchEvent):void
		{
			stage.addEventListener(TouchEvent.TOUCH_END, buttonMouseUp);
			for (var i:int = 0; i < buttonsArr.length; i++)
			{
				var button:Bitmap = buttonsArr[i];
				if (button.hitTestPoint(event.stageX, event.stageY, false))
				{
					pressKey(button.name);
					break;
				}
			}
		}

		protected function buttonMouseUp(event:TouchEvent):void
		{
			stage.removeEventListener(TouchEvent.TOUCH_END, buttonMouseUp);
			releaseKey("A");
			releaseKey("B");
			releaseKey("L1");
			releaseKey("R1");
		}

		protected function touchEvent(event:TouchEvent):void
		{
			event.updateAfterEvent();

			cross.removeEventListener(TouchEvent.TOUCH_BEGIN, touchEvent);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, stageMouseMove);
			stage.addEventListener(TouchEvent.TOUCH_END, stageMouseUp);

			if (crossBitmap.parent)
			{
				cross.removeChild(crossBitmap);
				cross.addChild(circleBitmap);
				cross.addChild(dot);
				dot.startDrag(true, null);
				var p:Point = new Point(event.stageX, event.stageY);
				p = dot.parent.globalToLocal(p);
				dot.x = p.x;
				dot.y = p.y;
				updateDotPosition();
				callLater(function():void
				{
					addEventListener(Event.ENTER_FRAME, enterFrame);
				});
			}
		}

		protected function enterFrame(event:Event):void
		{
			var hR:Number = R / 2;
			var offsetX:Number = dotPosition.x - center.x;
			var offsetY:Number = dotPosition.y - center.y;

			if (offsetX > hR)
				pressKey("right");
			else
			{
				releaseKey("right");
				if (offsetX < -hR)
					pressKey("left");
				else
					releaseKey("left");

			}
			if (offsetY > hR)
				pressKey("down");
			else
			{
				releaseKey("down");
				if (offsetY < -hR)
					pressKey("up");
				else
					releaseKey("up");

			}
		}

		private function releaseKey(v:String):void
		{
			if (keyMap[v] && keyMap[v].pressed)
			{
				keyMap[v].pressed = false;
				if (stage.focus)
				{
					trustFocus = stage.focus;
					stage.focus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, false, keyMap[v]["char"], keyMap[v]["key"]));
				}
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, false, keyMap[v]["char"], keyMap[v]["key"]));
			}
		}

		private function pressKey(v:String):void
		{
			if (keyMap[v])
			{
				keyMap[v].pressed = true;
				if (trustFocus)
				{
					trustFocus.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, false, keyMap[v]["char"], keyMap[v]["key"]));
				}
				stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, false, false, keyMap[v]["char"], keyMap[v]["key"]));
			}
		}

		protected function stageMouseUp(event:TouchEvent):void
		{
			cross.addEventListener(TouchEvent.TOUCH_BEGIN, touchEvent);
			stage.removeEventListener(TouchEvent.TOUCH_MOVE, stageMouseMove);
			stage.removeEventListener(TouchEvent.TOUCH_END, stageMouseUp);
			removeEventListener(Event.ENTER_FRAME, enterFrame);

			cross.addChild(crossBitmap);
			cross.removeChild(circleBitmap);
			cross.removeChild(dot);

			releaseKey("up");
			releaseKey("down");
			releaseKey("left");
			releaseKey("right");
		}

		protected function stageMouseMove(event:TouchEvent):void
		{
			event.updateAfterEvent();
			updateDotPosition();
		}

		private function updateDotPosition():void
		{
			dotPosition.x = dot.x;
			dotPosition.y = dot.y;
			if (Point.distance(center, dotPosition) > R)
			{
				var d:Point = dotPosition.subtract(center);
				d.normalize(R);
				dotPosition = center.add(d);
				dot.x = dotPosition.x;
				dot.y = dotPosition.y;
			}
		}
	}
}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

class BitmapTextureAltas
{
	private var source:BitmapData;
	private var xml:XML;
	private var bitmapDataDic:Object = {};
	private var rectDic:Object = {};

	public function BitmapTextureAltas(source:*, xml:XML)
	{
		setupSource(source);
		for each (var subTexture:XML in xml.SubTexture)
		{
			var x:Number = Number(subTexture.@x);
			var y:Number = Number(subTexture.@y);
			var w:Number = Number(subTexture.@width);
			var h:Number = Number(subTexture.@height);
			rectDic[subTexture.@name] = new Rectangle(x, y, w, h);
		}
	}

	private function setupSource(source:*):void
	{
		if (source is Class)
		{
			setupSource(source);
			return;
		}
		if (source is Bitmap)
		{
			setupSource((source as Bitmap).bitmapData);
			return;
		}
		if (source is BitmapData)
		{
			this.source = source;
		}
	}

	public function getBitmap(name:String):Bitmap
	{
		var bitmap:Bitmap = new Bitmap(getBitmapData(name));
		bitmap.smoothing = true;
		return bitmap;
	}

	public function getRect(name:String):Rectangle
	{
		return rectDic[name];
	}

	private function getBitmapData(name:String):BitmapData
	{
		if (bitmapDataDic[name])
			return bitmapDataDic[name];
		//
		var rect:Rectangle = getRect(name);
		var bitmapData:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
		bitmapData.copyPixels(source, rect, new Point(0, 0));
		return bitmapDataDic[name] = bitmapData;
	}
}
