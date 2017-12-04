/***
CRC32String
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；未婚（已有女友）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2012年08月23日 09:21:11
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package zero.codec{
	import flash.utils.ByteArray;
	public function CRC32String(string:String):int{
		if(string){
			var data:ByteArray=new ByteArray();
			data.writeUTFBytes(string);
			return CRC32(data);
		}
		return 0x00000000;
	}
}