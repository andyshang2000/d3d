package ands.drama.scripting
{
	import mx.utils.StringUtil;
	
	import ands.utils.Reader;
	
	import diary.game.Level;
	import diary.game.Tachie;
	import diary.res.RES;

	public class ScriptParser
	{
		public static function parse(file:*):Script
		{
			return new ScriptParser().parse(file);
		}

		private var state:String = "ready";
		private var result:Script;
		//
		public static var actorStr:String = "";
		private static var actors:Array = [];
		private static var emotions:Array = [];
		//
		private var lastLine:String = "";
		private var lastMatch:Array = null;

		public function parse(file:*):Script
		{
			var reader:Reader = new Reader(file);
			reader.readLine() // skip the first line BOE
			result = new Script;
			while (reader.hasNextline())
			{
				var line:String = StringUtil.trim(reader.readLine());
				if (line.length == 0 || line.charAt(0) == "#")
					continue;

				parseLine(line);
			}

			return result;
		}

		public static function addActors(... names:Array):void
		{
			actors = actors.concat(names);
			actorStr = actors.join("|");
		}

		public static function addEmotions(... names:Array):void
		{
			emotions = emotions.concat(names);
		}

		private function parseLine(line:String):void
		{
			switch (state)
			{
				case "actor":
					parseActor(line);
					break;
				case "mapIndex":
					parseMapIndex(line);
					break;
				case "ready":
					parseReadyState(line);
					break;
				case "content":
					parseContentState(line);
					break;
				case "condition":
					parseConditionState(line);
					break;
				case "quest":
					parseQuestState(line);
					break;
				case "jump":
					parseJump(line);
			}
		}

		private function parseReadyState(line:String):void
		{
			if (line.charAt(0) == ":")
			{
				state = "label";
				result.addLabel(line.substr(2));
				state = "ready";
			}
			else if (line.charAt() == "%")
			{
				parseConfig(line);
			}
			else if (line.charAt(0) == "*")
			{
				parseEffect(line);
			}
			else if (line.charAt(0) == "@")
			{
				if (line.indexOf("@include") == 0)
					includeFile(line.split(" ")[1]);
				else
					parseCommand(line);
			}
			else if (line.indexOf("->") == 0)
			{
				state = "jump";
				lastLine = line;
				parseJump(line);
			}
			else
			{
				if (isContent(line))
				{
					state = "content";
					parseContentState(line);
				}
			}
		}

		private function parseConfig(line:String):void
		{
			switch (line)
			{
				case "%人物:":
					state = "actor";
					break;
				case "%地图索引:":
					state = "mapIndex";
					break;
			}
			trace(line)
		}

		private function parseEffect(line:String):void
		{
		}

		private function parseCommand(line:String):void
		{
			if (line == "@条件:")
			{
				state = "condition";
				result.createBranch();
			}
			else if (line.indexOf("@解锁:") == 0)
			{
				state = "scene";
				result.addUnlock(line.substr(4));
				state = "ready";
			}
			else if (line.indexOf("@分镜:") == 0)
			{
				state = "scene";
				result.addSceneSwitch(line.substr(4));
				state = "ready";
			}
			else if (line.indexOf("@任务:") == 0)
			{
				state = "quest";
				lastLine = line;
				parseQuestState(line);
			}
		}

		private function includeFile(name:String):void
		{
			var reader:Reader = new Reader(RES.get(name));
			reader.readLine() // skip the first line BOE
			while (reader.hasNextline())
			{
				var line:String = StringUtil.trim(reader.readLine());
				if (line.length == 0 || line.charAt(0) == "#")
					continue;
				parseLine(line);
			}
		}

		private function isContent(line:String):Boolean
		{
			var emotionList:String = emotions.join("|")
			var regStr:String = StringUtil.substitute("({0})(\\*({1}))?说?:(.*)", actorStr, emotionList);
			var regExp:RegExp = new RegExp(regStr);
//			var regExp:RegExp = new RegExp("(女主|女配1|男主|男配1)(\\*(微笑|眨眼))?说?:(.*)");
			var match:Array = regExp.exec(line)
			if (match && match.length > 1)
			{
				lastLine = line;
				lastMatch = match;
				return true;
			}
			lastLine = null;
			lastMatch = null;
			return false;
		}

		private function parseContentState(line:String):void
		{
			if (lastLine == line || isContent(line))
			{
				result.addContent(lastMatch);
			}
			else
			{
				state = "ready";
				parseLine(line);
			}
		}

		private function parseMapIndex(line:String):void
		{
			var match:Array = /^(.*)\((.*)\):(.*)/.exec(line);
			if (match)
			{
				var level:Level = Level.getData(match[1])
				level.setLevels(match[2]);
				level.setMedia(match[3]);
			}
			else
			{
				state = "ready";
				parseLine(line);
			}
		}

		private function parseActor(line:String):void
		{
			var match:Array = /^(.*):(tche_\w+)/.exec(line);
			if (match)
			{
				addActors(match[1]);
				Tachie.add(match[1], match[2]);
			}
			else
			{
				state = "ready";
				parseLine(line);
			}
		}

		private function parseConditionState(line:String):void
		{
			var regExp:RegExp = /(\$[A-Z]):(.+)/;
			var match:Array = regExp.exec(line);
			if (match && match.length > 1)
			{
				result.addCondition(match);
			}
			else
			{
				state = "ready";
				parseLine(line);
			}
		}

		private function parseQuestState(line:String):void
		{
			if (lastLine == line || line.indexOf("@任务:") == 0)
			{
				result.addQuest(line.substr(4));
			}
			else
			{
				state = "ready";
				parseLine(line);
			}
		}

		private function parseJump(line:String):void
		{
			if (lastLine == line || line.indexOf("->") == 0)
			{
				result.addJump(line.substr(2));
			}
			else
			{
				state = "ready";
				parseLine(line);
			}
		}
	}
}
