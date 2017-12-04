package diary.avatar

{
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import diary.res.ZF3D;

	import flare.core.Label3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Surface3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureMapFilter;
	import flare.utils.Pivot3DUtils;

	import nblib.util.res.ResManager;

	public class Avatar extends Pivot3D
	{
		public static var ACT_NORMAL:String = "assets/act/g_dod_idle.f3d";
		public static var platform:String = "android";

		private var poseInvalid:Boolean;
		private var currentPose:String;
		private var partDic:Object = {}; //ZF3D
		private var defaultF:String;
		private var defaultJ:String;
		private var defaultP:String;
		private var defaultS:String;
		private var defaultH:String;
		private var _index:int = 0;
		private var _value:Number = 0;
		private var acts:Array = [ //
			"assets/act/g_dod_body.f3d", //0
			"assets/act/g_dod_clothes.f3d", //1
			"assets/act/g_dod_clothes01.f3d", //2
			"assets/act/g_dod_hair01.f3d", //3
			"assets/act/g_dod_idlea.f3d", //4
			"assets/act/g_dod_idle01.f3d", //5
			"assets/act/g_dod_idle02.f3d", //6
			"assets/act/g_dod_idlea.f3d", //7
			"assets/act/g_dod_shoes.f3d", //9
			"assets/act/g_dod_shoes01.f3d", //10
			"assets/act/g_dod_hair.f3d" //11
			];
		private var tid:uint;
		private var _poseInQueue:Boolean;
		private var currentAnimation:Pivot3D;
		private var numInQueue:int = 0;
		private var poseSequence:Array;

		ResManager.mapResource("zf3d", ZF3D);
		ResManager.mapResource("f3d", ZF3D);

		public function Avatar(name:String = "", //
			defaultFace:String = "", //
			defaultShirt:String = "", //
			defaultPants:String = "", //
			defaultShoes:String = "", //
			defaultHair:String = "")
		{
			super(name);
			this.defaultF = defaultFace;
			this.defaultJ = defaultShirt;
			this.defaultP = defaultPants;
			this.defaultS = defaultShoes;
			this.defaultH = defaultHair;
			setupBody();
			poseSequence = [];
		}

		public function get poseInQueue():Boolean
		{
			return _poseInQueue;
		}

		public function set poseInQueue(value:Boolean):void
		{
			_poseInQueue = value;
		}

		public function setupBody():void
		{
//			hide();
			loadPart(defaultF, "assets/" + defaultF);
			loadPart(defaultJ, "assets/" + defaultJ);
			loadPart(defaultP, "assets/" + defaultP);
			loadPart(defaultS, "assets/" + defaultS);
			loadPart(defaultH, "assets/" + defaultH);
			addEventListener(Event.COMPLETE, function(event:Event):void
			{
				removeEventListener(Event.COMPLETE, arguments.callee);
				updatePose(ACT_NORMAL);
				playExpression("normal", 100);
			});
		}

		public function updatePart(name:String, folder:String = null, check:Boolean = true):void
		{
			var match:Array = /(g|b)\d{4}_(\w+)_dod/.exec(name + "");
			var type:String = match[2];
			var path:String = "assets" + (folder || ("/" + platform + "/")) + name;
			if (folder == null)
				path += "/gg.zf3d";

			loadPart(name, path, function(zf3d:ZF3D):void
			{
				if (!updatePoseByPart(type))
				{
					applyAnimation();
				}
				_value = 0;
			});
		}

		protected function resourceProxy(str:String):String
		{
			return str;
		}

		private function loadPart(name:String, path:String, callback:Function = null):void
		{
			var match:Array = /(g|b)\d{4}_(\w+)_dod/.exec(name + "");
			var type:String = match[2];
			var zf3d:ZF3D = partDic[type.charAt(0)];
			if (zf3d != null && zf3d.content.name == name)
				return;
			//
			numInQueue++;
			ResManager.getResAsync(resourceProxy(path), function(zf3d:ZF3D):void
			{
				numInQueue--;
//				zf3d.content.hide();
				takeOff(type);
				addChild(zf3d.content).name = name;
				for (var i:int = 0; i < type.length; i++)
				{
					partDic[type.charAt(i)] = zf3d;
				}

				if (numInQueue == 0)
				{
					dispatchEvent(new Event(Event.COMPLETE));
				}
				if (callback)
				{
					callback(zf3d);
				}
			});
		}

		private function updatePoseByPart(part:String):Boolean
		{
			if (part == "j")
			{
				return updatePose(acts[1]);
			}
			else if (part == "h")
			{
				if (Math.random() > 0.5)
				{
					return updatePose(acts[3]);
				}
				else
				{
					return updatePose(acts[10]);
				}

			}
			else if (part == "p")
			{
				return updatePose(acts[0]);
			}
			else if (part == "s")
			{
				if (Math.random() > 0.5)
				{
					return updatePose(acts[9]);
				}
				else
				{
					return updatePose(acts[10]);
				}
			}
			return updatePose(acts[1]);
		}

		protected function animationCompleteHandler(event:Event):void
		{
			(event.target as Mesh3D).removeEventListener(Pivot3D.ANIMATION_COMPLETE_EVENT, animationCompleteHandler);
			//检查两次，队列弹出一个，这个动作是正在执行的
			if (poseSequence.length > 0)
			{
				poseSequence.shift();
			}
			//正在执行的动作弹出了，如果队列补位空，执行队列首
			if (poseSequence.length > 0)
			{
				updatePose(poseSequence[0]);
			}
			else if (currentPose != ACT_NORMAL)
			{
				updatePose(ACT_NORMAL);
			}
		}

		private function takeOff(part:String):void
		{
			for (var i:int = 0; i < part.length; i++)
			{
				var p:String = part.charAt(i);
				var zf3d:ZF3D = partDic[p];

				if (zf3d != null)
				{
					zf3d.content.parent = null;
					ResManager.removeRes(zf3d.path);
					partDic[part] = null;
				}
			}
		}

		public function sequencePose(poseName:String):void
		{
			poseSequence.push(poseName);
			if (poseSequence.length == 1)
			{
				updatePose(poseName);
			}
		}

		public function updatePose(poseName:String):Boolean
		{
			if (poseName == null)
				throw new Error("pos name cannot be null")
			if (currentPose != poseName)
			{
				currentPose = poseName;
				poseInvalid = true;
				return true;
			}
			return false;
		}

		public function updateRandomPose():void
		{
			var i:int = Math.random() * acts.length;
			updatePose(acts[i]);
			_value = 0;
		}

		public function tick(delta:Number):void
		{
			if (poseInvalid && !poseInQueue)
			{
//				trace("loading pose: " + currentPose);
				poseInvalid = false;
				poseInQueue = true;
				ResManager.getResAsync(resourceProxy(currentPose), poseLoaded);
				return;
			}
			_value++;
			if (_value >= 500)
			{
				_value = 0;
				updateRandomPose();
			}
		}

		private function poseLoaded(zf3d:ZF3D):void
		{
//			trace("avatar pose:", currentPose);
			poseInQueue = false;
			currentAnimation = zf3d.content;
			applyAnimation();
		}

		private function applyAnimation():void
		{
			gotoAndStop(0);
			show();
			Pivot3DUtils.removeAnimations(this);
			Pivot3DUtils.appendAnimation(this, currentAnimation);
			var mesh3d:Mesh3D = getChildByName("f") as Mesh3D;
			addLabel(new Label3D(currentPose, 0, mesh3d.frames.length - 1, 1));
			mesh3d.addEventListener(Pivot3D.ANIMATION_COMPLETE_EVENT, animationCompleteHandler);
			if (currentPose == ACT_NORMAL)
			{
				gotoAndPlay(currentPose, 0, Pivot3D.ANIMATION_LOOP_MODE);
//				trace("looping pose:" + currentPose);
			}
			else
			{
				gotoAndPlay(currentPose, 0, Pivot3D.ANIMATION_STOP_MODE);
//				trace("playing pose:" + currentPose);
			}
		}

		public function playExpression(name:String, duration:int):void
		{
			var face:Pivot3D = Pivot3D(partDic["f"].content);
			var mesh3d:Mesh3D = face.getChildByName("f") as Mesh3D;
			var surface3d:Surface3D = mesh3d.surfaces[0];
			var shader3d:Shader3D = Shader3D(surface3d.material);
			var skin:TextureMapFilter = TextureMapFilter(shader3d.filters[0]);
			clearTimeout(tid);
			//TODO read the offset by name, replace offsetX and offsetY
			skin.offsetX = 0.5;
			skin.offsetY = 0;
			tid = setTimeout(function():void
			{
				skin.offsetX = 0.0001;
				skin.offsetY = 0.0;
				clearTimeout(tid);
			}, duration);
		}

		public function updateFacial():void
		{
		}

		override public function dispose():void
		{
			takeOff("hjpsf")
			super.dispose();
		}
	}
}
