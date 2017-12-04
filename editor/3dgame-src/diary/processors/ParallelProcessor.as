//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.processors
{
    import com.edgebee.atlas.util.Cursor;
    import com.edgebee.atlas.interfaces.IExecutable;

    public class ParallelProcessor extends BaseProcessor 
    {


        override public function execute():void
        {
            var _local_1:Cursor;
            var _local_2:IExecutable;
            if (active)
            {
                _local_1 = new Cursor(executables);
                while (_local_1.valid)
                {
                    _local_2 = (_local_1.current as IExecutable);
                    _local_2.execute();
                    if (!_local_2.active)
                    {
                        _local_1.remove();
                    }
                    else
                    {
                        _local_1.next();
                    };
                };
            };
        }


    }
}//package com.edgebee.atlas.managers.processors
