package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PNGEncoderOptions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import mx.utils.StringUtil;
	
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	import deng.fzip.FZipLibrary;
	
	import diary.avatar.AnimatedAvatar;
	import diary.avatar.AnimationTicker;
	import diary.avatar.Avatar;
	import diary.avatar.AvatarView;
	import diary.game.AvatarModel;
	import diary.game.Item;
	import diary.ui.RenderManager;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	import feathers.themes.MetalWorksDesktopTheme;
	
	import flare.basic.Scene3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Surface3D;
	import flare.flsl.FLSLFilter;
	import flare.loaders.Flare3DLoader;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureMapFilter;
	
	import starling.events.Event;
	
	import zzsdk.editor.utils.FileUtil;

	[SWF(width = "1000", height = "700", frameRate = "60")]
	public class Rating extends Sprite
	{
		[Embed(source = "flare3d.swf", mimeType = "application/octet-stream")]
		private var f3dIDE:Class;
		
		private var rMgr:RenderManager;
		private var scene:Scene3D;
		private var avatar:AnimatedAvatar;

		private var list:List;
		private var costField:NumField;
		private var prop1:NumField;
		private var prop2:NumField;
		private var prop3:NumField;
		private var prop4:NumField;
		private var prop5:NumField;
		private var tag:TField;
		private var nameField:TField;
		private var type2Field:ComboField;

		private var aModel:AvatarModel;
		private var selectedCheck:CheckField;
		private var lockCheck:CheckField;
		private var exportButton:Button;

		private var selectedItems:Array = [];
		private var selectedNumText:Label;

		private var hList:List;

		private var targetItem:Item;

		private var sList:List;
		private var genderList:List;
		private var aniList:List;

		public static var resourceRoot = "file:///E:/zz2017/dress3d/resources/";
		private var globalB:Shader3D;
		private var exporter:Object;

		public function Rating()
		{
			var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			lc.allowCodeImport = true;
			var loader:Loader = new Loader;
			loader.loadBytes(new f3dIDE, lc);
			loader.contentLoaderInfo.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function():void
			{
			});
			setupItemData();
			AvatarView.platform = "windows";

//			ItemData.

			rMgr = new RenderManager(stage);
			rMgr.addLayer("2d", "2d");
			rMgr.addLayer("3d", "3d");
			rMgr.addEventListener("layerCreated", function(event:flash.events.Event):void
			{
				new MetalWorksDesktopTheme;
				//
				scene = rMgr;

				list = new List;
				Item.addData(FileUtil.readFile(File.applicationDirectory.resolvePath("items_s.csv"), "text", "utf-8"));
				list.dataProvider = new ListCollection(Item.list);
				list.width = 160;
				list.height = 300;
				list.x = 46;
				list.itemRendererType = ItemRenderer;
				list.addEventListener("change", changeHandler);
				rMgr.getLayerRoot("2d").addChild(list);

				scene.camera.setPosition(0, 160, -800);
				scene.camera.lookAt(0, 125, 0);
				scene.camera.fieldOfView = 35;
				scene.camera.viewPort = new Rectangle(350, -170, scene.viewPort.width, scene.viewPort.height + 170);
				Avatar.platform = "windows"
				scene.addChild(avatar = new AnimatedAvatar);
				avatar.setAvatar(aModel = new AvatarModel);
				avatar.addComponent(new AnimationTicker);
//				avatar.addComponent(new RotationComponent);

				var lGroup:LayoutGroup = new LayoutGroup;
				var layout:VerticalLayout = new VerticalLayout;
				layout.gap = 2;
				lGroup.layout = layout;
				lGroup.addChild(costField = new NumField("cost", 0, 0, 999999, 50));
				lGroup.addChild(prop1 = new NumField("华丽/简约", 0, -30, 30, 1));
				lGroup.addChild(prop2 = new NumField("优雅/活泼", 0, -30, 30, 1));
				lGroup.addChild(prop3 = new NumField("成熟/可爱", 0, -30, 30, 1));
				lGroup.addChild(prop4 = new NumField("性感/清纯", 0, -30, 30, 1));
				lGroup.addChild(prop5 = new NumField("保暖/清凉", 0, -30, 30, 1));
				lGroup.addChild(tag = new TField("tag", ""));
				lGroup.addChild(nameField = new TField("名纸", ""));
				lGroup.addChild(type2Field = new ComboField("type2"));
				lGroup.addChild(selectedCheck = new CheckField("加入游戏"));
				lGroup.addChild(lockCheck = new CheckField("需要解锁"));
				lGroup.addChild(exportButton = new Button());
				exportButton.label = "导出";
				rMgr.getLayerRoot("2d").addChild(lGroup);
				lGroup.x = 240 + 155;

				exportButton.addEventListener(starling.events.Event.TRIGGERED, export);

				hList = new List;
				hList.itemRendererType = DefaultListItemRenderer;
				hList.dataProvider = new ListCollection([{"label": "头发", "type": 1}, //
					{"label": "上装", "type": 2}, //
					{"label": "裤子", "type": 3}, //
					{"label": "鞋子", "type": 4}, //
					{"label": "套装", "type": 9}, //
					]);
				rMgr.getLayerRoot("2d").addChild(hList);
				hList.addEventListener("change", function():void
				{
					updateMainList(list.selectedIndex);
					updateSelectedList();
				});
				genderList = new List;
				genderList.dataProvider = new ListCollection(["女", "男"]);
				rMgr.getLayerRoot("2d").addChild(genderList);
				genderList.x = 0
				genderList.y = 140
				genderList.selectedIndex = 0;
				genderList.addEventListener("change", function():void
				{
					updateMainList(list.selectedIndex);
					updateSelectedList();
				});

				selectedNumText = new Label();
				rMgr.getLayerRoot("2d").addChild(selectedNumText);
				selectedNumText.x = 0;
				selectedNumText.y = 305;

				selectedCheck.addEventListener("change", function():void
				{
					targetItem.selected = selectedCheck.isSelected;
					if (!targetItem.selected)
					{
						targetItem.locked = lockCheck.isSelected = false;
						lockCheck.enable(false);
						delete selectedItems[targetItem.model];
					}
					else
					{
						lockCheck.enable(true);
						selectedItems[targetItem.model] = targetItem;
					}
					updateInfo();
					list.invalidate("all");
					targetItem.render.label += (targetItem.selected ? "√" : "");
					updateSelectedList();
					updateMainList(list.selectedIndex);
				});
				lockCheck.addEventListener("change", function():void
				{
					list.selectedItem.locked = lockCheck.isSelected;
					updateInfo();
				});

				rMgr.getLayerRoot("2d").addEventListener("numChange", function():void
				{
					list.selectedItem.cost = costField.value;
					list.selectedItem.prop1 = prop1.value;
					list.selectedItem.prop2 = prop2.value;
					list.selectedItem.prop3 = prop3.value;
					list.selectedItem.prop4 = prop4.value;
					list.selectedItem.prop5 = prop5.value;
					list.selectedItem.tag = tag.value;
					list.selectedItem.name = nameField.value;
					list.selectedItem.type2 = type2Field.value;
					trace("prop changes!" + prop1.value, prop2.value, prop3.value, prop4.value, prop5.value)
				});

				sList = new List
				sList.height = 150;
				sList.x = 210;
				sList.width = 160;
				sList.height = 300;
				sList.dataProvider = new ListCollection();
				rMgr.getLayerRoot("2d").addChild(sList);
				sList.itemRendererType = ItemRenderer;
				sList.addEventListener("change", changeHandler);
				list.selectedIndex = 0;
				hList.selectedIndex = 0;

				var aniActs = [];
				var file:File = new File(resourceRoot + "res/obj/animaction")
				for each (var f:File in file.getDirectoryListing())
				{
					aniActs.push({label: f.name, url: f.url});
				}

				aniList = new List;
				aniList.dataProvider = new ListCollection(aniActs);
				rMgr.getLayerRoot("2d").addChild(aniList);
				aniList.x = 200
				aniList.y = 306
				aniList.width = 250;
				aniList.height = 288;
				aniList.selectedIndex = 0;
				aniList.addEventListener("change", function():void
				{
					avatar.sequencePose(aniList.selectedItem.url);
				})
			});
		}

		private function setupItemData():void
		{
			var data:ItemData = new ItemData;
			for (var path:String in data.filelist)
			{
				if (path.substr(path.lastIndexOf(".") + 1) == "f3d")
				{
					var p:String = path.substring(path.lastIndexOf("/") + 1, path.lastIndexOf("."));
					if (p.charAt(p.length - 2) == "_")
						p = p.substr(0, p.length - 2);
					data.filelist[p] = path;
				}
			}
			Item.filelist = data.filelist;

			var line = "";
			var d2:Array = [];
			for (var i:int = 0; i < data.items.length; i++)
			{
				var d:Array = (data.items[i] as Array);
				if (d[2] == 1)
				{
					line += d.join(", ");
					line += "\n";
					d2.push(d);
				}
			}
			FileUtil.save(line, "items.csv", true);

			line = "name	model	mcode	type	type2	subType	cost	dropLevel	prop1	prop2	prop3	prop4	prop5	\n";
			for (var i:int = 0; i < d2.length; i++)
			{
				d = d2[i];
				if (!chechModel(d))
					continue;
				if (getType(d[7]) == -1)
					continue;
				line += d[6] + "\t";
				line += d[7] + "\t";
				line += d[13] + "\t"; //t-a-e-c-b
				line += getType(d[7]) + "\t";
				line += "0" + "\t"; //type2
				line += "0" + "\t"; //sub
				line += "0" + "\t"; //cost
				line += "0" + "\t"; //droplevel
				line += "0" + "\t"; //p1
				line += "0" + "\t"; //p2
				line += "0" + "\t"; //p3
				line += "0" + "\t"; //p4
				line += "0" + "\t"; //p5
				line += "\n"
			}
			trace("ok");
			FileUtil.save(line, "items_s.csv", true);
			trace("ok!");
		}

		private function chechModel(d:Array):Boolean
		{
			var suffix = d[13];
			var model = d[7];
			var prefiex = resourceRoot;
			var filelist = Item.filelist;
			var file = prefiex + filelist[model];
			if (new File(file).exists)
				return true;
			return false;
		}

		private function getSuffix(suffix:String):String
		{
			if (StringUtil.isWhitespace(suffix))
				return "";
			return "_" + StringUtil.trim(suffix).substr(0, 1);
		}

		private function getType(n):int
		{
			var m = n.match(/(b|g)\d{4}_(.*)_dod/);
			if (!m)
			{
				return 12;
			}
			var s = m[2];
			if (s == "h")
				return 1;
			if (s == "j")
				return 2;
			if (s == "p")
				return 3;
			if (s == "s")
				return 4;
			if (s == "f")
				return -1;
			return 9;
		}

		private function updateSelectedList():void
		{
			sList.dataProvider = new ListCollection(asArray(selectedItems).filter(function(item:Item, ... args)
			{
				if (item.type == hList.selectedItem.type)
					if (getGender(item.model) == genderList.selectedIndex)
						return true;
				return false;
			}))
		}

		private function getGender(model:String):int
		{
			if (model.charAt(0) == "b")
				return 1;
			return 0;
		}

		private function updateMainList(value:int):void
		{
			list.dataProvider = new ListCollection(Item.list.filter(function(item:Item, ... args)
			{
				if (item.type == hList.selectedItem.type)
					if (selectedItems[item.model] == null)
						if (getGender(item.model) == genderList.selectedIndex)
							return true;
				return false;
			}));
			list.selectedIndex = Math.min(value, list.dataProvider.length - 1);
			list.scrollToDisplayIndex(list.selectedIndex);
		}

		private function asArray(selectedItems:Array):Object
		{
			var res = []
			for each (var i:Object in selectedItems)
			{
				res.push(i);
			}
			return res;
		}

		private function export(event):void
		{
			var g = {"game": {"p": [ /*{"id": "g5174_p_dod"}*/], //
						"s": [], //
						"x": [], //
						"h": [], //
						"g": [], //
						"j": []}}
			for each (var i:Item in selectedItems)
			{
				switch (i.type)
				{
					case 1:
						g.game.h.push({"id": i.model});
						break;
					case 2:
						g.game.j.push({"id": i.model});
						break;
					case 3:
						g.game.p.push({"id": i.model});
						break;
					case 4:
						g.game.s.push({"id": i.model});
						break;
					case 9:
						g.game.x.push({"id": i.model});
						break;
				}
			}
			FileUtil.defaultFileName = "map.json";
			FileUtil.saveAs(JSON.stringify(g));

			var n:int = 0;
			var zip:FZip = new FZip;
			var bytes:ByteArray = new ByteArray;
			var obj = {};
			var bitmapData:BitmapData = new BitmapData(2048, 2048, true, 0);
			for (var k:String in selectedItems)
			{
				obj[k] = selectedItems[k];
			}
			var atlasText = "";
			var ax:int = 1;
			var ay:int = 1;
			var r2048:Rectangle = new Rectangle(0, 0, 2048, 2048);
			//
			//
			var children:* = scene.children;
			for each (var c:Pivot3D in children)
			{
				if (c is AnimatedAvatar)
					scene.removeChild(c);
			}
			//
			//
			addNext(obj);
			function addNext(files:*):void
			{
				var file:Item = null;
				for (var k:String in files)
				{
					file = files[k];
					delete files[k];
					break;
				}
				if (file == null)
				{
					atlasText = '<TextureAtlas imagePath="texture.png">' + atlasText + "</TextureAtlas>";
					var bytesS:ByteArray = new ByteArray;
					bytesS.writeUTFBytes(atlasText);
					zip.addFile("icon/texture.png", bitmapData.encode(bitmapData.rect, new PNGEncoderOptions()));
					zip.addFile("icon/texture.xml", bytesS);
					//
					addDefaultZipFile(zip, "g_dod_body");
					addDefaultZipFile(zip, "g_dod_clothes");
					addDefaultZipFile(zip, "g_dod_clothes01");
					addDefaultZipFile(zip, "g_dod_hair01");
					addDefaultZipFile(zip, "g_dod_idle");
					addDefaultZipFile(zip, "g_dod_idlea");
					addDefaultZipFile(zip, "g_dod_idle01");
					addDefaultZipFile(zip, "g_dod_idle02");
					addDefaultZipFile(zip, "g_dod_shoes");
					addDefaultZipFile(zip, "g_dod_shoes01");
					addDefaultZipFile(zip, "g_dod_hair");
					addDefaultZipFile(zip, "g0001_f_dod");
					addDefaultZipFile(zip, "g2015_j_dod");
					addDefaultZipFile(zip, "g2015_p_dod");
					addDefaultZipFile(zip, "g2016_s_dod");
					addDefaultZipFile(zip, "g2015_h_dod");
					//
					zip.serialize(bytes, false);
					
					FileUtil.save(exporter.save(), "jiong.zf3d");
					FileUtil.save(bytes, "xxxx.zip", true);

					//Create XML from text (much faster than working with an actual XML object)
					return;
				}

				if (file.model.indexOf("_f") != -1)
				{
					setTimeout(addNext, 1, files);
					return;
				}

				addToScene(FileUtil.readFile(new File(resourceRoot + Item.filelist[file.model])), function():void
				{
					zip.addFile("model/" + file.model + ".f3d", FileUtil.readFile(new File(resourceRoot + Item.filelist[file.model])));

					var loader:Loader = new Loader();
					loader.loadBytes(FileUtil.readFile(new File(getIconPath(file))));
					loader.contentLoaderInfo.addEventListener("complete", function():void
					{
						var b:BitmapData = (loader.content as Bitmap).bitmapData;
						var rect:Rectangle = new Rectangle(0, 0, loader.content.width, loader.content.height);
						rect.x = ax;
						rect.y = ay;
						if (!r2048.containsRect(rect))
						{
							ay = rect.y += loader.content.height + 1;
							ax = rect.x = 1;
						}
						if (!r2048.containsRect(rect))
						{
							throw new Error("太多了！");
						}
						var subText:String = '<SubTexture name="' + file.model + '" ' + 'x="' + rect.x + '" y="' + rect.y + '" width="' + rect.width + '" height="' + rect.height + '" frameX="0" frameY="0" ' + 'frameWidth="' + rect.width + '" frameHeight="' + rect.height + '"/>';
						atlasText += subText;
						ax += loader.content.width + 1;
						bitmapData.copyPixels(b, b.rect, new Point(rect.x, rect.y));
						setTimeout(addNext, 1, files);
					});
				});
			}
		}

		private function addToScene(bytes:ByteArray, callback:Function):void
		{
			var loader:Flare3DLoader = new Flare3DLoader(bytes);
			loader.addEventListener("addedToScene", function():void
			{
				callback();
				for each (var p:Pivot3D in loader.children)
				{
					if (p is Mesh3D)
					{
						handleMesh(p as Mesh3D);
						if(exporter == null)
							exporter = new (getDefinitionByName("flare.exporters::ZF3DExporter"))
						exporter.add(p);
					}
				}
			})
			loader.load();
			scene.addChild(loader);
		}

		private function handleMesh(mesh:Mesh3D):void
		{
			trace("mesh name " + mesh.name);
			for (var i:int = 0; i < mesh.surfaces.length; i++)
			{
				var surface:Surface3D = mesh.surfaces[i];
				if (surface.material is Shader3D)
				{
					var s3s:Shader3D = surface.material as Shader3D;
					trace("surface " + s3s.name);
					if (s3s.name == "b")
					{
						if (globalB == null)
						{
							globalB = s3s;
						}
						else
						{
							mesh.surfaces[i].material = globalB;
						}
					}
					for each (var filter:FLSLFilter in s3s.filters)
					{
						if (filter is TextureMapFilter)
						{
							filter.params
						}
					}
				}
			}
		}

		private function addDefaultZipFile(zip:FZip, param1:String):void
		{
			if (zip.getFileByName("model/" + param1 + ".f3d") == null)
			{
				zip.addFile("model/" + param1 + ".f3d", FileUtil.readFile(new File(resourceRoot + Item.filelist[param1])));
			}
		}

		private function getIconPath(item:Item):String
		{
			var path:String = resourceRoot + "image/player/";
			var typeString = ["", "h", "j", "p", "s", "5", "6", "7", "8", "x"]
			return path + typeString[item.type] + "/" + item.model + ".png";
		}

		private function updateInfo():void
		{
			var numHair:int = 0;
			var numJack:int = 0;
			var numPants:int = 0;
			var numShoes:int = 0;
			var numSuit:int = 0;
			var numHairLocked:int = 0;
			var numJackLocked:int = 0;
			var numPantsLocked:int = 0;
			var numShoesLocked:int = 0;
			var numSuitLocked:int = 0;
			for each (var i:Item in selectedItems)
			{
				switch (i.type)
				{
					case 1:
						numHair++;
						if (i.locked)
							numHairLocked++;
						break;
					case 2:
						numJack++;
						if (i.locked)
							numJackLocked++;
						break;
					case 3:
						numPants++;
						if (i.locked)
							numPantsLocked++;
						break;
					case 4:
						numShoes++;
						if (i.locked)
							numShoesLocked++;
						break;
					case 9:
						numSuit++;
						if (i.locked)
							numSuitLocked++;
						break;
				}
			}

			selectedNumText.text = "已选中 :\n" + //
				"发型: " + numHair + "  需解锁: " + numHairLocked + // 
				"\n上装: " + numJack + "  需解锁: " + numJackLocked + // 
				"\n裤子: " + numPants + "  需解锁: " + numPantsLocked + //
				"\n鞋  : " + numShoes + "  需解锁: " + numShoesLocked + //
				"\n套装: " + numSuit + "  需解锁: " + numSuitLocked;
		}

		private function changeHandler(event:starling.events.Event):void
		{
			if (!(event.currentTarget as List).selectedItem)
				return;

			targetItem = (event.currentTarget as List).selectedItem as Item;
			aModel.updatePart(targetItem);

			costField.value = targetItem.cost;
			prop1.value = targetItem.prop1;
			prop2.value = targetItem.prop2;
			prop3.value = targetItem.prop3;
			prop4.value = targetItem.prop4;
			prop5.value = targetItem.prop5;
			tag.value = targetItem.tag;
			nameField.value = targetItem.name;
			updateType2Selection(type2Field, targetItem.type);
			type2Field.value = targetItem.type2;

			selectedCheck.isSelected = targetItem.selected;
			lockCheck.isSelected = targetItem.locked;

//			save();
		}

		private function updateType2Selection(type2Field:ComboField, type:int):void
		{
			switch (type)
			{
				case 1:
					type2Field.setSelection(["未分类发", "短发", "长直发", "长卷发", "盘发", "辫子", "帽装"])
					break;
				case 2:
					type2Field.setSelection(["未分类上", "短袖", "长袖", "比基尼", "小礼服", "睡上衣"])
					break;
				case 3:
					type2Field.setSelection(["未分类下", "短裤", "长裤", "短裙", "长裙", "泳裤", "睡裤"])
					break;
				case 4:
					type2Field.setSelection(["未分类鞋", "运动鞋", "拖鞋", "凉鞋", "短靴", "长靴", "高跟"])
					break;
				case 9:
					type2Field.setSelection(["未分类套", "礼服", "连衣裙", "睡裙", "泳装"])
					break;
			}
		}
	}
}
import diary.game.Item;

import feathers.controls.Check;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.NumericStepper;
import feathers.controls.PickerList;
import feathers.controls.TextInput;
import feathers.controls.ToggleButton;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.renderers.LayoutGroupListItemRenderer;
import feathers.data.ListCollection;
import feathers.layout.HorizontalLayout;

import starling.events.Event;

class ItemRenderer extends DefaultListItemRenderer
{
	override protected function commitData():void
	{
		super.commitData();
		var item:Item = _data as Item;
		if (item)
		{
			item.render = this;
			label = label + (item.selected ? "√" : "");
		}
	}
}

class ItemRenderer2 extends LayoutGroupListItemRenderer
{
	public function CustomLayoutGroupItemRenderer()
	{
//		this._trigger = new TapToTrigger(this);
//		this._select = new TapToSelect(this);
	}

	protected var _label:ToggleButton;

	protected var _padding:Number = 0;

	private var check:Check;
	private var _trigger:Object;
	private var _select:Object;

	public function get padding():Number
	{
		return this._padding;
	}

	public function set padding(value:Number):void
	{
		if (this._padding == value)
		{
			return;
		}
		this._padding = value;
		this.invalidate(INVALIDATION_FLAG_LAYOUT);
	}

	override protected function initialize():void
	{
		this.layout = new HorizontalLayout();
		addChild(check = new Check);
		addChild(_label = new DefaultListItemRenderer);
		_label.addEventListener(Event.CHANGE, function():void
		{
			dispatchEventWith("triggered")
		});
	}

	override protected function commitData():void
	{
		if (this._data && this._owner)
		{
			this._label.label = (this._data as Item).name;
			check.isSelected = (this._data as Item).selected;
		}
		else
		{
			this._label.label = null;
		}
	}

	override protected function preLayout():void
	{
//		var labelLayoutData:AnchorLayoutData = AnchorLayoutData(this._label.layoutData);
//		labelLayoutData.top = this._padding;
//		labelLayoutData.right = this._padding;
//		labelLayoutData.bottom = this._padding;
//		labelLayoutData.left = this._padding;
	}
}

class ComboField extends LayoutGroup
{
	private var labelField:Label;
	private var picker:PickerList;
	private var options:Array

	public function ComboField(label:String)
	{
		layout = new HorizontalLayout;
		addChild(labelField = new Label);
		addChild(picker = new PickerList);
		picker.width = 80
		this.label = label
	}

	public function get value():String
	{
		return picker.selectedItem + "";
	}

	public function set value(value:String):void
	{
		picker.removeEventListener("change", textInputChange)
		picker.selectedIndex = options.indexOf(value);
		picker.addEventListener("change", textInputChange)
	}

	private function textInputChange():void
	{
		dispatchEventWith("numChange", true);
	}

	public function set label(value:String):void
	{
		labelField.text = value;
	}

	public function setSelection(param0:Array):void
	{
		picker.removeEventListener("change", textInputChange)
		picker.dataProvider = new ListCollection(this.options = param0);
		picker.addEventListener("change", textInputChange)
	}
}

class TField extends LayoutGroup
{
	private var labelField:Label;
	private var textInput:TextInput;

	public function TField(label:String, str:String)
	{
		layout = new HorizontalLayout;
		addChild(labelField = new Label);
		addChild(textInput = new TextInput);
		this.label = label
	}

	public function get value():String
	{
		return textInput.text;
	}

	public function set value(value:String):void
	{
		textInput.removeEventListener("change", textInputChange)
		textInput.text = value;
		textInput.addEventListener("change", textInputChange)
	}

	private function textInputChange():void
	{
		dispatchEventWith("numChange", true);
	}

	public function set label(value:String):void
	{
		labelField.text = value;
	}
}

class CheckField extends LayoutGroup
{
	private var labelField:Label;
	private var check:Check;
	private var silent:Boolean;

	public function CheckField(label:String)
	{
		layout = new HorizontalLayout;
		addChild(labelField = new Label);
		addChild(check = new Check());
		check.addEventListener("change", function():void
		{
			if (!silent)
				dispatchEventWith("change");
		});
		labelField.text = label;
	}

	public function get isSelected():Boolean
	{
		return check.isSelected;
	}

	public function set isSelected(value:Boolean):void
	{
		silent = true;
		check.isSelected = value;
		silent = false;
	}

	public function enable(value:Boolean):void
	{
		check.alpha = value ? 1 : 0.5;
		check.touchable = value;
	}
}

class NumField extends LayoutGroup
{
	private var labelField:Label;
	private var stepper:NumericStepper;

	public function NumField(label:String, value:int, min = -10, max = 10, step = 1)
	{
		layout = new HorizontalLayout;
		addChild(labelField = new Label);
		addChild(stepper = new NumericStepper);
		setupStepper(min, max, step);
		this.label = label;
		this.value = value;
	}

	public function setupStepper(min, max, step):void
	{
		stepper.minimum = min;
		stepper.maximum = max;
		stepper.step = step;
	}

	public function get value():int
	{
		return stepper.value;
	}

	public function set value(value:int):void
	{
		stepper.removeEventListener("change", stepperChange)
		stepper.value = value;
		stepper.addEventListener("change", stepperChange)
	}

	public function set label(value:String):void
	{
		labelField.text = value;
	}

	protected function stepperChange():void
	{
		// TODO Auto Generated method stub
		dispatchEventWith("numChange", true);
	}

}
