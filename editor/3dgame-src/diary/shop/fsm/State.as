//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.fsm
{
	

	public class State
	{

		private var _machine:WeakReference;
		private var name:String;

		public function State(_arg_1:Machine, _arg_2:String = null)
		{
			this._machine = new WeakReference(_arg_1, Machine);
			this.name = _arg_2;
		}

		public function get machine():Machine
		{
			return ((this._machine.get() as Machine));
		}

		public function transitionInto(_arg_1:Boolean = false):void
		{
			if (_arg_1)
			{
			}
		}

		public function loop(_arg_1:Boolean = false)
		{
			if (_arg_1)
			{
			}
			;
			return (Result.CONTINUE);
		}

		public function transitionOut(_arg_1:Boolean = false):void
		{
			if (_arg_1)
			{
			}
			;
		}

	}
} //package com.edgebee.atlas.util.fsm
