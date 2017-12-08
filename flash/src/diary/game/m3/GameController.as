package diary.game.m3 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import diary.game.m3.states.AbstractState;
	import diary.game.m3.states.Combine;
	import diary.game.m3.states.Destroyer;
	import diary.game.m3.states.FallerAndFiller;
	import diary.game.m3.states.InputListener;
	import diary.game.m3.states.Matcher;
	import diary.game.m3.states.Swapper;
	
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	
	/**
	 * Main controller of the game.
	 * It handles the transition between the differents states/sub-controllers,
	 * depending on the signals they dispatch.
	 * It also handles score and time.
	 * @author damrem
	 */
	public class GameController 
	{
		public static var verbose:Boolean;
		
		//	score management
		private var _score:uint;
		public const SCORE_UPDATED:Signal = new Signal();
		
		//	the board containing the pawns
		private var _board:Board;
		
		//	the current sub-controller
		private var currentState:AbstractState;
		
		//	the sub-controllers
		private var matcher:Matcher;
		private var combine:Combine;
		private var destroyer:Destroyer;
		private var fallerAndFiller:FallerAndFiller;
		private var inputListener:InputListener;
		private var swapper:Swapper;
		
		public function GameController() 
		{
			if (verbose)	trace(this + "GameController(" + arguments);
			
			this._board = new Board(9,9);
			
			this.fallerAndFiller = new FallerAndFiller(this._board);
			this.inputListener = new InputListener(this._board);
			this.swapper = new Swapper(this._board);
			this.matcher = new Matcher(this._board);
			this.destroyer = new Destroyer(this._board);
			this.combine = new Combine(this._board);

			
		}
		
		public function start():void
		{
			if (verbose)	trace(this + "start(" + arguments);
			
			
			
			this.fallerAndFiller.FILLED.add(this.gotoMatcher);
			this.inputListener.SWAP_REQUESTED.add(this.gotoSwapper);
			
			this.swapper.SWAPPED.add(this.gotoMatcher);
			this.swapper.UNSWAPPED.add(this.gotoInputListener);

			this.updateScore("GameController");
			
			//	this will be plugged only after a 1st swipe, to prevent scoring during initial board filling
			//this.matcher.MATCHES_FOUND.add(this.updateScore);
			
			this.matcher.MATCHES_FOUND.add(this.gotoCombine);
			this.matcher.MATCHES_FOUND.add(this.gotoDestroyer);
			this.matcher.INVALID_SWAP.add(this.gotoSwapper);
			this.matcher.NO_MATCHES_FOUND.add(this.gotoInputListener);
			
			this.destroyer.ALL_ARE_DESTROYED.add(this.gotoFillerAndFaller);
			
			this._score = 0;
			this.updateScore("start");			
			this.board.fillWithHoles();
			this.gotoFillerAndFaller();
		}
		
		/**
		 * Unset the state and unplug all the signals.
		 */
		public function stop():void
		{
			if (verbose)	trace(this + "stop(" + arguments);
			
			this.setState(null);
			
			this.destroyer.exit();
			this.fallerAndFiller.exit();
			this.inputListener.exit();
			this.matcher.exit();
			this.swapper.exit();
			
			Pawn.unselect();
			
			this.fallerAndFiller.FILLED.removeAll();
			
			this.inputListener.SWAP_REQUESTED.removeAll();
			
			this.swapper.SWAPPED.removeAll();
			this.swapper.UNSWAPPED.removeAll();

			this.matcher.MATCHES_FOUND.removeAll();
			this.matcher.INVALID_SWAP.removeAll();
			this.matcher.NO_MATCHES_FOUND.removeAll();
			
			this.destroyer.ALL_ARE_DESTROYED.removeAll();
			
			this.board.reset();
		}
		
		private function updateScore(caller:String="other"):void 
		{
			if (verbose)	trace(this + "updateScore(" + arguments);
			
			var matchScore:int = this.board.destroyablePawns.length;
			matchScore -= 2;
			matchScore = Math.max(matchScore, 0);
			matchScore *= Math.min(3, matchScore);
			matchScore *= 10;
			
			this._score += matchScore;
			this.SCORE_UPDATED.dispatch(this.score);
		}
		
		/**
		 * Defines the current state, by exiting the previous one, and entering the specified one.
		 * @param	state
		 */
		private function setState(state:AbstractState):void
		{
			if (verbose)	trace(this + "setState(" + arguments);
			
			if (currentState)
			{
				currentState.exit();
			}
			
			currentState = state;
			
			if (currentState)
			{
				currentState.enter("gameController.setState");
			}
		}
		
		/**
		 * Enter the input state.
		 * @param	caller
		 */
		private function gotoInputListener(caller:String="other"):void
		{
			if (verbose)	trace(this + "gotoInputListener(" + arguments);
			
			this.setState(this.inputListener);
		}
		
		/**
		 * Depending on from what's just happened, we will swap or unswap.
		 * @param	isUnswapping
		 */
		private function gotoSwapper(isUnswapping:Boolean=false):void 
		{
			if (verbose)	trace(this + "gotoSwapper(" + arguments);
			
			this.swapper.isUnswapping = isUnswapping; 
			this.setState(this.swapper);
		}
		
		/**
		 * Enter the states which detects matches.
		 */
		private function gotoMatcher():void
		{
			if (verbose)	trace(this + "gotoMatcher(" + arguments);
			
			this.setState(this.matcher);
		}
		
		private function gotoCombine():void
		{
			this.setState(this.combine);
		}
		/**
		 * Enter the states which destroys pawns.
		 */
		private function gotoDestroyer():void 
		{
			if (verbose)	trace(this + "gotoDestroyer(" + arguments);
			
			this.setState(this.destroyer);
		}
		
		/**
		 * Enter the states which generates pawns and make them fall.
		 */
		private function gotoFillerAndFaller():void 
		{
			if (verbose)	trace(this + "gotoFillAndFall(" + arguments);
			
			this.setState(this.fallerAndFiller);
		}
		
		public function get board():Board 
		{
			return _board;
		}
		
		public function get score():uint 
		{
			return _score;
		}		
	}
}