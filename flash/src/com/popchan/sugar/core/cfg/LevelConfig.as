//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.core.cfg
{
	import com.popchan.framework.core.Core;
	import com.popchan.framework.ds.Dict;
	import com.popchan.framework.manager.Debug;
	import com.popchan.sugar.core.cfg.levels.LevelCO;
	import com.popchan.sugar.core.data.AimType;
	import com.popchan.sugar.core.data.GameConst;

	import zzsdk.utils.FileUtil;

	public class LevelConfig implements IJsonConfig
	{

		public static const TOTAL_LEVEL:int = 330;

		private var dict:Dict;

		public function LevelConfig()
		{
			this.dict = new Dict();
			super();
		}

		public function setUp(_arg_1:Object):void
		{
		}

		public function getLevel(_arg_1:int):LevelCO
		{
			var _local_2:LevelCO;
			var _local_4:int;
			var _local_5:String;
			var _local_6:int;
			var _local_7:int;
			var _local_8:int;
			if (this.dict.contains(_arg_1))
			{
				return (this.dict.take(_arg_1));
			}
			;
			var _local_3:XML = XML(FileUtil.readFile("assets/level/Level" + _arg_1 + ".xml", "text"));
			if (_local_3 != null)
			{
				_local_2 = new LevelCO();
				_local_2.tile = this.convertToArray(String(_local_3.tile));
				_local_2.board = this.convertToArray(String(_local_3.board));
				_local_2.ice = this.convertToArray(String(_local_3.ice));
				_local_2.stone = this.convertToArray(String(_local_3.stone));
				_local_2.candy = this.convertToArray(String(_local_3.candy));
				_local_2.barrier = this.convertToArray(String(_local_3.barrier));
				if (_local_3.hasOwnProperty("colorCount"))
				{
					_local_2.colorCount = int(_local_3.colorCount);
				}
				else
				{
					_local_2.colorCount = 5;
				}
				;
				if (_local_2.colorCount < 3)
				{
					_local_2.colorCount = 3;
				}
				else
				{
					if (_local_2.colorCount > 5)
					{
						_local_2.colorCount = 5;
					}
					;
				}
				;
				if (_local_3.hasOwnProperty("ironWire"))
				{
					_local_2.ironWire = this.convertToArray(String(_local_3.ironWire));
				}
				else
				{
					_local_2.ironWire = this.getBlankArray();
				}
				;
				if (_local_3.hasOwnProperty("eat"))
				{
					_local_2.eat = this.convertToArray(String(_local_3.eat));
				}
				else
				{
					_local_2.eat = this.getBlankArray();
				}
				;
				if (_local_3.hasOwnProperty("monster"))
				{
					_local_2.monster = this.convertToArray(String(_local_3.monster));
				}
				else
				{
					_local_2.monster = this.getBlankArray();
				}
				;
				_local_2.lock = this.convertToArray(String(_local_3.lock));
				_local_2.entryAndExit = this.convertToArray(String(_local_3.entryAndExit));
				_local_2.aim = String(_local_3.aim).split("|");
				_local_2.mode = _local_3.mode;
				_local_2.step = _local_3.step;
				_local_2.needScore = 0;
				_local_4 = 0;
				while (_local_4 < GameConst.COL_COUNT)
				{
					_local_6 = 0;
					while (_local_6 < GameConst.ROW_COUNT)
					{
						if (_local_2.tile[_local_6][_local_4] > 0)
						{
							_local_2.needScore = (_local_2.needScore + 50);
						}
						;
						_local_6++;
					}
					;
					_local_4++;
				}
				;
				for each (_local_5 in _local_2.aim)
				{
					_local_7 = int(_local_5.split(",")[0]);
					_local_8 = int(_local_5.split(",")[1]);
					if (_local_7 != AimType.SCORE)
					{
						_local_2.needScore = (_local_2.needScore + (_local_8 * 50));
					}
					;
				}
				;
				this.dict.put(_arg_1, _local_2);
			}
			else
			{
				Debug.log(("未找到关卡-" + _arg_1));
			}
			;
			return (_local_2);
		}

		private function convertToArray(_arg_1:String, _arg_2:String = "|", _arg_3:String = ","):Array
		{
			var _local_7:String;
			var _local_8:Array;
			var _local_9:int;
			var _local_4:Array = [];
			var _local_5:Array = _arg_1.split(_arg_2);
			var _local_6:int;
			while (_local_6 < _local_5.length)
			{
				_local_7 = _local_5[_local_6];
				_local_8 = _local_7.split(_arg_3);
				_local_4[_local_6] = [];
				_local_9 = 0;
				while (_local_9 < _local_8.length)
				{
					_local_4[_local_6][_local_9] = int(_local_8[_local_9]);
					_local_9++;
				}
				;
				_local_6++;
			}
			;
			return (_local_4);
		}

		private function getBlankArray():Array
		{
			var _local_3:int;
			var _local_1:Array = [];
			var _local_2:int;
			while (_local_2 < 9)
			{
				_local_1[_local_2] = [];
				_local_3 = 0;
				while (_local_3 < 9)
				{
					_local_1[_local_2][_local_3] = 0;
					_local_3++;
				}
				;
				_local_2++;
			}
			;
			return (_local_1);
		}

	}
} //package com.popchan.sugar.core.cfg
