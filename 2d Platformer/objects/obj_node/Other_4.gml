// generate nodes on top of solid walls
with (obj_wall) {
	if object_index != obj_moving_wall
	{
	    
	    var _previousNode = noone;
    
	    for (var _x = bbox_left; _x <= bbox_right; _x += CELL_SIZE) {
	        var _nodeX = _x + (CELL_SIZE / 2); 
	        var _nodeY = bbox_top - 16; 
        
	        var _hasFloorBelow = position_meeting(_nodeX, _nodeY + 16, obj_wall);
	        var _isAirAbove    = !position_meeting(_nodeX, _nodeY - 16, obj_wall);
	        var _inRoom        = (_nodeX >= 0 && _nodeX <= room_width && _nodeY >= 0 && _nodeY <= room_height);
        
	        if (_hasFloorBelow && _isAirAbove && _inRoom) {
	            var _newNode = new global.NavNode(_nodeX, _nodeY, "walk");
	            array_push(global.nodes, _newNode);
            
	            if (_previousNode != noone) {
	                var _pathBlocked = check_solid_wall_blocked(_previousNode.x, _previousNode.y - 4, _nodeX, _nodeY - 4);
	                if (!_pathBlocked) {
	                    _previousNode.connect(_newNode, "walk");
	                    _newNode.connect(_previousNode, "walk");
	                }
	            }
	            _previousNode = _newNode;
	        } else {
	            _previousNode = noone;
	        }
	    }
	}
}

//nodes on semi solid walls
with (obj_semi_solid_wall) {
    if (object_index != obj_semi_solid_moving_wall) {
        
        var _previousNode = noone;
        
        for (var _x = bbox_left; _x <= bbox_right; _x += CELL_SIZE) {
            var _nodeX = _x + (CELL_SIZE / 2); 
            var _nodeY = bbox_top - 16; 
            
            var _hasFloorBelow = position_meeting(_nodeX, _nodeY + 16, obj_semi_solid_wall);
            var _isAirAbove    = !position_meeting(_nodeX, _nodeY - 16, obj_wall);
            var _inRoom        = (_nodeX >= 0 && _nodeX <= room_width && _nodeY >= 0 && _nodeY <= room_height);
            
            if (_hasFloorBelow && _isAirAbove && _inRoom) {
                var _newNode = new global.NavNode(_nodeX, _nodeY, "walk");
                array_push(global.nodes, _newNode);
                
                if (_previousNode != noone) {
                    var _pathBlocked = check_solid_wall_blocked(_previousNode.x, _previousNode.y - 4, _nodeX, _nodeY - 4);
                    if (!_pathBlocked) {
                        _previousNode.connect(_newNode, "walk");
                        _newNode.connect(_previousNode, "walk");
                    }
                }
                _previousNode = _newNode;
            } else {
                _previousNode = noone;
            }
        }
    }
}

var _nodeCount = array_length(global.nodes);

//nodes as edge or walk
for (var i = 0; i < _nodeCount; i++) {
    var _node = global.nodes[i];
    
    var _hasWallLeft  = position_meeting(_node.x - 32, _node.y + 16, obj_wall) || position_meeting(_node.x - 32, _node.y + 16, obj_semi_solid_wall);
    var _hasWallRight = position_meeting(_node.x + 32, _node.y + 16, obj_wall) || position_meeting(_node.x + 32, _node.y + 16, obj_semi_solid_wall);
    
    var _isAtRoomEdge = (_node.x <= 32 || _node.x >= room_width - 32);
    
    if (((!_hasWallLeft || !_hasWallRight) && !_isAtRoomEdge)) {
        _node.type = "edge";
    } else {
        _node.type = "walk";
    }
}

//wall collision checks (ignores semi-solid walls so paths can draw through them)
function check_solid_wall_blocked(_x1, _y1, _x2, _y2) {
    var _dist = point_distance(_x1, _y1, _x2, _y2);
    var CELL_SIZEs = max(1, floor(_dist / 8));
    
    for (var s = 0; s <= CELL_SIZEs; s++) {
        var _px = lerp(_x1, _x2, s / CELL_SIZEs);
        var _py = lerp(_y1, _y2, s / CELL_SIZEs);
        
        with (obj_wall) {
            if (_px >= bbox_left && _px <= bbox_right && _py >= bbox_top + 4 && _py <= bbox_bottom) {
                return true;
            }
        }
    }
    return false;
}

//connect edge nodes using 2 outward air nodes perpendicular drops
for (var i = 0; i < _nodeCount; i++) {
    var _nodeA = global.nodes[i];
    
    if (_nodeA.type == "edge") {
        var _checkDirs = [1, -1];
        
        for (var d = 0; d < 2; d++) {
            var _dir = _checkDirs[d];
            var _isAirOpen = !position_meeting(_nodeA.x + (_dir * 32), _nodeA.y + 16, obj_wall) && 
                             !position_meeting(_nodeA.x + (_dir * 32), _nodeA.y + 16, obj_semi_solid_wall);
            
            if (_isAirOpen) {
                var _outX1 = _nodeA.x + (_dir * 32);
                var _outX2 = _nodeA.x + (_dir * 64);
                var _outY  = _nodeA.y;
                
                var _inRoom = (_outX2 >= 0 && _outX2 <= room_width && _outY >= 0 && _outY <= room_height);
                var _airBlocked = check_solid_wall_blocked(_nodeA.x, _nodeA.y, _outX2, _outY);
                
                if (_inRoom && !_airBlocked) {
                    //cast straight down to find the floor below
                    var _landingY = -1;
                    var _targetWallInst = noone;
                    var _testY = _outY;
                    
                    while (_testY < room_height) {
                        _testY += 16;
                        var _wInst = instance_position(_outX2, _testY, obj_wall);
                        if (_wInst == noone) _wInst = instance_position(_outX2, _testY, obj_semi_solid_wall);
                        
                        if (_wInst != noone) {
                            _targetWallInst = _wInst;
                            _landingY = _wInst.bbox_top - 16;
                            break;
                        }
                    }
                    
                    if (_landingY != -1 && _landingY > _outY && _targetWallInst != noone) {
                        //snap the drop X coordinate to the nearest grid node on the target platform
                        var _wallLeft = _targetWallInst.bbox_left;   
                        var _gridSnappedX = _wallLeft + 16 + round((_outX2 - (_wallLeft + 16)) / 32) * 32;
                        _gridSnappedX = clamp(_gridSnappedX, _targetWallInst.bbox_left + 16, _targetWallInst.bbox_right - 16);
                        
                        var _airDropX1 = _nodeA.x + (_dir * 32);
                        var _airDropX2 = _gridSnappedX;
                        
                        //check if vertical drop path is clear of solid walls
                        var _dropBlocked = check_solid_wall_blocked(_airDropX2, _outY, _airDropX2, _landingY);
                        
                        if (!_dropBlocked) {
                            //find or create landing node
                            var _landingNode = noone;
                            for (var j = 0; j < array_length(global.nodes); j++) {
                                var _n = global.nodes[j];
                                if (abs(_n.x - _airDropX2) <= 2 && abs(_n.y - _landingY) <= 2) {
                                    _landingNode = _n;
                                    break;
                                }
                            }
                            
                            if (_landingNode == noone) {
							    _landingNode = new global.NavNode(_airDropX2, _landingY, "walk");
							    array_push(global.nodes, _landingNode);
    
							    //IMPORTANT --- link landing nodes horizontally
							    for (var k = 0; k < array_length(global.nodes); k++) {
							        var _otherNode = global.nodes[k];
							        //check for other horizontal nodes and connect them
							        if (_otherNode != _landingNode && _otherNode.y == _landingY && abs(_otherNode.x - _landingNode.x) <= 32) {
							            var _blocked = check_solid_wall_blocked(_landingNode.x, _landingNode.y - 4, _otherNode.x, _otherNode.y - 4);
							            if (!_blocked) {
							                _landingNode.connect(_otherNode, "walk");
							                _otherNode.connect(_landingNode, "walk");
							            }
							        }
							    }
							}
                            
                            var _airNode1 = new global.NavNode(_airDropX1, _outY, "jump");
                            var _airNode2 = new global.NavNode(_airDropX2, _outY, "jump");
                            array_push(global.nodes, _airNode1);
                            array_push(global.nodes, _airNode2);
                            
                            //connect perpendicular
                            _nodeA.connect(_airNode1, "jump");
                            _airNode1.connect(_nodeA, "jump");
                            
                            _airNode1.connect(_airNode2, "jump");
                            _airNode2.connect(_airNode1, "jump");
                            
                            _airNode2.connect(_landingNode, "jump");
                            _landingNode.connect(_airNode2, "jump");
                        }
                    }
                }
            }
        }
    }
}

for (var i = 0; i < _nodeCount; i++) {
    var _node = global.nodes[i];
    
    if (_node.type == "edge") {
        var _hasJumpConnection = false;
        
        //check all neighbors to see if any link is a jump/drop action
        var _neighborCount = array_length(_node.neighbors);
        for (var j = 0; j < _neighborCount; j++) {
            var _link = _node.neighbors[j];
            if (_link.action == "jump") {
                _hasJumpConnection = true;
                break;
            }
        }
        
        //if it's marked as an edge but has no jump/drop escape route, demote it to walk
        if (!_hasJumpConnection) {
			_node.type = "walk";
        }
    }
}

//connect edge nodes across gaps
for (var i = 0; i < array_length(global.nodes); i++) {
    var _nodeA = global.nodes[i];
    
    if (_nodeA.type == "edge") {
        var _checkDirs = [1, -1];
        var _maxHorizJump = 32 * 5; 
        var _maxVertRise  = 32 * 2;  
        var _maxVertFall  = 32 * 2;  
        
        for (var d = 0; d < 2; d++) {
            var _dir = _checkDirs[d];
            
            var _bestNodeB = noone;
            var _minDist = infinity;
            
            for (var j = 0; j < array_length(global.nodes); j++) {
                var _nodeB = global.nodes[j];
                
                //must be a different node in the correct direction
                if (_nodeB != _nodeA && _nodeB.type == "edge" && sign(_nodeB.x - _nodeA.x) == _dir) {
                    var _distX = abs(_nodeB.x - _nodeA.x);
                    var _distY = _nodeB.y - _nodeA.y; 
                    
                    //must be across an actual gap (> 32px) and within jump range
                    if (_distX > 32 && _distX <= _maxHorizJump && _distY >= -_maxVertRise && _distY <= _maxVertFall) {
                        var _pathBlocked = check_solid_wall_blocked(_nodeA.x, _nodeA.y - 12, _nodeB.x, _nodeB.y - 12);
                        
                        if (!_pathBlocked) {
                            var _totalDist = point_distance(_nodeA.x, _nodeA.y, _nodeB.x, _nodeB.y);
                            
                            //find the single closest valid edge across the gap
                            if (_totalDist < _minDist) {
                                _minDist = _totalDist;
                                _bestNodeB = _nodeB;
                            }
                        }
                    }
                }
            }
            
            //connect the best edges across the gap
            if (_bestNodeB != noone) {
                _nodeA.connect(_bestNodeB, "jump");
                _bestNodeB.connect(_nodeA, "jump");
            }
        }
    }
}

for (var i = 0; i < _nodeCount; i++) {
    var _nodeA = global.nodes[i];
    
    for (var j = 0; j < _nodeCount; j++) {
        var _nodeB = global.nodes[j];
        
        if (_nodeB != _nodeA) {
            var _distX = abs(_nodeB.x - _nodeA.x);
            var _distY = abs(_nodeB.y - _nodeA.y);
            
            //ff they are on the same vertical plane and within 34 pixels horizontally
            if (_distY <= 2 && _distX <= 34) {
                
                //ensure no solid walls block the direct horizontal line between them
                var _blocked = check_solid_wall_blocked(_nodeA.x, _nodeA.y - 4, _nodeB.x, _nodeB.y - 4);
                
                if (!_blocked) {
                    _nodeA.connect(_nodeB, "walk");
                    _nodeB.connect(_nodeA, "walk");
                }
            }
        }
    }
}