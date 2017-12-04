package ands.drama.scripting
{

	public class Branch extends ScriptEntry implements IResponding
	{
		private var conditions:Array = [];

		public function addCondition(condition:Array):void
		{
			conditions.push(condition);
		}

		public function get numConditions():int
		{
			return conditions.length;
		}

		public function getLabel(i:int):String
		{
			return conditions[i][2].split("->")[0];
		}

		public function getJump(i:int):Jump
		{
			var arr:Array = conditions[i - 1][2].split("->");
			return arr.length == 1 ? null : new Jump(arr[1]);
		}
	}
}
