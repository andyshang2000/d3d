package diary.game.m3 
{
	import flash.geom.Point;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	import utils.Random;
	
	/**
	 * ...
	 * @author damrem
	 */
	public class Pawn extends Sprite
	{
		public static var verbose:Boolean;
		
		private static var _selected:Pawn;
		
		private var _type:int;
		private var _index:int;
		private var _special:int = 0;
		
		public var debugTf:TextField;
		
		public static const SIZE:int = 62;
		
		public static const COLORS:Array = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0xff00ff];
		
		public static const SP_NORMAL:int = 1;
		public static const SP_ROW:int = 1;
		public static const SP_BLOCK:int = 2;
		public static const SP_BIRD:int = 3;
		
		public static const BRICK:int = 100; //附近消除，砖减一
		public static const ICE:int = 200; //动物下的冰块，动物消除冰块减一
		public static const NET:int = 300; //网，动物上的网，动物符合消除条件，网减一
		public static const HONEY:int = 400; //蜂蜜，动物上的网，周围或者动物消除，消失
		public static const CLOUD:int = 400; //云，附近消除消失，没有消除增加一

		private var img:Image;
		/**
		 * Does nothing.
		 * The pawn 'construction' is made by the reset() method for pooling.
		 */
		public function Pawn()
		{
			if (verbose)	trace(this + "Pawn(" + arguments);
		}

		/**
		 * Replaces the constructor. Useful for pooling.
		 */
		public function reset():void
		{
			if(verbose)	trace(this + "reset(" + arguments);
			this.type = Random.getInteger(0, 3);
			
			this.alpha = 1.0;
			this.scaleX = this.scaleY = 1.0;
			
			this.drawGem();
			
			Pawn.select(this);
			Pawn.unselect();
		}
		
		public function refresh():void
		{
			img.texture = Embeds.gemTextures[Math.min(this.type + special * 6, Embeds.gemTextures.length - 1)];
		}
		
		private function drawGem():void
		{
			img = new Image(Embeds.gemTextures[Math.min(this.type + special * 6, Embeds.gemTextures.length - 1)]);
			this.addChild(img);
		}
		
		private function drawQuad():void
		{
			this.addChild(new Quad(SIZE, SIZE, COLORS[this.type]));
			
			if (verbose)
			{
				this.debugTf = new TextField(SIZE, SIZE/2, "");
				this.updateDebug();
				if(verbose)	this.addChild(this.debugTf);
			}
			
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function setIndex(value:int):void 
		{
			_index = value;
			this.updateDebug();
		}
		
		private function updateDebug():void
		{
			if (this.debugTf)	this.debugTf.text = index + ":" + _type;
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set type(value:int):void 
		{
			_type = value;
			this.updateDebug();
		}
		
		static public function get selected():Pawn 
		{
			return _selected;
		}
		
		/**
		 * Removes the graphics from its parent, and the contained graphics as well.
		 */
		public function remove():void
		{
			this.removeChildren();
			
			if (this.parent)
			{
				_special = 0;
				this.parent.removeChild(this);
			}
		}
		
		static public function select(pawn:Pawn):void
		{
			Pawn._selected = pawn;
			Pawn._selected.alpha = 0.75;
		}
		
		static public function unselect():void
		{
			if (Pawn.selected)
			{
				Pawn._selected.alpha = 1.0;
				Pawn._selected = null;
			}
		}
		
		
		public function get special():int
		{
			return _special;
		}
		
		public function set special(value:int):void
		{
			_special = value;
		}
		
		public function toString():String
		{
			return "[Pawn (index:"+this.index+", color:"+this.type+", special:" + this._special + ")";
		}
	}

}