package zzsdk.editor.gui
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.utils.setTimeout;

	import mx.graphics.codec.PNGEncoder;
	import mx.utils.StringUtil;

	import fl.controls.CheckBox;
	import fl.controls.ComboBox;

	import nblib.util.Properties;
	import nblib.util.callLater;

	import sui.components.flash.Input;
	import sui.components.flash.PushButton;

	import zzsdk.editor.Config;
	import zzsdk.editor.IEditor;
	import zzsdk.editor.utils.AntTask;
	import zzsdk.editor.utils.BindingUtil;
	import zzsdk.editor.utils.DragDropUtils;
	import zzsdk.editor.utils.FileUtil;
	import zzsdk.services.Screenshot;

	public class InfoPanel extends InfoPanelBase
	{

		[Skin]
		[Bind("GameInfo.app_id")]
		public var appIDField:Input;
		[Skin]
		public var versionField:Input;
		[Skin]
		public var autoVersionField:TextField;
		[Skin]
		[Bind("GameInfo.game_name", setter = "setGameName", getter = "getGameName")]
		public var gamenameField:Input;
		[Skin]
		[Bind("GameInfo.managedID_936")]
		public var managedID936Field:Input;
		[Skin]
		[Bind("GameInfo.managedID_mafa")]
		public var managedIDMafaField:Input;
		[Skin]
		[Bind("GameInfo.pubChannel")]
		public var channelComboBox:ComboBox
		[Skin]
		[Bind("GameInfo.AD_provider")]
		public var adchannelCombo:ComboBox
		[Skin]
		[Bind("GameInfo.AD_ID")]
		public var adChannelField:Input
		[Bind("GameInfo.version")]
		public var autoVersion:AutoVersion;
		[Skin]
		[Bind("GameInfo.swfWidth")]
		public var swfWidth:Input
		[Skin]
		[Bind("GameInfo.swfHeight")]
		public var swfHeight:Input
		[Skin]
		[Bind("GameInfo.adPosition")]
		public var adPositionCombo:ComboBox;
		[Skin]
		public var ppField:TextField;
		[Skin]
		public var apkErrorHintField:TextField;
		[Skin]
		public var debugCheckBox:CheckBox;
		[Skin]
		public var aspectRatioBox:CheckBox;

		[Skin(optional)]
		public var joypadButton:PushButton;
		[Skin(optional)]
		[Bind("GameInfo.joyPadEnabled")]
		public var joyPadCheckBox:CheckBox;
		[Skin(optional)]
		[Bind("GameInfo.scaleMode")]
		public var scaleModeCombo:ComboBox;

		[Bind("GameInfo.joyPadSettings")]
		public var joyPad:JoyPadConfig = new JoyPadConfig;

		[Embed(source = "save2.png", mimeType = "application/octet-stream")]
		public var save2:Class;

		//
		public var editor:IEditor;

		private var screenshot:Screenshot;

		public function InfoPanel(_arg1)
		{
			super(_arg1);
			BindingUtil.updateView();
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			DragDropUtils.enable(this);
			apkErrorHintField.visible = false;

			iconSaveAsButton.addEventListener(MouseEvent.CLICK, function():void
			{
				saveIconAs();
			});
			if (iosPreviewButton)
			{
				iosPreviewButton.visible = false;
			}
		}

		override protected function postConstruct():void
		{
			autoVersion = new AutoVersion(versionField, autoVersionField);
			super.postConstruct();
		}

		protected function addedToStage(event:Event):void
		{
			removeEventListener(event.type, arguments.callee);
			appIDField.tabIndex = 1;
			versionField.tabIndex = 2;
			gamenameField.tabIndex = 3;
			managedID936Field.tabIndex = 4;
			managedIDMafaField.tabIndex = 5;
			managedIDMafaField.addEventListener(FocusEvent.FOCUS_OUT, function():void
			{
				appIDField.focus();
			})
			update();
			//
			screenSizeCombo.addEventListener(Event.CHANGE, update);
			aspectRatioBox.addEventListener(Event.CHANGE, update);
			debugCheckBox.addEventListener(Event.CHANGE, update);
			adchannelCombo.addEventListener(Event.CHANGE, update);
			joyPadCheckBox.addEventListener(Event.CHANGE, update);
			joyPadCheckBox.selected = false;

			screenshot = new Screenshot;
			screenshot.start();
			screenshotButton.enable(false);
			screenshotButton.alpha = 0.5;
			screenshotButton.addEventListener(MouseEvent.CLICK, function():void
			{
				screenshot.request();
			});
			screenshot.addEventListener("start", function():void
			{
				screenshotButton.enable(true);
				screenshotButton.alpha = 1;
			});
			screenshot.addEventListener("close", function():void
			{
				screenshotButton.enable(false);
				screenshotButton.alpha = 0.5;
			});
		}

		public function update(event:Event = null):void
		{
			if (screenSizeCombo.selectedIndex == -1)
			{
				screenSizeCombo.selectedIndex = 0;
			}
			AntTask.defaultAspectRatio = aspectRatioBox.selected ? "portrait" : "landscape";
			trace("SET defaultAspectRatio to:" + AntTask.defaultAspectRatio)
			AntTask.defaultPreviewSize = screenSizeCombo.selectedLabel;
			autoVersion.update(appIDField.text);

			updateIOS();
			updateAdChannel();
			updateJoyPad();
		}

		private function updateJoyPad():void
		{
			if (joyPadCheckBox.selected)
			{
				joypadButton.enable(true);
				joypadButton.alpha = 1;
				joypadButton.addEventListener(MouseEvent.CLICK, joyPadHandler);
			}
			else
			{
				joypadButton.enable(false);
				joypadButton.alpha = 0.5
				joypadButton.removeEventListener(MouseEvent.CLICK, joyPadHandler);
			}
		}

		protected function joyPadHandler(event:MouseEvent):void
		{
			if (joyPad.parent)
			{
				joyPad.visible = false;
				removeChild(joyPad);
			}
			else
			{
				joyPad.visible = true;
				addChild(joyPad);
			}
		}

		private function updateAdChannel():void
		{
			if (adchannelCombo.selectedIndex == -1)
			{
				adchannelCombo.selectedIndex = 0;
			}
			if (adchannelCombo.selectedIndex == 0)
			{
				adChannelField.enabled = false;
			}
			else
			{
				adChannelField.enabled = true;
			}
		}

		private function getPPFile():File
		{
			var ppFilename:String = debugCheckBox.selected ? "0.mobileprovision" : "1.mobileprovision"
			var file:File = File.applicationDirectory.resolvePath(Config.DEPLOY_DIR + "/" + ppFilename);
			return file;
		}

		private function updateIOS():void
		{
			var file:File = getPPFile()
			if (file.exists)
			{
				editor.importBytes(file.name, FileUtil.readFile(file));
				ipaButton.enable(true);
				ipaButton.alpha = 1
			}
			else
			{
				ppField.htmlText = StringUtil.substitute("缺少mobileprovision文件，\r请将<b><font color='#FF3333'>{0}</font></b>版的mobileprovision文件拖进来", debugCheckBox.selected ? "develop" : "release")
				ipaButton.enable(false);
				ipaButton.alpha = 0.6
			}
		}

		public function linkTo(editor:IEditor):void
		{
			this.editor = editor;
			editor.addImporter(new MobileprovisionImporter(this));
			editor.addImporter(new InfoImporter);
			editor.addImporter(new IconImporter(this));
			editor.addImporter(new QdrxImporter(editor));
		}

		public function saveIconAs():void
		{
			var file:File = new File;
			file.save(new save2, "icon.png");
			file.addEventListener(Event.SELECT, function():void
			{
				setTimeout(function():void
				{
					var p:Properties = Properties.readFile("screenshot.txt");
					var append:Array = [];
					for each (var value:String in p)
					{
						if (/^\d+$/.test(StringUtil.trim(value)) && int(value) > 0)
						{
							append.push(value);
						}
					}
					saveIcon(null, file.parent.nativePath, append);
				}, 50);
			});
		}

		public function saveIcon(iconDisplayObject:DisplayObject = null, targerDir:String = null, append:Array = null):void
		{
			if (!iconDisplayObject)
			{
				iconDisplayObject = getChildByName("iconContainer");
			}
			if (!targerDir)
			{
				targerDir = Config.DEPLOY_DIR;
			}

			var xml:XML = Config.appXml;
			var ns:Namespace = xml.namespace();
			var icon:XMLList = xml.ns::icon;
			var node:XML = icon[0];
			var list:XMLList = icon.children();
			var len:int = list.length();
			var filelist:Array = [];
			for (var i:int = 0; i < list.length(); i++)
			{
				trace(list[i].text());
				filelist.push(list[i].text())
			}
			filelist.push("2/512.png", "2/1024.png");
			if (append)
			{
				for (i = 0; i < append.length; i++)
				{
					var filename:String = "2/" + append[i] + ".png"
					if (filelist.indexOf(filename) == -1)
					{
						filelist.push(filename);
					}
				}
			}

			for (i = 0; i < filelist.length; i++)
			{
				var d:int = int(/\d\/(\d+).png/.exec(filelist[i])[1]);
				var bitmapData:BitmapData = new BitmapData(d, d, true, 0);
				var scale:Number = d / iconDisplayObject.width
				bitmapData.draw(iconDisplayObject, new Matrix(scale, 0, 0, scale));
				FileUtil.save(new PNGEncoder().encode(bitmapData), targerDir + "/" + filelist[i], //
					true);
				callLater(bitmapData.dispose);
			}
		}
	}
}
import flash.display.Bitmap;
import flash.display.BlendMode;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.filesystem.File;
import flash.globalization.DateTimeFormatter;
import flash.utils.ByteArray;

import mx.utils.StringUtil;

import deng.fzip.FZip;
import deng.fzip.FZipFile;

import fl.controls.ComboBox;

import nblib.util.res.ResManager;
import nblib.util.res.formats.ImageRes;

import zzsdk.editor.Config;
import zzsdk.editor.ImporterBase;
import zzsdk.editor.gui.InfoPanel;
import zzsdk.editor.utils.BindingUtil;
import zzsdk.editor.utils.DragDropUtils;
import zzsdk.editor.utils.FileUtil;

class InfoImporter extends ImporterBase
{
	override public function validate(filename:String):Boolean
	{
		return filename == "info.properties";
	}

	override public function importBytes(filename:String, bytes:ByteArray):void
	{
		GameInfo.unserialize(bytes);
		BindingUtil.updateView();
	}
}

class MobileprovisionImporter extends ImporterBase
{
	private var infoPanel:InfoPanel;

	private var currentAppid:String;
	private var currentType:String
	private var currentCreateDate:Date;

	public function MobileprovisionImporter(infoPanel:InfoPanel)
	{
		this.infoPanel = infoPanel;
	}

	override public function validate(filename:String):Boolean
	{
		return filename.substr(-"mobileprovision".length).toLowerCase() == "mobileprovision";
	}

	override public function importBytes(filename:String, bytes:ByteArray):void
	{
		var str:String = String(bytes);
		str = str.substring(str.indexOf("<?xml"), str.indexOf("</plist>") + "</plist>".length);
		trace(str)
		var xml:XML = XML(str);
		var output:Object = {};
		parseDict(output, xml.dict[0]);

		var type:String;
		if (output.hasOwnProperty("ProvisionedDevices"))
			type = "develop"
		else
			type = "release"
		var appid:String = output.Entitlements["application-identifier"];
		var createDate:Date = output.CreationDate;
		var ppFilename:String = type == "release" ? "1.mobileprovision" : "0.mobileprovision";
		if (currentType != type || //
			currentAppid != appid || //
			(currentCreateDate < createDate))
		{
			currentType = type;
			currentAppid = appid;
			currentCreateDate = createDate;
			FileUtil.save(bytes, File.applicationDirectory.resolvePath(Config.DEPLOY_DIR + "/" + ppFilename).nativePath, true);
			//
			infoPanel.debugCheckBox.selected = (currentType == "develop");
			infoPanel.appIDField.text = currentAppid.substr(currentAppid.indexOf(".") + 1);

			var fmt:DateTimeFormatter = new DateTimeFormatter("beijing");
			fmt.setDateTimePattern("yyyy-MM-dd HH:mm:ss");
			infoPanel.ppField.htmlText = output.AppIDName + "|<b><font color='#FF3333'>" + type + "</font></b>\r" + fmt.format(createDate) + "";
			infoPanel.update();
		}
	}

	private function parseDict(output:Object, xml:XML):void
	{
		var children:XMLList = xml.children();
		var length:int = children.length();
		var key:String
		for (var i:int = 0; i < length; i++)
		{
			var node:XML = children[i];
			if (node.name() == "key")
			{
				key = node;
			}
			else
			{
				switch (node.name().toString())
				{
					case "string":
						output[key] = node.text() + "";
						break;
					case "integer":
						output[key] = parseInt(node.text());
						break;
					case "dict":
						output[key] = {};
						parseDict(output[key], node);
						break;
					case "date":
						output[key] = new Date(Date.parse(formatDate(node.text())));
						break;
					case "array":
						output[key] = [];
						break;
					default:
						output[key] = "not supported type";
						break;
				}
			}
		}
	}

	private function formatDate(str:String):String
	{
		var match:Array = /(\d{4})-(\d{2})-(\d{2})\w?(\d\d:\d\d:\d\d)\w?/.exec(str)
//		2014-12-18T05:20:55Z
		if (match)
		{
//			MM/DD/YYYY HH:MM:SS TZD
			return StringUtil.substitute("{1}/{2}/{0} {3}", match[1], match[2], match[3], match[4]) //
		}
		return "01/01/1970 00:00:00";
	}
}

class IconImporter extends ImporterBase
{
	private var agent:InfoPanel;
	private var bitmap:Bitmap;
	private var round:Bitmap;
	private var iosMask:Bitmap;

	private var container:Sprite;

	[Embed(source = "ios7.1024.png")]
	private var iosTemplate:Class;

	public function IconImporter(agent:InfoPanel)
	{
		this.agent = agent;
		//
		container = new Sprite;
		container.name = "iconContainer"
		container.addChild(round = new Bitmap)
		container.addChild(iosMask = new iosTemplate)
		iosMask.width = 250;
		iosMask.height = 250;

		container.blendMode = BlendMode.LAYER;
		iosMask.blendMode = BlendMode.ALPHA;

		agent.addChild(container);
		container.x = 484;
		container.y = 25;
		//
		agent.iconField.text = "";

		var fileDir:File = File.applicationDirectory.resolvePath(Config.ZZSDK + "/icon-round")
		var arr:Array = fileDir.getDirectoryListing();
		for (var i:int = 0; i < arr.length; i++)
		{
			var filename:String = File(arr[i]).name;
			filename = filename.substring(0, filename.lastIndexOf(arr[i].extension) - 1);
			agent.iconRoundCombo.dataProvider.addItem({label: filename, data: arr[i].url})
		}
		agent.iconRoundCombo.addEventListener(Event.CHANGE, changeHandler);
	}

	protected function changeHandler(event:Event):void
	{
		var combo:ComboBox = agent.iconRoundCombo;
		if (combo.selectedIndex == 0)
		{
			round.visible = false;
//			round.bitmapData = null
		}
		else
		{
			ResManager.getResAsync(combo.selectedItem.data, function(res:ImageRes):void
			{
				round.bitmapData = res.bitmapData;
				round.width = 250;
				round.height = 250;
				round.visible = true;
			});
		}
	}

	override public function get priority():int
	{
		return -1;
	}

	override public function get terminate():Boolean
	{
		return true;
	}

	override public function validate(filename:String):Boolean
	{
		if (filename == "2/1024.png")
		{
			return true;
		}
		if (DragDropUtils.currentTrigger != agent)
		{
			return false;
		}
		var ext:String = filename.substr(-4)
		if (ext == ".png" || ext == ".jpg")
		{
			return true;
		}
		return false;
	}

	override public function importBytes(filename:String, bytes:ByteArray):void
	{
		var loader:Loader = new Loader;
		loader.loadBytes(bytes);
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);
			var bitmap:Bitmap = loader.content as Bitmap;
			agent.iconField.text = bitmap.width + "x" + bitmap.height;

			showOnIconPreview(bitmap);
		})
	}

	private function showOnIconPreview(bitmap:Bitmap):void
	{
		if (this.bitmap)
		{
			this.bitmap.bitmapData.dispose();
			container.removeChild(this.bitmap);
		}
		this.bitmap = bitmap;
		bitmap.smoothing = true;
		bitmap.width = 250;
		bitmap.height = 250;
		round.width = 250;
		round.height = 250;
		container.addChildAt(bitmap, 0);
	}
}

class QdrxImporter extends ImporterBase
{
	private var zip:FZip //FZip;
	private var agent:*;

	public function QdrxImporter(agent:*)
	{
		this.agent = agent
	}

	override public function validate(filename:String):Boolean
	{
		return filename.substr(-5).toLowerCase() == ".qdrx";
	}

	override public function importBytes(filename:String, bytes:ByteArray):void
	{
		zip = new FZip;
		zip.addEventListener(Event.COMPLETE, zip_completeHandler);
		zip.loadBytes(bytes);
	}

	protected function zip_completeHandler(event:Event):void
	{
		var count:int = zip.getFileCount();
		for (var i:int = 0; i < count; i++)
		{
			var f:FZipFile = zip.getFileAt(i);
			agent.importBytes(f.filename, f.content);
		}
	}
}
