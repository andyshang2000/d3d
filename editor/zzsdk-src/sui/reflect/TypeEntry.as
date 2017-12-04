package sui.reflect
{
	import flash.system.*;

	public class TypeEntry
	{

		public var metadatas:Object;
		public var name:String;
		public var type:Class;

		public function TypeEntry(_arg1:String, _arg2:String)
		{
			this.metadatas = {};
			super();
			this.name = _arg1;
			if (((!((_arg2 == "void"))) && (!((_arg2 == "*")))))
			{
				this.type = (ApplicationDomain.currentDomain.getDefinition(_arg2) as Class);
			}
		}

		public function parseMetadata(_arg1:XMLList):void
		{
			var _local2:XML;
			var _local3:Metadata;
			for each (_local2 in _arg1)
			{
				_local3 = new Metadata(_local2.@name);
				_local3.parseArgs(_local2..arg);
				if (metadatas[_local3.name] == null)
				{
					metadatas[_local3.name] = _local3;
				}
				else if (this.metadatas[_local3.name] is Array)
				{
					metadatas[_local3.name].push(_local3);
				}
				else
				{
					metadatas[_local3.name] = [metadatas[_local3.name], _local3];
				}
			}
		}
	}
}
