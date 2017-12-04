package ands.drama.scripting
{
	import diary.game.Quest;

	public class QuestRef extends ScriptEntry implements IResponding
	{
		public var quest:Quest;

		public function QuestRef(line:String)
		{
			if (line.charAt(0) == "《")
			{
				line = line.substring(1, line.length - 1);
			}
			quest = Quest.get(line);
			trace(quest);
		}
	}
}
