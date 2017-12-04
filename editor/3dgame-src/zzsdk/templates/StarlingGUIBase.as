package zzsdk.templates
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	
	import feathers.controls.ScreenNavigator;
	
	import lzm.starling.swf.Swf;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import sui.utils.stlSWFUtil;

	public class StarlingGUIBase extends Sprite
	{
//		private var loading:LoadingUI;
		public var loadingResName:String = "Loading";

		protected var resList:Array;

		protected var _navigator:ScreenNavigator = new ScreenNavigator;
		public static var defaultScreen:String = "main_menu";

		public function StarlingGUIBase()
		{
			Swf.init(this);
			addEventListener(starling.events.Event.ADDED_TO_STAGE, init);
		}

		private function init(e:starling.events.Event = null):void
		{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE, init);
			addChild(_navigator);
			loadStarlingResources();
		}

		protected function loadStarlingResources():void
		{
			var total:Number = 0;
			for (var i:int = 0; i < resList.length; i++)
			{
				for each (var value:Number in resList[i])
				{
					total += value;
				}
			}
//			loading.setTotal(total);

			loadNext(resList);
		}

		private function loadNext(arr:Array):void
		{
			if (arr.length == 0)
			{
				boot()
				return;
			}

			var conf:Object = arr.pop();
			var name:String;
			var weight:Number;
			for (var key:String in conf)
			{
				name = key;
				weight = conf[key];
			}
			var file:File = File.applicationDirectory.resolvePath("res/" + name + "/");
			stlSWFUtil.loadQueueFromFile(file, name, function(ratio:Number):void
			{
//				loading.advance(ratio * weight);
				if (ratio == 1)
				{
//					loading.commitSegment(weight);
					loadNext(arr);
					
				}
			});
		}

		protected function boot():void
		{
		
		}
	}
}
import zzsdk.game.GameView;

class LoadingUI extends GameView
{
	private var committed:Number = 0;
	private var total:Number = 0;

	public function LoadingUI()
	{
		super("Loading/spr_loading");
	}

	public function setTotal(total:Number):void
	{
		this.total = total;
	}

	public function commitSegment(value:Number):void
	{
		committed += value;
	}

	public function advance(value:Number):void
	{
		trace(Number(100 * (committed + value) / total).toFixed(0) + "%")
	}
}
