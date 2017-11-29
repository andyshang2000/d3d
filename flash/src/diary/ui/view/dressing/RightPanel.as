package diary.ui.view.dressing
{
	import diary.ui.view.ViewBase;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	
	import starling.events.Event;

	public class RightPanel extends ViewBase
	{
		private var list:List;

		[Embed(source = "/embedded/dress1.mp3")] //[Embed(source = "../../assets/btn_sound.mp3")]
		private var dressClass:Class;

		override public function loadAssets(callback:Function = null):void
		{
			super.loadAssets(callback)
		}

		public function update(items:Array):void
		{
			if (list)
			{
				list.removeFromParent(true);
			}
			list = new List;
			list.x = 30;
			list.y = 30;
			list.itemRendererType = ItemRenderer;
			list.isSelectable = true;
			list.addEventListener(Event.TRIGGERED, touchHandler);
			//
			view.addChild(list);
			list.dataProvider = new ListCollection(items);
			list.width = 100;
			list.height = 500;
		}

		private function touchHandler(e:Event):void
		{
			dispatchEventWith("change", false, e.data);
		}
	}
}

import flash.geom.Point;

import diary.res.RES;
import diary.ui.components.ItemRendererBase;
import diary.ui.view.dressing.EmbedMgr;

import feathers.controls.Label;
import feathers.controls.renderers.IListItemRenderer;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.MovieClip;
import starling.events.Event;
import starling.textures.Texture;

class ItemRenderer extends ItemRendererBase implements IListItemRenderer
{
	private var _label:Label;
	//
	private var lastIndex:int = -1;
	private var figureFrame:DisplayObject;
	private var image:Image;
	private var clkEff:MovieClip;

	public function ItemRenderer()
	{
		if (!clkEff)
		{
			clkEff = new MovieClip(EmbedMgr.Instance().getTextures("clickfire"), 50);
			Starling.juggler.add(clkEff);
			clkEff.loop = false;
			clkEff.stop();
		}
		addEventListener(Event.TRIGGERED, blink);
	}

	private function blink(event:Event):void
	{
		stage.addChild(clkEff);
		var p:Point = new Point(-56, -55);
		p = this.localToGlobal(p)
		clkEff.x = p.x;
		clkEff.y = p.y;
		clkEff.touchable = false;
		clkEff.scaleX = 1;
		clkEff.scaleY = 1;
		clkEff.currentFrame = 0;
		clkEff.play();
		clkEff.addEventListener(Event.COMPLETE, function():void
		{
			clkEff.stop();
			if (clkEff.parent)
			{
				clkEff.parent.removeChild(clkEff);
			}
		});
	}

	override protected function commitData():void
	{
		if (image)
		{
			image.dispose();
			removeChild(image);
		}
		if (!data)
			return;
		//
		var texture:Texture = RES.get(data.model);
		if (!texture)
			return;
		image = new Image(texture);
		image.touchable = true;
		image.scaleX *= 2;
		image.scaleY *= 2;
		addChild(image);
		setSizeInternal(image.width, image.height, false);
	}
}
