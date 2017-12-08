//Created by Action Script Viewer - http://www.buraks.com/asv
package com.popchan.sugar.modules.end.view
{
    import com.popchan.sugar.modules.BasePanel3D;
    import starling.display.Image;
    import starling.textures.Texture;
    import com.popchan.framework.core.Core;
    import com.popchan.sugar.core.Model;
    import com.popchan.sugar.modules.map.vo.LevelVO;

    public class VictoryPanel extends BasePanel3D 
    {


        override public function close():void
        {
            super.close();
        }

        override public function hide():void
        {
            super.hide();
        }

        override public function init():void
        {
            super.init();
            var _local_1:Image = new Image(Texture.fromTexture(Core.texturesManager.getTexture("dialogsuccess")));
            addChild(_local_1);
        }

        override public function show(_arg_1:*):void
        {
            super.show(_arg_1);
            if (Model.levelModel.currentLevel == Model.levelModel.selectedLevel)
            {
                Model.levelModel.currentLevel++;
                if (Model.levelModel.currentLevel > Model.levelModel.totalLevel)
                {
                    Model.levelModel.currentLevel = Model.levelModel.totalLevel;
                };
            };
            var _local_2:int = 2;
            var _local_3:LevelVO = Model.levelModel.getLevelVO(Model.levelModel.selectedLevel);
            _local_3.star = _local_2;
            _local_3.highscore = Model.gameModel.highScore;
            Model.levelModel.saveData();
        }

        override public function updateData(_arg_1:*):void
        {
            super.updateData(_arg_1);
        }


    }
}//package com.popchan.sugar.modules.end.view
