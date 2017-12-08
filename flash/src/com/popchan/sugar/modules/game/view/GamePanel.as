//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.core.MsgDispatcher;
	import com.popchan.framework.ds.BasePool;
	import com.popchan.framework.manager.Debug;
	import com.popchan.framework.manager.SoundManager;
	import com.popchan.sugar.core.Model;
	import com.popchan.sugar.core.cfg.Config;
	import com.popchan.sugar.core.cfg.LevelConfig;
	import com.popchan.sugar.core.cfg.levels.LevelCO;
	import com.popchan.sugar.core.data.AimType;
	import com.popchan.sugar.core.data.CandySpecialStatus;
	import com.popchan.sugar.core.data.ColorType;
	import com.popchan.sugar.core.data.GameConst;
	import com.popchan.sugar.core.data.GameMode;
	import com.popchan.sugar.core.data.TileConst;
	import com.popchan.sugar.core.events.GameEvents;
	import com.popchan.sugar.core.manager.WindowManager3D;
	import com.popchan.sugar.modules.BasePanel3D;

	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import caurina.transitions.Tweener;

	import fairygui.GRoot;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class GamePanel extends BasePanel3D
	{
		private static const STATE_INIT:int = 1;
		private static const STATE_GAME:int = 2;
		private static const STATE_PAUSE:int = 3;
		private static const STATE_END:int = 4;
		private static const STATE_WAIT:int = 5;
		private static const STATE_GAME_WAIT:int = 1;
		private static const STATE_GAME_SWAP:int = 2;
		private static const STATE_GAME_REMOVE:int = 3;
		private static const STATE_GAME_WAIT_DROP:int = 4;
		private static const STATE_GAME_CHECK_DROP_COMPLETE:int = 5;
		private static const STATE_GAME_SHUFFLE:int = 6;
		private static const STATE_GAME_END:int = 7;
		private static const STATE_END_VICTORY:int = 1;
		private static const STATE_END_FAILED:int = 2;
		private static const DROP_DELAY:int = 15;

		public var currentLevel:LevelCO;
		public var offsetX:int = 0;
		public var offsetY:int = 0;
		private var contentW:int;
		private var contentH:int;
		public var tileBgs:Array;
		public var tileBoarders:Array;
		public var candys:Array;
		public var bricks:Array;
		public var locks:Array;
		public var ices:Array;
		public var eats:Array;
		public var monsters:Array;
		public var stones:Array;
		public var tDoors:Array;
		public var ironWires:Array;

		public var infoPanel:InfoPanel;

		private var container:Sprite;
		private var candy_layer:Sprite;
		private var tileBg_layer:Sprite;
		private var door_layer:Sprite;
		private var brick_layer:Sprite;
		private var ice_layer:Sprite;
		private var stone_layer:Sprite;
		private var lock_layer:Sprite;
		private var eat_layer:Sprite;
		private var monster_layer:Sprite;
		private var ironWire_layer:Sprite;
		public var selectedCard:Candy;
		public var aimCard:Candy;
		private var isMoving:Boolean;
		private var addFruitIndex:int;
		private var nextFruitId:int;
		private var colAdd:Array;
		private var tDoorAdd:Array;
		private var eatRemoved:Boolean = false;
		private var state:int;
		private var gameState:int;
		private var dropCount:int = 0;
		private var tipCount:int = 0;
		private var tipDelay:int = 400;
		private var tempScore:int;
		private var matchCountOnceSwap:int = 0;
		private var _instanceName:String = "GamePanel";

		override public function init():void
		{
			super.init();
			this.container = new Sprite();
			this.addChild(this.container);
			this.tileBg_layer = new Sprite();
			this.container.addChild(this.tileBg_layer);
			this.brick_layer = new Sprite();
			this.container.addChild(this.brick_layer);
			this.ice_layer = new Sprite();
			this.container.addChild(this.ice_layer);
			this.stone_layer = new Sprite();
			this.container.addChild(this.stone_layer);
			this.eat_layer = new Sprite();
			this.container.addChild(this.eat_layer);
			this.candy_layer = new Sprite();
			this.container.addChild(this.candy_layer);
			this.lock_layer = new Sprite();
			this.container.addChild(this.lock_layer);
			this.monster_layer = new Sprite();
			this.container.addChild(this.monster_layer);
			this.ironWire_layer = new Sprite();
			this.container.addChild(this.ironWire_layer);
			this.door_layer = new Sprite();
			this.container.addChild(this.door_layer);
			this.tDoors = this.getBlankMapArray();
			this.tileBgs = this.getBlankMapArray();
			this.candys = this.getBlankMapArray();
			this.bricks = this.getBlankMapArray();
			this.ices = this.getBlankMapArray();
			this.stones = this.getBlankMapArray();
			this.eats = this.getBlankMapArray();
			this.locks = this.getBlankMapArray();
			this.ironWires = this.getBlankMapArray();
			this.monsters = this.getBlankMapArray();
			this.tileBoarders = [];
		}

		private function getBlankMapArray():Array
		{
			var _local_3:int;
			var _local_1:Array = [];
			var _local_2:int;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_1[_local_2] = [];
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					_local_1[_local_2][_local_3] = null;
					_local_3++;
				}
				_local_2++;
			}
			return (_local_1);
		}

		public function newGame(level:LevelCO):void
		{
			Model.gameModel.score = 0;
			this.addEventListener(TouchEvent.TOUCH, this.onTouch);
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, this.update);
			this.currentLevel = level;
			this.state = STATE_INIT;
			this.gameState = STATE_GAME_WAIT;
		}

		private function createElements():void
		{
			this.createTileBg();
			this.createDoor();
			this.createBrick();
			this.createBarrier();
			this.createCandys();
			this.createBombs();
			this.container.x = 650;
			Tweener.addTween(this.container, {"time": 0.6, "x": 0, "delay": 0.1, "transition": "easeBackOut"});
		}

		private function createBombs():void
		{
			var _local_3:int;
			var _local_4:int;
			var _local_1:Array = this.currentLevel.barrier;
			var _local_2:int;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					_local_4 = _local_1[_local_2][_local_3];
					if (_local_4 == TileConst.BOMB)
					{
						this.createBomb(_local_2, _local_3);
					}
					_local_3++;
				}
				_local_2++;
			}
		}

		private function createBarrier():void
		{
			var _local_3:int;
			var _local_4:int;
			var _local_1:Array = this.currentLevel.barrier;
			var _local_2:int;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					_local_4 = _local_1[_local_2][_local_3];
					if (_local_4 > 0)
					{
						switch (_local_4)
						{
							case TileConst.ICE1:
							case TileConst.ICE2:
							case TileConst.ICE3:
								this.createIce(_local_2, _local_3, _local_4);
								break;
							case TileConst.LOCK:
								this.createLock(_local_2, _local_3);
								break;
							case TileConst.STONE:
								this.createStones(_local_2, _local_3, _local_4);
								break;
							case TileConst.EAT:
								this.createEat(_local_2, _local_3);
								break;
							case TileConst.MONSTER:
								this.createMonster(_local_2, _local_3);
								break;
							case TileConst.IRONWIRE:
								this.createIronWire(_local_2, _local_3, 1);
								break;
							case TileConst.IRONWIRE2:
								this.createIronWire(_local_2, _local_3, 2);
								break;
							case TileConst.BOMB:
								break;
						}
						;
					}
					;
					_local_3++;
				}
				;
				_local_2++;
			}
			;
		}

		private function createTileBg():void
		{
			var _local_6:int;
			var _local_7:int;
			var _local_8:*;
			var _local_9:*;
			var _local_10:*;
			var _local_11:*;
			var _local_14:int;
			var _local_15:TileBg;
			var _local_16:Point;
			var _local_17:TileBoarder;
			var _local_1:Array = this.currentLevel.tile;
			var _local_2:int;
			var _local_3:int = (GameConst.ROW_COUNT - 1);
			var _local_4:int;
			var _local_5:int = (GameConst.COL_COUNT - 1);
			_local_7 = 0;
			_loop_1: while (_local_7 < GameConst.COL_COUNT)
			{
				_local_6 = 0;
				while (_local_6 < GameConst.ROW_COUNT)
				{
					if (_local_1[_local_6][_local_7] > 0)
					{
						_local_4 = _local_7;
						break _loop_1;
					}
					_local_6++;
				}
				_local_7++;
			}
			_local_7 = (GameConst.COL_COUNT - 1);
			_loop_2: while (_local_7 >= 0)
			{
				_local_6 = 0;
				while (_local_6 < GameConst.ROW_COUNT)
				{
					if (_local_1[_local_6][_local_7] > 0)
					{
						_local_5 = _local_7;
						break _loop_2;
					}
					;
					_local_6++;
				}
				;
				_local_7--;
			}
			;
			_local_6 = 0;
			_loop_3: while (_local_6 < GameConst.ROW_COUNT)
			{
				_local_7 = 0;
				while (_local_7 < GameConst.COL_COUNT)
				{
					if (_local_1[_local_6][_local_7] > 0)
					{
						_local_2 = _local_6;
						break _loop_3;
					}
					;
					_local_7++;
				}
				;
				_local_6++;
			}
			;
			_local_6 = (GameConst.ROW_COUNT - 1);
			_loop_4: while (_local_6 >= 0)
			{
				_local_7 = 0;
				while (_local_7 < GameConst.COL_COUNT)
				{
					if (_local_1[_local_6][_local_7] > 0)
					{
						_local_3 = _local_6;
						break _loop_4;
					}
					;
					_local_7++;
				}
				;
				_local_6--;
			}
			;
			var _local_12:int = ((GameConst.ROW_COUNT - _local_3) - _local_2);
			var _local_13:int = ((GameConst.COL_COUNT - _local_5) - _local_4);
			this.offsetX = (((Core.stage3DManager.canvasWidth - (GameConst.COL_COUNT * GameConst.CARD_W)) >> 1) + ((_local_13 * GameConst.CARD_W) * 0.5));
//            this.offsetY = (((((Core.stage3DManager.canvasHeight ) - (GameConst.ROW_COUNT * GameConst.CARD_W)) >> 1) + ((_local_12 * GameConst.CARD_W) * 0.5)) + 100);
			this.offsetY = GRoot.inst.height - GameConst.ROW_COUNT * GameConst.CARD_W - 35;
			_local_6 = 0;
			while (_local_6 < GameConst.ROW_COUNT)
			{
				_local_7 = 0;
				while (_local_7 < GameConst.COL_COUNT)
				{
					_local_14 = _local_1[_local_6][_local_7];
					if (_local_14 > 0)
					{
						_local_15 = (TileBg.pool.take() as TileBg);
						_local_16 = this.getCandyPosition(_local_6, _local_7);
						_local_15.x = _local_16.x;
						_local_15.y = _local_16.y;
						this.tileBgs[_local_6][_local_7] = _local_15;
						this.tileBg_layer.addChild(_local_15);
						if (((((this.isBlank(_local_6, (_local_7 - 1))) && (this.isBlank((_local_6 - 1), _local_7)))) && (this.isBlank((_local_6 - 1), (_local_7 - 1)))))
						{
							_local_17 = TileBoarder.pool.take();
							_local_17.setType(TileBoarder.x_border_left_up, this.tileBg_layer, (_local_16.x - 38), (_local_16.y - 38));
							this.tileBoarders.push(_local_17);
						}
						;
						if ((((!(this.isBlank((_local_6 + 1), (_local_7 - 1))))) && (this.isBlank((_local_6 + 1), _local_7))))
						{
							_local_17 = TileBoarder.pool.take();
							_local_17.setType(TileBoarder.x_border_left_up_x, this.tileBg_layer, (_local_16.x - 32), (_local_16.y + 32));
							this.tileBoarders.push(_local_17);
						}
						;
						if (((((this.isBlank(_local_6, (_local_7 + 1))) && (this.isBlank((_local_6 - 1), _local_7)))) && (this.isBlank((_local_6 - 1), (_local_7 + 1)))))
						{
							_local_17 = TileBoarder.pool.take();
							_local_17.setType(TileBoarder.x_border_right_up, this.tileBg_layer, (_local_16.x - 3), (_local_16.y - 38));
							this.tileBoarders.push(_local_17);
						}
						;
						if ((((!(this.isBlank((_local_6 + 1), (_local_7 + 1))))) && (this.isBlank((_local_6 + 1), _local_7))))
						{
							_local_17 = TileBoarder.pool.take();
							_local_17.setType(TileBoarder.x_border_right_up_x, this.tileBg_layer, (_local_16.x - 4), (_local_16.y + 32));
							this.tileBoarders.push(_local_17);
						}
						;
						if (((((this.isBlank((_local_6 - 1), _local_7)) && ((!(this.isBlank(_local_6, (_local_7 + 1))))))) && (this.isBlank((_local_6 - 1), (_local_7 + 1)))))
						{
							_local_17 = TileBoarder.pool.take();
							_local_17.setType(TileBoarder.x_border_heng_xia, this.tileBg_layer, _local_16.x, (_local_16.y - 38));
							this.tileBoarders.push(_local_17);
						}
						;
						if (((((this.isBlank(_local_6, (_local_7 - 1))) && ((!(this.isBlank((_local_6 + 1), _local_7)))))) && (this.isBlank((_local_6 + 1), (_local_7 - 1)))))
						{
							_local_17 = TileBoarder.pool.take();
							_local_17.setType(TileBoarder.x_border_shu_you, this.tileBg_layer, (_local_16.x - 38), _local_16.y);
							this.tileBoarders.push(_local_17);
						}
						;
						if (((((this.isBlank(_local_6, (_local_7 + 1))) && ((!(this.isBlank((_local_6 + 1), _local_7)))))) && (this.isBlank((_local_6 + 1), (_local_7 + 1)))))
						{
							_local_17 = TileBoarder.pool.take();
							_local_17.setType(TileBoarder.x_border_shu_zuo, this.tileBg_layer, (_local_16.x + 32), _local_16.y);
							this.tileBoarders.push(_local_17);
						}
						;
						if (((((this.isBlank(_local_6, (_local_7 - 1))) && (this.isBlank((_local_6 + 1), _local_7)))) && (this.isBlank((_local_6 + 1), (_local_7 - 1)))))
						{
							_local_17 = TileBoarder.pool.take();
							_local_17.setType(TileBoarder.x_border_left_down, this.tileBg_layer, (_local_16.x - 38), (_local_16.y - 3));
							this.tileBoarders.push(_local_17);
						}
						;
						if (((this.isBlank(_local_6, (_local_7 + 1))) && ((!(this.isBlank((_local_6 + 1), (_local_7 + 1)))))))
						{
							_local_17 = TileBoarder.pool.take();
							_local_17.setType(TileBoarder.x_border_left_down_x, this.tileBg_layer, (_local_16.x + 32), (_local_16.y - 4));
							this.tileBoarders.push(_local_17);
						}
						;
						if (((((this.isBlank(_local_6, (_local_7 + 1))) && (this.isBlank((_local_6 + 1), _local_7)))) && (this.isBlank((_local_6 + 1), (_local_7 + 1)))))
						{
							_local_17 = TileBoarder.pool.take();
							_local_17.setType(TileBoarder.x_border_right_down, this.tileBg_layer, (_local_16.x - 3), (_local_16.y - 3));
							this.tileBoarders.push(_local_17);
						}
						;
						if (((this.isBlank(_local_6, (_local_7 - 1))) && ((!(this.isBlank((_local_6 + 1), (_local_7 - 1)))))))
						{
							_local_17 = TileBoarder.pool.take();
							_local_17.setType(TileBoarder.x_border_right_down_x, this.tileBg_layer, (_local_16.x - 68), (_local_16.y - 4));
							this.tileBoarders.push(_local_17);
						}
						;
						if (((((this.isBlank((_local_6 + 1), _local_7)) && ((!(this.isBlank(_local_6, (_local_7 + 1))))))) && (this.isBlank((_local_6 + 1), (_local_7 + 1)))))
						{
							_local_17 = TileBoarder.pool.take();
							_local_17.setType(TileBoarder.x_border_heng_shang, this.tileBg_layer, _local_16.x, (_local_16.y + 32));
							this.tileBoarders.push(_local_17);
						}
						;
					}
					;
					_local_7++;
				}
				;
				_local_6++;
			}
			;
		}

		private function isBlank(_arg_1:int, _arg_2:int):Boolean
		{
			if (!this.isValidPos(_arg_1, _arg_2))
			{
				return (true);
			}
			;
			if (this.currentLevel.tile[_arg_1][_arg_2] == 0)
			{
				return (true);
			}
			;
			return (false);
		}

		private function createDoor():void
		{
			var _local_3:int;
			var _local_4:int;
			var _local_5:FruitDoor;
			var _local_6:Point;
			var _local_1:Array = this.currentLevel.entryAndExit;
			var _local_2:int;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					_local_4 = _local_1[_local_2][_local_3];
					if (_local_4 == TileConst.FRUIT_END)
					{
						_local_5 = (FruitDoor.pool.take() as FruitDoor);
						_local_6 = this.getCandyPosition(_local_2, _local_3);
						_local_5.x = _local_6.x;
						_local_5.y = (_local_6.y + 30);
						_local_5.alpha = 0.7;
						this.door_layer.addChild(_local_5);
					}
					else
					{
						if ((((_local_4 >= TileConst.T_DOOR_ENTRY1)) && ((_local_4 <= TileConst.T_DOOR_EXIT9))))
						{
							this.createTransportDoor(_local_2, _local_3, _local_4);
						}
						;
					}
					;
					_local_3++;
				}
				;
				_local_2++;
			}
			;
		}

		private function createTransportDoor(_arg_1:int, _arg_2:int, _arg_3:int):void
		{
			var _local_4:TransportDoor = (TransportDoor.pool.take() as TransportDoor);
			_local_4.tileID = _arg_3;
			_local_4.row = _arg_1;
			_local_4.col = _arg_2;
			_local_4.start();
			var _local_5:Point = this.getCandyPosition(_arg_1, _arg_2);
			_local_4.x = _local_5.x;
			_local_4.y = _local_5.y;
			this.ice_layer.addChild(_local_4);
			this.tDoors[_arg_1][_arg_2] = _local_4;
		}

		private function createBrick():void
		{
			var _local_3:int;
			var _local_4:int;
			var _local_5:Brick;
			var _local_6:Point;
			var _local_1:Array = this.currentLevel.board;
			var _local_2:int;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					_local_4 = _local_1[_local_2][_local_3];
					if (_local_4 > 0)
					{
						_local_5 = (Brick.pool.take() as Brick);
						_local_5.brickID = _local_4;
						_local_5.row = _local_2;
						_local_5.col = _local_3;
						_local_6 = this.getCandyPosition(_local_2, _local_3);
						_local_5.x = _local_6.x;
						_local_5.y = _local_6.y;
						this.brick_layer.addChild(_local_5);
						this.bricks[_local_2][_local_3] = _local_5;
					}
					;
					_local_3++;
				}
				;
				_local_2++;
			}
			;
		}

		private function createIce(_arg_1:int, _arg_2:int, _arg_3:int):Ice
		{
			var _local_4:Ice = (Ice.pool.take() as Ice);
			_local_4.tileID = _arg_3;
			_local_4.row = _arg_1;
			_local_4.col = _arg_2;
			var _local_5:Point = this.getCandyPosition(_arg_1, _arg_2);
			_local_4.x = _local_5.x;
			_local_4.y = _local_5.y;
			this.ice_layer.addChild(_local_4);
			this.ices[_arg_1][_arg_2] = _local_4;
			return (_local_4);
		}

		private function createStones(_arg_1:int, _arg_2:int, _arg_3:int):void
		{
			var _local_4:Stone = (Stone.pool.take() as Stone);
			_local_4.tileID = _arg_3;
			_local_4.row = _arg_1;
			_local_4.col = _arg_2;
			var _local_5:Point = this.getCandyPosition(_arg_1, _arg_2);
			_local_4.x = _local_5.x;
			_local_4.y = _local_5.y;
			this.stone_layer.addChild(_local_4);
			this.stones[_arg_1][_arg_2] = _local_4;
		}

		private function createCandys():void
		{
			var _local_4:int;
			var _local_5:int;
			var _local_6:Candy;
			var _local_1:Boolean;
			var _local_2:Array = this.currentLevel.candy;
			var _local_3:int;
			while (_local_3 < GameConst.ROW_COUNT)
			{
				_local_4 = 0;
				while (_local_4 < GameConst.COL_COUNT)
				{
					if ((((this.currentLevel.tile[_local_3][_local_4] > 0)) && (this.isCandyValidPos(_local_3, _local_4))))
					{
						_local_5 = _local_2[_local_3][_local_4];
						if (_local_5 > 0)
						{
							if ((((_local_5 >= 6)) && ((_local_5 <= 10))))
							{
								_local_6 = this.newCandy(_local_3, _local_4, (_local_5 - 5));
								_local_6.setSpecialStatus(CandySpecialStatus.HORIZ);
							}
							else
							{
								if ((((_local_5 >= 11)) && ((_local_5 <= 15))))
								{
									_local_6 = this.newCandy(_local_3, _local_4, (_local_5 - 10));
									_local_6.setSpecialStatus(CandySpecialStatus.VERT);
								}
								else
								{
									if ((((_local_5 >= 16)) && ((_local_5 <= 20))))
									{
										_local_6 = this.newCandy(_local_3, _local_4, (_local_5 - 15));
										_local_6.setSpecialStatus(CandySpecialStatus.BOMB);
									}
									else
									{
										if (_local_5 == TileConst.COLORFUL)
										{
											_local_6 = this.newCandy(_local_3, _local_4);
											_local_6.setSpecialStatus(CandySpecialStatus.COLORFUL);
										}
										else
										{
											this.newCandy(_local_3, _local_4, _local_5);
										}
										;
									}
									;
								}
								;
							}
							;
							_local_1 = false;
						}
						else
						{
							_local_1 = true;
							this.newCandy(_local_3, _local_4, _local_5);
						}
						;
					}
					;
					_local_4++;
				}
				;
				_local_3++;
			}
			;
			if (_local_1)
			{
				this.shuffle();
			}
			;
		}

		private function newCandy(_arg_1:int, _arg_2:int, _arg_3:int = 0):Candy
		{
			if (_arg_3 == 0)
			{
				_arg_3 = int(((Math.random() * this.currentLevel.colorCount) + 1));
			}
			;
			var _local_4:Candy = (Candy.pool.take() as Candy);
			_local_4.reset();
			var _local_5:Point = this.getCandyPosition(_arg_1, _arg_2);
			_local_4.x = _local_5.x;
			_local_4.y = _local_5.y;
			_local_4.row = _arg_1;
			_local_4.col = _arg_2;
			_local_4.color = _arg_3;
			this.candys[_arg_1][_arg_2] = _local_4;
			this.candy_layer.addChild(_local_4);
			return (_local_4);
		}

		private function getCandyPosition(_arg_1:int, _arg_2:int):Point
		{
			return (new Point(((_arg_2 * GameConst.CARD_W) + this.offsetX), ((_arg_1 * GameConst.CARD_W) + this.offsetY)));
		}

		private function createIronWires():void
		{
			var _local_3:int;
			var _local_4:int;
			var _local_1:Array = this.currentLevel.ironWire;
			var _local_2:int;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					_local_4 = _local_1[_local_2][_local_3];
					if (_local_4 > 0)
					{
						if (_local_4 == TileConst.IRONWIRE)
						{
							this.createIronWire(_local_2, _local_3, 1);
						}
						else
						{
							if (_local_4 == TileConst.IRONWIRE2)
							{
								this.createIronWire(_local_2, _local_3, 2);
							}
							;
						}
						;
					}
					;
					_local_3++;
				}
				;
				_local_2++;
			}
			;
		}

		private function createIronWire(_arg_1:int, _arg_2:int, _arg_3:int = 1):void
		{
			var _local_4:IronWire = (IronWire.pool.take() as IronWire);
			_local_4.dir = _arg_3;
			_local_4.row = _arg_1;
			_local_4.col = _arg_2;
			var _local_5:Point = this.getCandyPosition(_arg_1, _arg_2);
			_local_4.x = _local_5.x;
			_local_4.y = _local_5.y;
			this.ironWire_layer.addChild(_local_4);
			this.ironWires[_arg_1][_arg_2] = _local_4;
		}

		private function createBomb(_arg_1:int, _arg_2:int):void
		{
			var _local_3:int = ((Math.random() * 7) + 10);
			var _local_4:Candy = this.candys[_arg_1][_arg_2];
			_local_4.setBomb(_local_3);
		}

		private function isCandyValidPos(_arg_1:int, _arg_2:int):Boolean
		{
			if ((((((!((this.ices[_arg_1][_arg_2] == null)))) || ((!((this.stones[_arg_1][_arg_2] == null)))))) || ((!((this.eats[_arg_1][_arg_2] == null))))))
			{
				return (false);
			}
			return (true);
		}

		private function createEat(_arg_1:int, _arg_2:int):Eat
		{
			var _local_3:Eat = (Eat.pool.take() as Eat);
			_local_3.reset();
			_local_3.row = _arg_1;
			_local_3.col = _arg_2;
			var _local_4:Point = this.getCandyPosition(_arg_1, _arg_2);
			_local_3.x = _local_4.x;
			_local_3.y = _local_4.y;
			this.eat_layer.addChild(_local_3);
			this.eats[_arg_1][_arg_2] = _local_3;
			return (_local_3);
		}

		private function createMonster(_arg_1:int, _arg_2:int):Monster
		{
			var _local_3:Monster = (Monster.pool.take() as Monster);
			_local_3.reset();
			_local_3.row = _arg_1;
			_local_3.col = _arg_2;
			var _local_4:Point = this.getCandyPosition(_arg_1, _arg_2);
			_local_3.x = _local_4.x;
			_local_3.y = _local_4.y;
			this.monster_layer.addChild(_local_3);
			this.monsters[_arg_1][_arg_2] = _local_3;
			return (_local_3);
		}

		private function createLock(_arg_1:int, _arg_2:int):Lock
		{
			var _local_3:Lock = (Lock.pool.take() as Lock);
			_local_3.row = _arg_1;
			_local_3.col = _arg_2;
			var _local_4:Point = this.getCandyPosition(_arg_1, _arg_2);
			_local_3.x = _local_4.x;
			_local_3.y = _local_4.y;
			this.lock_layer.addChild(_local_3);
			this.locks[_arg_1][_arg_2] = _local_3;
			return (_local_3);
		}

		private function update(e:EnterFrameEvent):void
		{
			switch (this.state)
			{
				case STATE_INIT:
					this.createElements();
					MsgDispatcher.execute(GameEvents.OPEN_MISSION_UI);
					this.state = STATE_WAIT;
					setTimeout(function():void
					{
						state = STATE_GAME;
					}, 1000);
					return;
				case STATE_GAME:
					this.updateGameState();
					return;
				case STATE_PAUSE:
					return;
				case STATE_END:
					return;
				case STATE_WAIT:
					return;
			}
			;
		}

		private function updateGameState():void
		{
			var _local_1:Boolean;
			var _local_2:int;
			var _local_3:int;
			var _local_4:Candy;
			this.tipCount++;
			if (this.tipCount > this.tipDelay)
			{
				this.checkSwapTip();
				this.tipCount = 0;
			}
			;
			switch (this.gameState)
			{
				case STATE_GAME_SWAP:
					return;
				case STATE_GAME_SHUFFLE:
					return;
				case STATE_GAME_WAIT_DROP:
					this.dropCount++;
					if (this.dropCount > DROP_DELAY)
					{
						this.dropCount = 0;
						this.gameState = STATE_GAME_WAIT;
						_local_1 = this.checkTop();
						if (!_local_1)
						{
							this.checkShuffle();
						}
					}
					return;
				case STATE_GAME_WAIT:
					return;
				case STATE_GAME_REMOVE:
					return;
				case STATE_GAME_CHECK_DROP_COMPLETE:
					this.isMoving = false;
					_local_2 = 0;
					while (_local_2 < GameConst.ROW_COUNT)
					{
						_local_3 = 0;
						while (_local_3 < GameConst.COL_COUNT)
						{
							_local_4 = this.candys[_local_2][_local_3];
							if (_local_4 != null)
							{
								if (Tweener.isTweening(_local_4))
								{
									this.isMoving = true;
								}
							}
							_local_3++;
						}
						_local_2++;
					}
					this.tipCount = 0;
					if (!this.isMoving)
					{
						Debug.log("没有糖果正在掉落");
						if (this.checkHasMatches())
						{
							Debug.log("有移除的");
							this.removeAllMatches();
						}
						else
						{
							Debug.log("检测游戏是否胜利");
							this.checkBomb();
							this.checkEatAndMonster();
							if (Model.gameModel.checkAimComplete())
							{
								Debug.log("游戏胜利");
								this.gameState = STATE_GAME_END;
								this.handleVictory();
							}
							else
							{
								Debug.log("目标未完成，游戏没有胜利");
								if ((((this.currentLevel.mode == GameMode.NORMAL)) && ((Model.gameModel.step == 0))))
								{
									Debug.log("游戏失败");
									this.gameState = STATE_GAME_END;
									this.handleFailed();
								}
								else
								{
									if ((((this.currentLevel.mode == GameMode.TIME)) && ((Model.gameModel.time == 0))))
									{
										Debug.log("游戏失败");
										this.gameState = STATE_GAME_END;
										this.handleFailed();
									}
								}
								this.checkShuffle();
							}
						}
					}
					return;
			}
		}

		private function checkShuffle():void
		{
			var _local_2:NoSwapTip;
			var _local_1:Array = this.checkConnectable();
			if (_local_1.length == 0)
			{
				this.gameState = STATE_GAME_WAIT;
				_local_2 = new NoSwapTip();
				_local_2.doAniamtion(null);
				this.addChild(_local_2);
				Debug.log("没有可以消除的了，洗牌");
				this.shuffle(true);
			}
			else
			{
				this.gameState = STATE_GAME_WAIT;
				Debug.log("居然有可以消除的，不用洗牌", _local_1[0]);
			}
			;
		}

		private function onTimer():void
		{
			Model.gameModel.time--;
			if (Model.gameModel.time == 0)
			{
				Core.timerManager.remove(this, this.onTimer);
				this.gameState = STATE_GAME_CHECK_DROP_COMPLETE;
			}
		}

		private function onTouch(_arg_1:TouchEvent):void
		{
			var _local_3:Point;
			var _local_4:int;
			var _local_5:int;
			var _local_6:Point;
			if (this.state != STATE_GAME)
			{
				return;
			}
			if (this.gameState != STATE_GAME_WAIT)
			{
				return;
			}
			var _local_2:Touch = _arg_1.getTouch(Starling.current.stage);
			if (!_local_2)
			{
				return;
			}
			if (_local_2.phase == TouchPhase.BEGAN)
			{
				_local_3 = _local_2.getLocation(Starling.current.stage);
				_local_3 = container.globalToLocal(_local_3)
				this.selectedCard = this.getCandyByTouch(_local_3);
				if (this.selectedCard != null)
				{
					Debug.log(("选择的candy位置:row=" + this.selectedCard.row), ("col=" + this.selectedCard.col), this.selectedCard.x, this.selectedCard.y);
				}
			}
			else
			{
				if (_local_2.phase == TouchPhase.MOVED)
				{
					if (this.selectedCard != null)
					{
						_local_4 = this.selectedCard.row;
						_local_5 = this.selectedCard.col;
						_local_6 = _local_2.getLocation(Starling.current.stage);
						_local_6 = container.globalToLocal(_local_6)
						if (((((((((((((_local_5 - 1) >= 0)) && ((!((this.candys[_local_4][(_local_5 - 1)] == null)))))) && ((this.locks[_local_4][(_local_5 - 1)] == null)))) && ((this.monsters[_local_4][(_local_5 - 1)] == null)))) && (this.candys[_local_4][(_local_5 - 1)].collidePoint(_local_6)))) && ((!(this.hasIronWire(this.selectedCard.row, this.selectedCard.col, 1))))))
						{
							this.makeSwap(this.selectedCard, this.candys[_local_4][(_local_5 - 1)]);
						}
						else
						{
							if (((((((((((((_local_5 + 1) < GameConst.COL_COUNT)) && ((!((this.candys[_local_4][(_local_5 + 1)] == null)))))) && ((this.locks[_local_4][(_local_5 + 1)] == null)))) && ((this.monsters[_local_4][(_local_5 + 1)] == null)))) && (this.candys[_local_4][(_local_5 + 1)].collidePoint(_local_6)))) && ((!(this.hasIronWire(_local_4, (_local_5 + 1), 1))))))
							{
								this.makeSwap(this.selectedCard, this.candys[_local_4][(_local_5 + 1)]);
							}
							else
							{
								if (((((((((((((_local_4 - 1) >= 0)) && ((!((this.candys[(_local_4 - 1)][_local_5] == null)))))) && ((this.locks[(_local_4 - 1)][_local_5] == null)))) && ((this.monsters[(_local_4 - 1)][_local_5] == null)))) && (this.candys[(_local_4 - 1)][_local_5].collidePoint(_local_6)))) && ((!(this.hasIronWire((_local_4 - 1), _local_5, 2))))))
								{
									this.makeSwap(this.selectedCard, this.candys[(_local_4 - 1)][_local_5]);
								}
								else
								{
									if (((((((((((((_local_4 + 1) < GameConst.ROW_COUNT)) && ((!((this.candys[(_local_4 + 1)][_local_5] == null)))))) && ((this.locks[(_local_4 + 1)][_local_5] == null)))) && ((this.monsters[(_local_4 + 1)][_local_5] == null)))) && (this.candys[(_local_4 + 1)][_local_5].collidePoint(_local_6)))) && ((!(this.hasIronWire(this.selectedCard.row, this.selectedCard.col, 2))))))
									{
										this.makeSwap(this.selectedCard, this.candys[(_local_4 + 1)][_local_5]);
									}
								}
							}
						}
					}
				}
				else
				{
					if (_local_2.phase == TouchPhase.ENDED)
					{
					}
				}
			}
		}

		private function hasIronWire(_arg_1:int, _arg_2:int, _arg_3:int):Boolean
		{
			if (this.ironWires[_arg_1][_arg_2] != null)
			{
				if (this.ironWires[_arg_1][_arg_2].dir == _arg_3)
				{
					return (true);
				}
			}
			return (false);
		}

		private function makeSwap(candyA:Candy, candyB:Candy):void
		{
			var posA:Point;
			var posB:Point;
			this.stopCandyTip();
			this.aimCard = candyB;
			this.gameState = STATE_GAME_SWAP;
			this.swapCandy(candyA, candyB);
			if (this.currentLevel.mode == GameMode.TIME)
			{
				Core.timerManager.add(this, this.onTimer, 1000);
			}
			posA = this.getCandyPosition(candyA.row, candyA.col);
			posB = this.getCandyPosition(candyB.row, candyB.col);
			candyA.runMoveAction({"time": 0.2, "x": posA.x, "y": posA.y, "transition": "linear"});
			candyB.runMoveAction({"time": 0.2, "x": posB.x, "y": posB.y, "transition": "linear", "onComplete": function():void
			{
				if ((((((((candyA.status == 4)) || ((candyB.status == 4)))) || ((((candyA.status > 0)) && ((candyB.status > 0)))))) || (checkHasMatches(false))))
				{
					Debug.log("交换有效");
					handleValidSwap();
				}
				else
				{
					Debug.log("交换无效");
					SoundManager.instance.playSound("notswap");
					swapCandy(candyA, candyB);
					posA = getCandyPosition(candyA.row, candyA.col);
					posB = getCandyPosition(candyB.row, candyB.col);
					candyA.runMoveAction({"time": 0.2, "x": posA.x, "y": posA.y, "transition": "linear"});
					candyB.runMoveAction({"time": 0.2, "x": posB.x, "y": posB.y, "transition": "linear", "onComplete": function():void
					{
						gameState = STATE_GAME_WAIT;
					}});
				}
			}});
		}

		private function swapCandy(_arg_1:Candy, _arg_2:Candy):void
		{
			var _local_3:int = _arg_1.row;
			var _local_4:int = _arg_1.col;
			_arg_1.row = _arg_2.row;
			_arg_1.col = _arg_2.col;
			_arg_2.row = _local_3;
			_arg_2.col = _local_4;
			this.candys[_arg_1.row][_arg_1.col] = _arg_1;
			this.candys[_arg_2.row][_arg_2.col] = _arg_2;
		}

		private function getCandyByTouch(_arg_1:Point):Candy
		{
			var _local_3:int;
			var _local_4:Candy;
			var _local_2:int;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					_local_4 = this.candys[_local_2][_local_3];
					if ((((((!((_local_4 == null)))) && ((this.locks[_local_2][_local_3] == null)))) && ((this.monsters[_local_2][_local_3] == null))))
					{
						if (_local_4.collidePoint(_arg_1))
						{
							return (_local_4);
						}
					}
					_local_3++;
				}
				_local_2++;
			}
			return (null);
		}

		private function checkSwapTip():void
		{
			var _local_2:Array;
			var _local_3:Candy;
			var _local_4:Candy;
			if (this.hasSwapTip())
			{
				return;
			}
			;
			var _local_1:Array = this.checkConnectable();
			if (_local_1.length > 0)
			{
				_local_2 = _local_1[int((Math.random() * _local_1.length))];
				this.stopCandyTip();
				_local_3 = _local_2[0];
				_local_4 = _local_2[int(((Math.random() * (_local_2.length - 1)) + 1))];
				_local_3.shake();
				_local_4.shake();
			}
			;
		}

		private function hasSwapTip():Boolean
		{
			var _local_2:int;
			var _local_3:Candy;
			var _local_1:int;
			while (_local_1 < GameConst.ROW_COUNT)
			{
				_local_2 = 0;
				while (_local_2 < GameConst.COL_COUNT)
				{
					_local_3 = this.candys[_local_1][_local_2];
					if ((((!((_local_3 == null)))) && (_local_3.isShake)))
					{
						return (true);
					}
					;
					_local_2++;
				}
				;
				_local_1++;
			}
			;
			return (false);
		}

		private function stopCandyTip():void
		{
			var _local_2:int;
			var _local_3:Candy;
			var _local_1:int;
			while (_local_1 < GameConst.ROW_COUNT)
			{
				_local_2 = 0;
				while (_local_2 < GameConst.COL_COUNT)
				{
					_local_3 = this.candys[_local_1][_local_2];
					if (_local_3 != null)
					{
						_local_3.stopShake();
					}
					;
					_local_2++;
				}
				;
				_local_1++;
			}
			;
		}

		private function handleValidSwap():void
		{
			this.gameState = STATE_GAME_REMOVE;
			if ((((((this.aimCard.status == 4)) || ((this.selectedCard.status == 4)))) || ((((this.aimCard.status > 0)) && ((this.selectedCard.status > 0))))))
			{
				Debug.log("特殊交换");
				this.matchCountOnceSwap = 0;
				this.checkSpecialSwapMathces();
				if (this.currentLevel.mode == GameMode.NORMAL)
				{
					Model.gameModel.step--;
				}
				this.checkNeedDropFruit();
				this.aimCard = (this.selectedCard = null);
			}
			else
			{
				Debug.log("普通交换");
				this.removeAllMatches();
				this.matchCountOnceSwap = 0;
				this.checkNeedDropFruit();
				if (this.currentLevel.mode == GameMode.NORMAL)
				{
					Model.gameModel.step--;
				}
				;
			}
			;
		}

		private function checkHasMatches(_arg_1:Boolean = true):Boolean
		{
			var _local_2:int;
			var _local_3:int;
			var _local_4:Array;
			var _local_5:Candy;
			var _local_6:Array;
			var _local_7:Array;
			var _local_8:Array;
			_local_2 = 0;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					_local_5 = this.candys[_local_2][_local_3];
					if (_local_5 != null)
					{
						_local_6 = this.getHorizMatches(this.candys, _local_2, _local_3);
						if (_local_6.length >= 3)
						{
							return (true);
						}
						;
						_local_7 = this.getVertMatches(this.candys, _local_2, _local_3);
						if (_local_7.length >= 3)
						{
							return (true);
						}
						;
					}
					;
					_local_3++;
				}
				;
				_local_2++;
			}
			;
			if (_arg_1)
			{
				_local_8 = this.checkFruitIsEnd();
				if (_local_8.length > 0)
				{
					return (true);
				}
				;
			}
			;
			return (false);
		}

		private function searchMatchesAndMark():Array
		{
			var _local_4:int;
			var _local_5:int;
			var _local_6:Array;
			var _local_7:Candy;
			var _local_8:Array;
			var _local_9:Array;
			var _local_10:Array;
			var _local_11:Array;
			var _local_1:Number = getTimer();
			var _local_2:Array = [];
			var _local_3:Array = this.candys;
			_local_4 = 0;
			while (_local_4 < GameConst.ROW_COUNT)
			{
				_local_5 = 0;
				while (_local_5 < GameConst.COL_COUNT)
				{
					_local_7 = _local_3[_local_4][_local_5];
					if (_local_7 != null)
					{
						_local_7.setNextStatus(0);
						_local_7.mark = false;
						_local_7.remove = false;
					}
					;
					_local_5++;
				}
				;
				_local_4++;
			}
			;
			_local_4 = 0;
			while (_local_4 < GameConst.ROW_COUNT)
			{
				_local_5 = 0;
				while (_local_5 < GameConst.COL_COUNT)
				{
					_local_7 = _local_3[_local_4][_local_5];
					if (_local_7 != null)
					{
						if (!_local_7.mark)
						{
							_local_8 = this.getHorizMatches(_local_3, _local_4, _local_5);
							if (_local_8.length >= 5)
							{
								this.markAndChangeStatus(_local_8, CandySpecialStatus.COLORFUL);
							}
							else
							{
								_local_9 = this.getVertMatches(_local_3, _local_4, _local_5);
								if (_local_9.length >= 5)
								{
									this.markAndChangeStatus(_local_9, CandySpecialStatus.COLORFUL);
								}
								;
							}
							;
						}
						;
					}
					;
					_local_5++;
				}
				;
				_local_4++;
			}
			;
			_local_4 = 0;
			while (_local_4 < GameConst.ROW_COUNT)
			{
				_local_5 = 0;
				while (_local_5 < GameConst.COL_COUNT)
				{
					_local_7 = _local_3[_local_4][_local_5];
					if (_local_7 != null)
					{
						if (!_local_7.mark)
						{
							_local_6 = this.getHVMatches(_local_3, _local_4, _local_5, [1, 2, 3], [-1, 1, -2]);
							if (_local_6.length >= 5)
							{
								this.markAndChangeStatus(_local_6, CandySpecialStatus.BOMB);
							}
							else
							{
								_local_6 = this.getHVMatches(_local_3, _local_4, _local_5, [1, 2, 4], [-1, 1, 2]);
								if (_local_6.length >= 5)
								{
									this.markAndChangeStatus(_local_6, CandySpecialStatus.BOMB);
								}
								else
								{
									_local_6 = this.getHVMatches(_local_3, _local_4, _local_5, [3, 4, 1], [-1, 1, -2]);
									if (_local_6.length >= 5)
									{
										this.markAndChangeStatus(_local_6, CandySpecialStatus.BOMB);
									}
									else
									{
										_local_6 = this.getHVMatches(_local_3, _local_4, _local_5, [3, 4, 2], [-1, 1, 2]);
										if (_local_6.length >= 5)
										{
											this.markAndChangeStatus(_local_6, CandySpecialStatus.BOMB);
										}
										;
									}
									;
								}
								;
							}
							;
						}
						;
					}
					;
					_local_5++;
				}
				;
				_local_4++;
			}
			;
			_local_4 = 0;
			while (_local_4 < GameConst.ROW_COUNT)
			{
				_local_5 = 0;
				while (_local_5 < GameConst.COL_COUNT)
				{
					_local_7 = _local_3[_local_4][_local_5];
					if (_local_7 != null)
					{
						if (!_local_7.mark)
						{
							_local_6 = this.getHVMatches(_local_3, _local_4, _local_5, [4, 1], [2, -2]);
							if (_local_6.length >= 5)
							{
								this.markAndChangeStatus(_local_6, CandySpecialStatus.BOMB);
							}
							else
							{
								_local_6 = this.getHVMatches(_local_3, _local_4, _local_5, [3, 1], [-2, -2]);
								if (_local_6.length >= 5)
								{
									this.markAndChangeStatus(_local_6, CandySpecialStatus.BOMB);
								}
								else
								{
									_local_6 = this.getHVMatches(_local_3, _local_4, _local_5, [3, 2], [-2, 2]);
									if (_local_6.length >= 5)
									{
										this.markAndChangeStatus(_local_6, CandySpecialStatus.BOMB);
									}
									else
									{
										_local_6 = this.getHVMatches(_local_3, _local_4, _local_5, [4, 2], [2, 2]);
										if (_local_6.length >= 5)
										{
											this.markAndChangeStatus(_local_6, CandySpecialStatus.BOMB);
										}
										;
									}
									;
								}
								;
							}
							;
						}
						;
					}
					;
					_local_5++;
				}
				;
				_local_4++;
			}
			;
			_local_4 = 0;
			while (_local_4 < GameConst.ROW_COUNT)
			{
				_local_5 = 0;
				while (_local_5 < GameConst.COL_COUNT)
				{
					_local_7 = _local_3[_local_4][_local_5];
					if (_local_7 != null)
					{
						if (!_local_7.mark)
						{
							_local_10 = this.getHorizMatches(_local_3, _local_4, _local_5);
							if (_local_10.length == 4)
							{
								this.markAndChangeStatus(_local_10, CandySpecialStatus.VERT);
							}
							else
							{
								_local_11 = this.getVertMatches(_local_3, _local_4, _local_5);
								if (_local_11.length == 4)
								{
									this.markAndChangeStatus(_local_11, CandySpecialStatus.HORIZ);
								}
								else
								{
									if (_local_10.length == 3)
									{
										this.markAndChangeStatus(_local_10, CandySpecialStatus.NOTHING);
									}
									else
									{
										if (_local_11.length == 3)
										{
											this.markAndChangeStatus(_local_11, CandySpecialStatus.NOTHING);
										}
										;
									}
									;
								}
								;
							}
							;
						}
						;
					}
					;
					_local_5++;
				}
				;
				_local_4++;
			}
			;
			_local_4 = 0;
			while (_local_4 < GameConst.ROW_COUNT)
			{
				_local_5 = 0;
				while (_local_5 < GameConst.COL_COUNT)
				{
					_local_7 = _local_3[_local_4][_local_5];
					if ((((!((_local_7 == null)))) && (_local_7.remove)))
					{
						_local_2.push(_local_7);
					}
					;
					_local_5++;
				}
				;
				_local_4++;
			}
			;
			Debug.log((((("搜索移除耗时:" + (getTimer() - _local_1)) + "ms") + "---") + _local_2.length));
			return (_local_2);
		}

		private function markAndChangeStatus(_arg_1:Array, _arg_2:int = 0):void
		{
			var _local_4:Candy;
			var _local_3:Boolean;
			for each (_local_4 in _arg_1)
			{
				_local_4.mark = true;
				_local_4.remove = true;
				if ((((((_local_4 == this.selectedCard)) || ((_local_4 == this.aimCard)))) && ((_arg_2 > 0))))
				{
					_local_3 = true;
					_local_4.setNextStatus(_arg_2);
				}
				;
			}
			;
			if ((((!(_local_3))) && ((_arg_2 > 0))))
			{
				_arg_1[(_arg_1.length - 1)].setNextStatus(_arg_2);
			}
			;
		}

		private function changeCandysStatus(_arg_1:Array, _arg_2:int):void
		{
			var _local_3:Candy;
			for each (_local_3 in _arg_1)
			{
				_local_3.setSpecialStatus(_arg_2);
			}
			;
		}

		private function getHorizMatches(_arg_1:Array, _arg_2:int, _arg_3:int):Array
		{
			var _local_4:Array = [_arg_1[_arg_2][_arg_3]];
			var _local_5:int = (_arg_3 + 1);
			while (_local_5 < GameConst.COL_COUNT)
			{
				if ((((((((!((_arg_1[_arg_2][_local_5] == null)))) && ((_arg_1[_arg_2][_arg_3].color == _arg_1[_arg_2][_local_5].color)))) && ((_arg_1[_arg_2][_local_5].color > 0)))) && (this.isCandyValidPos(_arg_2, _local_5))))
				{
					_local_4.push(_arg_1[_arg_2][_local_5]);
				}
				else
				{
					break;
				}
				;
				_local_5++;
			}
			;
			return (_local_4);
		}

		private function getVertMatches(_arg_1:Array, _arg_2:int, _arg_3:int):Array
		{
			var _local_4:Array = [_arg_1[_arg_2][_arg_3]];
			var _local_5:int = (_arg_2 + 1);
			while (_local_5 < GameConst.ROW_COUNT)
			{
				if ((((((((!((_arg_1[_local_5][_arg_3] == null)))) && ((_arg_1[_arg_2][_arg_3].color == _arg_1[_local_5][_arg_3].color)))) && ((_arg_1[_local_5][_arg_3].color > 0)))) && (this.isCandyValidPos(_local_5, _arg_3))))
				{
					_local_4.push(_arg_1[_local_5][_arg_3]);
				}
				else
				{
					break;
				}
				;
				_local_5++;
			}
			;
			return (_local_4);
		}

		private function getHVMatches(_arg_1:Array, _arg_2:int, _arg_3:int, _arg_4:Array, _arg_5:Array):Array
		{
			var _local_8:int;
			var _local_10:int;
			var _local_6:Array = [_arg_1[_arg_2][_arg_3]];
			var _local_7:int;
			var _local_9:int;
			while (_local_9 < _arg_4.length)
			{
				_local_10 = _arg_4[_local_9];
				if (_local_10 == 3)
				{
					_local_8 = Math.max(0, (_arg_3 + _arg_5[_local_9]));
					_local_7 = (_arg_3 - 1);
					while (_local_7 >= _local_8)
					{
						if ((((!((_arg_1[_arg_2][_local_7] == null)))) && ((_arg_1[_arg_2][_arg_3].color == _arg_1[_arg_2][_local_7].color))))
						{
							_local_6.push(_arg_1[_arg_2][_local_7]);
						}
						else
						{
							break;
						}
						;
						_local_7--;
					}
					;
				}
				;
				if (_local_10 == 4)
				{
					_local_8 = Math.min((GameConst.COL_COUNT - 1), (_arg_3 + _arg_5[_local_9]));
					_local_7 = (_arg_3 + 1);
					while (_local_7 <= _local_8)
					{
						if ((((!((_arg_1[_arg_2][_local_7] == null)))) && ((_arg_1[_arg_2][_arg_3].color == _arg_1[_arg_2][_local_7].color))))
						{
							_local_6.push(_arg_1[_arg_2][_local_7]);
						}
						else
						{
							break;
						}
						;
						_local_7++;
					}
					;
				}
				;
				if (_local_10 == 2)
				{
					_local_8 = Math.min((GameConst.ROW_COUNT - 1), (_arg_2 + _arg_5[_local_9]));
					_local_7 = (_arg_2 + 1);
					while (_local_7 <= _local_8)
					{
						if ((((!((_arg_1[_local_7][_arg_3] == null)))) && ((_arg_1[_arg_2][_arg_3].color == _arg_1[_local_7][_arg_3].color))))
						{
							_local_6.push(_arg_1[_local_7][_arg_3]);
						}
						else
						{
							break;
						}
						;
						_local_7++;
					}
					;
				}
				;
				if (_local_10 == 1)
				{
					_local_8 = Math.max(0, (_arg_2 + _arg_5[_local_9]));
					_local_7 = (_arg_2 - 1);
					while (_local_7 >= _local_8)
					{
						if ((((!((_arg_1[_local_7][_arg_3] == null)))) && ((_arg_1[_arg_2][_arg_3].color == _arg_1[_local_7][_arg_3].color))))
						{
							_local_6.push(_arg_1[_local_7][_arg_3]);
						}
						else
						{
							break;
						}
						;
						_local_7--;
					}
					;
				}
				;
				_local_9++;
			}
			;
			return (_local_6);
		}

		private function removeAllMatches():void
		{
			var _local_1:Array = this.checkFruitIsEnd();
			if (_local_1.length > 0)
			{
				this.removeFruits(_local_1);
				this.gameState = STATE_GAME_WAIT_DROP;
			}
			;
			var _local_2:Array = this.searchMatchesAndMark();
			if (_local_2.length >= 3)
			{
				if (!this.checkHasStatusCandy(_local_2))
				{
					this.tempScore = (((_local_2.length - 3) * 25) + 50);
				}
				else
				{
					this.tempScore = 300;
				}
				;
				this.handleRemoveList(_local_2);
				this.gameState = STATE_GAME_WAIT_DROP;
				this.selectedCard = (this.aimCard = null);
			}
			;
		}

		private function checkBomb():void
		{
			var _local_2:int;
			var _local_3:Candy;
			var _local_1:int;
			while (_local_1 < GameConst.ROW_COUNT)
			{
				_local_2 = 0;
				while (_local_2 < GameConst.COL_COUNT)
				{
					_local_3 = this.candys[_local_1][_local_2];
					if (((_local_3) && ((_local_3.getBombCount() > 0))))
					{
						_local_3.bombCountUpdate();
					}
					;
					_local_2++;
				}
				;
				_local_1++;
			}
			;
		}

		private function checkEatAndMonster():void
		{
			var _local_2:Array;
			var _local_3:Object;
			var _local_4:Eat;
			var _local_5:Point;
			var _local_6:Candy;
			var _local_7:Eat;
			var _local_8:Point;
			var _local_9:Object;
			var _local_10:Monster;
			var _local_11:Point;
			var _local_12:Point;
			if (!this.eatRemoved)
			{
				_local_2 = this.getEatAndAroundCandys();
				if (_local_2.length > 0)
				{
					_local_3 = _local_2[int((Math.random() * _local_2.length))];
					_local_4 = _local_3.eat;
					_local_4.zoomOutIn();
					_local_5 = _local_3.pos;
					_local_6 = this.candys[_local_5.x][_local_5.y];
					if ((((((!((_local_6 == null)))) && ((!(_local_6.isFruit()))))) && ((!(_local_6.isBomb())))))
					{
						this.candys[_local_5.x][_local_5.y] = null;
						_local_6.removeFromParent();
						_local_6.reset();
						Candy.pool.put(_local_6);
						_local_7 = Eat.pool.take();
						_local_7.row = _local_5.x;
						_local_7.col = _local_5.y;
						_local_7.reset();
						this.eats[_local_5.x][_local_5.y] = _local_7;
						_local_7.zoomIn();
						SoundManager.instance.playSound("msc_virus");
						_local_8 = this.getCandyPosition(_local_5.x, _local_5.y);
						_local_7.x = _local_8.x;
						_local_7.y = _local_8.y;
						this.eat_layer.addChild(_local_7);
					}
					;
				}
				;
			}
			;
			this.eatRemoved = false;
			var _local_1:Array = this.getMonsterAndAroundCandys();
			if (_local_1.length > 0)
			{
				for each (_local_9 in _local_1)
				{
					_local_10 = _local_9.monster;
					_local_11 = _local_9.pos;
					this.monsters[_local_10.row][_local_10.col] = null;
					_local_10.row = _local_11.x;
					_local_10.col = _local_11.y;
					this.monsters[_local_11.x][_local_11.y] = _local_10;
					_local_12 = this.getCandyPosition(_local_11.x, _local_11.y);
					Tweener.addTween(_local_10, {"time": 0.1, "x": _local_12.x, "y": _local_12.y});
				}
				;
				SoundManager.instance.playSound("msc_moveable");
			}
			;
			if (this.matchCountOnceSwap >= 40)
			{
				this.addGoodTip(3);
			}
			else
			{
				if (this.matchCountOnceSwap >= 25)
				{
					this.addGoodTip(2);
				}
				else
				{
					if (this.matchCountOnceSwap >= 10)
					{
						this.addGoodTip(1);
					}
					;
				}
				;
			}
			;
			this.matchCountOnceSwap = 0;
		}

		private function checkHasStatusCandy(_arg_1:Array):Boolean
		{
			var _local_2:Candy;
			for each (_local_2 in _arg_1)
			{
				if ((((((_local_2.status == 1)) || ((_local_2.status == 2)))) || ((_local_2.status == 3))))
				{
					return (true);
				}
				;
			}
			;
			return (false);
		}

		private function checkFruitIsEnd():Array
		{
			var _local_4:int;
			var _local_5:int;
			var _local_6:Candy;
			var _local_1:Array = [];
			var _local_2:Array = this.currentLevel.entryAndExit;
			var _local_3:int;
			while (_local_3 < GameConst.ROW_COUNT)
			{
				_local_4 = 0;
				while (_local_4 < GameConst.COL_COUNT)
				{
					_local_5 = _local_2[_local_3][_local_4];
					if (_local_5 == TileConst.FRUIT_END)
					{
						_local_6 = this.candys[_local_3][_local_4];
						if ((((!((_local_6 == null)))) && (_local_6.isFruit())))
						{
							_local_1.push(_local_6);
						}
						;
					}
					;
					_local_4++;
				}
				;
				_local_3++;
			}
			;
			return (_local_1);
		}

		private function checkSpecialSwapMathces():void
		{
			var matches:Array;
			var cols:Array;
			var rows:Array;
			var candyA:Candy;
			var candyB:Candy;
			matches = [];
			if (this.selectedCard.status < this.aimCard.status)
			{
				candyA = this.aimCard;
				candyB = this.selectedCard;
			}
			else
			{
				candyA = this.selectedCard;
				candyB = this.aimCard;
			}

			if (candyA.status == CandySpecialStatus.COLORFUL)
			{
				if (candyB.status == CandySpecialStatus.COLORFUL)
				{
					matches = this.getAllCandys();
					this.tempScore = 300;
					this.removeCandys(matches);
					this.waitDrop();
				}
				else if (candyB.status == CandySpecialStatus.BOMB)
				{
					matches = this.getCandysByColorType(candyB.color);
					this.createLaserEffect(candyA.x, candyA.y, matches, CandySpecialStatus.BOMB, function():void
					{
						tempScore = 300;
						changeCandysStatus(matches, CandySpecialStatus.BOMB);
						matches.push(candyA);
						removeCandys(matches);
						waitDrop();
					});
				}
				else if (candyB.status == CandySpecialStatus.VERT)
				{
					matches = this.getCandysByColorType(candyB.color);
					this.createLaserEffect(candyA.x, candyA.y, matches, CandySpecialStatus.VERT, function():void
					{
						tempScore = 300;
						matches.push(candyA);
						removeCandys(matches);
						waitDrop();
					}, true);
				}
				else if (candyB.status == CandySpecialStatus.HORIZ)
				{
					matches = this.getCandysByColorType(candyB.color);
					this.createLaserEffect(candyA.x, candyA.y, matches, CandySpecialStatus.HORIZ, function():void
					{
						tempScore = 300;
						matches.push(candyA);
						removeCandys(matches);
						waitDrop();
					}, true);
				}
				else if (candyB.status == CandySpecialStatus.NOTHING)
				{
					matches = this.getCandysByColorType(candyB.color);
					this.createRayEffect(candyA.x, candyA.y, matches, function():void
					{
						tempScore = 300;
						matches.push(candyA);
						removeCandys(matches);
						waitDrop();
					});
				}
			}
			else
			{
				if (candyA.status == CandySpecialStatus.BOMB)
				{
					if (candyB.status == CandySpecialStatus.BOMB)
					{
						matches = this.getAroundCandys2(candyA, candyB);
						this.tempScore = 300;
						this.removeCandys(matches);
						this.waitDrop();
					}
					else if (candyB.status == CandySpecialStatus.VERT)
					{
						if (candyA.col < candyB.col)
						{
							cols = [(candyA.col - 1), candyA.col, candyB.col, (candyB.col + 1)];
						}
						else
						{
							if (candyA.col > candyB.col)
							{
								cols = [(candyA.col + 1), candyA.col, candyB.col, (candyB.col - 1)];
							}
							else
							{
								if (candyA.col == candyB.col)
								{
									cols = [(candyA.col - 1), candyA.col, (candyB.col + 1)];
								}
							}
						}
						matches = this.getCandysByRowsOrCols([], cols);
						this.tempScore = 300;
						this.removeCandys(matches);
						this.waitDrop();
					}
					else if (candyB.status == CandySpecialStatus.HORIZ)
					{
						if (candyA.row < candyB.row)
						{
							rows = [(candyA.row - 1), candyA.row, candyB.row, (candyB.row + 1)];
						}
						else if (candyA.row > candyB.row)
						{
							rows = [(candyA.row + 1), candyA.row, candyB.row, (candyB.row - 1)];
						}
						else if (candyA.row == candyB.row)
						{
							rows = [(candyA.row - 1), candyA.row, (candyB.row + 1)];
						}

						matches = this.getCandysByRowsOrCols(rows, []);
						this.tempScore = 300;
						this.removeCandys(matches);
						this.waitDrop();
					}
				}
				else if (candyA.status == CandySpecialStatus.VERT)
				{
					if (candyB.status == CandySpecialStatus.VERT)
					{
						this.tempScore = 300;
						candyB.setSpecialStatus(1);
						this.removeCandys([candyA, candyB]);
						this.waitDrop();
					}
					else if (candyB.status == CandySpecialStatus.HORIZ)
					{
						this.tempScore = 300;
						this.removeCandys([candyA, candyB]);
						this.waitDrop();
					}
				}
				else if (candyA.status == CandySpecialStatus.HORIZ)
				{
					if (candyB.status == CandySpecialStatus.HORIZ)
					{
						candyB.setSpecialStatus(2);
						this.tempScore = 300;
						this.removeCandys([candyA, candyB]);
						this.waitDrop();
					}
				}
			}
		}

		private function createLaserEffect(x:int, y:int, list:Array, changeStatus:int, complete:Function, isRandomLine:Boolean = false):void
		{
			var animationCount:int;
			var candy:Candy;
			var disX:Number;
			var disY:Number;
			var dis:Number;
			var radian:Number;
			var laserEffect:LaserEffect;
			animationCount = 0;
			var i:int;
			while (i < list.length)
			{
				candy = list[i];
				disX = (candy.x - x);
				disY = (candy.y - y);
				dis = Math.sqrt(((disX * disX) + (disY * disY)));
				radian = Math.atan2(disY, disX);
				laserEffect = LaserEffect.pool.take();
				laserEffect.x = x;
				laserEffect.y = y;
				laserEffect.setData(radian);
				this.addChild(laserEffect);
				Tweener.addTween(laserEffect, {"time": (dis / 400), "x": candy.x, "y": candy.y, "onCompleteParams": [candy, laserEffect], "transition": "linear", "onComplete": function(_arg_1:Candy, _arg_2:LaserEffect):void
				{
					_arg_2.removeFromParent();
					LaserEffect.pool.put(_arg_2);
					if (isRandomLine)
					{
						if (Math.random() < 0.5)
						{
							_arg_1.setSpecialStatus(CandySpecialStatus.VERT, true);
						}
						else
						{
							_arg_1.setSpecialStatus(CandySpecialStatus.HORIZ, true);
						}
						;
					}
					else
					{
						_arg_1.setSpecialStatus(changeStatus, true);
					}
					;
					animationCount++;
					if (animationCount == list.length)
					{
						complete();
					}
					;
				}});
				i = (i + 1);
			}
			;
		}

		private function createRayEffect(x:int, y:int, list:Array, complete:Function):void
		{
			var animationCount:int;
			var candy:Candy;
			var disX:Number;
			var disY:Number;
			var dis:Number;
			var radian:Number;
			var laserEffect:RayEffect;
			animationCount = 0;
			var i:int;
			while (i < list.length)
			{
				candy = list[i];
				disX = (candy.x - x);
				disY = (candy.y - y);
				dis = Math.sqrt(((disX * disX) + (disY * disY)));
				radian = Math.atan2(disY, disX);
				laserEffect = RayEffect.pool.take();
				laserEffect.x = x;
				laserEffect.y = y;
				this.addChild(laserEffect);
				Tweener.addTween(laserEffect, {"time": (dis / 800), "x": candy.x, "y": candy.y, "onCompleteParams": [candy, laserEffect], "transition": "linear", "onComplete": function(_arg_1:Candy, _arg_2:RayEffect):void
				{
					_arg_2.removeFromParent();
					RayEffect.pool.put(_arg_2);
					animationCount++;
					if (animationCount == list.length)
					{
						complete();
					}
					;
				}});
				i = (i + 1);
			}
			;
		}

		private function handleRemoveList(_arg_1:Array):void
		{
			var _local_3:Candy;
			var _local_4:Candy;
			var _local_2:int;
			while (_local_2 < _arg_1.length)
			{
				_local_3 = _arg_1[_local_2];
				if (_local_3.getNextStatus() > 0)
				{
					this.removeCandys([_local_3]);
					_local_4 = this.newCandy(_local_3.row, _local_3.col, _local_3.color);
					_local_4.setSpecialStatus(_local_3.getNextStatus(), true);
					_arg_1.splice(_local_2, 1);
					_local_2--;
				}
				;
				_local_2++;
			}
			;
			this.removeCandys(_arg_1);
		}

		private function removeCandys(_arg_1:Array):void
		{
			var _local_3:Candy;
			var _local_4:int;
			var _local_5:Array;
			var _local_6:Point;
			var _local_7:Point;
			var _local_8:Candy;
			var _local_9:Ice;
			var _local_10:Eat;
			var _local_11:Monster;
			var _local_12:Brick;
			var _local_2:Array = [];
			for each (_local_3 in _arg_1)
			{
				_local_5 = this.searchSpecialRelativeCandys(_local_3);
				for each (_local_6 in _local_5)
				{
					if (_local_2.indexOf(_local_6) == -1)
					{
						_local_2.push(_local_6);
					}
					;
				}
				;
			}
			;
			SoundManager.instance.playSound("boomcommon");
			_local_4 = (_local_2.length - 1);
			while (_local_4 >= 0)
			{
				_local_7 = _local_2[_local_4];
				_local_8 = this.candys[_local_7.x][_local_7.y];
				if ((((!((_local_8 == null)))) && ((_local_8.color < 7))))
				{
					this.removeElementAroundCandy(_local_8);
					this.addEffect(_local_8.status, _local_8.x, _local_8.y);
					_local_8.reset();
					this.candys[_local_8.row][_local_8.col] = null;
					Candy.pool.put(_local_8);
					_local_8.removeFromParent();
					this.matchCountOnceSwap++;
				}
				else
				{
					_local_9 = this.ices[_local_7.x][_local_7.y];
					if (_local_9 != null)
					{
						this.removeIce(_local_9);
					}
					else
					{
						_local_12 = this.bricks[_local_7.x][_local_7.y];
						if (_local_12 != null)
						{
							this.removeBrick(_local_12);
						}
						;
					}
					;
					_local_10 = this.eats[_local_7.x][_local_7.y];
					if (_local_10 != null)
					{
						this.eats[_local_10.row][_local_10.col] = null;
						_local_10.doAnimation();
						this.eatRemoved = true;
					}
					;
					_local_11 = this.monsters[_local_7.x][_local_7.y];
					if (_local_11 != null)
					{
						this.monsters[_local_11.row][_local_11.col] = null;
						_local_11.doAnimation();
					}
					;
				}
				;
				_local_4--;
			}
			;
		}

		private function waitDrop():void
		{
			this.gameState = STATE_GAME_WAIT_DROP;
		}

		private function removeElementAroundCandy(_arg_1:Candy):void
		{
			var _local_5:Monster;
			var _local_6:Array;
			var _local_7:Eat;
			var _local_8:Array;
			var _local_9:Ice;
			var _local_10:Array;
			var _local_11:Stone;
			if (_arg_1.status == CandySpecialStatus.HORIZ)
			{
				SoundManager.instance.playSound("effect_hyper");
				Model.gameModel.offsetAim(AimType.LINE_BOMB, 1);
			}
			else
			{
				if (_arg_1.status == CandySpecialStatus.VERT)
				{
					SoundManager.instance.playSound("effect_hyper");
					Model.gameModel.offsetAim(AimType.LINE_BOMB, 1);
				}
				else
				{
					if (_arg_1.status == CandySpecialStatus.BOMB)
					{
						SoundManager.instance.playSound("bomb_blast");
					}
					;
				}
				;
			}
			;
			var _local_2:Lock = this.locks[_arg_1.row][_arg_1.col];
			if (_local_2)
			{
				this.locks[_arg_1.row][_arg_1.col] = null;
				_arg_1.remove = false;
				_arg_1.mark = false;
				_local_2.doAnimation();
				return;
			}
			;
			var _local_3:Brick = this.bricks[_arg_1.row][_arg_1.col];
			if (_local_3)
			{
				this.removeBrick(_local_3);
			}
			;
			var _local_4:Array = this.getNearMonster(_arg_1.row, _arg_1.col);
			for each (_local_5 in _local_4)
			{
				this.monsters[_local_5.row][_local_5.col] = null;
				_local_5.doAnimation();
			}
			;
			_local_6 = this.getNearEat(_arg_1.row, _arg_1.col);
			for each (_local_7 in _local_6)
			{
				this.eats[_local_7.row][_local_7.col] = null;
				_local_7.doAnimation();
				this.eatRemoved = true;
			}
			;
			_local_8 = this.getNearIce(_arg_1.row, _arg_1.col);
			for each (_local_9 in _local_8)
			{
				this.removeIce(_local_9);
			}
			;
			_local_10 = this.getNearStone(_arg_1.row, _arg_1.col);
			for each (_local_11 in _local_10)
			{
				_local_11.setLife((_local_11.life - 1), true);
				if (_local_11.life == 0)
				{
					this.stones[_local_11.row][_local_11.col] = null;
					Stone.pool.put(_local_11);
					_local_11.removeFromParent();
				}
				;
			}
			;
			if (_arg_1.color == ColorType.GREEN)
			{
				Model.gameModel.offsetAim(AimType.GREEN, 1);
			}
			else
			{
				if (_arg_1.color == ColorType.RED)
				{
					Model.gameModel.offsetAim(AimType.RED, 1);
				}
				else
				{
					if (_arg_1.color == ColorType.BLUE)
					{
						Model.gameModel.offsetAim(AimType.BLUE, 1);
					}
					else
					{
						if (_arg_1.color == ColorType.PURPLE)
						{
							Model.gameModel.offsetAim(AimType.PURPLE, 1);
						}
						else
						{
							if (_arg_1.color == ColorType.YELLOW)
							{
								Model.gameModel.offsetAim(AimType.YELLOW, 1);
							}
							;
						}
						;
					}
					;
				}
				;
			}
			;
			Model.gameModel.score = (Model.gameModel.score + this.tempScore);
			Model.gameModel.offsetAim(AimType.SCORE, this.tempScore);
//            this.addScoreTip(_arg_1.x, _arg_1.y, this.tempScore, _arg_1.color);
		}

		private function removeIce(_arg_1:Ice):void
		{
			SoundManager.instance.playSound("iceboom", false, 0, 1, 1, true);
			_arg_1.setLife((_arg_1.life - 1), true);
			if (_arg_1.life == 0)
			{
				Model.gameModel.offsetAim(AimType.ICE, 1);
				this.ices[_arg_1.row][_arg_1.col] = null;
				Ice.pool.put(_arg_1);
				_arg_1.removeFromParent();
			}
			;
		}

		private function removeBrick(_arg_1:Brick):void
		{
			_arg_1.loseLife();
			if (_arg_1.life == 0)
			{
				this.bricks[_arg_1.row][_arg_1.col] = null;
				Brick.pool.put(_arg_1);
				_arg_1.removeFromParent();
				Model.gameModel.offsetAim(AimType.BOARD, 1);
			}
			;
		}

		private function removeFruits(list:Array):void
		{
			var removeCandy:Candy;
			var tp:Point;
			var disX:Number;
			var disY:Number;
			var dis:Number;
			var t:Number;
			Debug.log("移除水果");
			for each (removeCandy in list)
			{
//                this.addScoreTip(removeCandy.x, removeCandy.y, 10, removeCandy.color);
				this.addEffect(removeCandy.status, removeCandy.x, removeCandy.y);
				removeCandy.reset();
				this.candys[removeCandy.row][removeCandy.col] = null;
				this.addChild(removeCandy);
				tp = new Point(0, 0);
				if (removeCandy.color == 7)
				{
					tp = this.infoPanel.getIconPos(AimType.FRUIT1);
				}
				else
				{
					if (removeCandy.color == 8)
					{
						tp = this.infoPanel.getIconPos(AimType.FRUIT2);
					}
					else
					{
						if (removeCandy.color == 9)
						{
							tp = this.infoPanel.getIconPos(AimType.FRUIT3);
						}
						;
					}
					;
				}
				;
				if (removeCandy.color == ColorType.FRUIT1)
				{
					Model.gameModel.offsetAim(AimType.FRUIT1, 1);
				}
				else
				{
					if (removeCandy.color == ColorType.FRUIT2)
					{
						Model.gameModel.offsetAim(AimType.FRUIT2, 1);
					}
					else
					{
						if (removeCandy.color == ColorType.FRUIT3)
						{
							Model.gameModel.offsetAim(AimType.FRUIT3, 1);
						}
						;
					}
					;
				}
				;
				disX = ((tp.x + this.infoPanel.x) - removeCandy.x);
				disY = ((tp.y + this.infoPanel.y) - removeCandy.y);
				dis = Math.sqrt(((disX * disX) + (disY * disY)));
				t = (dis / 600);
				Tweener.addTween(removeCandy, {"time": t, "x": (tp.x + this.infoPanel.x), "y": (tp.y + this.infoPanel.y), "scaleX": 0.6, "scaleY": 0.6, "onCompleteParams": [removeCandy], "onComplete": function(_arg_1:Candy):void
				{
					Candy.pool.put(_arg_1);
					_arg_1.reset();
					_arg_1.removeFromParent();
				}});
			}
			;
		}

		private function searchSpecialRelativeCandys(_arg_1:Candy):Array
		{
			var _local_4:Point;
			var _local_5:Candy;
			var _local_6:Array;
			var _local_7:Point;
			var _local_8:Candy;
			var _local_2:Array = [];
			var _local_3:Array = [];
			_local_2.push(new Point(_arg_1.row, _arg_1.col));
			while (_local_2.length > 0)
			{
				_local_4 = _local_2.shift();
				_local_5 = this.candys[_local_4.x][_local_4.y];
				_local_3.push(_local_4);
				if ((((!((_local_5 == null)))) && ((_local_5.status > 0))))
				{
					_local_6 = this.getRelativeCandysByStatus(_local_5);
					for each (_local_7 in _local_6)
					{
						_local_8 = this.candys[_local_7.x][_local_7.y];
						if (_local_8 != _local_5)
						{
							if ((((!((_local_8 == null)))) && ((_local_8.status > 0))))
							{
								if ((((!(this.checkListContainPoint(_local_2, _local_7)))) && ((!(this.checkListContainPoint(_local_3, _local_7))))))
								{
									_local_2.push(_local_7);
								}
								;
							}
							else
							{
								if (!this.checkListContainPoint(_local_3, _local_7))
								{
									_local_3.push(_local_7);
								}
								;
							}
							;
						}
						;
					}
					;
				}
				;
			}
			;
			return (_local_3);
		}

		private function checkListContainPoint(_arg_1:Array, _arg_2:Point):Boolean
		{
			var _local_3:Point;
			for each (_local_3 in _arg_1)
			{
				if ((((_local_3.x === _arg_2.x)) && ((_local_3.y == _arg_2.y))))
				{
					return (true);
				}
				;
			}
			;
			return (false);
		}

		private function checkTop():Boolean
		{
			var _local_3:int;
			var _local_4:Boolean;
			var _local_5:Candy;
			Debug.log("检测掉落");
			this.colAdd = [];
			this.tDoorAdd = [];
			var _local_1:int;
			while (_local_1 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					if (this.currentLevel.entryAndExit[_local_1][_local_3] == TileConst.ENTRY)
					{
						this.colAdd[_local_3] = (_local_1 - 1);
					}
					else
					{
						if ((((this.currentLevel.entryAndExit[_local_1][_local_3] >= TileConst.T_DOOR_EXIT1)) && ((this.currentLevel.entryAndExit[_local_1][_local_3] <= TileConst.T_DOOR_EXIT9))))
						{
							this.tDoorAdd[_local_3] = (_local_1 - 1);
						}
						;
					}
					;
					_local_3++;
				}
				;
				_local_1++;
			}
			;
			while (true)
			{
				_local_4 = this.dropAndAdd();
				if (!_local_4)
					break;
			}
			;
			var _local_2:Boolean;
			_local_1 = 0;
			while (_local_1 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					_local_5 = this.candys[_local_1][_local_3];
					if (_local_5 != null)
					{
						if (_local_5.path.length > 0)
						{
							_local_5.runAsPath();
							_local_2 = true;
						}
						;
					}
					;
					_local_3++;
				}
				;
				_local_1++;
			}
			;
			return (_local_2);
		}

		private function dropAndAdd():Boolean
		{
			var _local_4:int;
			var _local_5:int;
			var _local_6:Candy;
			var _local_7:int;
			var _local_8:Candy;
			var _local_9:Point;
			var _local_10:Candy;
			var _local_11:Point;
			var _local_12:Point;
			var _local_1:Boolean;
			var _local_2:Array = [4, 3, 2, 1, 0, 5, 6, 7, 8];
			var _local_3:int = (GameConst.ROW_COUNT - 1);
			while (_local_3 >= 0)
			{
				_local_4 = 0;
				while (_local_4 < _local_2.length)
				{
					_local_5 = _local_2[_local_4];
					_local_6 = this.candys[_local_3][_local_5];
					if ((((((_local_6 == null)) && ((!((this.currentLevel.tile[_local_3][_local_5] == 0)))))) && ((!(this.checkIsBlock(_local_3, _local_5))))))
					{
						if (this.currentLevel.entryAndExit[_local_3][_local_5] == TileConst.ENTRY)
						{
							_local_7 = 0;
							if (this.nextFruitId > 0)
							{
								_local_7 = this.nextFruitId;
								this.nextFruitId = 0;
							}
							;
							_local_8 = this.newCandy(_local_3, _local_5, _local_7);
							_local_9 = this.getCandyPosition(this.colAdd[_local_5], _local_5);
							_local_8.x = _local_9.x;
							_local_8.y = _local_9.y;
							this.gameState = STATE_GAME_CHECK_DROP_COMPLETE;
							_local_8.addPath({"pos": this.getCandyPosition(_local_3, _local_5), "type": 1});
							_local_1 = true;
							this.colAdd[_local_5]--;
							Debug.log("添加新的candy", _local_3, _local_5);
						}
						else
						{
							if ((((this.currentLevel.entryAndExit[_local_3][_local_5] >= TileConst.T_DOOR_EXIT1)) && ((this.currentLevel.entryAndExit[_local_3][_local_5] <= TileConst.T_DOOR_EXIT9))))
							{
								_local_10 = this.getTransportCandy(this.currentLevel.entryAndExit[_local_3][_local_5]);
								if (_local_10 != null)
								{
									this.candys[_local_10.row][_local_10.col] = null;
									_local_10.row = _local_3;
									_local_10.col = _local_5;
									_local_11 = this.getCandyPosition(this.tDoorAdd[_local_5], _local_5);
									_local_10.addPath({"pos": _local_11, "type": 2});
									this.candys[_local_3][_local_5] = _local_10;
									var _local_13 = this.tDoorAdd;
									var _local_14 = _local_5;
									var _local_15 = (_local_13[_local_14] - 1);
									_local_13[_local_14] = _local_15;
									_local_10.addPath({"pos": this.getCandyPosition(_local_3, _local_5), "type": 1});
									this.gameState = STATE_GAME_CHECK_DROP_COMPLETE;
									_local_1 = true;
								}
								;
							}
							else
							{
								if (this.checkIsUpPosition(_local_3, _local_5))
								{
									if (((((this.isValidPos((_local_3 - 1), (_local_5 + 1))) && ((!(this.checkIsBlock((_local_3 - 1), (_local_5 + 1))))))) && ((!((this.candys[(_local_3 - 1)][(_local_5 + 1)] == null))))))
									{
										_local_12 = new Point((_local_3 - 1), (_local_5 + 1));
										this.candys[_local_12.x][_local_12.y].row = _local_3;
										this.candys[_local_12.x][_local_12.y].col = _local_5;
										this.candys[_local_12.x][_local_12.y].addPath({"pos": this.getCandyPosition(_local_3, _local_5), "type": 1});
										this.candys[_local_3][_local_5] = this.candys[_local_12.x][_local_12.y];
										this.candys[_local_12.x][_local_12.y] = null;
										this.gameState = STATE_GAME_CHECK_DROP_COMPLETE;
										_local_1 = true;
									}
									else
									{
										if (((((this.isValidPos((_local_3 - 1), (_local_5 - 1))) && ((!(this.checkIsBlock((_local_3 - 1), (_local_5 - 1))))))) && ((!((this.candys[(_local_3 - 1)][(_local_5 - 1)] == null))))))
										{
											_local_12 = new Point((_local_3 - 1), (_local_5 - 1));
											this.candys[_local_12.x][_local_12.y].row = _local_3;
											this.candys[_local_12.x][_local_12.y].col = _local_5;
											this.candys[_local_12.x][_local_12.y].addPath({"pos": this.getCandyPosition(_local_3, _local_5), "type": 1});
											this.candys[_local_3][_local_5] = this.candys[_local_12.x][_local_12.y];
											this.candys[_local_12.x][_local_12.y] = null;
											this.gameState = STATE_GAME_CHECK_DROP_COMPLETE;
											_local_1 = true;
										}
										;
									}
									;
								}
								else
								{
									_local_12 = this.getCandyCanDropPos(_local_3, _local_5);
									if (_local_12 != null)
									{
										this.candys[_local_12.x][_local_12.y].row = _local_3;
										this.candys[_local_12.x][_local_12.y].col = _local_5;
										this.candys[_local_12.x][_local_12.y].addPath({"pos": this.getCandyPosition(_local_3, _local_5), "type": 1});
										this.candys[_local_3][_local_5] = this.candys[_local_12.x][_local_12.y];
										this.candys[_local_12.x][_local_12.y] = null;
										this.gameState = STATE_GAME_CHECK_DROP_COMPLETE;
										_local_1 = true;
									}
									;
								}
								;
							}
							;
						}
						;
					}
					;
					_local_4++;
				}
				;
				_local_3--;
			}
			;
			return (_local_1);
		}

		private function checkIsUpPosition(_arg_1:int, _arg_2:int):Boolean
		{
			var _local_5:int;
			var _local_3:Array = this.currentLevel.tile;
			var _local_4:int;
			while (_local_4 < GameConst.COL_COUNT)
			{
				_local_5 = 0;
				while (_local_5 < GameConst.ROW_COUNT)
				{
					if (_local_3[_local_5][_local_4] != 0)
					{
						if ((((_arg_1 == _local_5)) && ((_arg_2 == _local_4))))
						{
							return (true);
						}
						;
						break;
					}
					;
					_local_5++;
				}
				;
				_local_4++;
			}
			;
			return (false);
		}

		private function getCandyCanDropPos(_arg_1:int, _arg_2:int):Point
		{
			var _local_3:int = (_arg_1 - 1);
			if (_local_3 < 0)
			{
				return (null);
			}
			;
			if ((((((!((this.candys[_local_3][_arg_2] == null)))) && ((!(this.checkIsBlock(_local_3, _arg_2)))))) && ((!(this.hasIronWire(_local_3, _arg_2, 2))))))
			{
				return (new Point(_local_3, _arg_2));
			}
			;
			if ((((((((!((this.ices[_local_3][_arg_2] == null)))) || (this.locks[_local_3][_arg_2]))) || (this.hasIronWire(_local_3, _arg_2, 2)))) || (this.checkTopIsBlockByCol(_local_3, _arg_2))))
			{
				if (((((((_arg_2 - 1) >= 0)) && ((!((this.candys[_local_3][(_arg_2 - 1)] == null)))))) && ((!(this.checkIsBlock(_local_3, (_arg_2 - 1)))))))
				{
					return (new Point(_local_3, (_arg_2 - 1)));
				}
				;
				if (((((((_arg_2 + 1) < GameConst.COL_COUNT)) && ((!((this.candys[_local_3][(_arg_2 + 1)] == null)))))) && ((!(this.checkIsBlock(_local_3, (_arg_2 + 1)))))))
				{
					return (new Point(_local_3, (_arg_2 + 1)));
				}
				;
			}
			else
			{
				if (this.currentLevel.tile[_local_3][_arg_2] == 0)
				{
					return (this.getCandyCanDropPos(_local_3, _arg_2));
				}
				;
			}
			;
			return (null);
		}

		private function checkTopIsBlockByCol(_arg_1:int, _arg_2:int):Boolean
		{
			var _local_3:int = _arg_1;
			while (_local_3 >= 0)
			{
				if (this.currentLevel.tile[_local_3][_arg_2] > 0)
				{
					if (this.candys[_local_3][_arg_2] != null)
					{
						return (false);
					}
					;
					if (this.checkIsBlock(_local_3, _arg_2))
					{
						return (true);
					}
					;
				}
				;
				_local_3--;
			}
			;
			return (false);
		}

		private function getTransportCandy(_arg_1:int):Candy
		{
			var _local_5:int;
			var _local_6:int;
			var _local_2:int = (_arg_1 - 9);
			var _local_3:Array = this.currentLevel.entryAndExit;
			var _local_4:int;
			while (_local_4 < GameConst.ROW_COUNT)
			{
				_local_5 = 0;
				while (_local_5 < GameConst.COL_COUNT)
				{
					_local_6 = _local_3[_local_4][_local_5];
					if (_local_6 == _local_2)
					{
						if (this.candys[_local_4][_local_5] != null)
						{
							return (this.candys[_local_4][_local_5]);
						}
						;
					}
					;
					_local_5++;
				}
				;
				_local_4++;
			}
			;
			return (null);
		}

		private function checkIsBlock(_arg_1:int, _arg_2:int):Boolean
		{
			if ((((((((((!((this.ices[_arg_1][_arg_2] == null)))) || ((!((this.locks[_arg_1][_arg_2] == null)))))) || ((!((this.stones[_arg_1][_arg_2] == null)))))) || ((!((this.eats[_arg_1][_arg_2] == null)))))) || ((!((this.monsters[_arg_1][_arg_2] == null))))))
			{
				return (true);
			}
			;
			return (false);
		}

		private function checkConnectable():Array
		{
			var _local_2:Array;
			var _local_5:int;
			var _local_1:Array = this.candys;
			var _local_3:Array = [];
			var _local_4:int;
			while (_local_4 < GameConst.ROW_COUNT)
			{
				_local_5 = 0;
				while (_local_5 < GameConst.COL_COUNT)
				{
					if (_local_1[_local_4][_local_5] != null)
					{
						_local_2 = this.checkMatches([_local_4, _local_5], [0, 1], [0, 2], [[0, 3], [-1, 2], [1, 2]]);
						if (_local_2.length >= 1)
						{
							_local_2.unshift(this.candys[_local_4][(_local_5 + 2)]);
							_local_3.push(_local_2);
						}
						;
						_local_2 = this.checkMatches([_local_4, _local_5], [0, 1], [0, -1], [[0, -2], [-1, -1], [1, -1]]);
						if (_local_2.length >= 1)
						{
							_local_2.unshift(this.candys[_local_4][(_local_5 - 1)]);
							_local_3.push(_local_2);
						}
						;
						_local_2 = this.checkMatches([_local_4, _local_5], [0, 2], [0, 1], [[-1, 1], [1, 1]]);
						if (_local_2.length >= 1)
						{
							_local_2.unshift(this.candys[_local_4][(_local_5 + 1)]);
							_local_3.push(_local_2);
						}
						;
						_local_2 = this.checkMatches([_local_4, _local_5], [1, 0], [2, 0], [[3, 0], [2, -1], [2, 1]]);
						if (_local_2.length >= 1)
						{
							_local_2.unshift(this.candys[(_local_4 + 2)][_local_5]);
							_local_3.push(_local_2);
						}
						;
						_local_2 = this.checkMatches([_local_4, _local_5], [1, 0], [-1, 0], [[-2, 0], [-1, -1], [-1, 1]]);
						if (_local_2.length >= 1)
						{
							_local_2.unshift(this.candys[(_local_4 - 1)][_local_5]);
							_local_3.push(_local_2);
						}
						;
						_local_2 = this.checkMatches([_local_4, _local_5], [2, 0], [1, 0], [[1, -1], [1, 1]]);
						if (_local_2.length >= 3)
						{
							_local_2.unshift(this.candys[(_local_4 + 1)][_local_5]);
							_local_3.push(_local_2);
						}
						;
					}
					;
					_local_5++;
				}
				;
				_local_4++;
			}
			;
			return (_local_3);
		}

		private function checkMatches(_arg_1:Array, _arg_2:Array, _arg_3:Array, _arg_4:Array):Array
		{
			var _local_14:int;
			var _local_15:int;
			var _local_5:Array = this.candys;
			var _local_6:Array = [];
			var _local_7:int = _arg_1[0];
			var _local_8:int = _arg_1[1];
			var _local_9:int = (_local_7 + _arg_2[0]);
			var _local_10:int = (_local_8 + _arg_2[1]);
			var _local_11:int = (_local_7 + _arg_3[0]);
			var _local_12:int = (_local_8 + _arg_3[1]);
			if (!this.isValidPos(_local_9, _local_10))
			{
				return (_local_6);
			}
			;
			if (_local_5[_local_9][_local_10] == null)
			{
				return (_local_6);
			}
			;
			if (_local_5[_local_9][_local_10].color != _local_5[_local_7][_local_8].color)
			{
				return (_local_6);
			}
			;
			if (this.checkIsBlock(_local_9, _local_10))
			{
				return (_local_6);
			}
			;
			if (!this.isValidPos(_local_11, _local_12))
			{
				return (_local_6);
			}
			;
			if (_local_5[_local_11][_local_12] == null)
			{
				return (_local_6);
			}
			;
			if (this.checkIsBlock(_local_11, _local_12))
			{
				return (_local_6);
			}
			;
			var _local_13:int;
			while (_local_13 < _arg_4.length)
			{
				_local_14 = (_arg_4[_local_13][0] + _local_7);
				_local_15 = (_arg_4[_local_13][1] + _local_8);
				if (((this.isValidPos(_local_14, _local_15)) && ((!((_local_5[_local_14][_local_15] == null))))))
				{
					if ((((_local_5[_local_7][_local_8].color == _local_5[_local_14][_local_15].color)) && ((!(this.checkIsBlock(_local_14, _local_15))))))
					{
						_local_6.push(_local_5[_local_14][_local_15]);
					}
					;
				}
				;
				_local_13++;
			}
			;
			return (_local_6);
		}

		private function getNearIce(_arg_1:int, _arg_2:int):Array
		{
			var _local_6:int;
			var _local_7:int;
			var _local_3:Array = [];
			var _local_4:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]];
			var _local_5:int;
			while (_local_5 < _local_4.length)
			{
				_local_6 = (_arg_1 + _local_4[_local_5][0]);
				_local_7 = (_arg_2 + _local_4[_local_5][1]);
				if (this.isValidPos(_local_6, _local_7))
				{
					if (this.ices[_local_6][_local_7] != null)
					{
						_local_3.push(this.ices[_local_6][_local_7]);
					}
					;
				}
				;
				_local_5++;
			}
			;
			return (_local_3);
		}

		private function getNearStone(_arg_1:int, _arg_2:int):Array
		{
			var _local_6:int;
			var _local_7:int;
			var _local_3:Array = [];
			var _local_4:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]];
			var _local_5:int;
			while (_local_5 < _local_4.length)
			{
				_local_6 = (_arg_1 + _local_4[_local_5][0]);
				_local_7 = (_arg_2 + _local_4[_local_5][1]);
				if (this.isValidPos(_local_6, _local_7))
				{
					if (this.stones[_local_6][_local_7] != null)
					{
						_local_3.push(this.stones[_local_6][_local_7]);
					}
					;
				}
				;
				_local_5++;
			}
			;
			return (_local_3);
		}

		private function getNearEat(_arg_1:int, _arg_2:int):Array
		{
			var _local_6:int;
			var _local_7:int;
			var _local_3:Array = [];
			var _local_4:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]];
			var _local_5:int;
			while (_local_5 < _local_4.length)
			{
				_local_6 = (_arg_1 + _local_4[_local_5][0]);
				_local_7 = (_arg_2 + _local_4[_local_5][1]);
				if (this.isValidPos(_local_6, _local_7))
				{
					if (this.eats[_local_6][_local_7] != null)
					{
						_local_3.push(this.eats[_local_6][_local_7]);
					}
					;
				}
				;
				_local_5++;
			}
			;
			return (_local_3);
		}

		private function getNearMonster(_arg_1:int, _arg_2:int):Array
		{
			var _local_6:int;
			var _local_7:int;
			var _local_3:Array = [];
			var _local_4:Array = [[1, 0], [-1, 0], [0, 1], [0, -1]];
			var _local_5:int;
			while (_local_5 < _local_4.length)
			{
				_local_6 = (_arg_1 + _local_4[_local_5][0]);
				_local_7 = (_arg_2 + _local_4[_local_5][1]);
				if (this.isValidPos(_local_6, _local_7))
				{
					if (this.monsters[_local_6][_local_7] != null)
					{
						_local_3.push(this.monsters[_local_6][_local_7]);
					}
					;
				}
				;
				_local_5++;
			}
			;
			return (_local_3);
		}

		private function getCandysByColorType(_arg_1:int):Array
		{
			var _local_4:int;
			var _local_2:Array = [];
			var _local_3:int;
			while (_local_3 < GameConst.ROW_COUNT)
			{
				_local_4 = 0;
				while (_local_4 < GameConst.COL_COUNT)
				{
					if ((((!((this.candys[_local_3][_local_4] == null)))) && ((this.candys[_local_3][_local_4].color == _arg_1))))
					{
						_local_2.push(this.candys[_local_3][_local_4]);
					}
					;
					_local_4++;
				}
				;
				_local_3++;
			}
			;
			return (_local_2);
		}

		private function getSpecialCandys():Array
		{
			var _local_3:int;
			var _local_4:Candy;
			var _local_1:Array = [];
			var _local_2:int;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					_local_4 = this.candys[_local_2][_local_3];
					if ((((((!((_local_4 == null)))) && ((_local_4.status > 0)))) && ((_local_4.status < 5))))
					{
						_local_1.push(_local_4);
					}
					;
					_local_3++;
				}
				;
				_local_2++;
			}
			;
			return (_local_1);
		}

		private function getNormalCandys():Array
		{
			var _local_3:int;
			var _local_4:Candy;
			var _local_1:Array = [];
			var _local_2:int;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					_local_4 = this.candys[_local_2][_local_3];
					if ((((!((_local_4 == null)))) && ((_local_4.status == 0))))
					{
						_local_1.push(_local_4);
					}
					;
					_local_3++;
				}
				;
				_local_2++;
			}
			;
			return (_local_1);
		}

		private function getCandysByRowsOrCols(_arg_1:Array, _arg_2:Array):Array
		{
			var _local_4:int;
			var _local_5:int;
			var _local_6:Candy;
			var _local_3:Array = [];
			var _local_7:int;
			while (_local_7 < _arg_1.length)
			{
				_local_4 = _arg_1[_local_7];
				if (!(((_local_4 < 0)) || ((_local_4 >= GameConst.ROW_COUNT))))
				{
					_local_5 = 0;
					while (_local_5 < GameConst.COL_COUNT)
					{
						_local_6 = this.candys[_local_4][_local_5];
						if ((((!((_local_6 == null)))) && ((!(_local_6.isFruit())))))
						{
							_local_3.push(_local_6);
						}
						;
						_local_5++;
					}
					;
				}
				;
				_local_7++;
			}
			;
			_local_7 = 0;
			while (_local_7 < _arg_2.length)
			{
				_local_5 = _arg_2[_local_7];
				if (!(((_local_5 < 0)) || ((_local_5 >= GameConst.COL_COUNT))))
				{
					_local_4 = 0;
					while (_local_4 < GameConst.ROW_COUNT)
					{
						_local_6 = this.candys[_local_4][_local_5];
						if ((((!((_local_6 == null)))) && ((!(_local_6.isFruit())))))
						{
							_local_3.push(_local_6);
						}
						;
						_local_4++;
					}
					;
				}
				;
				_local_7++;
			}
			;
			return (_local_3);
		}

		private function getRelativeCandysByStatus(_arg_1:Candy):Array
		{
			if (_arg_1.status == CandySpecialStatus.HORIZ)
			{
				return (this.getCandysByRow(_arg_1.row));
			}
			;
			if (_arg_1.status == CandySpecialStatus.VERT)
			{
				return (this.getCandysByCol(_arg_1.col));
			}
			;
			if (_arg_1.status == CandySpecialStatus.BOMB)
			{
				return (this.getAroundCandys(_arg_1.row, _arg_1.col));
			}
			;
			return ([]);
		}

		private function getCandysByRow(_arg_1:int):Array
		{
			var _local_2:Array = [];
			var _local_3:int;
			while (_local_3 < GameConst.COL_COUNT)
			{
				_local_2.push(new Point(_arg_1, _local_3));
				_local_3++;
			}
			;
			return (_local_2);
		}

		private function getCandysByCol(_arg_1:int):Array
		{
			var _local_2:Array = [];
			var _local_3:int;
			while (_local_3 < GameConst.ROW_COUNT)
			{
				_local_2.push(new Point(_local_3, _arg_1));
				_local_3++;
			}
			;
			return (_local_2);
		}

		private function getAroundCandys(_arg_1:int, _arg_2:int):Array
		{
			var _local_6:int;
			var _local_7:int;
			var _local_3:Array = [[0, -1], [0, -2], [0, 1], [0, 2], [-1, 0], [-2, 0], [1, 0], [2, 0], [1, -1], [1, 1], [-1, -1], [-1, 1]];
			var _local_4:Array = [];
			var _local_5:int;
			while (_local_5 < _local_3.length)
			{
				_local_6 = (_arg_1 + _local_3[_local_5][0]);
				_local_7 = (_arg_2 + _local_3[_local_5][1]);
				if ((((((((_local_6 > 0)) && ((_local_6 < GameConst.ROW_COUNT)))) && ((_local_7 > 0)))) && ((_local_7 < GameConst.COL_COUNT))))
				{
					_local_4.push(new Point(_local_6, _local_7));
				}
				;
				_local_5++;
			}
			;
			return (_local_4);
		}

		private function getAroundCandys2(_arg_1:Candy, _arg_2:Candy):Array
		{
			var _local_4:int;
			var _local_5:int;
			var _local_6:int;
			var _local_7:int;
			var _local_8:Point;
			var _local_9:Point;
			var _local_10:Candy;
			var _local_3:Array = [];
			if (_arg_1.row == _arg_2.row)
			{
				if (_arg_1.col < _arg_2.col)
				{
					_local_8 = new Point(_arg_1.row, _arg_1.col);
					_local_9 = new Point(_arg_2.row, _arg_2.col);
				}
				else
				{
					_local_8 = new Point(_arg_2.row, _arg_2.col);
					_local_9 = new Point(_arg_1.row, _arg_1.col);
				}
				;
				_local_4 = 0;
				while (_local_4 >= -3)
				{
					_local_6 = ((_local_8.x - 3) - _local_4);
					_local_7 = ((_local_8.x + 3) + _local_4);
					_local_5 = _local_6;
					while (_local_5 <= _local_7)
					{
						if (this.isValidPos(_local_5, (_local_8.y + _local_4)))
						{
							_local_10 = this.candys[_local_5][(_local_8.y + _local_4)];
							if (_local_10 != null)
							{
								_local_3.push(_local_10);
							}
							;
						}
						;
						_local_5++;
					}
					;
					_local_4--;
				}
				;
				_local_4 = 0;
				while (_local_4 <= 3)
				{
					_local_6 = ((_local_9.x - 3) + _local_4);
					_local_7 = ((_local_9.x + 3) - _local_4);
					_local_5 = _local_6;
					while (_local_5 <= _local_7)
					{
						if (this.isValidPos(_local_5, (_local_9.y + _local_4)))
						{
							_local_10 = this.candys[_local_5][(_local_9.y + _local_4)];
							if (_local_10 != null)
							{
								_local_3.push(_local_10);
							}
							;
						}
						;
						_local_5++;
					}
					;
					_local_4++;
				}
				;
			}
			else
			{
				if (_arg_1.col == _arg_2.col)
				{
					if (_arg_1.row < _arg_2.row)
					{
						_local_8 = new Point(_arg_1.row, _arg_1.col);
						_local_9 = new Point(_arg_2.row, _arg_2.col);
					}
					else
					{
						_local_8 = new Point(_arg_2.row, _arg_2.col);
						_local_9 = new Point(_arg_1.row, _arg_1.col);
					}
					;
					_local_4 = 0;
					while (_local_4 >= -3)
					{
						_local_6 = ((_local_8.y - 3) - _local_4);
						_local_7 = ((_local_8.y + 3) + _local_4);
						_local_5 = _local_6;
						while (_local_5 <= _local_7)
						{
							if (this.isValidPos((_local_8.x + _local_4), _local_5))
							{
								_local_10 = this.candys[(_local_8.x + _local_4)][_local_5];
								if (_local_10 != null)
								{
									_local_3.push(_local_10);
								}
								;
							}
							;
							_local_5++;
						}
						;
						_local_4--;
					}
					;
					_local_4 = 0;
					while (_local_4 <= 3)
					{
						_local_6 = ((_local_9.y - 3) + _local_4);
						_local_7 = ((_local_9.y + 3) - _local_4);
						_local_5 = _local_6;
						while (_local_5 <= _local_7)
						{
							if (this.isValidPos((_local_9.x + _local_4), _local_5))
							{
								_local_10 = this.candys[(_local_9.x + _local_4)][_local_5];
								if (_local_10 != null)
								{
									_local_3.push(_local_10);
								}
								;
							}
							;
							_local_5++;
						}
						;
						_local_4++;
					}
					;
				}
				;
			}
			;
			return (_local_3);
		}

		private function isValidPos(_arg_1:int, _arg_2:int):Boolean
		{
			if ((((((((_arg_1 >= 0)) && ((_arg_1 < GameConst.ROW_COUNT)))) && ((_arg_2 >= 0)))) && ((_arg_2 < GameConst.COL_COUNT))))
			{
				return (true);
			}
			;
			return (false);
		}

		private function getAllCandys():Array
		{
			var _local_3:int;
			var _local_1:Array = [];
			var _local_2:int;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					if (this.candys[_local_2][_local_3] != null)
					{
						_local_1.push(this.candys[_local_2][_local_3]);
					}
					;
					_local_3++;
				}
				;
				_local_2++;
			}
			;
			return (_local_1);
		}

		private function getAllCandysNoBlock():Array
		{
			var _local_3:int;
			var _local_1:Array = [];
			var _local_2:int;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					if ((((!((this.candys[_local_2][_local_3] == null)))) && ((!(this.checkIsBlock(_local_2, _local_3))))))
					{
						_local_1.push(this.candys[_local_2][_local_3]);
					}
					;
					_local_3++;
				}
				;
				_local_2++;
			}
			;
			return (_local_1);
		}

		private function getFruits():Array
		{
			var _local_3:int;
			var _local_4:Candy;
			var _local_1:Array = [];
			var _local_2:int;
			while (_local_2 < GameConst.ROW_COUNT)
			{
				_local_3 = 0;
				while (_local_3 < GameConst.COL_COUNT)
				{
					_local_4 = this.candys[_local_2][_local_3];
					if ((((!((_local_4 == null)))) && (_local_4.isFruit())))
					{
						if (_local_4.color == ColorType.FRUIT1)
						{
							_local_1.push(AimType.FRUIT1);
						}
						else
						{
							if (_local_4.color == ColorType.FRUIT2)
							{
								_local_1.push(AimType.FRUIT2);
							}
							else
							{
								if (_local_4.color == ColorType.FRUIT3)
								{
									_local_1.push(AimType.FRUIT3);
								}
								;
							}
							;
						}
						;
					}
					;
					_local_3++;
				}
				;
				_local_2++;
			}
			;
			return (_local_1);
		}

		private function checkNeedDropFruit():void
		{
			var _local_1:Array = this.getFruits();
			var _local_2:Array = Model.gameModel.getLeftFruitAim(_local_1);
			if (_local_2.length > 0)
			{
				this.addFruitIndex++;
				if (this.addFruitIndex == 1)
				{
					this.nextFruitId = _local_2[int((Math.random() * _local_2.length))];
				}
				else
				{
					if (_local_1.length == 0)
					{
						this.nextFruitId = _local_2[int((Math.random() * _local_2.length))];
					}
					else
					{
						if (this.addFruitIndex >= 10)
						{
							this.addFruitIndex = 0;
						}
						;
					}
					;
				}
				;
			}
			;
		}

		private function getEatAndAroundCandys():Array
		{
			var _local_2:Eat;
			var _local_5:int;
			var _local_1:Array = [];
			var _local_3:int;
			while (_local_3 < GameConst.ROW_COUNT)
			{
				_local_5 = 0;
				while (_local_5 < GameConst.COL_COUNT)
				{
					_local_2 = this.eats[_local_3][_local_5];
					if (_local_2 != null)
					{
						_local_1.push(_local_2);
					}
					;
					_local_5++;
				}
				;
				_local_3++;
			}
			;
			var _local_4:Array = [];
			for each (_local_2 in _local_1)
			{
				if (((((this.isValidPos((_local_2.row - 1), _local_2.col)) && ((!((this.candys[(_local_2.row - 1)][_local_2.col] == null)))))) && ((!(this.checkIsBlock((_local_2.row - 1), _local_2.col))))))
				{
					_local_4.push({"eat": _local_2, "pos": new Point((_local_2.row - 1), _local_2.col)});
				}
				;
				if (((((this.isValidPos((_local_2.row + 1), _local_2.col)) && ((!((this.candys[(_local_2.row + 1)][_local_2.col] == null)))))) && ((!(this.checkIsBlock((_local_2.row + 1), _local_2.col))))))
				{
					_local_4.push({"eat": _local_2, "pos": new Point((_local_2.row + 1), _local_2.col)});
				}
				;
				if (((((this.isValidPos(_local_2.row, (_local_2.col - 1))) && ((!((this.candys[_local_2.row][(_local_2.col - 1)] == null)))))) && ((!(this.checkIsBlock(_local_2.row, (_local_2.col - 1)))))))
				{
					_local_4.push({"eat": _local_2, "pos": new Point(_local_2.row, (_local_2.col - 1))});
				}
				;
				if (((((this.isValidPos(_local_2.row, (_local_2.col + 1))) && ((!((this.candys[_local_2.row][(_local_2.col + 1)] == null)))))) && ((!(this.checkIsBlock(_local_2.row, (_local_2.col + 1)))))))
				{
					_local_4.push({"eat": _local_2, "pos": new Point(_local_2.row, (_local_2.col + 1))});
				}
				;
			}
			;
			return (_local_4);
		}

		private function getMonsterAndAroundCandys():Array
		{
			var _local_2:Monster;
			var _local_5:int;
			var _local_1:Array = [];
			var _local_3:int;
			while (_local_3 < GameConst.ROW_COUNT)
			{
				_local_5 = 0;
				while (_local_5 < GameConst.COL_COUNT)
				{
					_local_2 = this.monsters[_local_3][_local_5];
					if (_local_2 != null)
					{
						_local_1.push(_local_2);
					}
					;
					_local_5++;
				}
				;
				_local_3++;
			}
			;
			var _local_4:Array = [];
			for each (_local_2 in _local_1)
			{
				if (((((((this.isValidPos((_local_2.row - 1), _local_2.col)) && ((!((this.candys[(_local_2.row - 1)][_local_2.col] == null)))))) && ((this.monsters[(_local_2.row - 1)][_local_2.col] == null)))) && ((!(this.checkHasMonsterByPos(_local_4, new Point((_local_2.row - 1), _local_2.col)))))))
				{
					_local_4.push({"monster": _local_2, "pos": new Point((_local_2.row - 1), _local_2.col)});
				}
				;
				if (((((((this.isValidPos((_local_2.row + 1), _local_2.col)) && ((!((this.candys[(_local_2.row + 1)][_local_2.col] == null)))))) && ((this.monsters[(_local_2.row + 1)][_local_2.col] == null)))) && ((!(this.checkHasMonsterByPos(_local_4, new Point((_local_2.row + 1), _local_2.col)))))))
				{
					_local_4.push({"monster": _local_2, "pos": new Point((_local_2.row + 1), _local_2.col)});
				}
				;
				if (((((((this.isValidPos(_local_2.row, (_local_2.col - 1))) && ((!((this.candys[_local_2.row][(_local_2.col - 1)] == null)))))) && ((this.monsters[_local_2.row][(_local_2.col - 1)] == null)))) && ((!(this.checkHasMonsterByPos(_local_4, new Point(_local_2.row, (_local_2.col - 1))))))))
				{
					_local_4.push({"monster": _local_2, "pos": new Point(_local_2.row, (_local_2.col - 1))});
				}
				;
				if (((((((this.isValidPos(_local_2.row, (_local_2.col + 1))) && ((!((this.candys[_local_2.row][(_local_2.col + 1)] == null)))))) && ((this.monsters[_local_2.row][(_local_2.col + 1)] == null)))) && ((!(this.checkHasMonsterByPos(_local_4, new Point(_local_2.row, (_local_2.col + 1))))))))
				{
					_local_4.push({"monster": _local_2, "pos": new Point(_local_2.row, (_local_2.col + 1))});
				}
				;
			}
			;
			return (_local_4);
		}

		private function checkHasMonsterByPos(_arg_1:Array, _arg_2:Point):Boolean
		{
			var _local_3:Object;
			for each (_local_3 in _arg_1)
			{
				if ((((_local_3.pos.x == _arg_2.x)) && ((_local_3.pos.y == _arg_2.y))))
				{
					return (true);
				}
				;
			}
			;
			return (false);
		}

		private function shuffle(_arg_1:Boolean = false):void
		{
			var _local_5:int;
			var _local_6:int;
			var _local_7:int;
			var _local_8:Candy;
			var _local_9:Candy;
			var _local_10:int;
			var _local_11:int;
			var _local_12:int;
			var _local_13:Candy;
			var _local_14:Point;
			Debug.log("洗牌");
			var _local_2:Array = this.getAllCandysNoBlock();
			var _local_3:int;
			while (true)
			{
				_local_5 = 0;
				while (_local_5 < 20)
				{
					_local_6 = int((Math.random() * _local_2.length));
					_local_7 = int((Math.random() * _local_2.length));
					if (_local_6 != _local_7)
					{
						_local_8 = _local_2[_local_6];
						_local_9 = _local_2[_local_7];
						_local_10 = _local_8.row;
						_local_8.row = _local_9.row;
						_local_9.row = _local_10;
						_local_11 = _local_8.col;
						_local_8.col = _local_9.col;
						_local_9.col = _local_11;
						this.candys[_local_8.row][_local_8.col] = _local_8;
						this.candys[_local_9.row][_local_9.col] = _local_9;
					}
					;
					_local_5++;
				}
				;
				_local_3 = (_local_3 + 1);
				if (_local_3 > 1000)
					break;
				if ((((!(this.checkHasMatches()))) && ((this.checkConnectable().length > 0))))
					break;
			}
			;
			Debug.log(("洗牌次数:" + _local_3));
			var _local_4:int;
			while (_local_4 < GameConst.ROW_COUNT)
			{
				_local_12 = 0;
				while (_local_12 < GameConst.COL_COUNT)
				{
					_local_13 = this.candys[_local_4][_local_12];
					if (_local_13 != null)
					{
						if (_arg_1)
						{
							this.moveToRightPos(_local_13);
						}
						else
						{
							_local_14 = this.getCandyPosition(_local_4, _local_12);
							_local_13.x = _local_14.x;
							_local_13.y = _local_14.y;
						}
						;
					}
					;
					_local_12++;
				}
				;
				_local_4++;
			}
			;
		}

		private function moveToRightPos(_arg_1:Candy, _arg_2:Function = null):void
		{
			var _local_3:Point = this.getCandyPosition(_arg_1.row, _arg_1.col);
			var _local_4:Number = Math.abs((_local_3.y - _arg_1.y));
			var _local_5:Number = Math.abs((_local_3.x - _arg_1.x));
			var _local_6:Number = Math.sqrt(((_local_5 * _local_5) + (_local_4 * _local_4)));
			var _local_7:Number = ((_local_6 / GameConst.CARD_W) * 0.1);
			Tweener.addTween(_arg_1, {"x": _local_3.x, "y": _local_3.y, "time": _local_7, "transition": "linear", "delay": 0.5});
		}

		private function handleVictory():void
		{
			var _local_2:int;
			Core.timerManager.remove(this, this.onTimer);
			var _local_1:Array = this.getSpecialCandys();
			if (_local_1.length > 0)
			{
				this.queueToBouns();
			}
			else
			{
				_local_2 = 0;
				if (this.currentLevel.mode == GameMode.NORMAL)
				{
					_local_2 = Model.gameModel.step;
				}
				else
				{
					if (this.currentLevel.mode == GameMode.TIME)
					{
						_local_2 = (Model.gameModel.time / 5);
					}
					;
				}
				;
				if (_local_2 > 0)
				{
					this.doBounsTimeEffect();
				}
				else
				{
					Debug.log("弹出胜利结算面板");
					Model.gameModel.isSuccess = true;
					MsgDispatcher.execute(GameEvents.OPEN_GAME_END_UI);
				}
			}
		}

		private function handleFailed():void
		{
			Debug.log("弹出失败结算面板");
			Model.gameModel.isSuccess = false;
			MsgDispatcher.execute(GameEvents.OPEN_GAME_END_UI);
		}

		private function queueToBouns():void
		{
			Tweener.addCaller(this, {"time": 0.2, "count": 1, "onComplete": function():void
			{
				var _local_2:*;
				var _local_3:*;
				var _local_4:*;
				var _local_5:*;
				var _local_6:*;
				var _local_7:*;
				var _local_1:* = getSpecialCandys();
				if (_local_1.length > 0)
				{
					_local_2 = int((Math.random() * _local_1.length));
					_local_3 = _local_1[_local_2];
					if (_local_3.status == CandySpecialStatus.COLORFUL)
					{
						_local_4 = getNormalCandys();
						_local_5 = int((Math.random() * _local_4.length));
						_local_6 = _local_4[_local_5].color;
						_local_7 = getCandysByColorType(_local_6);
						_local_7.push(_local_3);
						removeCandys(_local_7);
					}
					else
					{
						removeCandys([_local_3]);
					}
					;
					gameState = STATE_GAME_WAIT_DROP;
				}
				;
			}});
		}

		private function doBounsTimeEffect():void
		{
			var bonusTip:BonusTimeTip = BonusTimeTip.pool.take();
			this.addChild(bonusTip);
			bonusTip.doAniamtion();
			setTimeout(function():void
			{
				var step:int;
				var candys:Array;
				var animationCount:int;
				var i:int;
				var rnd:int;
				var candy:Candy;
				var disX:Number;
				var disY:Number;
				var dis:Number;
				var radian:Number;
				var laserEffect:LaserEffect;
				step = 0;
				if (currentLevel.mode == GameMode.NORMAL)
				{
					step = Model.gameModel.step;
				}
				else
				{
					if (currentLevel.mode == GameMode.TIME)
					{
						step = (Model.gameModel.time / 5);
					}
					;
				}
				;
				if (step > 0)
				{
					candys = getNormalCandys();
					if (candys.length > 0)
					{
						animationCount = 0;
						i = 0;
						while (i < step)
						{
							rnd = (Math.random() * candys.length);
							candy = candys[rnd];
							disX = (candy.x - 100);
							disY = (candy.y - 20);
							dis = Math.sqrt(((disX * disX) + (disY * disY)));
							radian = Math.atan2(disY, disX);
							laserEffect = LaserEffect.pool.take();
							laserEffect.x = 100;
							laserEffect.y = 20;
							laserEffect.setData(radian);
							addChild(laserEffect);
							Tweener.addTween(laserEffect, {"time": (dis / 600), "x": candy.x, "y": candy.y, "onCompleteParams": [candy, laserEffect], "transition": "linear", "onComplete": function(_arg_1:Candy, _arg_2:LaserEffect):void
							{
								_arg_2.removeFromParent();
								LaserEffect.pool.put(_arg_2);
								var _local_3:* = ((Math.random() * 3) + 1);
								_arg_1.setSpecialStatus(_local_3, true);
								candys.splice(rnd, 1);
								animationCount++;
								if (animationCount == step)
								{
									Model.gameModel.time = 0;
									Model.gameModel.step = 0;
									queueToBouns();
								}
								;
							}});
							i = (i + 1);
						}
						;
					}
					;
				}
				;
			}, 1200);
		}

		private function addScoreTip(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):void
		{
//            var _local_5:ScoreTip = (ScoreTip.pool.take() as ScoreTip);
//            _local_5.x = _arg_1;
//            _local_5.y = _arg_2;
//            _local_5.setData(_arg_3, _arg_4);
//            this.addChild(_local_5);
		}

		private function addGoodTip(_arg_1:int):void
		{
			var _local_2:GoodTip = GoodTip.pool.take();
			_local_2.x = (Core.stage3DManager.canvasWidth >> 1);
			_local_2.y = ((Core.stage3DManager.canvasHeight >> 1) + 40);
			_local_2.setType(_arg_1);
			this.addChild(_local_2);
		}

		private function addEffect(_arg_1:int, _arg_2:int, _arg_3:int):void
		{
			var _local_4:BombNormalEffect;
			var _local_5:LineBombEffect;
			var _local_6:LineBombEffect;
			var _local_7:BombEffect;
			if (_arg_1 == 0)
			{
				_local_4 = BombNormalEffect.pool.take();
				_local_4.x = _arg_2;
				_local_4.y = _arg_3;
				_local_4.play();
				this.addChild(_local_4);
			}
			else
			{
				if (_arg_1 == 1)
				{
					_local_5 = LineBombEffect.pool.take();
					_local_5.x = _arg_2;
					_local_5.y = _arg_3;
					_local_5.play(1);
					addChild(_local_5);
				}
				else
				{
					if (_arg_1 == 2)
					{
						_local_6 = LineBombEffect.pool.take();
						_local_6.x = _arg_2;
						_local_6.y = _arg_3;
						_local_6.play(2);
						addChild(_local_6);
					}
					else
					{
						if (_arg_1 == 3)
						{
							_local_7 = BombEffect.pool.take();
							_local_7.x = _arg_2;
							_local_7.y = _arg_3;
							_local_7.play();
							this.addChild(_local_7);
						}
						else
						{
							if (_arg_1 == 4)
							{
							}
							;
						}
						;
					}
					;
				}
				;
			}
			;
		}

		private function removeAll():void
		{
			var _local_1:int;
			var _local_2:int;
			var _local_3:int;
			var _local_4:TileBoarder;
			this.removeEventListener(EnterFrameEvent.ENTER_FRAME, this.update);
			Core.timerManager.remove(this, this.onTimer);
			this.removeAllElements(this.candys, Candy.pool);
			this.removeAllElements(this.tileBgs, TileBg.pool);
			this.removeAllElements(this.bricks, Brick.pool);
			this.removeAllElements(this.locks, Lock.pool);
			this.removeAllElements(this.eats, Eat.pool);
			this.removeAllElements(this.ices, Ice.pool);
			this.removeAllElements(this.monsters, Monster.pool);
			this.removeAllElements(this.tDoors, TransportDoor.pool);
			this.removeAllElements(this.ironWires, IronWire.pool);
			_local_3 = (this.tileBoarders.length - 1);
			while (_local_3 >= 0)
			{
				_local_4 = this.tileBoarders[_local_3];
				TileBoarder.pool.put(_local_4);
				_local_4.removeFromParent();
				this.tileBoarders.splice(_local_3, 1);
				_local_3--;
			}
			;
			Model.gameModel.reset();
		}

		private function removeAllElements(_arg_1:Array, _arg_2:BasePool):void
		{
			var _local_4:int;
			var _local_5:Element;
			var _local_3:int;
			while (_local_3 < GameConst.ROW_COUNT)
			{
				_local_4 = 0;
				while (_local_4 < GameConst.COL_COUNT)
				{
					_local_5 = _arg_1[_local_3][_local_4];
					if (_local_5 != null)
					{
						_local_5.reset();
						_arg_2.put(_local_5);
						_local_5.removeFromParent();
						_arg_1[_local_3][_local_4] = null;
					}
					;
					_local_4++;
				}
				;
				_local_3++;
			}
			;
		}

		override public function destory():void
		{
			this.removeAll();
			super.destory();
		}

	}
} //package com.popchan.sugar.modules.game.view
