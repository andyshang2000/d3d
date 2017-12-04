package
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	import mx.utils.StringUtil;

	import nblib.util.Reader;

	public class Named extends ByteArray
	{
		public var list:Vector.<Item>

		public function Named()
		{
			list = new Vector.<Item>
			var fs:FileStream = new FileStream;
			fs.open(new File("D:\\3dgame\\src\\config\\item_c.txt"), FileMode.READ)
			var reader:Reader = new Reader(fs, "ANSI");
			while (reader.hasNextline())
			{
				var line:String = reader.readLine();
				line = StringUtil.trim(line);
				if (line.length == 0)
					continue;
				if (line.charAt(0) == "#" || line.charAt(1) == "#")
					continue;
				var arr:Array = line.split("\t");
				if (arr[1] == "model")
					continue;
				list.push(new Item(arr));
			}
			fs.close();
		}
	}
}

class Item
{
	public var text:String;
	public var f3d:String;

	public var name:String;
	public var model:String;
	public var mcode:int = 0;
	public var type:int = 0;
	public var type2:String = "";
	public var subType:int = 0;
	public var cost:int = 0;
	public var dropLevel:int = 0;
	public var prop1:int = 0;
	public var prop2:int = 0;
	public var prop3:int = 0;
	public var prop4:int = 0;
	public var prop5:int = 0;
	public var tag:String = "XX";

	public function Item(arr:Array)
	{
		text = arr[0];
		f3d = arr[1];

		if (arr.length > 12)
		{
			tag = arr[12];
		}
		arr = arr.slice(0, 12);
		for (var i:int = 2; i < arr.length; i++)
		{
			var name:String = getFieldName(i);
			if (name == "type2")
			{
				this[name] = arr[i];
			}
			else
			{
				this[name] = int(arr[i]);
			}
		}
	}

	private function getFieldName(i:int):String
	{
		// TODO Auto Generated method stub
		return ["name", "model", "mcode", //
			"type", "type2", "subType", //
			"cost", "dropLevel", //
			"prop1", "prop2", "prop3", "prop4", "prop5", "tag"][i];
	}

	public function serialize():String
	{
		var str:String = text + "\t" + f3d + "\t";
		for (var i:int = 2; i < 14; i++)
		{
			str += this[getFieldName(i)] + "\t"
		}
		return str.substr(0, str.length - 1);
	}

	public function toString():String
	{
		return text + (/^g\d{4}_(.*)_/.exec(f3d)[1]) + "(" + (/^g(\d{4})/.exec(f3d)[1]) + ")"
	}
}
