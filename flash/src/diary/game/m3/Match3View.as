package diary.game.m3 
{
	import flash.display.Bitmap;
	
	import fairygui.GObject;
	
	import gui.HUD;
	import gui.IScreen;
	
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * ...
	 * @author damrem
	 */
	public class Match3View extends GObject implements IScreen
	{
		public static var verbose:Boolean;
		public const GAME_OVER:Signal = new Signal();
		
		private var controller:GameController;
		
		public function Match3View() 
		{
			if (verbose)	trace(this + "GameScreen(" + arguments);
			
			//	loading textures needs to be done AFTER starling setup
			Embeds.init();
			this.controller = new GameController();
			super();
		}
		
		override protected function createDisplayObject():void
		{
			setDisplayObject(this.controller.board);
		}
		
		public function enter():void
		{	
			if (verbose)	trace(this + "start(" + arguments);
			
			this.controller.start();
		}
		
		public function exit():void
		{
			this.controller.stop();
		}
		
		public function get score():uint
		{
			return this.controller.score;
		}
		
	}

}