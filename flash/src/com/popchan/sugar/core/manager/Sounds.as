//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.core.manager
{
    import com.popchan.framework.manager.SoundManager;

    public class Sounds 
    {

        public static const bg:Class = Sounds_bg;
        public static const completeStar1:Class = Sounds_completeStar1;
        public static const completeStar2:Class = Sounds_completeStar2;
        public static const completeStar3:Class = Sounds_completeStar3;
        public static const bomb_blast:Class = Sounds_bomb_blast;
        public static const boomcommon:Class = Sounds_boomcommon;
        public static const boxmove:Class = Sounds_boxmove;
        public static const brickthrow:Class = Sounds_brickthrow;
        public static const button_down:Class = Sounds_button_down;
        public static const candy_land:Class = Sounds_candy_land;
        public static const candyspgrow1:Class = Sounds_candyspgrow1;
        public static const effect_hyper:Class = Sounds_effect_hyper;
        public static const fail1:Class = Sounds_fail1;
        public static const finaltry:Class = Sounds_finaltry;
        public static const fruit_arrive:Class = Sounds_fruit_arrive;
        public static const great:Class = Sounds_great;
        public static const iceboom:Class = Sounds_iceboom;
        public static const lockboom:Class = Sounds_lockboom;
        public static const msc_moveable:Class = Sounds_msc_moveable;
        public static const msc_virus:Class = Sounds_msc_virus;
        public static const nomatch:Class = Sounds_nomatch;
        public static const notswap:Class = Sounds_notswap;
        public static const stonebreak:Class = Sounds_stonebreak;
        public static const game_win:Class = Sounds_game_win;
        public static const thunder:Class = Sounds_thunder;
        public static const unswap:Class = Sounds_unswap;
        public static const warningmove:Class = Sounds_warningmove;
        public static const warningtime:Class = Sounds_warningtime;


        public static function init():void
        {
            SoundManager.instance.addSound("bg", new bg());
            SoundManager.instance.addSound("completeStar1", new completeStar1());
            SoundManager.instance.addSound("completeStar2", new completeStar2());
            SoundManager.instance.addSound("completeStar3", new completeStar3());
            SoundManager.instance.addSound("bomb_blast", new bomb_blast());
            SoundManager.instance.addSound("boomcommon", new boomcommon());
            SoundManager.instance.addSound("boxmove", new boxmove());
            SoundManager.instance.addSound("brickthrow", new brickthrow());
            SoundManager.instance.addSound("button_down", new button_down());
            SoundManager.instance.addSound("candy_land", new candy_land());
            SoundManager.instance.addSound("candyspgrow1", new candyspgrow1());
            SoundManager.instance.addSound("effect_hyper", new effect_hyper());
            SoundManager.instance.addSound("fail1", new fail1());
            SoundManager.instance.addSound("finaltry", new finaltry());
            SoundManager.instance.addSound("fruit_arrive", new fruit_arrive());
            SoundManager.instance.addSound("great", new great());
            SoundManager.instance.addSound("iceboom", new iceboom());
            SoundManager.instance.addSound("lockboom", new lockboom());
            SoundManager.instance.addSound("msc_moveable", new msc_moveable());
            SoundManager.instance.addSound("msc_virus", new msc_virus());
            SoundManager.instance.addSound("nomatch", new nomatch());
            SoundManager.instance.addSound("notswap", new notswap());
            SoundManager.instance.addSound("stonebreak", new stonebreak());
            SoundManager.instance.addSound("game_win", new game_win());
            SoundManager.instance.addSound("thunder", new thunder());
            SoundManager.instance.addSound("unswap", new unswap());
            SoundManager.instance.addSound("warningmove", new warningmove());
            SoundManager.instance.addSound("warningtime", new warningtime());
        }


    }
}//package com.popchan.sugar.core.manager
