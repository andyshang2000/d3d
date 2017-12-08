package diary.game.m3.states 
{
	import diary.game.m3.Board;
	import diary.game.m3.Pawn;
	
	import org.osflash.signals.Signal;
	/**
	 * Controller which detects matches.
	 * @author damrem
	 */
	public class Matcher extends AbstractState
	{
		public static var verbose:Boolean = true;
		
		public const NO_MATCHES_FOUND:Signal = new Signal();
		public const MATCHES_FOUND:Signal = new Signal();
		public const INVALID_SWAP:Signal = new Signal();
		
		public function Matcher(board:Board) 
		{
			if (verbose)	trace(this + "Matcher(" + arguments);
			
			super(board);
		}
		
		override public function enter(caller:String="other"):void
		{
			if (verbose)	trace(this + "enter(" + arguments);
			
			//	if no pawns have to be checked, we consider and dispatch that there's no matches found
			if (this.board.matchablePawns.length == 0)
			{
				if (verbose)	trace("NO MATCHES because no matchable pawns");
				this.NO_MATCHES_FOUND.dispatch("matcher.enter with no matchables");
				return;
			}
			
			this.board.matchedPawns = new <Vector.<Pawn>>[];
			//	we check if there are matches
			//	for each matchable pawn
			var areMatchesFound:Boolean;	//	we will dispatch only if any of the matchable pawns is part of a match
			
			if(this.board.matchablePawns.length == 2)
			{
				var a:Pawn = this.board.matchablePawns[0];
				var b:Pawn = this.board.matchablePawns[1];
				if(a.special > 0 && b.special > 0)
				{
					if(a.special <= 2 && b.special <= 2)
					{
						cross(b);
					}
					else if((a.special <= 2 && b.special == 3) ||//
						(a.special == 3 && b.special <= 2))//
					{
						bigCross(b);
					}
					else if(a.special == 3 && b.special == 3)
					{
						bigSquare(b);
					}
					else if(a.special == 4 || b.special == 4)
					{
						if(a.special == 4)
						{
							mass(b);
						}
						else
						{
							mass(a);
						}
					}
				}
				else if(a.special == 4 || b.special == 4)
				{
					if(a.special == 4)
					{
						mass(b);
					}
					else
					{
						mass(a);
					}
				}
				areMatchesFound = true;
			}
			
			for (var i:int = 0; i < this.board.matchablePawns.length;i++ )
			{
				var pawn:Pawn = this.board.matchablePawns[i];
				
				var onePawnMatches:Vector.<Pawn> = this.getMatches(pawn);
				
				if (verbose)	if(onePawnMatches.length)	trace(this+"matches for "+pawn+":" + onePawnMatches);
				
				//	if there's at least 1 match (vertical and/or horizontal)
				//	we will dispatch it, and we elect the pawns for later destruction
				if (onePawnMatches.length)
				{
					areMatchesFound = true;
					
					this.electMatchesForDestruction(onePawnMatches);
				}
			}
			
			if(verbose)	trace(this+"matchables: " + this.board.matchablePawns);
			
			//	swap check and no matches
			if (this.board.matchablePawns.length == 2 && !areMatchesFound)
			{
				if (verbose)	trace(this+"swap check and no matches");
				this.board.electPawnsForSwapping(this.board.matchablePawns[0], this.board.matchablePawns[1]);
				this.board.resetMatchablePawns();
				this.INVALID_SWAP.dispatch(true);
			}

			//	global check and no matches
			else if (this.board.matchablePawns.length > 2 && !areMatchesFound)
			{
				if (verbose)	trace(this+"global check and no matches");
				this.board.resetMatchablePawns();
				this.NO_MATCHES_FOUND.dispatch("matcher.enter with no matches on board");
			}
			
			//	any check and matches found
			else if (areMatchesFound)
			{
				if (verbose)	trace(this+"any check and matches found");
				this.board.resetMatchablePawns();
				this.MATCHES_FOUND.dispatch();
			}
		}
		
		
		private function hLine(a:Pawn):void
		{
			if(a == null)
				return
			var p:Pawn;
			this.board.destroyablePawns.push(a);
			p = a;
			while(p != null)
			{	
				p = this.board.getLeftPawn(p);
				markDestroy(p);
			}
			p = a;
			while(p != null)
			{	
				p = this.board.getRightPawn(p);
				markDestroy(p);
			}
		}
		
		private function vLine(a:Pawn):void
		{
			if(a == null)
				return
			var p:Pawn;
			p = a;
			markDestroy(p)
			while(p != null)
			{	
				p = this.board.getBottomPawn(p);
				markDestroy(p);
			}
			p = a;
			while(p != null)
			{	
				p = this.board.getTopPawn(p);
				markDestroy(p);
			}
		}
		
		private function markDestroy(p:Pawn):Boolean
		{
			if(p != null)
			{
				if (this.board.destroyablePawns.indexOf(p) == -1)
				{
					this.board.destroyablePawns.push(p);
					if(p.special == 1)
					{
						hLine(p);
					}
					else if(p.special == 2)
					{
						vLine(p);
					}
					else if(p.special == 3)
					{
						cross(p);
					}
					else if(p.special == 4)
					{
						mass(p);
					}
					return true;
				}
			}
			return false;
		}
		
		private function mass(m:Pawn):void
		{
			return;
			if(m.special == 0)
			{
				for each (var p:Pawn in this.board.pawns) 
				{
					if(p.type == m.type)
					{
						markDestroy(p);
					}
				}
			}
			else
			{
				for each (var p:Pawn in this.board.pawns) 
				{
					if(p.type == m.type)
					{
						p.special = m.special;
						markDestroy(p);
					}
				}
			}
		}
		
		private function cross(a:Pawn):void
		{
			hLine(a);
			vLine(a);
		}
		
		private function bigCross(a:Pawn):void
		{
			hLine(a);
			hLine(this.board.getBottomPawn(a));
			hLine(this.board.getTopPawn(a));
			vLine(a);
			vLine(this.board.getLeftPawn(a));
			vLine(this.board.getRightPawn(a));
		}
		
		private function square(a:Pawn):void
		{
			var p:Pawn;
			markDestroy(p = a);
			if(markDestroy(p = this.board.getBottomPawn(a)))
			{				
				markDestroy(this.board.getLeftPawn(p));
				markDestroy(this.board.getRightPawn(p));
				markDestroy(this.board.getBottomPawn(p));
			}
			
			if(markDestroy(p = this.board.getTopPawn(a)))
			{
				markDestroy(this.board.getLeftPawn(p));
				markDestroy(this.board.getRightPawn(p));
				markDestroy(this.board.getTopPawn(p));
			}
			
			if(markDestroy(p = this.board.getLeftPawn(a)))
			{
				markDestroy(this.board.getLeftPawn(p));
				markDestroy(this.board.getTopPawn(p));
				markDestroy(this.board.getBottomPawn(p));
			}
			
			if(markDestroy(p = this.board.getRightPawn(a)))
			{
				markDestroy(this.board.getRightPawn(p));
				markDestroy(this.board.getTopPawn(p));
				markDestroy(this.board.getBottomPawn(p));
			}
		}
		
		private function bigSquare(a:Pawn):void
		{
			square(this.board.getRightPawn(a));
			square(this.board.getTopPawn(a));
			square(this.board.getBottomPawn(a));
			square(this.board.getLeftPawn(a));
		}
		
		private function electMatchesForDestruction(match:Vector.<Pawn>):void
		{
			if (verbose)	trace(this + "electMatchesForDestruction(" + arguments);
		
			this.board.matchedPawns.push(match);
			for (var j:int = 0; j < match.length; j++)
			{
				var pawn:Pawn = match[j];
				if (this.board.destroyablePawns.indexOf(pawn) < 0)
				{
					markDestroy(match[j]);
				}
			}
			
			if(verbose)	trace("destroyables: " + this.board.destroyablePawns);
		}
		
		/**
		 * TODO Unit test me!
		 * @param	pawn
		 * @return	The pawns matching the specified pawn. It's a vector, containing a vector of vectors of pawns: the horizontal match and the vertical match (if they're at least 3-long).
		 */
		private function getMatches(pawn:Pawn):Vector.<Pawn>
		{
			var hMatch:Vector.<Pawn> = this.getHorizontalMatch(pawn);
			var vMatch:Vector.<Pawn> = this.getVerticalMatch(pawn);
			
			var matches:Vector.<Pawn> = new <Pawn> [];
			//	the matches are valid only if they're at least 3 pawn-long.
			if (hMatch.length >= 3)	matches = matches.concat(hMatch);
			if (vMatch.length >= 3)	matches = matches.concat(vMatch);
			
			var ever:Object = null;
			matches = matches.filter(function(item:Pawn, ...args):Boolean
			{
				if(item.special > 0)
				{
				}
				if(item == ever)
					return false;
				ever = item;
				return true;
			});
			if(matches.length >= 5)
			{
				if(hMatch.length == 5 || vMatch.length == 5)
					matches[0].special = 4;
				else
					matches[0].special = 3;
			}
			else if(matches.length == 4)
			{
				if(vMatch.length > 3)
					matches[0].special = 1;
				else
					matches[0].special = 2;
			}
			return matches;
		}

		/**
		 * TODO Unit test me!
		 * @param	pawn
		 * @return	The pawns horizontally matching the specified pawn, whatever the length (1 if no actual match).
		 */
		private function getHorizontalMatch(pawn:Pawn):Vector.<Pawn>
		{
			var match:Vector.<Pawn> = new <Pawn>[];
			match.push(pawn);
			
			var l:Pawn = this.board.getLeftPawn(pawn);
			
			if (l && l.type == pawn.type)
			{
				match.push(l);
				
				var ll:Pawn = this.board.getLeftPawn(l);
				
				if (ll && ll.type == pawn.type)
				{
					match.push(ll);
				}
			}
			var r:Pawn = this.board.getRightPawn(pawn);

			if (r && r.type == pawn.type)
			{
				match.push(r);
				var rr:Pawn = this.board.getRightPawn(r);

				if (rr && rr.type == pawn.type)
				{
					match.push(rr);
				}
			}

			return match;
		}
		
		/**
		 * TODO Unit test me!
		 * @param	pawn
		 * @return	The pawns vertically matching the specified pawn, whatever the length (1 if no actual match).
		 */
		private function getVerticalMatch(pawn:Pawn):Vector.<Pawn>
		{
			var match:Vector.<Pawn> = new <Pawn>[];
			match.push(pawn);
			
			var t:Pawn = this.board.getTopPawn(pawn);
			if (t && t.type == pawn.type)
			{
				match.push(t);
				var tt:Pawn = this.board.getTopPawn(t);
				if (tt && tt.type == pawn.type)
				{
					match.push(tt);
				}
			}
			var b:Pawn = this.board.getBottomPawn(pawn);
			if (b && b.type == pawn.type)
			{
				match.push(b);
				var bb:Pawn = this.board.getBottomPawn(b);
				if (bb && bb.type == pawn.type)
				{
					match.push(bb);
				}
			}
			return match;
		}
		
		override public function exit(caller:String="other"):void
		{
			if (verbose)	trace(this + "exit(" + arguments);
		}
	}

}