package diary.ui.view
{
	import flash.display.TriangleCulling;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import diary.avatar.AvatarView;
	import diary.avatar.RotationComponent;
	import diary.game.Context;
	import diary.game.Item;
	import diary.game.ItemType;
	import diary.res.RES;
	import diary.res.ZF3D;
	import diary.util.FilterComponent;

	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.layout.TiledColumnsLayout;

	import flare.basic.Scene3D;
	import flare.core.Camera3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Surface3D;
	import flare.flsl.FLSLFilter;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureMapFilter;

	import lzm.starling.swf.display.SwfButton;
	import lzm.starling.swf.display.SwfImage;

	import nblib.util.res.ResManager;

	import shaders.EdgeShader;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	public class ShopView extends ViewWithTopBar implements IScreen
	{
		public var $shopGlow:SwfImage;

		public var $itemNameField:TextField;
		public var $itemDescField:TextField;
		public var $buyButton:SwfButton;
		public var $catField:TextField;
		public var $backButton:SwfButton;

		public var $hairButton:SwfButton;
		public var $upButton:SwfButton;
		public var $downButton:SwfButton;
		public var $dressButton:SwfButton;
		public var $shoesButton:SwfButton;
		public var $specialButton:SwfButton;

		private var list:List;
		private var scene:Scene3D;

		private var selectedItem:Object;
		private var currentItem:Object;

		private var shopAct:Pivot3D;
		private var currentCat:String;
		private var shopFace:Pivot3D;

		override public function initialize(callback:Function = null):void
		{
			$shopGlow.visible = true;
			$hairButton.addEventListener(Event.TRIGGERED, buttonTrigger);
			$upButton.addEventListener(Event.TRIGGERED, buttonTrigger);
			$downButton.addEventListener(Event.TRIGGERED, buttonTrigger);
			$dressButton.addEventListener(Event.TRIGGERED, buttonTrigger);
			$shoesButton.addEventListener(Event.TRIGGERED, buttonTrigger);
			$specialButton.addEventListener(Event.TRIGGERED, buttonTrigger);
			//
			$buyButton.enabled = false;
			$buyButton.text = "请选择商品";

			super.initialize(callback);
		}

		private function buttonTrigger(event:Event):void
		{
			dispatchEventWith("catChange", false, SwfButton(event.currentTarget).name)
		}

		public function getBack():Sprite
		{
			var view:Sprite = RES.get("gui/spr_shopView");

			list = createList();
			//
			var listContainer:Sprite = new Sprite;
			listContainer.addChild(list);
			listContainer.x = -24;
			view.addChild(listContainer);
			return view;
		}

		private function createList():List
		{
			var list:List = new List;
			var layout:TiledColumnsLayout = new TiledColumnsLayout();
			layout.horizontalGap = -21;
			layout.verticalGap = 5;
			list.itemRendererType = ItemRenderer;
			list.x = 35;
			list.y = 485;
			list.width = 440;
			list.height = 300;
			list.layout = layout;
			return list;
		}

		private function list_changeHandler(event:Event):void
		{
			if (selectedItem == list.selectedItem)
				return;
			selectedItem = list.selectedItem;
			if (selectedItem == null)
				return;
			var item:Item = selectedItem as Item
			if (item.cost > 0)
				$buyButton.text = "购买";
			else
				$buyButton.text = "看视频免费领";
			$buyButton.enabled = true;
			dispatchEventWith("selectChange", false, selectedItem);
		}

		public function update3D(scene:Scene3D):void
		{
			this.scene = scene;
			scene.camera.setPosition(0, 160, -200);
			scene.camera.lookAt(0, 125, 0);
			scene.camera.fovMode = Camera3D.FOV_VERTICAL;
			scene.camera.fieldOfView = 70;
			scene.camera.viewPort = new Rectangle(-50, -300, scene.viewPort.width, scene.viewPort.height);

			ResManager.getResAsync("assets/act/shop/dress.zf3d", function(zf3d:ZF3D):void
			{
				shopAct = zf3d.content.getChildByName("ActorRoot");
			});
			ResManager.getResAsync("assets/shop/face.zf3d", function(zf3d:ZF3D):void
			{
				shopFace = zf3d.content;
			});

		}

		public function updatePreview(item:Item):void
		{
			if (item == null)
				return;
			ResManager.getResAsync("assets/" + AvatarView.platform + "/" + item.model + ".f3d/gg.zf3d", function(zf3d:ZF3D):void
			{
				$itemNameField.text = item.name;
				$itemDescField.text = item.desc;
				//
				shopFace.parent = null;
				var pivot:Pivot3D = null;
				if (currentItem)
					pivot = Pivot3D(currentItem.model)
				if (pivot)
				{
					pivot.parent = null;
					ResManager.removeRes(ZF3D(currentItem.zf3d).path);
				}
				currentItem = {model: pivot = zf3d.content, zf3d: zf3d}
				scene.addChild(pivot).name = item.model;
				setupPivotForShop(pivot);
				pivot.addComponent(new RotationComponent);
				pivot.addComponent(new FilterComponent(new EdgeShader().filter));
				updatePreviewPort(item);
				if (item.type == 1)
					pivot.addChild(shopFace);
			});
		}

		private function updatePreviewPort(item:Item):void
		{
			var previewOrigin:Point;
			switch (currentCat)
			{
				case "hair":
					previewOrigin = new Point(-85, -180);
					break;
				case "shirt":
					previewOrigin = new Point(-85, -230);
					break;
				case "pants":
					if (ItemType.isType(item, "长裤"))
						previewOrigin = new Point(-85, -350);
					else if (ItemType.isType(item, "长裙"))
						previewOrigin = new Point(-85, -350);
					else
						previewOrigin = new Point(-85, -280);
					break;
				case "shoes":
					previewOrigin = new Point(-85, -480);
					break;
				case "dress":
					previewOrigin = new Point(-85, -280);
					break;
			}
			scene.camera.viewPort = // 
				new Rectangle( //
				previewOrigin.x * (scene.viewPort.height / 800), //
				previewOrigin.y * (scene.viewPort.height / 800), //
				scene.viewPort.width, scene.viewPort.height);
		}

		private function setupPivotForShop(pivot:Pivot3D):void
		{
			pivot.forEach(function(mesh:Mesh3D):void
			{
				for (var i:int = 0; i < mesh.surfaces.length; i++)
				{
					var surface:Surface3D = mesh.surfaces[i];
					if (surface.material is Shader3D)
					{
						var shader:Shader3D = surface.material as Shader3D;
						var hit:Boolean = false
						for (var j:int = 0; j < shader.filters.length; j++)
						{
							var filter:FLSLFilter = shader.filters[j];
							if (filter is TextureMapFilter)
							{
								trace("how many skin??" + TextureMapFilter(filter).texture.name)
								if (/.*(sk).*.atf/.test(TextureMapFilter(filter).texture.name))
								{
									filter.enabled = false;
									hit = true;
									break;
								}
								else
								{
									shader.cullFace = TriangleCulling.NONE;
								}
							}
						}
						//如果是皮肤，surface不显示
						if (hit)
						{
							surface.visible = false;
						}
					}
				}
			}, Mesh3D);
		}

		public function updateList(cat:String):void
		{
			var owned:Array = Context.context.inventory.shop;
			var dstType:int = 0;
			currentCat = cat;
			switch (cat)
			{
				case "hair":
					dstType = 1;
					break;
				case "shirt":
					dstType = 2;
					break;
				case "pants":
					dstType = 3;
					break;
				case "shoes":
					dstType = 4;
					break;
				case "dress":
					dstType = 9;
					break;
			}

			list.removeEventListener(Event.CHANGE, list_changeHandler);
			list.dataProvider = new ListCollection(owned.filter(function(item:Item, ... args):Boolean
			{
				return item.type == dstType;
			}));
			list.addEventListener(Event.CHANGE, list_changeHandler);
		}
	}
}

import diary.res.RES;
import diary.ui.components.ItemRendererBase;

import feathers.controls.Label;
import feathers.controls.renderers.IListItemRenderer;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.filters.BlurFilter;

class ItemRenderer extends ItemRendererBase implements IListItemRenderer
{
	private var _label:Label;
	//
	private var lastIndex:int = -1;
	private var figureFrame:DisplayObject;
	private var image:Image;

	//
	override protected function initialize():void
	{
		if (!this._label)
		{
			this._label = new Label;
			this.addChild(this._label);
		}
	}

	override protected function commitData():void
	{
		drawFigureFrame();
		if (image)
		{
			image.dispose();
			removeChild(image);
		}
		if (!data)
			return;
		//
		image = new Image(RES.get(data.model));
		image.touchable = true;
		image.scaleX *= 2;
		image.scaleY *= 2;
		image.y = 10
		addChild(image);
		if (isSelected)
			image.filter = BlurFilter.createGlow(0xFF0000);
//		setSizeInternal(image.width, image.height, false);
	}

	override public function set isSelected(value:Boolean):void
	{
		super.isSelected = value;
		if (!image)
			return;
		if (value)
			image.filter = BlurFilter.createGlow(0xFF0000);
		else
			image.filter = null;
	}

	private function drawFigureFrame():void
	{
		var needToRedraw:Boolean = false;
		if (!figureFrame)
		{
			needToRedraw = true;
		}
		else
		{
			var odd:Boolean = index % 2 != 0;
			if (lastIndex % 2 != odd)
			{
				needToRedraw = true;
			}
		}
		if (!needToRedraw)
			return;
		if (figureFrame)
		{
			figureFrame.dispose();
			removeChild(figureFrame);
		}
		if (index % 2)
		{
			addChild(figureFrame = RES.get("gui/spr_itemFrameDown"));
			figureFrame.x -= 2;
		}
		else
		{
			addChild(figureFrame = RES.get("gui/spr_itemFrameUp"));
		}
		lastIndex = index;
		this.setSizeInternal(figureFrame.width - 15, figureFrame.height, false);
	}
}
