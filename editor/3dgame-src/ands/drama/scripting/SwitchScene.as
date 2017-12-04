package ands.drama.scripting
{
	import diary.game.Level;
	import diary.game.Tachie;

	public class SwitchScene extends ScriptEntry
	{
		public var level:Level;
		public var tachieList:Array = [];
		private var line:String;

		public function SwitchScene(line:String)
		{
			this.line = line
			var arr:Array = line.split(",");
			level = Level.getData(arr[0]);
			tachieList = [];
			for (var i:int = 1; i < arr.length; i++)
			{
				tachieList.push(parseTachie(arr[i]));
			}
		}

		private function parseTachie(str:String):Object
		{
			var match:Array = new RegExp("(" + ScriptParser.actorStr + ")(左|中|右)").exec(str);
			if (!match)
				throw new Error("illegel format on @分镜:" + line);
			var tachie:Tachie = Tachie.get(match[1]);
			return {tachie: tachie, posRef: match[2]};
		}
	}
}
