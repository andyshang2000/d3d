package diary.ui.view
{
	import diary.controller.IState;

	public interface IScreenCtrl extends IState
	{
		function dispose():void;
		
		function onInit(callback:Function):void;
	}
}
