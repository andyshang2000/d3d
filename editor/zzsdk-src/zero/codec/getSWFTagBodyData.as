/***
getSWFTagBodyData
创建人：ZЁЯ¤　身高：168cm+；体重：57kg+；未婚（已有女友）；最爱的运动：睡觉；格言：路见不平，拔腿就跑。QQ：358315553。
创建时间：2012年0月日 21:00:53
简要说明：这家伙很懒什么都没写。
用法举例：这家伙还是很懒什么都没写。
*/

package zero.codec{
	import flash.utils.ByteArray;
	
	public function getSWFTagBodyData(swfData:ByteArray,_tag_type:int):ByteArray{
		
		//import zero.BytesAndStr16;
		//trace(zero.BytesAndStr16.bytes2str16(swfData,0,swfData.length));
		
		if(swfData.length>8){
		}else{
			trace("不是有效的SWF文件");
			return null;
		}
		swfData.position=0;
		var type:String=swfData.readUTFBytes(3);//压缩和非压缩标记
		
		var data:ByteArray=new ByteArray();
		data.writeBytes(swfData,8);
		
		//trace("type="+type);
		
		switch(type){
			case "CWS":
				try{
					data.uncompress();
				}catch(e:Error){
					trace("CWS 解压缩数据时出错");
					return null;
				}
			break;
			case "FWS":
			break;
			default:
				trace("不是有效的SWF文件");
				return null;
			break;
		}
		
		//var Version:int=swfData[3];//播放器版本
		
		//var FileLength:int=data.length+8;//SWF文件长度
		//if(FileLength!=(swfData[4]|(swfData[5]<<8)|(swfData[6]<<16)|(swfData[7]<<24))){
		//	trace(
		//		"文件长度不符 FileLength="+FileLength+
		//		",ErrorFileLength="+(swfData[4]|(swfData[5]<<8)|(swfData[6]<<16)|(swfData[7]<<24))
		//	);
		//}
		
		//var offset:int=0;
		//获取SWF的宽高帧频
		//var bGroupValue:int=(data[offset++]<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];
		//var Nbits:int=bGroupValue>>>27;							//11111000 00000000 00000000 00000000
		//if(Nbits){
		//	var bGroupBitsOffset:int=5;
		//	
		//	var bGroupRshiftBitsOffset:int=32-Nbits;
		//	var bGroupNegMask:int=1<<(Nbits-1);
		//	var bGroupNeg:int=0xffffffff<<Nbits;
		//	
		//	var Xmin:int=(bGroupValue<<5)>>>bGroupRshiftBitsOffset;
		//	if(Xmin&bGroupNegMask){Xmin|=bGroupNeg;}//最高位为1,表示负数
		//	bGroupBitsOffset+=Nbits;
		//	
		//	//从 data 读取足够多的位数以备下面使用:
		//	if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
		//	
		//	var Xmax:int=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
		//	if(Xmax&bGroupNegMask){Xmax|=bGroupNeg;}//最高位为1,表示负数
		//	bGroupBitsOffset+=Nbits;
		//	
		//	//从 data 读取足够多的位数以备下面使用:
		//	if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
		//	
		//	var Ymin:int=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
		//	if(Ymin&bGroupNegMask){Ymin|=bGroupNeg;}//最高位为1,表示负数
		//	bGroupBitsOffset+=Nbits;
		//	
		//	//从 data 读取足够多的位数以备下面使用:
		//	if(bGroupBitsOffset>=16){if(bGroupBitsOffset>=24){bGroupBitsOffset-=24;bGroupValue=(bGroupValue<<24)|(data[offset++]<<16)|(data[offset++]<<8)|data[offset++];}else{bGroupBitsOffset-=16;bGroupValue=(bGroupValue<<16)|(data[offset++]<<8)|data[offset++];}}else if(bGroupBitsOffset>=8){bGroupBitsOffset-=8;bGroupValue=(bGroupValue<<8)|data[offset++];}
		//	
		//	var Ymax:int=(bGroupValue<<bGroupBitsOffset)>>>bGroupRshiftBitsOffset;
		//	if(Ymax&bGroupNegMask){Ymax|=bGroupNeg;}//最高位为1,表示负数
		//	bGroupBitsOffset+=Nbits;
		//}
		//
		//offset-=int(4-bGroupBitsOffset/8);
		
		//var x:Number=Xmin/20;
		//var y:Number=Ymin/20;
		//var width:Number=(Xmax-Xmin)/20;
		//var height:Number=(Ymax-Ymin)/20;
		
		//var FrameRate:Number=data[offset++]/256+data[offset++];//帧频是一个Number, 在SWF里以 FIXED8(16-bit 8.8 fixed-point number, 16位8.8定点数) 的结构保存
		
		//var FrameCount:int=data[offset++]|(data[offset++]<<8);//帧数是一个int, 在SWF里以 UI16(Unsigned 16-bit integer value, 16位无符号整数) 的结构保存
		
		var offset:int=Math.ceil((5+(data[0]>>>3)*4)/8)+4;
		var endOffset:int=data.length;
		while(offset<endOffset){
			var temp:int=data[offset++];
			var tag_type:int=(temp>>>6)|(data[offset++]<<2);
			var tag_bodyLength:int=temp&0x3f;
			if(tag_bodyLength==0x3f){//长tag
				tag_bodyLength=data[offset++]|(data[offset++]<<8)|(data[offset++]<<16)|(data[offset++]<<24);
				//test_isShort=false;
			}//else{
			//	test_isShort=true;
			//}
			if(tag_type==_tag_type){
				var tagBodyData:ByteArray=new ByteArray();
				tagBodyData.writeBytes(data,offset,tag_bodyLength);
				tagBodyData.position=0;
				return tagBodyData;
			}
			offset+=tag_bodyLength;
		}
		//if(offset===endOffset){
		//}else{
		//	trace("最后一个 tag, tag_type="+tag_type);
		//	trace("offset="+offset+"，endOffset="+endOffset+"，offset!=endOffset");
		//}
		
		//trace("找不到 _tag_type="+_tag_type+"对应的 tag");
		return null;
	}
}