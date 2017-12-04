//Created by Action Script Viewer - http://www.buraks.com/asv
package diary.shop
{
    import flash.events.Event;
    import flash.utils.Dictionary;
    
    import __AS3__.vec.Vector;
    
    import diary.shop.astar.AStarMultipleSearch;
    import diary.shop.astar.AStarNode;
    import diary.shop.astar.AStarSearch;
    import diary.shop.astar.PointOfInterest;
    import diary.shop.astar.PointOfInterestCollection;
    import diary.shop.astar.StaticPath;
    import diary.shop.fsm.AutomaticClockMachine;
    
    import zzsdk.editor.utils.Client;

    public class Agent extends AutomaticClockMachine
    {
        public static const REACHED_FINAL_DESTINATION:String = "ReachedFinalDestination";
		
        public var client:Client;
        public var player:Player;
        public var scene:Shopr2Scene;
        public var gameView:GameView;
        public var poi:PointOfInterest;
        private var _inScene:Boolean;
        private var _path:StaticPath;
        private var _characterView:ICharacterView;
        private var _bubbleView:BubbleView;

        public function Agent()
        {
            super(UIGlobals.root.client.processorTimer);
            this.client = (UIGlobals.root.client as Client);
            this.player = this.client.player;
            this.gameView = (UIGlobals.root as Shopr2).gameView;
            this.scene = this.gameView.sceneView.currentScene;
        }

        public function get characterView():ICharacterView
        {
            return (this._characterView);
        }

        public function set characterView(_arg_1:ICharacterView):void
        {
            if (this._characterView != null)
            {
                throw (new Error("The same agent cannot be used for different character view"));
            };
            this._characterView = _arg_1;
        }

        public function interact():void
        {
        }

        public function addToScene():void
        {
            if (this._inScene)
            {
                throw (new Error("An agent can only be added once to the scene"));
            };
            this.characterView.addToScene(this.scene, true);
            this.updateBubbleView();
            this._inScene = true;
        }

        protected function removeFromScene():void
        {
            if (this._bubbleView != null)
            {
                if (this._characterView != null)
                {
                    (this.characterView as NewCharacterView).bubbleSprite.removeChild(this._bubbleView);
                };
                this._bubbleView.remove();
                this._bubbleView = null;
            };
            if (this._inScene)
            {
                this._characterView.removeFromScene(this.scene, true);
                this._characterView = null;
                this._inScene = false;
            };
        }

        public function dispose():void
        {
            if (this.poi != null)
            {
                this.poi.reserved = false;
            };
            stop();
            this.removeFromScene();
        }

        public function leave():void
        {
            if (this.poi != null)
            {
                this.poi.reserved = false;
                this.poi = null;
            };
        }

        public function reachedDestination():void
        {
            if (this._path.done())
            {
                dispatchEvent(new Event(REACHED_FINAL_DESTINATION));
            }
            else
            {
                this.characterView.walk(this._path.getNextNode().point);
            };
        }

        public function walkTo(_arg_1:int, _arg_2:int):void
        {
            var _local_7:AStarNode;
            var _local_3:AStarNode = this.scene.aStarMap.getNode(_arg_1, _arg_2);
            var _local_4:AStarNode = this.scene.aStarMap.getNode(this.characterView.getIsoX(), this.characterView.getIsoY());
            var _local_5:AStarSearch = new AStarSearch(_local_4, _local_3);
            var _local_6:Array = _local_5.perform();
            this._path = new StaticPath(_local_6);
            if (this._path.done())
            {
                dispatchEvent(new Event(REACHED_FINAL_DESTINATION));
            }
            else
            {
                _local_7 = this._path.getNextNode();
                this.characterView.walk(_local_7.point);
            };
        }

        public function continueFromEntranceToPOI(_arg_1:PointOfInterest):void
        {
            var _local_2:AStarNode;
            this._path = new StaticPath(_arg_1.getPathFromEntrance(this.player.entranceNode, this.scene.aStarMap));
            if (this._path.done())
            {
                dispatchEvent(new Event(REACHED_FINAL_DESTINATION));
            }
            else
            {
                _local_2 = this._path.getNextNode();
                this.characterView.setNextIsoPosition(_local_2.point);
            };
        }

        public function walkBackFromPOI(_arg_1:PointOfInterest):void
        {
            var _local_2:AStarNode;
            this._path = new StaticPath(_arg_1.getPathToExit(this.player.exitNode, this.scene.aStarMap));
            if (this._path.done())
            {
                dispatchEvent(new Event(REACHED_FINAL_DESTINATION));
            }
            else
            {
                _local_2 = this._path.getNextNode();
                this.characterView.walk(_local_2.point);
            };
        }

        public function walkUsingPath(_arg_1:Array):void
        {
            var _local_2:AStarNode;
            this._path = new StaticPath(_arg_1);
            if (this._path.done())
            {
                dispatchEvent(new Event(REACHED_FINAL_DESTINATION));
            }
            else
            {
                _local_2 = this._path.getNextNode();
                this.characterView.walk(_local_2.point);
            };
        }

        public function continueUsingPath(_arg_1:Array):void
        {
            var _local_2:AStarNode;
            this._path = new StaticPath(_arg_1);
            if (this._path.done())
            {
                dispatchEvent(new Event(REACHED_FINAL_DESTINATION));
            }
            else
            {
                _local_2 = this._path.getNextNode();
                this.characterView.setNextIsoPosition(_local_2.point);
            };
        }

        public function getDistanceFromModuleInstance(_arg_1:ModuleInstance):Array
        {
            var _local_5:PointOfInterest;
            var _local_6:AStarNode;
            var _local_7:AStarSearch;
            var _local_8:Number;
            var _local_2:AStarNode = this.scene.aStarMap.getNode(this.characterView.getIsoX(), this.characterView.getIsoY());
            var _local_3:PointOfInterest;
            var _local_4:Number = 0;
            for each (_local_5 in _arg_1.poiCollection.freePointOfInterests)
            {
                _local_6 = this.scene.aStarMap.getNode(_local_5.point.x, _local_5.point.y);
                _local_7 = new AStarSearch(_local_2, _local_6);
                _local_7.perform();
                _local_8 = _local_7.cost();
                if ((((_local_3 == null)) || ((_local_4 > _local_8))))
                {
                    _local_3 = _local_5;
                    _local_4 = _local_8;
                };
            };
            return ([_local_3, _local_4]);
        }

        public function getClosestPOI(_arg_1:uint, _arg_2:DataArray, _arg_3:int=-1):Array
        {
            var _local_7:ModuleInstance;
            var _local_8:ModuleInstance;
            var _local_9:PointOfInterest;
            var _local_10:AStarNode;
            var _local_11:AStarSearch;
            var _local_12:Number;
            var _local_4:PointOfInterest;
            var _local_5:Number = 0;
            var _local_6:AStarNode = this.scene.aStarMap.getNode(this.characterView.getIsoX(), this.characterView.getIsoY());
            for each (_local_8 in _arg_2)
            {
                if (_local_8.module.type == _arg_1)
                {
                    for each (_local_9 in _local_8.poiCollection.freePointOfInterests)
                    {
                        _local_10 = this.scene.aStarMap.getNode(_local_9.point.x, _local_9.point.y);
                        _local_11 = new AStarSearch(_local_6, _local_10);
                        _local_11.perform();
                        _local_12 = (_local_11.cost() + _local_9.cost);
                        if ((((_local_4 == null)) || ((_local_5 > _local_12))))
                        {
                            _local_4 = _local_9;
                            _local_5 = _local_12;
                            _local_7 = _local_8;
                        };
                    };
                };
            };
            return ([_local_4, _local_5, _local_7]);
        }

        private function sortPotentialModules(_arg_1:Array, _arg_2:Array):int
        {
            return ((_arg_1[1] - _arg_2[1]));
        }

        public function getRandomPOIWithLeastCustomersFromEntrance(_arg_1:uint, _arg_2:DataArray):PointOfInterest
        {
            var _local_4:ModuleInstance;
            var _local_6:int;
            var _local_10:PointOfInterest;
            var _local_3:Array = [];
            for each (_local_4 in _arg_2)
            {
                if (_local_4.module.type == _arg_1)
                {
                    if (_local_4.hasFreePOI)
                    {
                        _local_3.push([_local_4, _local_4.nbOccupiedPOI]);
                    };
                };
            };
            if (_local_3.length == 0)
            {
                return (null);
            };
            _local_3.sort(this.sortPotentialModules);
            var _local_5:int = _local_3[0][1];
            _local_6 = 1;
            while (_local_6 < _local_3.length)
            {
                if (_local_3[_local_6][1] > _local_5) break;
                _local_6++;
            };
            var _local_7:uint = Random.randRange(0, _local_6);
            _local_4 = (_local_3[_local_7][0] as ModuleInstance);
            var _local_8:Number = Number.MAX_VALUE;
            var _local_9:PointOfInterest;
            for each (_local_10 in _local_4.poiCollection.freePointOfInterests)
            {
                if (_local_10.cost < _local_8)
                {
                    _local_8 = _local_10.cost;
                    _local_9 = _local_10;
                };
            };
            return (_local_9);
        }

        public function getClosestBinPOI(_arg_1:Resource, _arg_2:DataArray):Array
        {
            var _local_6:ModuleInstance;
            var _local_8:ModuleInstance;
            var _local_9:PointOfInterest;
            var _local_10:AStarNode;
            var _local_11:AStarSearch;
            var _local_12:Number;
            var _local_3:PointOfInterest;
            var _local_4:Number = Number.MAX_VALUE;
            var _local_5:AStarNode = this.scene.aStarMap.getNode(this.characterView.getIsoX(), this.characterView.getIsoY());
            var _local_7:Boolean;
            for each (_local_8 in _arg_2)
            {
                if (_local_8.module.type == Module.TYPE_BIN)
                {
                    if (_local_8.hasResource(_arg_1))
                    {
                        _local_7 = true;
                        for each (_local_9 in _local_8.poiCollection.freePointOfInterests)
                        {
                            _local_10 = this.scene.aStarMap.getNode(_local_9.point.x, _local_9.point.y);
                            if (_local_10)
                            {
                                _local_11 = new AStarSearch(_local_5, _local_10);
                                _local_11.perform();
                                _local_12 = _local_11.cost();
                                if (_local_4 > _local_12)
                                {
                                    _local_3 = _local_9;
                                    _local_4 = _local_12;
                                    _local_6 = _local_8;
                                };
                            };
                        };
                    };
                };
            };
            return ([_local_3, _local_4, _local_6, _local_7]);
        }

        public function getFreePoi(_arg_1:uint, _arg_2:DataArray, _arg_3:int=-1, _arg_4:int=-1):PointOfInterest
        {
            var _local_7:ModuleInstance;
            var _local_8:PointOfInterest;
            var _local_9:Number;
            var _local_5:PointOfInterest;
            var _local_6:Number = Number.MAX_VALUE;
            for each (_local_7 in _arg_2)
            {
                if (_local_7.module.type == _arg_1)
                {
                    if ((((_arg_4 == -1)) || ((_local_7.module.id == _arg_4))))
                    {
                        for each (_local_8 in _local_7.poiCollection.freePointOfInterests)
                        {
                            _local_9 = _local_8.cost;
                            if (_local_6 > _local_9)
                            {
                                _local_5 = _local_8;
                                _local_6 = _local_9;
                            };
                        };
                    };
                };
            };
            return (_local_5);
        }

        private function compareDistances(_arg_1:Array, _arg_2:Array):Number
        {
            return ((_arg_1[0] - _arg_2[0]));
        }

        public function getAlmostClosestPOI(_arg_1:PointOfInterestCollection, _arg_2:Number, _arg_3:AStarNode=null):PointOfInterest
        {
            var _local_6:int;
            var _local_7:PointOfInterest;
            var _local_8:AStarMultipleSearch;
            var _local_9:Dictionary;
            var _local_10:AStarNode;
            var _local_11:PointOfInterest;
            var _local_12:AStarNode;
            var _local_13:Number;
            var _local_14:Number;
            var _local_15:Number;
            if (_arg_3 == null)
            {
                _arg_3 = this.scene.aStarMap.getNode(this.characterView.getIsoX(), this.characterView.getIsoY());
            };
            var _local_4:Array = [];
            var _local_5:Vector.<AStarNode> = new Vector.<AStarNode>();
            for each (_local_7 in _arg_1.freePointOfInterests)
            {
                _local_10 = this.scene.aStarMap.getNode(_local_7.point.x, _local_7.point.y);
                _local_5.push(_local_10);
            };
            _local_8 = new AStarMultipleSearch(_arg_3, _local_5);
            _local_8.perform();
            _local_9 = _local_8.costs();
            _local_6 = 0;
            while (_local_6 < _local_5.length)
            {
                _local_11 = _arg_1.freePointOfInterests[_local_6];
                _local_12 = this.scene.aStarMap.getNode(_local_11.point.x, _local_11.point.y);
                _local_13 = _local_9[_local_12.key];
                _local_4.push([(_local_11.cost + _local_13), _local_11]);
                _local_6++;
            };
            if (_local_4.length > 0)
            {
                _local_4.sort(this.compareDistances);
                _local_14 = _local_4[0][0];
                _local_15 = (_local_14 + _arg_2);
                _local_6 = 0;
                while (_local_6 < _local_4.length)
                {
                    if (_local_4[_local_6][0] > _local_15) break;
                    _local_6++;
                };
                _local_4.splice(_local_6);
                return (Random.choice(_local_4)[1]);
            };
            return (null);
        }

        public function setBubbleType(_arg_1:int):void
        {
            if (((!((this._bubbleView == null))) && (!((this._bubbleView.imageType == _arg_1)))))
            {
                this._bubbleView.pop(_arg_1);
            };
        }

        public function hurry():void
        {
            this._bubbleView.hurry();
        }

        public function setBubbleSubImageTextureName(_arg_1:String, _arg_2:uint=0, _arg_3:Number=0):void
        {
            this._bubbleView.setSubImageTextureName(_arg_1, _arg_2, _arg_3);
        }

        protected function updateBubbleView():void
        {
            if (!this._bubbleView)
            {
                this.createBubbleView();
            };
        }

        protected function createBubbleView():void
        {
            this._bubbleView = new BubbleView();
            this._bubbleView.x = 40;
            this._bubbleView.y = -145;
            (this.characterView as NewCharacterView).bubbleSprite.addChild(this._bubbleView);
        }

        public function lookAtCamera():void
        {
            var _local_1:uint = this.characterView.getCurrentAxis();
            if (_local_1 == AStarNode.NORTH)
            {
                this.characterView.setCurrentAxis(AStarNode.WEST);
            }
            else
            {
                if (_local_1 == AStarNode.EAST)
                {
                    this.characterView.setCurrentAxis(AStarNode.SOUTH);
                };
            };
        }


    }
}//package com.edgebee.shopr2.controller.agent
