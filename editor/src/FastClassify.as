package
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import diary.game.Item;
	import diary.game.ItemType;
	
	import zzsdk.editor.utils.FileUtil;

	public class FastClassify extends Sprite
	{
		private var list:Array;

		public function FastClassify()
		{
			ItemType.addType(FileUtil.readFile(new File("D:\\3dgame\\src\\config\\type.txt"), "text", "ANSI"));
			Item.addData(FileUtil.readFile(new File("D:\\3dgame\\src\\config\\item_c.txt"), "text", "ANSI"));
			for (var i:int = 0; i < Item.list.length; i++)
			{
				var item:Item = Item.list[i];
				if (!ItemType.isType(item, "apprl"))
				{
					switch (item.model.match(/g\d{4}_(.*)_dod/)[1])
					{
						case "h":
							item.type2 = "未分类发";
							break;
						case "j":
							item.type2 = "未分类上";
							break;
						case "p":
							item.type2 = "未分类下";
							break;
						case "s":
							item.type2 = "未分类鞋";
							break;
						case "jp":
						case "jps":
						case "hjps":
						case "ps":
							item.type2 = "未分类套";
							break;
						default:
							item.type2 = "未分类";
							break;
					}
				}
			}
			
			save();
		}

		private function save():void
		{
			var str:String = "";
			for (var i:int = 0; i < Item.list.length; i++)
			{
				str += Item.list[i].serialize() + "\r\n";
			}
			var fs:FileStream = new FileStream();
			fs.open(new File("D:\\3dgame\\src\\config\\item_c.txt"), FileMode.WRITE);
			fs.writeMultiByte("name	model	mcode	type	type2	subType	cost	dropLevel	prop1	prop2	prop3	prop4	prop5	tag\r\n", "ANSI");
			fs.writeMultiByte(str, "ANSI");
			fs.close();
		}
	}
}
