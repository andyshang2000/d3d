package diary.game
{
	import flash.utils.ByteArray;

	import ands.drama.scripting.QuestRef;
	import ands.drama.scripting.Script;
	import ands.drama.scripting.ScriptEntry;
	import ands.drama.scripting.ScriptParser;
	import ands.drama.scripting.SwitchScene;
	import ands.drama.scripting.Unlock;

	import diary.res.RES;

	public class Context
	{
		private static var instance:Context;

		public static function get context():Context
		{
			return instance ||= new DynamicContext;
		}

		public var script:Script;
		public var scriptIndex:int;
		public var avatar:AvatarModel;
		public var scoreList:Array;
		public var rating:Rate;
		public var level:Level;
		public var inventory:Inventory;

		private var quest:Quest;

		public function Context()
		{
			initializeItems();
			initializeScript();
			new Record().setup(this);
		}

		public function put(name:String, obj:Object):void
		{
			this["__" + name] = obj;
		}

		public function get(name:String):*
		{
			return this["__" + name];
		}

		public function rate():void
		{
			rating = new Rate;
			var score:int = 0;
			for each (var item:Item in avatar.partList)
			{
				score += item.prop1 * quest.prop1;
				score += item.prop2 * quest.prop2;
				score += item.prop3 * quest.prop3;
				score += item.prop4 * quest.prop4;
				score += item.prop5 * quest.prop5;
			}
			if (score > quest.S)
				rating.rank = "S";
			else if (score > quest.A)
				rating.rank = "A";
			else if (score > quest.B)
				rating.rank = "B";
			else if (score > quest.C)
				rating.rank = "C";
			else
				rating.rank = "F";
			rating.quest = quest;
		}

		public function loadLevelConfig(id:int):Object
		{
			var str:String;
			if (id < 10)
				return RES.get("level00" + id);
			if (id < 100)
				return RES.get("level0" + id);
			else
				return RES.get("level" + id);
		}

		private function initializeItems():void
		{
			Treasure.addData(useCode(RES.get("treasure"), "ANSI"));
			ItemType.addType(useCode(RES.get("type"), "ANSI"));
			Item.addData(useCode(RES.get("item_c"), "ANSI"));
			Item.addData(useCode(RES.get("misc"), "ANSI"));
			Quest.addData(useCode(RES.get("quests"), "ANSI"));
			Level.addData(useCode(RES.get("level"), "ANSI"));
		}

		private function useCode(bytes:ByteArray, code:String):String
		{
			return bytes.readMultiByte(bytes.length, code);
		}

		private function initializeScript():void
		{
			ScriptParser.addEmotions("微笑", "眨眼");
			script = ScriptParser.parse(RES.get("script"));
		}

		public function pushbackScript():void
		{
			script.currentIndex--;
		}

		public function nextScript():ScriptEntry
		{
			var entry:ScriptEntry = script.next();
			if (script.playing && entry == null)
				throw new Error("unexpected scriptEntry");
			if (entry is Unlock)
			{
				Level.getData(Unlock(entry).name).locked = false;
			}
			else if (entry is SwitchScene)
			{
				SwitchScene(entry).level
				for each (var o:Object in SwitchScene(entry).tachieList)
				{
					Tachie(o.tachie).defaultPos = o.posRef;
				}
				return nextScript();
			}
			return entry;
		}

		public function scriptSelect(i:int):void
		{
			script.select(i);
		}

		public function isScriptPlaying():Boolean
		{
			return script;
		}

		public function serialize():ByteArray
		{
			return null;
		}

		public function unserialize(bytes:ByteArray):void
		{
		}

		public function saveTo(cpIndex:int):void
		{
		}

		public function loadFrom(cpIndex:int):void
		{
		}

		public function setQuest(param0:QuestRef):void
		{
			script.playing = false;
			quest = param0.quest;
		}

		public function afford(item:Item):Boolean
		{
			return inventory.canAfford(item);
		}

		public function bonus():Array
		{
			var dropLevel:int = 0;
			switch (rating.rank)
			{
				case "S":
					dropLevel += 2;
					break;
				case "A":
					dropLevel += 2;
					break;
				case "B":
					dropLevel += 2;
					break;
				case "C":
					dropLevel += 2;
					break;
				default:
					dropLevel = 0;
					break;
			}
			if (quest)
			{
				dropLevel += int(quest.first);
			}
			var res:Array = [];
			Treasure.get(quest.first).pick(res, dropLevel);
			for (var i:int = 0; i < res.length; i++)
			{
				inventory.gain(res[i]);
			}
			return res;
		}

		public function acceptQuest():void
		{
			script.playing = true;
		}

		public function cancelQuest():void
		{
			script.playing = true;
			quest = null;
			script.currentIndex -= 2;
		}

		public function isEnd():Boolean
		{
			// TODO Auto Generated method stub
			return script;
		}

		public function passed(level:Level):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}

		public function setLevel(level:Level):void
		{
			this.level = level;
		}
	}
}
import diary.game.Context;

dynamic class DynamicContext extends Context
{
}
