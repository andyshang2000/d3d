package 
{
	import diary.game.m3.Board;
	import diary.game.m3.Pawn;
	import diary.game.m3.PawnPool;
	import diary.game.m3.GameController;
	import diary.game.m3.Match3View;
	import diary.game.m3.states.FallerAndFiller;
	import diary.game.m3.states.InputListener;
	import diary.game.m3.states.Matcher;
	import diary.game.m3.states.Destroyer;
	import diary.game.m3.states.Swapper;
	import utils.getSimpleToString;
	import utils.FPSCounter;
	import gui.GameOverScreen;
	
	/**
	 * @author damrem
	 */
	public class Verbosifier 
	{		
		public static function setup():void
		{
			var classes:Vector.<Class> = new <Class>
			[
				//Embeds,
				//Main,
				//Root,
				//GameScreen,
				//GameOverScreen,
				//GameController,
				//InputListener,
				//Destroyer,
				//Board, 
				//Swapper,
				//FallerAndFiller,
				//Assets,
				//Matcher,
				//Pawn,
				//PawnPool,
				//FPSCounter
			];
			
			for each(var classToDebug:Class in classes)
			{
				classToDebug['verbose'] = true;
				classToDebug.prototype['toString'] = getSimpleToString(classToDebug);
			}
		}
	}
}
