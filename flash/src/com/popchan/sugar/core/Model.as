//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.core
{
	import com.popchan.framework.utils.DataUtil;
	import com.popchan.sugar.core.manager.Sounds;
	import com.popchan.sugar.modules.game.model.GameModel;
	import com.popchan.sugar.modules.map.model.LevelModel;
	
	import diary.game.Inventory;
	import diary.game.Money;
	import diary.game.Shop;

	public class Model
	{

		public static var gameModel:GameModel = new GameModel();
		public static var levelModel:LevelModel = new LevelModel();
		public static var money:Money = new Money;
		public static var inventory:Inventory;
		public static var shop:Inventory;

		public static function save():void
		{
			levelModel.saveData();
			money.save();
			inventory.save();
		}

		public static function load():void
		{
			DataUtil.id = "com.popchanniuniu.bubble410";
			DataUtil.load(DataUtil.id);
			levelModel.loadData();
			money.load();
			if (!inventory)
				inventory = new Inventory;
			if (!shop)
				shop = new Shop;
			inventory.load();

			Sounds.init();
		}
	}
} //package com.popchan.sugar.core
