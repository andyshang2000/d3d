//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.framework.manager
{
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.media.Sound;
    import flash.events.Event;
    import flash.media.SoundMixer;
    import caurina.transitions.Tweener;

    public class SoundManager 
    {

        private static var _instance:SoundManager;

        private var sounds:Array;
        private var soundEffectsChannels:Array;
        private var musicChannel:SoundChannel;
        private var musicTransform:SoundTransform;
        private var soundTransform:SoundTransform;
        private var muteSoundTransform:SoundTransform;
        public var isMute:Boolean = false;
        public var isMusicMute:Boolean = false;
        public var isSoundMute:Boolean = false;
        private var _curSoundName:String;

        public function SoundManager()
        {
            this.sounds = [];
            this.soundEffectsChannels = [];
            this.musicTransform = new SoundTransform();
            this.soundTransform = new SoundTransform();
            this.muteSoundTransform = new SoundTransform();
            super();
        }

        public static function get instance():SoundManager
        {
            if (_instance == null)
            {
                _instance = new (SoundManager)();
            };
            return (_instance);
        }


        public function addSound(_arg_1:String, _arg_2:Sound):void
        {
            this.sounds[_arg_1] = _arg_2;
        }

        public function hasSound(_arg_1:String):Boolean
        {
            return ((!((this.sounds[_arg_1] == null))));
        }

        public function get curSoundName():String
        {
            return (this._curSoundName);
        }

        public function playSound(_arg_1:String, _arg_2:Boolean=false, _arg_3:Number=0, _arg_4:int=1, _arg_5:Number=1, _arg_6:Boolean=false):void
        {
			return;
            Debug.log(("音效:" + _arg_1));
            this.soundTransform.volume = _arg_5;
            var _local_7:Sound = this.sounds[_arg_1];
            if (_arg_2)
            {
                if (this.isMusicMute)
                {
                    this.soundTransform.volume = 0;
                };
                if (this.musicChannel != null)
                {
                    this.musicChannel.stop();
                };
                this.musicChannel = _local_7.play(_arg_3, _arg_4);
                if (this.musicChannel)
                {
                    this.musicChannel.soundTransform = this.soundTransform;
                };
                if (_arg_4 > 1)
                {
                    this._curSoundName = _arg_1;
                };
            }
            else
            {
                if (this.isSoundMute)
                {
                    this.soundTransform.volume = 0;
                };
                if (_arg_6)
                {
                    if (!this.soundEffectsChannels[_arg_1])
                    {
                        this.soundEffectsChannels[_arg_1] = _local_7.play(_arg_3, _arg_4);
                        if (this.soundEffectsChannels[_arg_1])
                        {
                            (this.soundEffectsChannels[_arg_1] as SoundChannel).addEventListener(Event.SOUND_COMPLETE, this.onSoundCmp);
                            this.soundEffectsChannels[_arg_1].soundTransform = this.soundTransform;
                        };
                    };
                }
                else
                {
                    this.soundEffectsChannels[_arg_1] = _local_7.play(_arg_3, _arg_4);
                    if (this.soundEffectsChannels[_arg_1])
                    {
                        this.soundEffectsChannels[_arg_1].soundTransform = this.soundTransform;
                    };
                };
            };
        }

        private function onSoundCmp(_arg_1:Event):void
        {
            var _local_3:String;
            var _local_2:SoundChannel = (_arg_1.target as SoundChannel);
            _local_2.stop();
            _local_2.removeEventListener(Event.SOUND_COMPLETE, this.onSoundCmp);
            for (_local_3 in this.soundEffectsChannels)
            {
                if (this.soundEffectsChannels[_local_3] == _local_2)
                {
                    this.soundEffectsChannels[_local_3] = null;
                    break;
                };
            };
        }

        public function stopSound(_arg_1:String, _arg_2:Boolean=false):void
        {
            if (_arg_2)
            {
                if (this.musicChannel)
                {
                    this.musicChannel.stop();
                    this._curSoundName = null;
                };
            }
            else
            {
                if (this.soundEffectsChannels[_arg_1])
                {
                    this.soundEffectsChannels[_arg_1].stop();
                    if ((this.soundEffectsChannels[_arg_1] as SoundChannel).hasEventListener(Event.SOUND_COMPLETE))
                    {
                        (this.soundEffectsChannels[_arg_1] as SoundChannel).removeEventListener(Event.SOUND_COMPLETE, this.onSoundCmp);
                    };
                    this.soundEffectsChannels[_arg_1] = null;
                };
            };
        }

        public function stopAllSound():void
        {
            var _local_1:String;
            if (this.musicChannel)
            {
                this.musicChannel.stop();
                this._curSoundName = null;
            };
            for (_local_1 in this.soundEffectsChannels)
            {
                if (this.soundEffectsChannels[_local_1])
                {
                    this.soundEffectsChannels[_local_1].stop();
                    if ((this.soundEffectsChannels[_local_1] as SoundChannel).hasEventListener(Event.SOUND_COMPLETE))
                    {
                        (this.soundEffectsChannels[_local_1] as SoundChannel).removeEventListener(Event.SOUND_COMPLETE, this.onSoundCmp);
                    };
                    this.soundEffectsChannels[_local_1] = null;
                };
            };
        }

        public function muteAllSound(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.muteSoundTransform.volume = 0;
                SoundMixer.soundTransform = this.muteSoundTransform;
                this.isMute = true;
            }
            else
            {
                this.muteSoundTransform.volume = 1;
                SoundMixer.soundTransform = this.muteSoundTransform;
                this.isMute = false;
            };
        }

        public function muteSoundEffect(_arg_1:Boolean):void
        {
            var _local_2:SoundChannel;
            if (_arg_1)
            {
                this.soundTransform.volume = 0;
                this.isSoundMute = true;
            }
            else
            {
                this.soundTransform.volume = 1;
                this.isSoundMute = false;
            };
            for each (_local_2 in this.soundEffectsChannels)
            {
                if (_local_2)
                {
                    _local_2.soundTransform = this.soundTransform;
                };
            };
        }

        public function muteMusic(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.musicTransform.volume = 0;
                this.isMusicMute = true;
                if (this.musicChannel)
                {
                    this.musicChannel.soundTransform = this.musicTransform;
                };
            }
            else
            {
                this.musicTransform.volume = 1;
                this.isMusicMute = false;
                if (this.musicChannel)
                {
                    this.musicChannel.soundTransform = this.musicTransform;
                };
            };
        }

        public function fadeIn(name:String, isMusic:Boolean=false, time:Number=1):void
        {
            this.playSound(name, isMusic);
            if (isMusic)
            {
                if (this.isMusicMute)
                {
                    return;
                };
                this.soundTransform.volume = 0;
                this.musicTransform = this.soundTransform;
                Tweener.addTween(this.soundTransform, {
                    "time":time,
                    "volume":1,
                    "onUpdate":function ():void
                    {
                        musicChannel.soundTransform = soundTransform;
                    }
                });
            }
            else
            {
                if (this.soundEffectsChannels[name])
                {
                    if (this.isSoundMute)
                    {
                        return;
                    };
                    this.soundTransform.volume = 0;
                    this.soundEffectsChannels[name].soundTransform = this.soundTransform;
                    Tweener.addTween(this.soundTransform, {
                        "time":time,
                        "volume":1,
                        "onUpdate":function ():void
                        {
                            soundEffectsChannels[name].soundTransform = soundTransform;
                        }
                    });
                };
            };
        }

        public function fadeOut(name:String, isMusic:Boolean=false, time:Number=1):void
        {
            if (isMusic)
            {
                this.soundTransform.volume = this.musicTransform.volume;
                Tweener.addTween(this.soundTransform, {
                    "time":time,
                    "volume":0,
                    "onComplete":function ():void
                    {
                        stopSound(name, isMusic);
                    },
                    "onUpdate":function ():void
                    {
                        musicChannel.soundTransform = soundTransform;
                    }
                });
            }
            else
            {
                if (this.soundEffectsChannels[name])
                {
                    this.soundTransform = this.soundEffectsChannels[name].soundTransform;
                    Tweener.addTween(this.soundTransform, {
                        "time":time,
                        "volume":0,
                        "onComplete":function ():void
                        {
                            stopSound(name, isMusic);
                        },
                        "onUpdate":function ():void
                        {
                            soundEffectsChannels[name].soundTransform = soundTransform;
                        }
                    });
                };
            };
        }


    }
}//package com.popchan.framework.manager
