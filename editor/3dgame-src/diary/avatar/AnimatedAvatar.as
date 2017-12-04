package diary.avatar
{
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import diary.game.Item;
	import diary.res.ZF3D;

	import flare.core.Label3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Surface3D;
	import flare.loaders.Flare3DLoader;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureMapFilter;
	import flare.utils.Pivot3DUtils;

	import nblib.util.res.ResManager;

	public class AnimatedAvatar extends AvatarView
	{
		public static var ACT_NORMAL:String = "assets/act/g_dod_idle.f3d";
		public static var platform:String = "android";

		private var validCount:int = 0;

		private var poseInvalid:Boolean;
		private var currentPose:String;
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
		private var face:Flare3DLoader;
		private var poseSequence:Array = [];

		public function AnimatedAvatar()
		{
			face = new Flare3DLoader("assets/g0001_f_dod.zf3d");
			face.load()
			addChild(face);
		}

		public function get poseInQueue():Boolean
		{
			return _poseInQueue;
		}

		public function set poseInQueue(value:Boolean):void
		{
			_poseInQueue = value;
		}

		override protected function completeHandler(event:Event):void
		{
			updatePoseByPart(lastItem.type)
			poseInvalid = true;
		}

		private function updatePoseByPart(part:int):Boolean
		{
			if (validCount++ % 5 != 0)
			{
				return updatePose(ACT_NORMAL);
			}
			if (part == 2)
			{
				return updatePose(acts[1]);
			}
			else if (part == 1)
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
			else if (part == 3)
			{
				return updatePose(acts[0]);
			}
			else if (part == 4)
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
		
		public function sequencePose(poseName:String):void
		{
			poseSequence.push(poseName);
			if (poseSequence.length == 1)
			{
				updatePose(poseName);
			}
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
			var aa:Array = ["assets/act/g_dod_idle01.f3d", //5
				"assets/act/g_dod_idle02.f3d", //6
				"assets/act/g_dod_idlea.f3d" //7
				]
			var i:int = Math.random() * aa.length;
			updatePose(aa[i]);
			_value = 0;
		}

		public function tick(delta:Number):void
		{
			if (poseInvalid && !poseInQueue)
			{
				//				trace("loading pose: " + currentPose);
				poseInvalid = false;
				poseInQueue = true;
				ResManager.getResAsync(currentPose, poseLoaded);
				return;
			}
			_value++;
			if (_value >= 500)
			{
				_value = 0;
//				updateRandomPose();
			}
		}

		private function poseLoaded(zf3d:ZF3D):void
		{
			poseInQueue = false;
			currentAnimation = zf3d.content;
			applyAnimation();
			show();
			removeUnused();
		}

		private function applyAnimation():void
		{
			gotoAndStop(0);
			show();
			Pivot3DUtils.removeAnimations(this);
			Pivot3DUtils.appendAnimation(this, currentAnimation);
			var mesh3d:Mesh3D = face.getChildByName("f") as Mesh3D;
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
	}
}
