package sui.utils
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class SoundManager
	{
		public static const AMBIENT_CHANNEL:int = 0;

		private static var instance:SoundManager;

		private var assets:Object = {};
		private var channelMap:* = [];
		private var currentSoundMap:Dictionary = new Dictionary;
		private var guiMap:Dictionary = new Dictionary;
		private var mappedGuiClasses:Array = [];
		private var currentSoundIndex:Vector.<SoundChannel> = new Vector.<SoundChannel>;
		private var playingsound:Array = [];

		private static var soundMap:Dictionary = new Dictionary;
		private static var soundRequests:Array = [];
		private static var handled:Array = [];
		private static var cdmap:Object = {step: 0.2, // 
				attack: 0.2, // 
				impact: 0.1, //
				die: 0.1, //
				mumble: 5, //
				gui: 0.1, //
				fire: 0.3, //
				ice: 0.3, //
				elec: 0.3, //
				speech: 1};

		private static var ambientChannel:SoundChannel;
		private static var isMute:Boolean;
		private static var mappedGuiInstance:Dictionary = new Dictionary(true);
		private static var alias:Object = {};
		private static var ambient:*;
		private var paused:Boolean = false;
		private var currentAmbientVolume:Number = 50;

		public static function playAmbient(sound:* = null, channel:int = 0):void
		{
			sound ||= ambient;
			if (sound is Array)
			{
				sound;
			}
			if(ambientChannel)
				ambientChannel.stop();
			
			ambientChannel = playSound(sound, int.MAX_VALUE, 0, 40, false, AMBIENT_CHANNEL);
			ambient = sound;
		}

		public static function playSound(sound:*, loops:int = 0, startTime:int = 0, //
			volume:int = 50, fadeIn:Boolean = false, channelSpec:int = -1):SoundChannel
		{
			if (sound is Array)
			{
				while (sound.length < 6)
				{
					sound.push(arguments[sound.length]);
				}
			}
			return instance.playSound(sound, loops, startTime, volume, fadeIn, channelSpec);
		}

		public function SoundManager()
		{
			instance = this;
		}

		public function loadAssets(soundAssets:Object):void
		{
			for (var key:String in soundAssets)
			{
				var sound:Sound = new Sound;
				var content:ByteArray = soundAssets[key];
				content.position = 0;
				sound.loadCompressedDataFromByteArray(content, content.length);
				assets[key] = sound;
			}
		}

		public function setChannelMap(channelMap:*):void
		{
			this.channelMap = channelMap;
		}

		public function mapChannel(channel:int, assetName:String):void
		{
			channelMap[channel] = assets[assetName];
		}

		public function mapGui(target:*, sound:*):void
		{
			if (target is Class)
			{
				mappedGuiClasses.push(target);
				guiMap[target] = sound;
			}
			else
			{
				mappedGuiInstance[target] = sound;
			}
		}

		public function getSound(channel:int):Sound
		{
			if (channel < channelMap.length)
			{
				return assets[channelMap[channel]];
			}
			return null;
		}

		public function playSound(sound:*, //
			loops:int = 0, //
			startTime:Number = 0, //
			volume:int = 50, //
			fadeIn:Boolean = false, //
			channelSpec:int = -1):SoundChannel
		{
			if (isMute)
			{
				return null;
			}
			if (!sound)
			{
				return null;
			}
			if (sound is Array)
			{
				if ((sound[0] is Sound || sound[0] is Class || sound[0] is String) //
					&& (sound.length < 1 || sound[1] is Number) //
					&& (sound.length < 2 || sound[2] is Number) //
					&& (sound.length < 3 || sound[3] is Number))
				{
					return playSound.apply(null, sound as Array);
				}
				else
				{
					return playSound(sound[int(Math.random() * sound.length)])
				}
			}
			else if (sound is String)
			{
				return playSound(getSoundByAlias(sound), loops, startTime, volume, fadeIn);
			}
			else if (sound is Class)
			{
				return playSound(new sound, loops, startTime, volume, fadeIn);
			}
			else if (sound is ByteArray)
			{
				var s:Sound = new Sound;
				sound.position = 0;
				s.loadCompressedDataFromByteArray(sound, sound.length);
				return playSound(s, loops, startTime, volume, fadeIn);
			}
			else if (sound is Sound)
			{
				if (sound != null)
				{
					if (channelSpec == AMBIENT_CHANNEL)
					{
						currentAmbientVolume = volume;
					}
					return (sound as Sound).play(startTime, loops, new SoundTransform(volume / 100));
				}
			}
			return null;
		}

		private function getSoundByAlias(sound:String):*
		{
			// TODO Auto Generated method stub
			return alias[sound];
		}

		public function playChannel(channel:int):void
		{
			playSound(getSound(channel));
		}

		public static function recover():void
		{
			isMute = false;
			if (ambientChannel)
			{
				var st:SoundTransform = ambientChannel.soundTransform;
				st.volume = 0.75;
				ambientChannel.soundTransform = st;
			}
			else
			{
				playAmbient();
			}
		}

		public static function mute():void
		{
			isMute = true;
			if (ambientChannel)
			{
				var st:SoundTransform = ambientChannel.soundTransform;
				st.volume = 0;
				ambientChannel.soundTransform = st;
			}
		}

		public function pause():void
		{
			if (ambientChannel)
			{
				ambientChannel.stop()
				ambientChannel = null;
			}
		}

		public function resume():void
		{
			if (!ambientChannel)
			{
				playAmbient();
			}
			if (ambientChannel)
			{
				ambientChannel.soundTransform = new SoundTransform(isMute ? 0 : currentAmbientVolume / 100);
			}
		}

		public function clear():void
		{
			assets = {};
			channelMap = [];
			currentSoundMap = new Dictionary;
			currentSoundIndex = new Vector.<SoundChannel>;
			playingsound = [];
		}

		public static function playGuiSound(guiObject:*):void
		{
			var mappedGuiClasses:Array = instance.mappedGuiClasses;
			if (mappedGuiInstance[guiObject])
			{
				playSound(mappedGuiInstance[guiObject]);
				return;
			}
			else if (guiObject is Class)
			{
				playSound(instance.guiMap[guiObject]);
			}
			else
			{
				for (var i:int = mappedGuiClasses.length - 1; i >= 0; i--)
				{
					var clazz:Class = mappedGuiClasses[i]
					if (guiObject is clazz)
					{
						playSound(instance.guiMap[clazz]);
						break;
					}
				}
			}
		}

		public static function playSoundRequests(delta:Number):void
		{
			for (var i:int = 0; i < soundRequests.length; i++)
			{
				var request:Object = soundRequests[i];
				var entity:Object = request.entity;
				var type:String = request.type;
				if (entity.distanceToHero > 1000)
				{
					break;
				}
				var volume:Number = Math.max(50, (1400 - entity.distanceToHero) * 0.017);
				var clazz:Object = entity.taxonomy;
				var soundForClass:Object = soundMap[clazz];
				if (!soundForClass)
				{
					trace("sound missing : " + clazz + "(" + type + ")");
					break;
				}
				var arr:Array = soundForClass[type];
				if (!arr)
				{
					trace("sound missing : " + clazz + "(" + type + ")")
					break;
				}
				if (handled.indexOf(arr) != -1)
				{
					break;
				}
				handled.push(arr);

				var t:int = getTimer();
				if (arr.timestamp === undefined)
				{
					arr.timestamp = 0;
				}
				if (t - arr.timestamp >= (cdmap[type] || 0) * 1000)
				{
					var sound:Object = arr[int(Math.random() * arr.length)];
					if (sound is Array)
					{
						SoundManager.playSound(sound[0], sound[1], sound[2], sound[3] * volume * 0.01);
					}
					else
					{
						SoundManager.playSound(sound, 0, 0, volume);
					}
					arr.timestamp = t
				}
			}
			handled.splice(0);
			soundRequests.splice(0);
		}

		public static function setSound(clazz:*, type:String, sound:Array):void
		{
			if (!soundMap[clazz])
			{
				soundMap[clazz] = {};
			}
			soundMap[clazz][type] = sound;
		}

		public static function addRequest(obj:Object):void
		{
			soundRequests.push(obj)
		}

		public static function initialize():void
		{
			if(!instance)
				instance = new SoundManager;
		}

		public static function mapGUI(target:*, sound:*):void
		{
			instance.mapGui(target, sound);
		}

		public static function registSoundAlias(a:String, sound:*):void
		{
			alias[a] = sound;
		}

		public static function pause():void
		{
			if (instance)
			{
				instance.pause();
			}
		}

		public static function resume():void
		{
			if (instance)
			{
				instance.resume();
			}
		}
	}
}
