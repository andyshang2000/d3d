package diary.ui.view
{
	import com.popchan.framework.utils.DataUtil;
	import com.popchan.sugar.core.Model;
	import com.popchan.sugar.core.manager.Sounds;
	
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	
	import fairygui.UIPackage;
	
	import payment.ane.PaymentANE;
	
	import zzsdk.utils.FileUtil;

	public class EnterScreen extends GScreen implements IScreen
	{
		private var firstRun:Boolean;

		override protected function doLoadAssets():void
		{
			UIPackage.addPackage( //
				FileUtil.open("zz3d.dressup.gui"), //
				FileUtil.open("zz3d.dressup@res.gui"));
			UIPackage.addPackage( //
				FileUtil.open("zz3d.m3.gui"), //
				FileUtil.open("zz3d.m3@res.gui"));
			FileUtil.dir = File.applicationStorageDirectory;
			Model.load()
		}

		override public function createLayer(name:String):*
		{
			if (name == "front")
				return super.createLayer(name);
			return null;
		}

		[Handler(clickGTouch)]
		public function startButtonClick():void
		{
			if (firstRun)
				nextScreen(DressupScreen);
			else
				nextScreen(MapScreen);
		}

		override protected function onCreate():void
		{
			setGView("zz3d.dressup.gui", "Enter");

			fit(getChild("tpage").asLoader);
			try
			{
				PaymentANE.call("ready");
			}
			catch (err:Error)
			{
			}
			//prepare ad
			transferTo("transpage");
			setTimeout(function():void
			{
				transferTo("start");
			}, 2000);
		}
	}
}

