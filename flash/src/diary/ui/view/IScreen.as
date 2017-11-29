package diary.ui.view
{
	import flare.basic.Scene3D;

	import starling.display.Sprite;

	public interface IScreen
	{
		function dispose():void;
		function update2DLayer(name:String, root:Sprite):void;
		function update3DLayer(scene:Scene3D):void;
		function loadAssets(callback:Function = null):void;
		
	}
}
