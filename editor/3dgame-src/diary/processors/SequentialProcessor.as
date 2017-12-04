//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.processors
{
    import com.edgebee.atlas.util.Cursor;
    import com.edgebee.atlas.interfaces.IExecutable;

    public class SequentialProcessor extends BaseProcessor 
    {
        override public function execute():void
        {
            var _local_1:Cursor;
            var _local_2:Boolean;
            var _local_3:IExecutable;
            if (active)
            {
                _local_1 = new Cursor(executables);
                _local_2 = false;
                while (((!(_local_2)) && (_local_1.valid)))
                {
                    _local_3 = (_local_1.current as IExecutable);
                    _local_3.execute();
                    if (!_local_3.active)
                    {
                        _local_1.remove();
                        _local_2 = (executables.length == 0);
                    }
                    else
                    {
                        _local_2 = true;
                    };
                };
            };
        }


    }
}//package com.edgebee.atlas.managers.processors
