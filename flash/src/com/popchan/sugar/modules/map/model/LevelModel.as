//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.map.model
{
	import com.popchan.sugar.modules.map.vo.LevelVO;
	import com.popchan.framework.utils.DataUtil;
	import com.popchan.framework.utils.Base64;

	public class LevelModel
	{
		public var currentLevel:int = 105;
		public var selectedLevel:int = 105;
		private var levelsMap:Object;
		public var totalLevel:int = 330;

		public function LevelModel()
		{
			this.levelsMap = {};
			super();
		}

		public function getLevelVO(_arg_1:int):LevelVO
		{
			var _local_2:LevelVO;
			if (this.levelsMap[_arg_1] == null)
			{
				_local_2 = new LevelVO();
				_local_2.id = _arg_1;
				_local_2.star = 0;
				_local_2.highscore = 0;
				this.levelsMap[_local_2.id] = _local_2;
			}
			;
			return (this.levelsMap[_arg_1]);
		}

		public function loadData():void
		{
			var _local_2:Array;
			var _local_3:int;
			var _local_4:String;
			var _local_5:Array;
			var _local_6:LevelVO;
			var _local_1:String = DataUtil.readString("levels", "");
			_local_1 = Base64.decode(_local_1);
			if (_local_1.length > 0)
			{
				_local_2 = _local_1.split("|");
				_local_3 = 0;
				while (_local_3 < _local_2.length)
				{
					_local_4 = _local_2[_local_3];
					_local_5 = _local_4.split("&");
					_local_6 = new LevelVO();
					_local_6.id = int(_local_5[0]);
					_local_6.star = int(_local_5[1]);
					_local_6.highscore = int(_local_5[2]);
					this.levelsMap[_local_6.id] = _local_6;
					_local_3++;
				}
				;
			}
			;
			this.currentLevel = DataUtil.readInt("currentLevel", 1);
		}

		public function getTotalScore():Number
		{
			var _local_2:LevelVO;
			var _local_1:Number = 0;
			for each (_local_2 in this.levelsMap)
			{
				_local_1 = (_local_1 + _local_2.highscore);
			}
			;
			return (_local_1);
		}

		public function saveData():void
		{
			var _local_2:LevelVO;
			var _local_3:String;
			DataUtil.writeInt("currentLevel", this.currentLevel);
			var _local_1:Array = [];
			for each (_local_2 in this.levelsMap)
			{
				_local_1.push(((((_local_2.id + "&") + _local_2.star) + "&") + _local_2.highscore));
			}
			;
			_local_3 = _local_1.join("|");
			_local_3 = Base64.encode(_local_3);
			DataUtil.writeString("levels", _local_3);
			DataUtil.save(DataUtil.id);
		}

	}
} //package com.popchan.sugar.modules.map.model
