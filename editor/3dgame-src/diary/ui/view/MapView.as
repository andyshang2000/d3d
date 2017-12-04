package diary.ui.view
{
	import flash.geom.Rectangle;
	import flash.text.Font;

	import diary.avatar.DefaultAvatar;
	import diary.res.RES;
	import diary.ui.font.FZArtHei;

	import feathers.controls.SpinnerList;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalSpinnerLayout;

	import flare.basic.Scene3D;
	import flare.core.Camera3D;

	import starling.display.Sprite;

	public class MapView extends ViewWithTopBar implements IScreen
	{
		private var font:Font = new FZArtHei;

		public function getBack():Sprite
		{
			return createList();
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

		private function createList():Sprite
		{
			var list:SpinnerList = new SpinnerList();
			list.width = 480;
			list.height = 800;
			list.layout = new HorizontalSpinnerLayout;
			list.itemRendererType = ItemRenderer
			list.dataProvider = new ListCollection( //
				[ //
				{text: "1Milk"}, //thumbnail: textureAtlas.getTexture("milk")}, //
				{text: "2Eggs"}, //thumbnail: textureAtlas.getTexture("eggs")}, //
				{text: "3Bread"}, //thumbnail: textureAtlas.getTexture("bread")}, //
				{text: "4Chicken"}, //thumbnail: textureAtlas.getTexture("chicken")}, //
				{text: "5Milk"}, //thumbnail: textureAtlas.getTexture("milk")}, //
				]);

//			list.addEventListener(Event.CHANGE, list_changeHandler);

			return list
		}
	}
}

import flash.geom.Rectangle;

import diary.ui.components.ItemRendererBase;

import feathers.controls.Label;
import feathers.controls.renderers.IListItemRenderer;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.textures.Texture;

class ItemRenderer extends ItemRendererBase implements IListItemRenderer
{
	private var _label:Label;
	//
	private var lastIndex:int = -1;
	private var figureFrame:DisplayObject;
	private var image:Image;
	private var texture:Texture;

	private static var count:int = 0;

	//
	override protected function initialize():void
	{
		this.setSizeInternal(480, 800, false);
	}

	override protected function commitData(data:Object):void
	{
		if (image)
		{
			image.dispose();
			image.texture.base.dispose();
			image.texture.dispose();
			removeChild(image);
			image = null;
		}
		trace(data);
//		var sub:Texture = Texture.fromTexture(Texture.fromAtfData(null), new Rectangle(0, 0, 940, 1600));
//		Texture.from
		var sub:Texture = Texture.fromTexture(Texture.fromColor(1024, 1024, [0xFFFF0000, 0xFF00FF00, 0xFF0000FF, 0xFFFFFF00, 0xFFFF00FF][index]), new Rectangle(0, 0, 480, 800));
		image = new Image(sub);
		addChild(image);
	}
}
