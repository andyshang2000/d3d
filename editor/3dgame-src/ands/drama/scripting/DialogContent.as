package ands.drama.scripting
{

	public class DialogContent extends ScriptEntry implements IResponding
	{
		public var actor:String;
		public var emotion:String;
		public var content:String;

		public function DialogContent(data:Array)
		{
			actor = data[1];
			emotion = data[3];
			content = data[4];
		}
	}
}
