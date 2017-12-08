//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.framework.core
{
    import com.popchan.framework.manager.TimerManager;
    import com.popchan.framework.manager.LayerManager;
    import com.popchan.framework.manager.Layer3DManager;
    import com.popchan.framework.manager.StageManager;
    import com.popchan.framework.manager.Stage3DManager;
    import com.popchan.framework.manager.TipManager;
    import starling.utils.AssetManager;
    import flash.geom.Rectangle;
    import flash.display.Stage;

    public class Core 
    {

        public static var timerManager:TimerManager = new TimerManager();
        public static var layerManager:LayerManager = new LayerManager();
        public static var layer3DManager:Layer3DManager = new Layer3DManager();
        public static var stageManager:StageManager = new StageManager();
        public static var stage3DManager:Stage3DManager = new Stage3DManager();
        public static var tipManager:TipManager = new TipManager();
        public static var texturesManager:AssetManager = new AssetManager();


        public static function init(_arg_1:Stage):void
        {
            stageManager.setup(_arg_1, new Rectangle(0, 0, _arg_1.stageWidth, _arg_1.stageHeight));
            stage3DManager.setup(_arg_1, new Rectangle(0, 0, _arg_1.stageWidth, _arg_1.stageHeight));
            layerManager.setup();
            layer3DManager.setup();
        }


    }
}//package com.popchan.framework.core
