package zzsdk.editor
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.DropShadowFilter;

	import sui.plugins.PluginManager;
	import sui.skinning.flash.AutoLabel;
	import sui.skinning.flash.BindingPlugin;
	import sui.skinning.flash.flashSkinning;

	import zzsdk.editor.gui.InfoPanel;
	import zzsdk.editor.utils.AntTask;
	import zzsdk.editor.utils.BindingUtil;
	import zzsdk.editor.utils.Client;
	import zzsdk.editor.utils.FileUtil;
	import zzsdk.utils.FontUtil;

	public class EditorBase extends DragSupportedEditor
	{
		public var infoButton:Sprite = new _InfoButton;
		public var infoPanel:InfoPanel;

		public function EditorBase()
		{
			PluginManager.add(new flashSkinning);
			PluginManager.add(new AutoLabel);
			PluginManager.add(new BindingPlugin);

			Config.initialize();

			infoPanel = new InfoPanel(InfoPanelAsset);
			infoPanel.linkTo(this);

			addEventListener(Event.ADDED_TO_STAGE, addedToStage);

			var nApp:NativeApplication = NativeApplication.nativeApplication;
			nApp.addEventListener(InvokeEvent.INVOKE, function(event:InvokeEvent):void
			{
				var args:Array = event.arguments
				for (var i:int = 0; i < args.length; i++)
				{
					if (args[i] == "-f")
					{
						i++;
						if (i < args.length)
						{
							AntTask.bfile = args[i]
						}
					}
				}
				trace(">>>>>>>>>>>>>>>" + AntTask.bfile);
				Client.call(Config.ant.nativePath + " " + "clean copy -f " + AntTask.bfile);
			});
			nApp.addEventListener(Event.EXITING, function():void
			{
				Client.closeAll();
				Client.call(Config.ant.nativePath + " " + "clean -f " + AntTask.bfile);
			});
		}

		protected function addedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			stage.addChild(infoButton);
			infoButton.useHandCursor = true;
			infoButton.buttonMode = true;
			infoButton.addEventListener(MouseEvent.CLICK, function():void
			{
				infoPanel.visible = true;
				infoButton.parent.addChild(infoPanel);
				infoPanel.show();
				infoPanel.filters = [new DropShadowFilter(5, 45, 0, 0.6, 3, 3, 1, 2)]
			})

			var fontFile:File = new File(File.userDirectory.resolvePath(".zzfonts").nativePath);
			var path:String = File.applicationDirectory.resolvePath(Config.ZZSDK + "/tools/FontEditor/Main.exe").nativePath;
			if (!fontFile.exists)
			{
				Client.call(path, Config.ZZSDK);
			}
			else
			{
				var currFonts:Array = FontUtil.getAll();
				var oldFonts:Array = fontFile.getDirectoryListing();
				if (currFonts.length > oldFonts.length)
				{
					trace(Config.ZZSDK);
					Client.call(path, Config.ZZSDK);
				}
			}
		}

		public function writeBack():void
		{
			BindingUtil.updateModel();
			BindingUtil.writeBack();
			FileUtil.save(GameInfo.serialize(), Config.DEPLOY_DIR + "/info.properties", true);
		}
	}
}
