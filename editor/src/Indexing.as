package
{
	import flash.display.Sprite;
	import flash.filesystem.File;

	import zzsdk.editor.utils.FileUtil;

	public class Indexing extends Sprite
	{
		private var names:Object = {};
		private static var c:int = 0;

		public function Indexing()
		{
			var root:File = File.applicationDirectory.resolvePath("D:\\3dgame\\f3dfiles\\windows");
			var files:Array = root.getDirectoryListing();
			var txt:String = "";
			var count:int = 1;
			for each (var f:File in files)
			{
				txt += count++ + ",\t";
				txt += generateName(f.name) + ",\t";
				txt += f.name.substr(0, f.name.length - 4) + ",\t";
				txt += getType1(f.name) + ",\t"; //类别1
				txt += getType2(f.name) + ",\t"; //类别2
				txt += 0 + ",\t"; //心
				txt += 0 + ",\t"; //金币
				txt += "\n";
			}
			FileUtil.save(txt, "conf.txt");
		}

		private function getType2(name:String):int
		{
			var match:Array = /(g|b)\d{4}_(\w+)_dod/.exec(name);
			if (!match)
				return 0;
			var type:String = match[2];
			if (type.length > 1)
				return 9;
			return ["f", "h", "j", "p", "s"].indexOf(type);
		}

		private function getType1(name:String):int
		{
			var match:Array = /(g|b)\d{4}_(\w+)_dod/.exec(name);
			if (!match)
				return 0;
			var res:int = 0;
			var str:String = match[2];
			for (var i:int = 0; i < str.length; i++)
			{
				switch (str.charAt(i))
				{
					case "f":
						res |= 1;
						break;
					case "h":
						res |= 1 << 1;
						break;
					case "j":
						res |= 1 << 2;
						break;
					case "p":
						res |= 1 << 3;
						break;
					case "s":
						res |= 1 << 4;
						break;
				}
			}
			return res;
		}

		public function generateName(filename:String):String
		{
			var match:Array = /(g|b)(\d{4}).*\.f3d/ig.exec(filename);
			if (!match)
				return "未定义";
			if (names[match[2]])
				return names[match[2]];
			else
				return names[match[2]] = createNewName();

		}

		private function createNewName():Object
		{
			c++
			if (c < 10)
				return "name000" + c
			if (c < 100)
				return "name00" + c
			if (c < 1000)
				return "name0" + c
			return "name" + c;
		}
	}
}
