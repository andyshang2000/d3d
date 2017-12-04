package ands.drama.scripting
{
	import diary.game.Level;

	public class Script
	{
		public static var End:ScriptEntry = new EndEntry;
		public var currentIndex:int = -1;

		private var entries:Vector.<ScriptEntry> = new Vector.<ScriptEntry>;
		private var labelIndex:Vector.<Label> = new Vector.<Label>;

		public var playing:Boolean = true;

		public function next():ScriptEntry
		{
			if (!playing)
				return null;
			if (entries.length - 1 == currentIndex)
			{
				end();
				return End;
			}
			currentIndex++;
			executeEntry(entries[currentIndex])
			return entries[currentIndex];
		}

		public function select(i:int):void
		{
			if (playing || !(entries[currentIndex] is Branch))
				return;
			executeEntry(Branch(entries[currentIndex]).getJump(i));
			playing = true;
		}

		private function executeEntry(entry:ScriptEntry):void
		{
			if (!entry)
				return;
			//根据类型执行
			if (entry is Jump)
			{
				gotoLabel(Jump(entry).name)
			}
			else if (entry is Label)
			{
				next();
			}
			else if (entry is Branch)
			{
				playing = false;
			}
			else if (entry is EndEntry)
			{
				playing = false;
			}
		}

		private function end():void
		{
			trace("游戏结束")
			playing = false;
		}

		public function gotoLabel(name:String):void
		{
			for (var i:int = 0; i < labelIndex.length; i++)
			{
				if (labelIndex[i].name == name)
				{
					currentIndex = labelIndex[i].index;
					next();
					break;
				}
			}
		}

		public function addLabel(name:String):void
		{
			var label:Label = new Label(name);
			label.index = entries.length
			entries.push(label);
			labelIndex.push(label);
		}

		public function addContent(match:Array):void
		{
			entries.push(new DialogContent(match));
		}

		public function addCondition(match:Array):void
		{
			var branch:Branch = entries[entries.length - 1] as Branch;
			branch.addCondition(match);
		}

		public function createBranch():void
		{
			entries.push(new Branch);
		}

		public function addJump(line:String):void
		{
			entries.push(new Jump(line));
		}

		public function addQuest(line:String):void
		{
			entries.push(new QuestRef(line));
		}

		public function addUnlock(line:String):void
		{
			entries.push(new Unlock(line));
		}

		public function addSceneSwitch(line:String):void
		{
			entries.push(new SwitchScene(line));
		}
	}
}
