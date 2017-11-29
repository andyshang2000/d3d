package diary.avatar
{
	import flash.geom.Rectangle;

	import flare.basic.Scene3D;
	import flare.core.IComponent;
	import flare.core.Pivot3D;

	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ZoomMoveComponent implements IComponent
	{
		public static const ZOOM:String = "zoom";
		public static const MOVE:String = "move";

		private var stage:Stage;
		private var avatar:Avatar;
		private var mode:String

		private var p_x:int = 0;
		private var p_y:int = -100;
		private var p_z:int = -150;
		private var _dis:Number = 0;
		private var _mdis:Number = 0;
		private var _posX:Number = 0;
		private var _posY:Number = 0;
		private var _mposX:Number = 0;
		private var _mposY:Number = 0;
		private var _scale:Number = 1;

		public function ZoomMoveComponent(stage:Stage)
		{
			this.stage = stage;
		}

		public function added(target:Pivot3D):Boolean
		{
			avatar = target as Avatar;
			p_x = avatar.scene.viewPort.x;
			p_y = avatar.scene.viewPort.y;
			if (!avatar)
				return false;
			stage.addEventListener(TouchEvent.TOUCH, touchHandler);
			return true;
		}

		private function touchHandler(event:TouchEvent):void
		{
			var e:TouchEvent = event;
			var touches:Vector.<Touch> = e.touches;
			var finger1:Touch;
			var finger2:Touch;
			var dx:int;
			var dy:int;
			var value:Number;
			if (touches.length == 2)
			{
				finger1 = touches[0];
				finger2 = touches[1];

				if ((finger1.phase == TouchPhase.BEGAN && finger2.phase == TouchPhase.BEGAN) || (finger1.phase == TouchPhase.MOVED && finger2.phase == TouchPhase.BEGAN) || (finger1.phase == TouchPhase.BEGAN && finger2.phase == TouchPhase.MOVED))
				{
					mode = ZOOM;
					dx = Math.abs(finger1.globalX - finger2.globalX);
					dy = Math.abs(finger1.globalY - finger2.globalY);
					_dis = Math.sqrt(dx * dx + dy * dy);
				}
				else if (finger1.phase == TouchPhase.MOVED && //
					finger2.phase == TouchPhase.MOVED && //
					mode == ZOOM)
				{
					dx = Math.abs(finger1.globalX - finger2.globalX);
					dy = Math.abs(finger1.globalY - finger2.globalY);

					_mdis = Math.sqrt(dx * dx + dy * dy);
					_scale = (_mdis / _dis) * _scale;
					value = _dis / _mdis;
					_dis = _mdis;
					setScale(value);
				}
			}
			else if (touches.length == 1)
			{
				finger1 = touches[0];
				if (finger1.phase == TouchPhase.BEGAN)
				{
					mode = MOVE;
					_posX = finger1.globalX;
					_posY = finger1.globalY;
				}
				else if (finger1.phase == TouchPhase.MOVED && //
					mode == MOVE)
				{
					_mposX = finger1.globalX;
					_mposY = finger1.globalY;
					setPos(_mposX - _posX, _mposY - _posY);
					_posX = _mposX;
					_posY = _mposY;
				}
			}
		}

		private function setPos(dx:Number, dy:Number):void
		{
			p_x = p_x + dx;
			p_y = p_y + dy;

			var scene:Scene3D = avatar.scene;

			if (p_x < -scene.viewPort.width / 2)
				p_x = -scene.viewPort.width / 2;
			else if (p_x > scene.viewPort.width / 2)
				p_x = scene.viewPort.width / 2;
			if (p_y < -scene.viewPort.height / 2)
				p_y = -scene.viewPort.height / 2;
			else if (p_y > scene.viewPort.height / 2)
				p_y = scene.viewPort.height / 2;
			scene.camera.viewPort = new Rectangle(p_x, p_y, scene.viewPort.width, scene.viewPort.height);
		}

		private function setScale(value:Number):void
		{
			if ((p_z <= -1100 && value > 1) || (p_z >= -120 && value < 1))
			{
				return;
			}
			var scene:Scene3D = avatar.scene;
			p_z = p_z * value;
//			scene.camera.setPosition(0, 160, p_z);
//			scene.camera.setRotation(20, 0, 0);
		}

		public function removed():Boolean
		{
			stage.removeEventListener(TouchEvent.TOUCH, touchHandler);
			return true;
		}
	}
}
