//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.core.manager
{
    import starling.display.DisplayObjectContainer;
    import flash.utils.Dictionary;
    import com.popchan.framework.core.Core;
    import com.popchan.framework.manager.Layer3DManager;
    import starling.display.Quad;
    import starling.display.Sprite;
    import com.popchan.framework.manager.Debug;
    import flash.geom.Point;
    import com.popchan.sugar.modules.BasePanel3D;
    import starling.display.DisplayObject;

    public class WindowManager3D 
    {

        private static var _instance:WindowManager3D;

        private var _windowContainer:DisplayObjectContainer;
        private var _windows:Dictionary;
        private var _loaders:Dictionary;
        private var _showlist:Dictionary;

        public function WindowManager3D()
        {
            this._windows = new Dictionary();
            this._loaders = new Dictionary();
            this._showlist = new Dictionary();
            this._windowContainer = Core.layer3DManager.take(Layer3DManager.WINDOW);
            var _local_1:Quad = new Quad(Core.stage3DManager.canvasWidth, Core.stage3DManager.canvasHeight, 0);
            _local_1.alpha = 0.5;
            _local_1.name = "mask";
            _local_1.visible = false;
            this._windowContainer.addChild(_local_1);
        }

        public static function getInstance():WindowManager3D
        {
            if (_instance == null)
            {
                _instance = new (WindowManager3D)();
            };
            return (_instance);
        }


        public function init(_arg_1:Sprite):void
        {
        }

        public function open(_arg_1:Array, _arg_2:Object=null, _arg_3:Boolean=true, _arg_4:Point=null, _arg_5:Boolean=false):void
        {
            var _local_6:String = _arg_1[0];
            Debug.log(("Open ui:" + _local_6));
            var _local_7:Class = _arg_1[1];
            if (this._showlist[_local_6])
            {
                return;
            };
            this._showlist[_local_6] = {
                "modal":_arg_5,
                "pos":_arg_4,
                "isCenter":_arg_3,
                "showData":_arg_2
            };
            if (!this._windows[_local_6])
            {
                this._windows[_local_6] = new (_local_7)();
                if (_arg_1.length <= 2)
                {
                    this.loadPanelCompleteHandler(_arg_1);
                };
            }
            else
            {
                if (this._loaders[_local_6] == null)
                {
                    this.show(_local_6);
                };
            };
        }

        private function loadPanelCompleteHandler(_arg_1:Array):void
        {
            var _local_2:BasePanel3D = this._windows[_arg_1[0]];
            _local_2.winName = _arg_1[0];
            _local_2.init();
            if (this._showlist[_arg_1[0]])
            {
                this.show(_arg_1[0]);
            };
        }

        public function show(_arg_1:String):void
        {
            var _local_4:DisplayObject;
            var _local_2:Object = this._showlist[_arg_1];
            var _local_3:BasePanel3D = this._windows[_arg_1];
            if (_local_2.isCenter)
            {
                _local_3.x = ((Core.stageManager.canvasWidth - _local_3.width) >> 1);
                _local_3.y = ((Core.stageManager.canvasHeight - _local_3.height) >> 1);
            }
            else
            {
                _local_3.x = 0;
                _local_3.y = 0;
            };
            if (_local_2.pos != null)
            {
                _local_3.x = (_local_3.x + _local_2.pos.x);
                _local_3.y = (_local_3.y + _local_2.pos.y);
            };
            if (_local_2.modal)
            {
                _local_4 = this._windowContainer.getChildByName("mask");
                if (_local_4)
                {
                    _local_4.visible = true;
                    this._windowContainer.addChild(_local_4);
                };
            };
            this._windowContainer.addChild(_local_3);
            _local_3.show(_local_2.showData);
        }

        public function removeWindow(_arg_1:String):void
        {
            if (!this.remove(_arg_1))
            {
                return;
            };
        }

        private function remove(_arg_1:String):BasePanel3D
        {
            if (!this._showlist[_arg_1])
            {
                return (null);
            };
            this._showlist[_arg_1] = null;
            delete this._showlist[_arg_1];
            if (this._loaders[_arg_1])
            {
                return (null);
            };
            var _local_2:BasePanel3D = this._windows[_arg_1];
            this._windowContainer.getChildByName("mask").visible = false;
            if (_local_2.parent)
            {
                _local_2.close();
                _local_2.parent.removeChild(_local_2, true);
            };
            _local_2.hide();
            if (_local_2.destoryAfterClose)
            {
                _local_2.destory();
                delete this._windows[_arg_1];
            };
            return (_local_2);
        }

        public function removeAll(_arg_1:Boolean=false):void
        {
            var _local_2:String;
            for (_local_2 in this._windows)
            {
                this.remove(_local_2);
            };
        }

        public function updateData(_arg_1:String, _arg_2:*):void
        {
        }

        public function isShow(_arg_1:String):Boolean
        {
            return (this._showlist[_arg_1]);
        }

        public function getPanelName(_arg_1:BasePanel3D):String
        {
            var _local_2:String;
            for (_local_2 in this._windows)
            {
                if (this._windows[_local_2] == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }


    }
}//package com.popchan.sugar.core.manager
