scr_get_controls();

//get "unstuck" from walls that have moved into the player in the begin step

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
		
		//extra check to avoid being pushed into walls and also for crouching
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

	//direction
	face = rightKey - leftKey;
	
	///set the moveType
	if onGround {
		moveType = runKey;
	}
	
	//set xspd
	xspd = face * moveSpd[moveType];
	
	if face != 0 {draw_face = face;};
	
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

//move the player in the x
x += xspd;	

//Y movement

	if coyoteHangTimer > 0
	{
		//subtract from the coyote hang timer
		coyoteHangTimer--;
	} else { 
		//gravity, only if coyote hang timer <= 0
		yspd += grav;
		onGround = false;
		coyoteHangTimer = 0;
	}
	
	//cap the yspd based on the terminal vel
	if yspd > terminal_vel {yspd = terminal_vel};
	
	//reset jump vars
	if onGround 
	{
		jumpCount = 0;
		jumpHoldTimer = 0;
		
		
		//coyote jump time
		coyoteJumpTimer = coyoteJumpFrames;
		
	} else {
		
		//subtract from the jump timer
		coyoteJumpTimer--;

		
		//make sure the player can't initiate an extra jump when falling off a ledge
		if jumpCount == 0 && coyoteJumpTimer <= 0 { jumpCount = 1; }
	}
	
	
	
	
	//jumping-------------/
	if jumpKeyBuffered && jumpCount < maxJump
	{
		yspd = jumpSpd;//set the player jumping
		
		jumpKeyBuffered = false;//reset
		jumpKeyBufferTimer = 0;
		
		jumpCount++;//increase the number of jumps
		
		jumpHoldTimer = jumpHoldFrames[jumpCount-1];//start the timer for how long the jump button has been held
		
		onGround = false; //reset everything when jumping
		coyoteHangTimer = 0;
		coyoteJumpTimer = 0;
		currentFloor = noone;//VERY important to reset or wont be able to jump
	}
	
	//cut off the jump when the button is released
	if !jumpKeyHeld
	{
		jumpHoldTimer = 0;
	}
	
	if jumpHoldTimer > 0
	{
		//constantly set the yspd to be the jumping speed
		yspd = jumpSpd;
		//count down the timer
		jumpHoldTimer--;
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
			jumpHoldTimer = 0;
		}
		
		yspd = 0; //set yspd to 0 to "collide"
	}
	

	//floor y collision-------------/
	
		//check for solid and semisolid walls beneath the player
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
				//return any solid walls or any semi-solid walls below the player
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
			coyoteHangTimer = coyoteHangFrames;
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
				coyoteHangTimer = coyoteHangFrames;
			}
	
		//manually fall through a semi-solid platform
		if downKey
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
	
	
//move the player in the y
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
	
	//Y - snap player to currentFloor if it's a moving platform and is moving vertically
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
			y = currentFloor.bbox_top; //unfloor y so its not choppy;		
		}
		
		//made redundant by code block below----------/
								/*
								//going up into a solid wall while on a semi-solid platform
								if currentFloor.yspd < 0 && place_meeting(x, y + currentFloor.yspd, obj_wall)
								{
									if currentFloor.object_index == obj_semi_solid_moving_wall || object_is_ancestor(currentFloor.object_index, obj_semi_solid_moving_wall)
									{
										//get pushed down
										var _subPixel = 0.5;
										while place_meeting(x, y + currentFloor.yspd, obj_wall) {y += _subPixel};
				
										//if we got pushed into a solid wall, push ourselves back out
										while place_meeting(x, y, obj_wall) {y -= _subPixel};
				
										//round the y variable
										y = round(y);
				
										//set onGround to false, we are no longer on the ground
										onGround = false;
										currentFloor = noone;
										coyoteHangTimer = 0;
										coyoteJumpTimer = 0;
									}
								}*/
	}
	
	//get pushed down through a semi-solid by a moving solid platform
	if instance_exists(currentFloor) 
	&& (currentFloor.object_index == obj_semi_solid_wall || object_is_ancestor(currentFloor.object_index, obj_semi_solid_wall))
	&& place_meeting(x, y, obj_wall) //i'm stuck in a wall while standing on a semi-solid platform
	{
		//push me down through the semi-solid
		//unless i'm still stuck afterwards, in which case I've been properly crushed
		
		//also don't check too far, we don't want to warp below walls
		
		var _maxPushDist = 25;//the farthest a moving platform should be able to push the player downwards
		var _pushedDist = 0;
		var _start_y = y; //a reference point
		
		while place_meeting(x, y, obj_wall) && _pushedDist <= _maxPushDist
		{
			y++;
			_pushedDist++;
		}
		
		//set the current floor to be noone
		currentFloor = noone;
		coyoteHangTimer = 0;
		coyoteJumpTimer = 0;
		
		//if still in wall, just return to starting y
		if _pushedDist > _maxPushDist
		{
			y = _start_y;
		}	
	}


//sprite control------------/
/*
//walking
if abs(xspd) > 0 {sprite_index = walkSpr;};

//idle
if xspd == 0 {sprite_index = idleSpr;};

//in the air
if !onGround {sprite_index = jumpSpr;};

mask_index = maskSpr;