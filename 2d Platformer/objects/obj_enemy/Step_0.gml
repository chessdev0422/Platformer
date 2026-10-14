if global.paused exit;

if !instance_exists(obj_player) exit;

canFallThroughPlat = false;//reset falling through semi-solid platforms

var _startNode;
if onGround
{
	_startNode = get_nearest_node(x, y, true);
}
else {
	_startNode = get_nearest_node(temp_nearest_x, temp_nearest_y, true);
}

var _targetNode = get_nearest_node(obj_player.x, obj_player.y);

//show_debug_message(jumpKeyBuffered);

path_to_follow = a_star_find_path(_startNode, _targetNode);

//debug path code 
/*
var _path_str = "";
for (var i = 0; i < array_length(path_to_follow); i++) {
    _path_str += "(" + string(path_to_follow[i].x) + ", " + string(path_to_follow[i].y) + ") ";
}
show_debug_message("Path [0 to End]: " + _path_str);*/

if (array_length(path_to_follow) > 0) {

	path_to_follow = array_reverse(path_to_follow);

}

/*
var _path_str = "";
for (var i = 0; i < array_length(path_to_follow); i++) {
    _path_str += "(" + string(path_to_follow[i].x) + ", " + string(path_to_follow[i].y) + ") ";
}
show_debug_message("Path Reversed [0 to End]: " + _path_str);*/

moveDir = 0;

//check if we have a valid path with at least a next waypoint
if (array_length(path_to_follow) > 0) {
    var _current_node = path_to_follow[0];
    var _next_node    = (array_length(path_to_follow) > 1) ? path_to_follow[1] : _current_node;
	
    var _target_x = (array_length(path_to_follow) > 1) ? _next_node.x : _current_node.x;
    var _distToNode = point_distance(x, y, _target_x, y);
  	
	
	//implement jumping checks
	var _isJumpStep = false;

	if (array_length(path_to_follow) > 1 && yspd <= 0) {
	    var _maxVertRise  = 32 * 5.5 - 1;
		var _dist_to_node = abs(x - _current_node.x);
	    var _dist_x       = abs(_next_node.x - _current_node.x);
	    var _dist_y       = _next_node.y - _current_node.y;
    
	    for (var i = 0; i < array_length(_current_node.neighbors); i++) {
	        var _link = _current_node.neighbors[i];
        
	        if (_link.node == _next_node) {
	            var _is_explicit_jump = (_link.action == "jump") && (_dist_y < 0) && (_dist_y >= -_maxVertRise) && _dist_to_node < 2;
	            var _is_edge_gap = (_current_node.type == "edge" && _next_node.type == "edge" && _dist_x > 12 && _dist_to_node < 2 && _dist_y >= -_maxVertRise);
				
				var _check_height = abs(_next_node.y - y);
				var _hasOverheadWall = collision_rectangle(
				    x - (sprite_width / 2) - moveSpd, 
				    y, 
				    x + (sprite_width / 2) + moveSpd, 
				    y - _check_height, 
				    obj_wall, 
				    false, 
				    true
				);
            
				//if _hasOverheadWall show_debug_message("gg");
				
	            if ((_is_explicit_jump || _is_edge_gap) && !_hasOverheadWall) {
	                _isJumpStep = true;
	                break;
	            }
	        }
	    }
	}
	
	//check if we are falling through a semi-solid plat along the path
	if (array_length(path_to_follow) > 1 && yspd >= 0) {
	    var _dist_y = _next_node.y - _current_node.y;
	    var _is_vertical_drop = (abs(_current_node.x - _next_node.x) < 1);
    
	    for (var i = 0; i < array_length(_current_node.neighbors); i++) {
	        var _link = _current_node.neighbors[i];
        
	        if (_link.node == _next_node) {
	            if (_link.action == "jump" && _dist_y > 0 && _is_vertical_drop && onGround) {
	                canFallThroughPlat = true;
	                break;
	            }
	        }
	    }
	}
	
	if (array_length(path_to_follow) > 2) {
	    var _i = 1;
	
		var _max_lookahead = min(4, array_length(path_to_follow));
		
		for (var i = 1; i < _max_lookahead; i++) {
	        if (path_to_follow[i].y < path_to_follow[0].y) {
	            _max_lookahead = 3;
	            break;
	        }
	    }
		
	    while (_i < _max_lookahead && _i < array_length(path_to_follow)) {
	        if (path_to_follow[_i].type != "air") {
	            _target_x = path_to_follow[_i].x;
	            break;
	        }
	        _i++;
	    }
	}
    
	//show_debug_message(_target_x);
	
	//movement control
	if (onGround) { //horizontal -- on the ground
	    if (x < _target_x - 2) {
	        moveDir = 1;  //right
	    } 
	    else if (x > _target_x + 2) {
	        moveDir = -1; //left
	    } else {
	        moveDir = 0;
	    }
	} else { //in the air
	    var _hasClearedHeight = (y <= _next_node.y + CELL_SIZE);

        if (!_hasClearedHeight) {
            //wait until we know we can clear the jump
            airDir = 0;
        } else {
            //calculate airDir once
            if (airDir == 0) {
                var _air_target_x = _target_x;
                var _lookahead_idx = 1;
                
                while (_air_target_x == _current_node.x && _lookahead_idx < array_length(path_to_follow)) { 
                    _air_target_x = path_to_follow[_lookahead_idx].x;
                    _lookahead_idx++;
                }

                if (abs(x - _air_target_x) > 2) {
                    airDir = sign(_air_target_x - x);
                }
            }
			
			//prevent overshooting
			if (y < _next_node.y) {
	            if ((airDir == 1 && x >= _target_x) || (airDir == -1 && x <= _target_x)) {
	                airDir = 0;
	            }
	        }
        }
        
        moveDir = airDir;
	}

	if (_isJumpStep && onGround) {
	    jumpKeyBuffered = true;
		
		//show_debug_message("jumping");
	
	    var _dist_y = abs(_next_node.y - y); // height
	    var _max_jump_height = 32 * 5.5;     // max height
	    var _t = clamp(_dist_y / _max_jump_height, 0, 1);
	    var _quadratic_curve = _t * _t;

	    jumpHoldTimer = round(8 + (_quadratic_curve * 12));
	}
}

//get "unstuck" from walls that have moved into the enemy in the begin step

//check from each direction
var _rightWall = noone;
var _leftWall = noone;
var _bottomWall = noone;
var _topWall = noone;

var _list = ds_list_create();

var _listSize = instance_place_list(x, y, obj_moving_wall, _list, false);

//loop through all colliding moving walls
for(var i = 0; i < _listSize; i++)
{
	var _listInst = _list[| i];
	
	//if there are walls, get the closest one
	
	//right
	if _listInst.bbox_left - _listInst.xspd >= bbox_right-1
	{
		if !instance_exists(_rightWall) || (_listInst.bbox_left < _rightWall.bbox_left /*check which of the two walls is closest to the player*/)
		{
			_rightWall = _listInst;
		}
	}
	
	//left
	if _listInst.bbox_right - _listInst.xspd <= bbox_left+1
	{
		if !instance_exists(_leftWall) || (_listInst.bbox_right > _leftWall.bbox_right /*check which of the two walls is closest to the player*/)
		{
			_leftWall = _listInst;
		}
	}
	
	//bottom
	if _listInst.bbox_top - _listInst.yspd >= bbox_bottom-1
	{
		if !instance_exists(_bottomWall) || (_listInst.bbox_top < _bottomWall.bbox_top)
		{
			_bottomWall = _listInst;
		}
	}
	
	//top 
	if _listInst.bbox_bottom - _listInst.yspd <= bbox_top+1
	{
		if !instance_exists(_topWall) || (_listInst.bbox_bottom > _topWall.bbox_bottom)
		{
			_topWall = _listInst;
		}
	}
}

//destroy the ds_list to free memory
ds_list_destroy(_list);


//get out of the walls

	//horizontal----/(includes check for being shoved into a wall)
	//right wall
	if instance_exists(_rightWall) && !place_meeting(bbox_left + _rightWall.xspd, y, obj_wall)
	{
		var _rightDist = bbox_right - x;
		x = _rightWall.bbox_left - _rightDist;
	}
	
	//left wall
	if instance_exists(_leftWall)  && !place_meeting(bbox_right + _leftWall.xspd, y, obj_wall)
	{
		var _leftDist = x - bbox_left;
		x = _leftWall.bbox_right + _leftDist;
	}
	
	
	//vertical--------/
	//bottom wall
	if instance_exists(_bottomWall)
	{
		var _bottomDist = bbox_bottom - y;
		y = _bottomWall.bbox_top - _bottomDist;
	}
	
	//top wall
	if instance_exists(_topWall)
	{
		var _topDist = y - bbox_top;
		var _targetY = _topWall.bbox_bottom + _topDist;
		
		//extra check to avoid being pushed into walls
		if !place_meeting(x, _targetY, obj_wall)
		{
			y = _targetY;
		}
	}

//don't get left behind by the wall
earlyMoveWallxspd = false;
if instance_exists(currentFloor) && currentFloor.xspd != 0 && !place_meeting(x, y+1 + terminal_vel, currentFloor)
{
	//go ahead and move back onto the platform if not a wall in the way
	if !place_meeting(x + currentFloor.xspd, y, obj_wall)
	{
		x += currentFloor.xspd;
		earlyMoveWallxspd = true;
	}
}


//X movement
{
	//direction
	face = moveDir;
	
	//set xspd
	xspd = face * moveSpd;
	
	if face != 0 {draw_face = face;};
}
	//X collision ----- /
	
	//scoot right up to the wall
	var _subPixel = 0.5;
	
	if place_meeting(x + xspd, y, obj_wall)
	{
		var _pixelCheck = _subPixel * sign(xspd);//sign of xpsd returns essentially the same thing as face
		
		while(!place_meeting(x + _pixelCheck, y, obj_wall))//continue scooting until right up against the wall
		{
			x += _pixelCheck;
		}
		
		xspd = 0; //set xspd to 0 to "collide"
	}
//move the enemy in the x
x += xspd;	

//Y movement

	{
		//gravity
		yspd += grav;
		onGround = false;
	}
	
	//cap the yspd based on the terminal vel
	if yspd > terminal_vel {yspd = terminal_vel};
	
	
	
	
	//jumping-------------/
	
		//on ground
		if jumpKeyBuffered && jumpCount < maxJump
		{
			
			yspd = jumpSpd;//set the enemy jumping
		
			jumpKeyBuffered = false;//reset
			jumpKeyBufferTimer = 0;
		
			jumpCount++;//increase the number of jumps
		
			onGround = false; //reset everything when jumping
			currentFloor = noone;//VERY important to reset or wont be able to jump
		}
		
			if jumpHoldTimer > 0
			{
				//constantly set the yspd to be the jumping speed
				yspd = jumpSpd;
				//count down the timer
				jumpHoldTimer--;
			} else {
				jumpCount = 0;
			}
	
	//Y collision-----------/
	
	//up Y collisions-----/
	var _isWall = place_meeting(x, y + yspd, obj_wall)
	if _isWall
	{
		var _subPixel = 0.5;
		var _pixelCheck = _subPixel * sign(yspd);//sign of ypsd returns essentially the same thing as face
		
		while(!place_meeting(x, y + _pixelCheck, obj_wall))//continue scooting until right up against the wall/floor
		{
			y += _pixelCheck;
		}
		
		//bonk code ----- i.e. hitting head on ceiling
		if yspd < 0
		{
			// ceiling hit
		}
		
		yspd = 0; //set yspd to 0 to "collide"
	}
	

	//floor y collision-------------/
	
		//check for solid and semisolid walls beneath the enemy
		var _clamp_yspd = max(0, yspd);
	
		//look through the list of all walls we are currently colliding with
		var _list = ds_list_create();
	
		//create an array of potential colliding instances
		var _array = array_create(0);
		array_push(_array, obj_wall, obj_semi_solid_wall);
	
	
		var _listSize = instance_place_list(x, y+1 + _clamp_yspd + terminal_vel, _array, _list, false);
	
		
		var _ycheck = y + 1 + _clamp_yspd;
		if instance_exists(currentFloor) { _ycheck += max(0, currentFloor.yspd);};
		var _semiSolid = check_for_semisolid_platform(x, _ycheck);
		
		//loop through the colliding instances
		for(var i = 0; i < _listSize; i++)
		{
			//get an instance of the wall from the list
			var _listInst = _list[| i];
			
			if _listInst != forgetSemiSolidWall 
			&& (_listInst.yspd <= yspd || instance_exists(currentFloor))
			&& (_listInst.yspd > 0 || place_meeting(x, y+1 + _clamp_yspd, _listInst))//avoid "sticking" to the ground
			|| (_listInst == _semiSolid)
			{	
				var _solidWallBelow = _listInst.object_index == obj_wall || object_is_ancestor(_listInst.object_index, obj_wall)
				var _semiSolidWallBelow = floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.yspd)
				//return any solid walls or any semi-solid walls below the enemy
				if _solidWallBelow || _semiSolidWallBelow 
				{
					//return the "highest" wall object
					if !instance_exists(currentFloor)
					|| _listInst.bbox_top + _listInst.yspd <= currentFloor.bbox_top + currentFloor.yspd
					|| _listInst.bbox_top + _listInst.yspd  <= bbox_bottom
					{
						currentFloor = _listInst;
					}
				}
			}
		}
	
		//destroy the list
		ds_list_destroy(_list);

		//one last check to make sure the current floor is still below us
		if instance_exists(currentFloor) && !place_meeting(x, y+terminal_vel, currentFloor)
		{
			currentFloor = noone;
		}
		
		if yspd >= 0 && currentFloor != noone
		{
			onGround = true;
		}
		
		//land on the ground platform if there is one
			//scoot up precisely
			if instance_exists(currentFloor)
			{
				var _subPixel = 0.5;
				while !place_meeting(x, y + _subPixel, currentFloor) && !place_meeting(x, y, obj_wall)//check for the walls as well to prevent clipping
				{
					y += _subPixel;
				}
				
				//make sure we dont end up below the top of a semisolid
				if currentFloor.object_index == obj_semi_solid_wall || object_is_ancestor(currentFloor.object_index, obj_semi_solid_wall)
				{
					while place_meeting(x, y, currentFloor) {y -= _subPixel};
				}
				
				//floor the y
				y = floor(y);
				
				//collide with the ground
				yspd = 0;
				
				//set on ground to be true
				onGround = true;
			}
	
	
	//manually fall through a semi-solid platform
		if canFallThroughPlat
		{
			//make sure we have a semi-solid
			if instance_exists(currentFloor)
			&& (currentFloor.object_index == obj_semi_solid_wall || object_is_ancestor(currentFloor.object_index, obj_semi_solid_wall))
			{
				//check if we can go below the semi-solid
				var _ycheck = max(1, currentFloor.yspd+1);
				if !place_meeting(x, y + _ycheck, obj_wall)
				{
					//move below the platform
					y += 1;
					
					
					//inherit the platforms yspd
					yspd = _ycheck;
					
					//forget this platform for a brief time so we don't get "stuck" again
					forgetSemiSolidWall = currentFloor;
					
					onGround = false;
					coyoteHangTimer = 0;
					coyoteJumpTimer = 0;
					currentFloor = noone;
				}
			}
		}	

//move the enemy in the y
y += yspd;

//reset the forget semi solid wall
if instance_exists(forgetSemiSolidWall) && !place_meeting(x, y, forgetSemiSolidWall)
{
	forgetSemiSolidWall = noone;
}

//final moving platform collisions and movement

	//X - movement and collisions
		//get the moveWallxspd
		moveWallxspd = 0;
		
		if !earlyMoveWallxspd
		{
			if instance_exists(currentFloor) {moveWallxspd = currentFloor.xspd;};
	
			var _subPixel = 0.5;
	
			if place_meeting(x + moveWallxspd, y, obj_wall)
			{
				var _pixelCheck = _subPixel * sign(moveWallxspd);//sign of xpsd returns essentially the same thing as face
		
				while(!place_meeting(x + _pixelCheck, y, obj_wall))//continue scooting until right up against the wall
				{
					x += _pixelCheck;
				}
		
				moveWallxspd = 0; //set xspd to 0 to "collide"
			}
		}
		
	x += moveWallxspd; //move based on the moving platform's xspd
	
	//Y - snap enemy to currentFloor if it's a moving platform and is moving vertically
	if instance_exists(currentFloor) && (currentFloor.yspd != 0
	|| currentFloor.object_index == obj_semi_solid_moving_wall 
	|| object_is_ancestor(currentFloor.object_index, obj_semi_solid_moving_wall)
	|| currentFloor.object_index == obj_moving_wall 
	|| object_is_ancestor(currentFloor.object_index, obj_moving_wall))
	{
		//snap to the top of the floor platform
		if !place_meeting(x, currentFloor.bbox_top, obj_wall)
		&& currentFloor.bbox_top >= bbox_bottom - terminal_vel 
		{
			y = currentFloor.bbox_top; //unfloor y so its not choppy		
		}
	}
	
	//get pushed down through a semi-solid by a moving solid platform
	if instance_exists(currentFloor) 
	&& (currentFloor.object_index == obj_semi_solid_wall || object_is_ancestor(currentFloor.object_index, obj_semi_solid_wall))
	&& place_meeting(x, y, obj_wall) //I'm stuck in a wall while standing on a semi-solid platform
	{
		var _maxPushDist = 10;//the farthest a moving platform should be able to push the player downwards
		var _pushedDist = 0;
		var _start_y = y; //a reference point
		
		while place_meeting(x, y, obj_wall) && _pushedDist <= _maxPushDist
		{
			y++;
			_pushedDist++;
		}
		
		//set the current floor to be noone
		currentFloor = noone;
		
		//if still in wall, just return to starting y
		if _pushedDist > _maxPushDist
		{
			y = _start_y;
		}	
	}


//reset the air direction from the jumping code
if onGround
{
	airDir = 0;
	temp_nearest_x = x;
	temp_nearest_y = y;
}


//sprite control------------/

//walking
if abs(xspd) > 0 {sprite_index = walkSpr;};

//idle
if xspd == 0 {sprite_index = idleSpr;};

//in the air
if !onGround {sprite_index = jumpSpr;};

//attacking