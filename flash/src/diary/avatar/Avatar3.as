package diary.avatar
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import flare.core.Label3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Surface3D;
	import flare.loaders.Flare3DLoader;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureMapFilter;
	import flare.utils.Pivot3DUtils;
	
	import zzsdk.utils.FileUtil;
	
	public class Avatar3 extends Pivot3D
	{
		private var poseInvalid:Boolean;
		private var currentPose:String;
		private var partDic:Object = {};
		private var defaultF:String = "g0001_f_dod";
		private var defaultJ:String = "g2015_j_dod";
		private var defaultP:String = "g2015_p_dod";
		private var defaultS:String = "g2016_s_dod";
		private var defaultH:String = "g2015_h_dod";
		private var _index:int = 0;
		private var _value:Number = 0;
		private var acts:Array = [ //
			(BODY_01 = "g_dod_body"), //
			(CLOTH_01 = "g_dod_clothes"), //
			(CLOTH_02 = "g_dod_clothes01"), //
			(HAIR_01 = "g_dod_hair01"), //
			(DEFAULT = IDLE_01 = "g_dod_idle"), //
			(IDLE_02 = "g_dod_idle01"), //
			(IDLE_03 = "g_dod_idle02"), //
			(IDLE_04 = "g_dod_idlea"), //
			(SHOES_01 = "g_dod_shoes"), //
			(SHOES_02 = "g_dod_shoes01") //
		];
		private var tid:uint;
		
		private var BODY_01:String;
		private var CLOTH_01:String;
		private var CLOTH_02:String;
		private var HAIR_01:String;
		private var DEFAULT:String;
		private var IDLE_01:String;
		private var IDLE_02:String;
		private var IDLE_03:String;
		private var IDLE_04:String;
		private var SHOES_01:String;
		private var SHOES_02:String;
		
		public function Avatar3(name:String = "", //
							   defaultFace:String = "", //
							   defaultShirt:String = "", //
							   defaultPants:String = "", //
							   defaultShoes:String = "", //
							   defaultHair:String = "", //
							   currentPose:String = "")
		{
			super(name);
			this.defaultF = defaultFace || defaultF;
			this.defaultJ = defaultShirt || defaultJ;
			this.defaultP = defaultPants || defaultP;
			this.defaultS = defaultShoes || defaultS;
			this.defaultH = defaultHair || defaultH;
			setupBody();
		}
		
		public function setupBody():void
		{
			updatePart("face", defaultF, false);
			updatePart("hair", defaultH, false);
			updatePart("shirt", defaultJ, false);
			updatePart("pants", defaultP, false);
			updatePart("shoes", defaultS, false);
			updatePose(IDLE_01);
		}
		
		public function updatePart(part:String, name:String, invalidPose:Boolean = true):void
		{
			var currentPart:Pivot3D = partDic[part];
			if (currentPart != null)
			{
				if (partDic[part].name == name)
					return;
				//
			}
			
			loadF3D(name, function(content:Pivot3D):void
			{
				var currentPart:Pivot3D = partDic[part];
				var newPart:Pivot3D = content;
				addChild(newPart).name = name;
				takeOff(part);
				//set the new one to current part
				partDic[part] = newPart;
				//takeF off the old one
				if (part == "dress")
				{
					takeOff("shirt");
					takeOff("pants");
				}
				else if (part == "shirt")
				{
					if (takeOff("dress"))
						updatePart("pants", defaultP, false);
				}
				else if (part == "pants")
				{
					if (takeOff("dress"))
						updatePart("shirt", defaultJ, false);
				}
				if (part == "face")
				{
					wink();
				}
				if (!invalidPose)
				{
					return;
				}
				if (part == "shirt")
				{
					updatePose(pickFrom(CLOTH_01, CLOTH_02));
				}
				else if (part == "hair")
				{
					updatePose(HAIR_01);
				}
				else if (part == "pants")
				{
					updatePose(BODY_01);
				}
				else if (part == "shoes")
				{
					updatePose(pickFrom(SHOES_01, SHOES_02));
				}
				else if (part == "dress")
				{
					updatePose(DEFAULT);
				}
				trace("part:", part);
				_value = 0;
				wink();
			});
		}
		
		protected function animationCompleteHandler(event:Event):void
		{
			trace("animation complete: " + currentPose);
			(event.target as Mesh3D).removeEventListener(Pivot3D.ANIMATION_COMPLETE_EVENT, animationCompleteHandler);
			if (currentPose != DEFAULT)
			{
				updatePose(DEFAULT);
			}
		}
		
		private function takeOff(part:String):Boolean
		{
			if (partDic[part] != null)
			{
				Pivot3D(partDic[part]).parent = null;
				Pivot3D(partDic[part]).dispose();
				partDic[part] = null;
				return true;
			}
			return false;
		}
		
		hj hp hs jp js ps jps hjp hjs hps hjps  
		
		private function loadF3D(name:String, onLoad:Function):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("model/" + name + ".f3d");
			var bytes:ByteArray = FileUtil.readFile(file);
			var loader:Flare3DLoader = new Flare3DLoader(bytes);
			loader.addEventListener(Event.COMPLETE, function():void
			{
				onLoad(loader);
			});
			loader.load();
			addChild(loader);
		}
		
		public function updatePose(poseName:String):void
		{
			//			if (currentPose != poseName)
			//			{
			currentPose = poseName;
			poseInvalid = true;
			//			}
		}
		
		public function pickFrom(... args):String
		{
			if (args[0] is Array){
				args = args[0]
			}
			var roll:Number = int(args.length * Math.random());
			return args[roll];
		}
		
		public function updateRandomPose():void
		{
			updatePose(pickFrom(acts));
			_value = 0;
		}
		
		private function effCompleteHandler(e:Event):void
		{
			(e.target as Pivot3D).removeEventListener(Pivot3D.ANIMATION_COMPLETE_EVENT, effCompleteHandler);
			(e.target as Pivot3D).gotoAndStop(1);
		}
		
		public function tick(delta:Number):void
		{
			if (poseInvalid)
			{
				trace("loading pose: " + currentPose);
				poseInvalid = false;
				loadF3D(currentPose, poseLoaded);
				return;
			}
			_value++;
			if (_value >= 500)
			{
				_value = 0;
				updateRandomPose();
			}
		}
		
		private function poseLoaded(content:Pivot3D):void
		{
			Pivot3DUtils.removeAnimations(this);
			Pivot3DUtils.appendAnimation(this, content);
			var mesh3d:Mesh3D = getChildByName("f") as Mesh3D;
			addLabel(new Label3D(currentPose, 0, mesh3d.frames.length - 1, 1));
			mesh3d.addEventListener(Pivot3D.ANIMATION_COMPLETE_EVENT, animationCompleteHandler);
			if (currentPose == DEFAULT)
			{
				gotoAndPlay(currentPose, 0, Pivot3D.ANIMATION_LOOP_MODE);
				trace("looping pose:" + currentPose);
			}
			else
			{
				gotoAndPlay(currentPose, 0, Pivot3D.ANIMATION_STOP_MODE);
				trace("playing pose:" + currentPose);
			}
		}
		
		public function playExpression(name:String, duration:int):void
		{
			var face:Pivot3D = Pivot3D(partDic["face"]);
			var mesh3d:Mesh3D = face.getChildByName("f") as Mesh3D;
			var surface3d:Surface3D = mesh3d.surfaces[0];
			var shader3d:Shader3D = Shader3D(surface3d.material);
			var skin:TextureMapFilter = TextureMapFilter(shader3d.filters[0]);
			//			TextureMapFilter(Shader3D(mesh3d.surfaces[0].material).filters[0]).offsetX;
			//			TextureMapFilter(Shader3D(mesh3d.surfaces[0].material).filters[0]).offsetY;
			clearTimeout(tid);
			//TODO read the offset by name, replace offsetX and offsetY
			skin.offsetX = 0.5;
			skin.offsetY = 0;
			tid = setTimeout(function():void
			{
				//reset the expression to normal which is (0,0)
				skin.offsetX = 0.0001;
				skin.offsetY = 0.0;
				clearTimeout(tid);
				//
				tid = setTimeout(function():void
				{
					clearTimeout(tid);
					wink();
				}, 5000 * Math.random() + 500);
			}, duration);
		}
		
		private function wink():void
		{
			playExpression("closeEye", 150);
		}
		
		public function updateFacial():void
		{
		}
	}
}
