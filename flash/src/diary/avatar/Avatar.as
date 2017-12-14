package diary.avatar

{
	import com.greensock.TweenLite;

	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import diary.res.ResManager;
	import diary.res.ZF3D;

	import flare.core.Label3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.core.Surface3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureMapFilter;
	import flare.utils.Pivot3DUtils;

	public class Avatar extends Pivot3D
	{
		public static var ACT_NORMAL:String = "g_dod_idle";
		public static var platform:String = "android";

		private var poseInvalid:Boolean;
		private var currentPose:String;
		private var partDic:Object = {}; //ZF3D
		private var defaultF:String = "g0001_f_dod";
		private var defaultJ:String = "g2015_j_dod";
		private var defaultP:String = "g2015_p_dod";
		private var defaultS:String = "g2016_s_dod";
		private var defaultH:String = "g2015_h_dod";
		private var _index:int = 0;
		private var acts:Array = [ //
			"g_dod_body", //0
			"g_dod_clothes", //1
			"g_dod_clothes01", //2
			"g_dod_hair01", //3
			"g_dod_idlea", //4
			"g_dod_idle01", //5
			"g_dod_idle02", //6
			"g_dod_idlea", //7
			"g_dod_shoes", //9
			"g_dod_shoes01", //10
			"g_dod_hair" //11
			];
		
		private var useful:Array = [
		"pl_props_act_058" +
		""]
		private var tid:uint;
		private var _poseInQueue:Boolean;
		private var currentAnimation:Pivot3D;
		private var numInQueue:int = 0;
		private var poseSequence:Array;
		private var defaultPoseCD:int = 500;
		private var poseCD:int = defaultPoseCD

		public function Avatar(name:String = "", //
			defaultFace:String = "", //
			defaultShirt:String = "", //
			defaultPants:String = "", //
			defaultShoes:String = "", //
			defaultHair:String = "")
		{
			super(name);
			this.defaultF = defaultFace || defaultF;
			this.defaultJ = defaultShirt || defaultJ;
			this.defaultP = defaultPants || defaultP;
			this.defaultS = defaultShoes || defaultS;
			this.defaultH = defaultHair || defaultH;
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
			loadPart(defaultF);
			loadPart(defaultJ);
			loadPart(defaultP);
			loadPart(defaultS);
			loadPart(defaultH);
			addEventListener(Event.COMPLETE, function(event:Event):void
			{
				removeEventListener(Event.COMPLETE, arguments.callee);
				updatePose(ACT_NORMAL);
				playExpression("normal", 100);
			});
		}

		public function updatePart(name:String, check:Boolean = true):void
		{
			var match:Array = /(g|b)\d{4}_(\w+)_dod/.exec(name + "");
			var type:String = match[2];

			loadPart(name, function():void
			{
				if (!updatePoseByPart(type))
				{
					applyAnimation();
				}
			});
		}

		private function loadDefault(part:String):void
		{
			loadPart(this["default" + (part.toUpperCase())]);
		}

		private function loadPart(name:String, callback:Function = null):void
		{
			var match:Array = /(g|b)\d{4}_(\w+)_dod/.exec(name + "");
			var type:String = match[2];
			var zf3d:ZF3D = partDic[type.charAt(0)];
			if (zf3d != null && zf3d.content.name == name)
				return;
			//
			numInQueue++;
			var t:Number = getTimer();
			loadF3D(name, function(zf3d:ZF3D):void
			{
				numInQueue--;
//				zf3d.content.hide();
				takeOff(type);
				addChild(zf3d.content);
				trace(getTimer() - t);
				for (var i:int = 0; i < type.length; i++)
				{
					partDic[type.charAt(i)] = zf3d;
				}
				for (i = 0; i < "fhjps".length; i++)
				{
					if (partDic["fhjps".charAt(i)] == null)
					{
						loadDefault("FHJPS".charAt(i));
					}
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

		protected function updatePoseByPart(part:String):Boolean
		{
			return updatePose(getPoseByPart(part));
		}

		protected function getPoseByPart(part:String):String
		{
			// TODO Auto Generated method stub
			return null;
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

					for (var k:String in partDic)
					{
						if (partDic[k] == zf3d)
						{
							partDic[k] = null;
						}
					}
				}
				partDic[p] = null;
			}
		}

		public function sequencePose(poseName:String):void
		{
			poseSequence.push(poseName);
		}

		public function updatePose(poseName:String):Boolean
		{
			if (poseName == null)
				throw new Error("pos name cannot be null")

			currentPose = poseName;
			poseInvalid = true;
			poseCD = defaultPoseCD;
			return true;
		}

		public function updateRandomPose():void
		{
			if (defaultPoseCD > 0)
				return;

			var i:int = Math.random() * acts.length;
			updatePose(acts[i]);
		}

		public function tick(delta:Number):void
		{
			defaultPoseCD--;
			if (poseInvalid && !poseInQueue)
			{
//				trace("loading pose: " + currentPose);
				poseInvalid = false;
				poseInQueue = true;
				loadF3D(currentPose, poseLoaded, true);
				return;
			}
		}

		private function poseLoaded(zf3d:ZF3D):void
		{
//			trace("avatar pose:", currentPose);
			poseInQueue = false;
			var oldAnimation:Pivot3D = currentAnimation
			currentAnimation = zf3d.content;
			applyAnimation();
			if (oldAnimation != null)
			{
				oldAnimation.parent = null;
			}
		}

		private function loadF3D(name:String, onLoad:Function, ani:Boolean = false):void
		{
			ResManager.getResAsync("model/" + name + ".f3d", ZF3D, onLoad);
		}

		private function applyAnimation():void
		{
			gotoAndStop(0);
			show();
			Pivot3DUtils.removeAnimations(this);
			Pivot3DUtils.appendAnimation(this, currentAnimation);
			var mesh3d:Mesh3D = getChildByName("f") as Mesh3D;
			var num:* = mesh3d.frames.length;
			addLabel(new Label3D(currentPose, 0, num - 1, 1));
			mesh3d.addEventListener(Pivot3D.ANIMATION_COMPLETE_EVENT, animationCompleteHandler);
			if (currentPose == ACT_NORMAL)
			{
				gotoAndPlay(currentPose, 0, Pivot3D.ANIMATION_LOOP_MODE);
			}
			else
			{
				gotoAndPlay(currentPose, 0, Pivot3D.ANIMATION_STOP_MODE);
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

		public function zoomInMatch():void
		{
			TweenLite.killTweensOf(scene);
			TweenLite.to(scene.camera, 0.25, {fieldOfView: 18, //
					x: -3, //
					y: 230});
		}

		public function zoomIn():void
		{
			TweenLite.killTweensOf(scene);
			TweenLite.to(scene.camera, 0.25, {fieldOfView: 11, //
					x: -3, //
					y: 230});
		}

		public function zoomOut():void
		{
			TweenLite.killTweensOf(scene);
			TweenLite.to(scene.camera, 0.25, {fieldOfView: 28, //
					x: 0, //
					y: 195});
		}
	}
}
