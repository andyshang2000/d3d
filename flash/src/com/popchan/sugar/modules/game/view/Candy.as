//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game.view
{
	import com.popchan.framework.ds.BasePool;
	import starling.display.Image;
	import starling.display.TextSprite;
	import com.popchan.sugar.core.data.ColorType;
	import com.popchan.sugar.core.data.CandySpecialStatus;
	import com.popchan.framework.core.Core;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import caurina.transitions.Tweener;
	import starling.textures.Texture;
	import com.popchan.framework.manager.SoundManager;
	import com.popchan.framework.manager.Debug;
	import com.popchan.framework.utils.ToolKit;
	import com.popchan.sugar.core.Model;
	import com.popchan.framework.core.MsgDispatcher;
	import com.popchan.sugar.core.events.GameEvents;

	public class Candy extends Element
	{

		public static var pool:BasePool = new BasePool(Candy, 81);

		public var row:int;
		public var col:int;
		private var _color:int;
		private var _status:int;
		private var img:Image;
		public var mark:Boolean = false;
		public var remove:Boolean = false;
		private var _bombLeftCount:int = 0;
		public var path:Array;
		private var queue:Array;
		private var bomb_txt:TextSprite;
		private var r:Number = 0;
		private var rspeed:Number = 0.2;
		private var _isShake:Boolean;
		private var _nextStatus:int;

		public function Candy()
		{
			this.path = [];
			this.queue = [];
			super();
		}

		public function get isShake():Boolean
		{
			return (this._isShake);
		}

		public function isFruit():Boolean
		{
			if ((((((this._color == ColorType.FRUIT1)) || ((this._color == ColorType.FRUIT2)))) || ((this._color == ColorType.FRUIT3))))
			{
				return (true);
			}
			return (false);
		}

		public function get color():int
		{
			if (this.status == CandySpecialStatus.COLORFUL)
			{
				return (0);
			}
			;
			return (this._color);
		}

		public function set color(_arg_1:int):void
		{
			this._color = _arg_1;
			if (this.img != null)
			{
				this.img.removeFromParent(true);
				this.img.dispose();
				this.img = null;
			}
			;
			var _local_2:String = ("candy" + (this.color - 1));
			if (this.color == 7)
			{
				_local_2 = "fruit1";
			}
			else if (this.color == 8)
			{
				_local_2 = "fruit2";
			}
			else if (this.color == 9)
			{
				_local_2 = "fruit3";

			}
			this.img = new Image(Core.getTexture(_local_2));
			this.img.pivotX = (this.img.width >> 1);
			this.img.pivotY = (this.img.height >> 1);
			this.addChild(this.img);
		}

		public function collidePoint(_arg_1:Point):Boolean
		{
			var _local_2:Rectangle = new Rectangle((-32 + this.x), (-32 + this.y), 64, 64);
			if (_local_2.containsPoint(_arg_1))
			{
				return (true);
			}
			return (false);
		}

		public function get status():int
		{
			return (this._status);
		}

		public function runMoveAction(_arg_1:Object):void
		{
			Tweener.addTween(this, _arg_1);
		}

		public function addPath(_arg_1:Object):void
		{
			this.path.push(_arg_1);
			if ((_arg_1 is Point))
			{
			}
			;
		}

		public function stopAllActions():void
		{
			this.img.scaleX = (this.img.scaleY = 1);
			Tweener.removeTweens(this.img);
			Tweener.removeTweens(this);
		}

		public function runAsPath():void
		{
			var _local_2:Object;
			var _local_6:Object;
			var _local_7:Object;
			this.stopAllActions();
			this.queue = [];
			var _local_1:Object = this.path[0];
			if (_local_1.type == 1)
			{
				_local_2 = this.getCandyMoveAction(new Point(x, y), _local_1.pos);
			}
			else
			{
				if (_local_1.type == 2)
				{
					_local_2 = this.setCandMoveAction(_local_1.pos);
				}
				;
			}
			;
			this.queue.push(_local_2);
			var _local_3:int = 1;
			while (_local_3 < this.path.length)
			{
				_local_6 = this.path[_local_3];
				if (_local_6.type == 1)
				{
					_local_7 = this.getCandyMoveAction(this.path[(_local_3 - 1)].pos, this.path[_local_3].pos);
				}
				else
				{
					if (_local_6.type == 2)
					{
						_local_7 = this.setCandMoveAction(this.path[_local_3].pos);
					}
					;
				}
				;
				this.queue.push(_local_7);
				_local_3++;
			}
			;
			var _local_4:Object = {"time": 0.1, "y": (this.path[(_local_3 - 1)].pos.y - 3), "transition": "easeOutSine"};
			var _local_5:Object = {"time": 0.1, "y": (this.path[(_local_3 - 1)].pos.y + 3), "transition": "easeOutSine"};
			this.queue.push(_local_4);
			this.queue.push(_local_5);
			this.path = [];
			this.runMoveQueueAction();
		}

		private function runMoveQueueAction():void
		{
			var param:Object;
			if (this.queue.length > 0)
			{
				param = this.queue.shift();
				param.onComplete = function():void
				{
					runMoveQueueAction();
				};
				Tweener.addTween(this, param);
			}
			;
		}

		private function getCandyMoveAction(_arg_1:Point, _arg_2:Point):Object
		{
			var _local_3:int = Math.abs((_arg_2.y - _arg_1.y));
			var _local_4:int = Math.abs((_arg_2.x - _arg_1.x));
			var _local_5:int = Math.sqrt(((_local_4 * _local_4) + (_local_3 * _local_3)));
			var _local_6:Number = (_local_5 * 0.001);
			var _local_7:Object = {"x": _arg_2.x, "y": _arg_2.y, "time": _local_6, "transition": "linear"};
			return (_local_7);
		}

		private function setCandMoveAction(_arg_1:Point):Object
		{
			return ({"x": _arg_1.x, "y": _arg_1.y, "time": 1E-7, "transition": "linear"});
		}

		public function setSpecialStatus(_arg_1:int, _arg_2:Boolean = false, _arg_3:Boolean = false):void
		{
			if (this.img != null)
			{
				this.img.removeFromParent(true);
				this.img.dispose();
				this.img = null;
			}
			;
			this.img = new Image(Texture.fromTexture(Core.getTexture(("candy" + (this.color - 1)))));
			this._status = _arg_1;
			if (_arg_1 == CandySpecialStatus.HORIZ)
			{
				this.img = new Image(Texture.fromTexture(Core.getTexture((("candy" + (this.color - 1)) + "a"))));
			}
			else
			{
				if (_arg_1 == CandySpecialStatus.VERT)
				{
					this.img = new Image(Texture.fromTexture(Core.getTexture((("candy" + (this.color - 1)) + "b"))));
				}
				else
				{
					if (_arg_1 == CandySpecialStatus.BOMB)
					{
						this.img = new Image(Texture.fromTexture(Core.getTexture(("candybomb" + (this.color - 1)))));
					}
					else
					{
						if (_arg_1 == CandySpecialStatus.COLORFUL)
						{
							this.img = new Image(Texture.fromTexture(Core.getTexture("candyking")));
						}
						;
					}
					;
				}
				;
			}
			;
			this.img.pivotX = (this.img.width >> 1);
			this.img.pivotY = (this.img.height >> 1);
			this.addChild(this.img);
			this.img.scaleX = (this.img.scaleY = 1);
			if (_arg_2)
			{
				this.img.scaleX = (this.img.scaleY = 0);
				Tweener.addTween(this.img, {"time": 0.25, "scaleX": 1, "scaleY": 1});
				SoundManager.instance.playSound("candyspgrow1", false, 0, 1, 1, true);
			}
			;
			if (_arg_1 == 4)
			{
				this._color = 0;
			}
			;
		}

		public function setBomb(_arg_1:int):void
		{
			if (this.img != null)
			{
				this.img.removeFromParent(true);
				this.img.dispose();
				this.img = null;
			}
			;
			this.img = new Image(Texture.fromTexture(Core.getTexture(("candytimer" + (this.color - 1)))));
			this.img.pivotX = (this.img.width >> 1);
			this.img.pivotY = (this.img.height >> 1);
			this.addChild(this.img);
			this._bombLeftCount = _arg_1;
			Debug.log(("炸弹步数:" + _arg_1));
			if (!this.bomb_txt)
			{
				this.bomb_txt = ToolKit.createTextSprite(this, Core.getTextures("bombtxt_"), -22, 0, 8, "0123456789", 24);
			}
			;
			addChild(this.bomb_txt);
			this.bomb_txt.text = (_arg_1 + "");
		}

		public function isBomb():Boolean
		{
			return ((this._bombLeftCount > 0));
		}

		public function bombCountUpdate():void
		{
			this._bombLeftCount--;
			if (this._bombLeftCount <= 0)
			{
				this._bombLeftCount = 0;
				Model.gameModel.isSuccess = false;
				MsgDispatcher.execute(GameEvents.OPEN_GAME_END_UI);
			}
			this.bomb_txt.text = (this._bombLeftCount + "");
		}

		public function getBombCount():int
		{
			return (this._bombLeftCount);
		}

		override public function reset():void
		{
			Tweener.removeTweens(this);
			this.stopShake();
			this._bombLeftCount = 0;
			this._status = 0;
			this.mark = false;
			this.remove = false;
			this.scaleX = (this.scaleY = 1);
			if (this.img != null)
			{
				this.img.scaleX = (this.img.scaleY = 1);
			}
			;
		}

		public function shake():void
		{
			Tweener.removeTweens(this.img);
			this._isShake = true;
			Tweener.addTween(this.img, {"time": 100, "transition": "linear", "onUpdate": function():void
			{
				var _local_1:* = (Math.sin(r) * 10);
				r = (r + rspeed);
				img.rotation = ((Math.PI * _local_1) / 180);
			}, "onComplete": function():void
			{
				stopShake();
			}});
		}

		public function stopShake():void
		{
			this._isShake = false;
			if (this.img)
			{
				Tweener.removeTweens(this.img);
				this.img.rotation = 0;
			}
			;
			this.r = 0;
		}

		public function setNextStatus(_arg_1:int):void
		{
			this._nextStatus = _arg_1;
		}

		public function getNextStatus():int
		{
			return (this._nextStatus);
		}

	}
} //package com.popchan.sugar.modules.game.view
