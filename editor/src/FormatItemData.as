package
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import zzsdk.editor.utils.FileUtil;

	public class FormatItemData extends Sprite
	{
		public function FormatItemData()
		{
			var itemData:ItemData = new ItemData();
			var data:Array = itemData.items
			var str:String = "";
			for (var i:int = 0; i < data.length; i++)
			{
				str += (data[i] as Array).join(",") + "\n";
			}
			str += "";
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(str, "GBK");
			FileUtil.save(bytes, "formattedItems.csv", true);
		}
	}
}
