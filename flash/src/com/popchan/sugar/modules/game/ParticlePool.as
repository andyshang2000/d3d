//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.game
{
    import flash.utils.Dictionary;
    import starling.extensions.PDParticleSystem;
    import starling.textures.Texture;
    import com.popchan.framework.core.Core;
    import starling.core.Starling;
    import com.popchan.framework.manager.Debug;

    public class ParticlePool 
    {
		
		[Embed(source="symbol_48.bin",mimeType="application/octet-stream")]
        public static const bubbleExp1_cfg:Class;
		
		[Embed(source="symbol_38.bin",mimeType="application/octet-stream")]
        public static const bubbleExp2_cfg:Class;
		[Embed(source="symbol_35.bin",mimeType="application/octet-stream")]
        public static const lightning_cfg:Class;
		
		[Embed(source="symbol_50.bin",mimeType="application/octet-stream")]
        public static const leafExp_cfg:Class;
        public static const exp_cfg:Class = ParticlePool_exp_cfg;
        private static var _instance:ParticlePool;

        private var particles:Dictionary;

        public function ParticlePool()
        {
            this.particles = new Dictionary();
            super();
        }

        public static function get instance():ParticlePool
        {
            if (_instance == null)
            {
                _instance = new (ParticlePool)();
            };
            return (_instance);
        }


        public function getParticleByType(_arg_1:int):PDParticleSystem
        {
            var _local_2:PDParticleSystem;
            var _local_3:XML;
            var _local_4:Texture;
            if (this.particles[_arg_1] == null)
            {
                this.particles[_arg_1] = [];
            };
            if (this.particles[_arg_1].length > 0)
            {
                return (this.particles[_arg_1].shift());
            };
            if (_arg_1 == 1)
            {
                _local_3 = XML(new bubbleExp1_cfg());
                _local_2 = new PDParticleSystem(_local_3, Core.texturesManager.getTexture("exp1_res"));
                Starling.juggler.add(_local_2);
            }
            else
            {
                if (_arg_1 == 2)
                {
                    _local_3 = XML(new bubbleExp2_cfg());
                    _local_2 = new PDParticleSystem(_local_3, Core.texturesManager.getTexture("exp2_res"));
                    Starling.juggler.add(_local_2);
                }
                else
                {
                    if (_arg_1 == 3)
                    {
                        _local_3 = XML(new leafExp_cfg());
                        _local_2 = new PDParticleSystem(_local_3, Core.texturesManager.getTexture("leafExp"));
                        Starling.juggler.add(_local_2);
                    }
                    else
                    {
                        if (_arg_1 == 4)
                        {
                            _local_3 = XML(new lightning_cfg());
                            _local_2 = new PDParticleSystem(_local_3, Core.texturesManager.getTexture("lightning"));
                            Starling.juggler.add(_local_2);
                        }
                        else
                        {
                            if (_arg_1 == 5)
                            {
                                _local_3 = XML(new exp_cfg());
                                _local_2 = new PDParticleSystem(_local_3, Core.texturesManager.getTexture("followboom"));
                                Starling.juggler.add(_local_2);
                            };
                        };
                    };
                };
            };
            _local_2.tag = _arg_1;
            return (_local_2);
        }

        public function returnParticle(_arg_1:int, _arg_2:PDParticleSystem):void
        {
            if (this.particles[_arg_1] == null)
            {
                this.particles[_arg_1] = [];
            };
            this.particles[_arg_1].push(_arg_2);
            Debug.log(("return type=" + _arg_1), this.particles[_arg_1].length);
        }


    }
}//package com.popchan.sugar.modules.game
