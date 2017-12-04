//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop.astar
{
    import flash.utils.Dictionary;

    public class PriorityQueue 
    {

        private var _heap:Array;
        private var _size:int;
        private var _count:int;
        private var _posLookup:Dictionary;
        private var compare:Function;
        private var printFunc:Function;

        public function PriorityQueue(_arg_1:Function, _arg_2:int, _arg_3:Function)
        {
            this._heap = new Array((this._size = (_arg_2 + 1)));
            this._posLookup = new Dictionary(true);
            this._count = 0;
            this.compare = _arg_1;
            this.printFunc = _arg_3;
        }

        public function get front()
        {
            return (this._heap[1]);
        }

        public function get maxSize():int
        {
            return (this._size);
        }

        public function enqueue(_arg_1:*):Boolean
        {
            if ((this._count + 1) < this._size)
            {
                this._count++;
                this._heap[this._count] = _arg_1;
                this._posLookup[_arg_1] = this._count;
                this.walkUp(this._count);
                return (true);
            };
            return (false);
        }

        public function dequeue()
        {
            var _local_1:*;
            if (this._count >= 1)
            {
                _local_1 = this._heap[1];
                delete this._posLookup[_local_1];
                this._heap[1] = this._heap[this._count];
                this.walkDown(1);
                delete this._heap[this._count];
                this._count--;
                return (_local_1);
            };
            return (null);
        }

        public function remove(_arg_1:*):Boolean
        {
            var _local_2:int;
            var _local_3:*;
            if (this._count >= 1)
            {
                _local_2 = this._posLookup[_arg_1];
                _local_3 = this._heap[_local_2];
                delete this._posLookup[_local_3];
                this._heap[_local_2] = this._heap[this._count];
                this.walkDown(_local_2);
                delete this._heap[this._count];
                delete this._posLookup[this._count];
                this._count--;
                return (true);
            };
            return (false);
        }

        public function contains(_arg_1:*):Boolean
        {
            return (!((this._posLookup[_arg_1] == undefined)));
        }

        public function clear():void
        {
            this._heap = new Array(this._size);
            this._posLookup = new Dictionary(true);
            this._count = 0;
        }

        public function get size():int
        {
            return (this._count);
        }

        public function isEmpty():Boolean
        {
            return ((this._count == 0));
        }

        public function toString():String
        {
            return ((("[PriorityQueue, size=" + this._size) + "]"));
        }

        public function dump():String
        {
            if (this._count == 0)
            {
                return ("PriorityQueue (empty)");
            };
            var _local_1 = "PriorityQueue\n{\n";
            var _local_2:int = (this._count + 1);
            var _local_3:int = 1;
            while (_local_3 < _local_2)
            {
                if (this.printFunc != null)
                {
                    _local_1 = (_local_1 + (("\t" + this.printFunc(this._heap[_local_3])) + "\n"));
                }
                else
                {
                    _local_1 = (_local_1 + (("\t" + this._heap[_local_3]) + "\n"));
                };
                _local_3++;
            };
            return ((_local_1 + "\n}"));
        }

        private function walkUp(_arg_1:int):void
        {
            var _local_3:*;
            var _local_2 = (_arg_1 >> 1);
            var _local_4:* = this._heap[_arg_1];
            while (_local_2 > 0)
            {
                _local_3 = this._heap[_local_2];
                if (this.compare(_local_4, _local_3))
                {
                    this._heap[_arg_1] = _local_3;
                    this._posLookup[_local_3] = _arg_1;
                    _arg_1 = _local_2;
                    _local_2 = (_local_2 >> 1);
                }
                else
                {
                    break;
                };
            };
            this._heap[_arg_1] = _local_4;
            this._posLookup[_local_4] = _arg_1;
        }

        private function walkDown(_arg_1:int):void
        {
            var _local_3:*;
            var _local_2 = (_arg_1 << 1);
            var _local_4:* = this._heap[_arg_1];
            while (_local_2 < this._count)
            {
                if (this.compare(this._heap[int((_local_2 + 1))], this._heap[_local_2]))
                {
                    _local_2++;
                };
                _local_3 = this._heap[_local_2];
                if (this.compare(_local_3, _local_4))
                {
                    this._heap[_arg_1] = _local_3;
                    this._posLookup[_local_3] = _arg_1;
                    this._posLookup[_local_4] = _local_2;
                    _arg_1 = _local_2;
                    _local_2 = (_local_2 << 1);
                }
                else
                {
                    break;
                };
            };
            this._heap[_arg_1] = _local_4;
            this._posLookup[_local_4] = _arg_1;
        }


    }
}//package com.edgebee.atlas.astar
