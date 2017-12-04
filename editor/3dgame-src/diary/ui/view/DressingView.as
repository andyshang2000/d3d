package diary.ui.view
{
	import flash.geom.Rectangle;
	import flash.text.Font;
	
	import diary.avatar.DefaultAvatar;
	import diary.res.RES;
	import diary.ui.font.FZArtHei;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	
	import flare.basic.Scene3D;
	import flare.core.Camera3D;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class DressingView extends ViewWithTopBar implements IScreen
	{
		private var font:Font = new FZArtHei;
		private var list:List;

		public function getFront():Sprite
		{
			var view:Sprite = RES.get("gui/spr_closetView");

			list = createList();
			view.addChild(list);
			return view;
		}

		public function update3D(scene:Scene3D):void
		{
			scene.addChild(new DefaultAvatar);
			scene.camera.setPosition(0, 165, -180);
			scene.camera.lookAt(0, 135, 0);
			scene.camera.fovMode = Camera3D.FOV_VERTICAL;
			scene.camera.fieldOfView = 95;
			scene.camera.viewPort = new Rectangle(-60, -155, scene.viewPort.width, scene.viewPort.height);
		}

		private function createList():List
		{
			var list:List = new List;
			list.itemRendererType = ItemRenderer;
			list.x = 360;
			list.y = 12;
			list.width = 120;
			list.height = 766;
			list.dataProvider = new ListCollection([ //
				{text: "Milk", thumbnail: null}, //
				{text: "Eggs", thumbnail: null}, //
				{text: "Bread", thumbnail: null}, //
				{text: "Chicken", thumbnail: null}, //
				{text: "Milk", thumbnail: null}, //
				{text: "Eggs", thumbnail: null}, //
				{text: "Bread", thumbnail: null}, //
				{text: "Chicken", thumbnail: null}, //
				{text: "Milk", thumbnail: null}, //
				{text: "Eggs", thumbnail: null}, //
				{text: "Bread", thumbnail: null}, //
				{text: "Chicken", thumbnail: null}, //
				{text: "Milk", thumbnail: null}, //
				{text: "Eggs", thumbnail: null}, //
				{text: "Bread", thumbnail: null}, //
				{text: "Chicken", thumbnail: null}, //
				]);
			list.addEventListener(Event.CHANGE, list_changeHandler);
			return list;
		}

		private function list_changeHandler():void
		{
			// TODO Auto Generated method stub

		}
	}
}

import diary.res.RES;
import diary.ui.components.ItemRendererBase;

import feathers.controls.Label;
import feathers.controls.renderers.IListItemRenderer;

import starling.display.DisplayObject;

class ItemRenderer extends ItemRendererBase implements IListItemRenderer
{
	private var _label:Label;
	//
	private var lastIndex:int = -1;
	private var figureFrame:DisplayObject;

	//
	override protected function initialize():void
	{
		if (!this._label)
		{
			this._label = new Label;
			this.addChild(this._label);
		}
	}

	override protected function commitData(data:Object):void
	{
		drawFigureFrame();
		if (data)
		{
			_label.text = this.data.text;
		}
		else
		{
			_label.text = null;
		}
	}

	private function drawFigureFrame():void
	{
		if (figureFrame)
			return;
		addChild(figureFrame = RES.get("gui/spr_itemFrameUp"));
		lastIndex = index;
		this.setSizeInternal(figureFrame.width - 15, figureFrame.height, false);
	}
}
