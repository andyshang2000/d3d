//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.processors
{
    import flash.events.EventDispatcher;
    
    import zzsdk.editor.utils.Client;

    public class BaseProcessor extends EventDispatcher implements IExecutable, IDisposable 
    {
        protected var executables:Array;

        public function BaseProcessor()
        {
            this.executables = [];
        }

        public function get client():Client
        {
            return (UIGlobals.root.client);
        }

        public function add(_arg_1:IExecutable):void
        {
            this.executables.addItem(_arg_1);
        }

        public function dispose():void
        {
            this.clear();
        }

        public function clear():void
        {
            this.executables.removeAll();
        }

        public function execute():void
        {
            throw (Error("Not implemented."));
        }

        public function get active():Boolean
        {
            return ((this.executables.length > 0));
        }


    }
}//package com.edgebee.atlas.managers.processors
