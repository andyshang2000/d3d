//Created by Action Script Viewer - http://www.buraks.com/asv
package starling.display
{
    import starling.textures.Texture;
    import starling.text.TextField;
    import flash.geom.Rectangle;
    import starling.events.TouchEvent;
    import starling.utils.VAlign;
    import starling.utils.HAlign;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import starling.events.Touch;
    import starling.events.TouchPhase;
    import starling.events.Event;

    public class Button extends DisplayObjectContainer 
    {

        private static const MAX_DRAG_DIST:Number = 50;

        private var mUpState:Texture;
        private var mDownState:Texture;
        private var mOverState:Texture;
        private var mDisabledState:Texture;
        private var mContents:Sprite;
        private var mBody:Image;
        private var mTextField:TextField;
        private var mTextBounds:Rectangle;
        private var mOverlay:Sprite;
        private var mScaleWhenDown:Number;
        private var mAlphaWhenDisabled:Number;
        private var mUseHandCursor:Boolean;
        private var mEnabled:Boolean;
        private var mState:String;
        public var tag;

        public function Button(_arg_1:Texture, _arg_2:String="", _arg_3:Texture=null, _arg_4:Texture=null, _arg_5:Texture=null)
        {
            if (_arg_1 == null)
            {
                throw (new ArgumentError("Texture 'upState' cannot be null"));
            };
            this.mUpState = _arg_1;
            this.mDownState = _arg_3;
            this.mOverState = _arg_4;
            this.mDisabledState = _arg_5;
            this.mState = ButtonState.UP;
            this.mBody = new Image(_arg_1);
            this.mScaleWhenDown = ((_arg_3) ? 1 : 0.9);
            this.mAlphaWhenDisabled = ((_arg_5) ? 1 : 0.5);
            this.mEnabled = true;
            this.mUseHandCursor = true;
            this.mTextBounds = new Rectangle(0, 0, _arg_1.width, _arg_1.height);
            this.mContents = new Sprite();
            this.mContents.addChild(this.mBody);
            addChild(this.mContents);
            addEventListener(TouchEvent.TOUCH, this.onTouch);
            this.touchGroup = true;
            this.text = _arg_2;
        }

        override public function dispose():void
        {
            if (this.mTextField)
            {
                this.mTextField.dispose();
            };
            super.dispose();
        }

        public function readjustSize(_arg_1:Boolean=true):void
        {
            this.mBody.readjustSize();
            if (((_arg_1) && ((!((this.mTextField == null))))))
            {
                this.textBounds = new Rectangle(0, 0, this.mBody.width, this.mBody.height);
            };
        }

        private function createTextField():void
        {
            if (this.mTextField == null)
            {
                this.mTextField = new TextField(this.mTextBounds.width, this.mTextBounds.height, "");
                this.mTextField.touchable = false;
                this.mTextField.autoScale = true;
                this.mTextField.batchable = true;
            };
            this.mTextField.width = this.mTextBounds.width;
            this.mTextField.height = this.mTextBounds.height;
            this.mTextField.x = this.mTextBounds.x;
            this.mTextField.y = this.mTextBounds.y;
        }

        private function onTouch(_arg_1:TouchEvent):void
        {
            var _local_3:Rectangle;
            Mouse.cursor = ((((((this.mUseHandCursor) && (this.mEnabled))) && (_arg_1.interactsWith(this)))) ? MouseCursor.BUTTON : MouseCursor.AUTO);
            var _local_2:Touch = _arg_1.getTouch(this);
            if (!this.mEnabled)
            {
                return;
            };
            if (_local_2 == null)
            {
                this.state = ButtonState.UP;
            }
            else
            {
                if (_local_2.phase == TouchPhase.HOVER)
                {
                    this.state = ButtonState.OVER;
                }
                else
                {
                    if ((((_local_2.phase == TouchPhase.BEGAN)) && ((!((this.mState == ButtonState.DOWN))))))
                    {
                        this.state = ButtonState.DOWN;
                    }
                    else
                    {
                        if ((((_local_2.phase == TouchPhase.MOVED)) && ((this.mState == ButtonState.DOWN))))
                        {
                            _local_3 = getBounds(stage);
                            if ((((((((_local_2.globalX < (_local_3.x - MAX_DRAG_DIST))) || ((_local_2.globalY < (_local_3.y - MAX_DRAG_DIST))))) || ((_local_2.globalX > ((_local_3.x + _local_3.width) + MAX_DRAG_DIST))))) || ((_local_2.globalY > ((_local_3.y + _local_3.height) + MAX_DRAG_DIST)))))
                            {
                                this.state = ButtonState.UP;
                            };
                        }
                        else
                        {
                            if ((((_local_2.phase == TouchPhase.ENDED)) && ((this.mState == ButtonState.DOWN))))
                            {
                                this.state = ButtonState.UP;
                                dispatchEventWith(Event.TRIGGERED, true);
                            };
                        };
                    };
                };
            };
        }

        public function get state():String
        {
            return (this.mState);
        }

        public function set state(_arg_1:String):void
        {
            this.mState = _arg_1;
            this.mContents.scaleX = (this.mContents.scaleY = 1);
            switch (this.mState)
            {
                case ButtonState.DOWN:
                    this.setStateTexture(this.mDownState);
                    this.mContents.scaleX = (this.mContents.scaleY = this.scaleWhenDown);
                    this.mContents.x = (((1 - this.scaleWhenDown) / 2) * this.mBody.width);
                    this.mContents.y = (((1 - this.scaleWhenDown) / 2) * this.mBody.height);
                    return;
                case ButtonState.UP:
                    this.setStateTexture(this.mUpState);
                    this.mContents.x = (this.mContents.y = 0);
                    return;
                case ButtonState.OVER:
                    this.setStateTexture(this.mOverState);
                    this.mContents.x = (this.mContents.y = 0);
                    return;
                case ButtonState.DISABLED:
                    this.setStateTexture(this.mDisabledState);
                    this.mContents.x = (this.mContents.y = 0);
                    return;
                default:
                    throw (new ArgumentError(("Invalid button state: " + this.mState)));
            };
        }

        private function setStateTexture(_arg_1:Texture):void
        {
            this.mBody.texture = ((_arg_1) ? _arg_1 : this.mUpState);
        }

        public function get scaleWhenDown():Number
        {
            return (this.mScaleWhenDown);
        }

        public function set scaleWhenDown(_arg_1:Number):void
        {
            this.mScaleWhenDown = _arg_1;
        }

        public function get alphaWhenDisabled():Number
        {
            return (this.mAlphaWhenDisabled);
        }

        public function set alphaWhenDisabled(_arg_1:Number):void
        {
            this.mAlphaWhenDisabled = _arg_1;
        }

        public function get enabled():Boolean
        {
            return (this.mEnabled);
        }

        public function set enabled(_arg_1:Boolean):void
        {
            if (this.mEnabled != _arg_1)
            {
                this.mEnabled = _arg_1;
                this.mContents.alpha = ((_arg_1) ? 1 : this.mAlphaWhenDisabled);
                this.state = ((_arg_1) ? ButtonState.UP : ButtonState.DISABLED);
            };
        }

        public function get text():String
        {
            return (((this.mTextField) ? this.mTextField.text : ""));
        }

        public function set text(_arg_1:String):void
        {
            if (_arg_1.length == 0)
            {
                if (this.mTextField)
                {
                    this.mTextField.text = _arg_1;
                    this.mTextField.removeFromParent();
                };
            }
            else
            {
                this.createTextField();
                this.mTextField.text = _arg_1;
                if (this.mTextField.parent == null)
                {
                    this.mContents.addChild(this.mTextField);
                };
            };
        }

        public function get upState():Texture
        {
            return (this.mUpState);
        }

        public function set upState(_arg_1:Texture):void
        {
            if (_arg_1 == null)
            {
                throw (new ArgumentError("Texture 'upState' cannot be null"));
            };
            if (this.mUpState != _arg_1)
            {
                this.mUpState = _arg_1;
                if (this.mState == ButtonState.UP)
                {
                    this.setStateTexture(_arg_1);
                };
            };
        }

        public function get downState():Texture
        {
            return (this.mDownState);
        }

        public function set downState(_arg_1:Texture):void
        {
            if (this.mDownState != _arg_1)
            {
                this.mDownState = _arg_1;
                if (this.mState == ButtonState.DOWN)
                {
                    this.setStateTexture(_arg_1);
                };
            };
        }

        public function get overState():Texture
        {
            return (this.mOverState);
        }

        public function set overState(_arg_1:Texture):void
        {
            if (this.mOverState != _arg_1)
            {
                this.mOverState = _arg_1;
                if (this.mState == ButtonState.OVER)
                {
                    this.setStateTexture(_arg_1);
                };
            };
        }

        public function get disabledState():Texture
        {
            return (this.mDisabledState);
        }

        public function set disabledState(_arg_1:Texture):void
        {
            if (this.mDisabledState != _arg_1)
            {
                this.mDisabledState = _arg_1;
                if (this.mState == ButtonState.DISABLED)
                {
                    this.setStateTexture(_arg_1);
                };
            };
        }

        public function get textBounds():Rectangle
        {
            return (this.mTextBounds.clone());
        }

        public function set textBounds(_arg_1:Rectangle):void
        {
            this.mTextBounds = _arg_1.clone();
            this.createTextField();
        }

        public function get color():uint
        {
            return (this.mBody.color);
        }

        public function set color(_arg_1:uint):void
        {
            this.mBody.color = _arg_1;
        }

        public function get overlay():Sprite
        {
            if (this.mOverlay == null)
            {
                this.mOverlay = new Sprite();
            };
            this.mContents.addChild(this.mOverlay);
            return (this.mOverlay);
        }

        override public function get useHandCursor():Boolean
        {
            return (this.mUseHandCursor);
        }

        override public function set useHandCursor(_arg_1:Boolean):void
        {
            this.mUseHandCursor = _arg_1;
        }


    }
}//package starling.display
