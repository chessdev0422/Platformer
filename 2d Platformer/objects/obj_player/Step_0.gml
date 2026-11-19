//show_debug_message(dashAttack);

scr_get_controls(); //access the controls

mask_index = maskSpr;

var _damaged = iframeTimer > 0; //if we were just damaged, we are unable to jump, attack, dash, etc

//reset the jump before and after running interact code
if global.paused
{
    jumpKeyPressed = false;
    jumpKeyBuffered = false;
    jumpKeyBufferTimer = 0;
	xspd = 0;
	sprite_index = idleSpr;
}

//testing / debugging -----------//
if keyboard_check_pressed(ord("V"))
{
	var _cam_x = camera_get_view_x(view_camera[0]);
	var _cam_y = camera_get_view_y(view_camera[0]);
	var _cam_w = camera_get_view_width(view_camera[0]);
	var _cam_h = camera_get_view_height(view_camera[0]);
	var _random_x_offset = irandom(0 + _cam_w);
	var _random_y_offset = irandom(0 + _cam_h);
	instance_create_depth(_cam_x + _random_x_offset, _cam_y + _random_y_offset, 0, obj_fireball);
}
//--------------//


//interacting, run before everything else
if onGround && interactKey && (!global.dialogue && !obj_inventory_manager.invShowing && !obj_map.mapShowing)
{
	var _check_x = lengthdir_x(last_face, interactDist);
	
	var _inst = instance_place(x + _check_x, y - sprite_height/2, obj_interact);

	//show_debug_message(_inst);

	if instance_exists(_inst)
	{
		if interactInst == noone
		{
			interactInst = _inst;
		} else {
			interactInst = noone;
		}
	
		with(_inst)
		{
			interacting = !interacting;
		}
	}
}

if global.paused
{
    jumpKeyPressed = false;
    jumpKeyBuffered = false;
    jumpKeyBufferTimer = 0;
	xspd = 0;
	sprite_index = idleSpr;
}


if global.dialogue
{
	global.paused = true;
}

if global.paused exit;


//attacking ------------------- /
//reference anim end event
var _can_create_attack_inst = false;
#region attacking
if onGround
{
	currentAirAttackCnt = 0;
}

if (canAttack && !isAttacking && attackKeyBuffered && finalAttackRecoveryTimer <= 0 && dashTimer <= 0 && !_damaged && currentAirAttackCnt < maxAirAttack)
{
	
    attackKeyBuffered = false;
    isAttacking = true;
    
	_can_create_attack_inst = true;
	
	if (onGround)
    {
        if (upKey)
        {
            currentAttack = attacks.up_attack;
            image_index = 0;
        }
        else if (dashAttack)
        {
			currentAttackDmg = 2;
            currentAttack = attacks.wide_attack;
            image_index = 0;
        }
        else
        {
            if (currentCombo == 0)
            {
				currentAttackDmg = 1;
                currentAttack = attacks.attack_1;
                image_index = 0;
            }
            else if (currentCombo == 1)
            {
				currentAttackDmg = 2;
                currentAttack = attacks.attack_2;
                image_index = 0;
            }
            else if (currentCombo >= 2)
            {
				currentAttackDmg = 2;
                currentAttack = attacks.wide_attack;
                image_index = 0;
            }
        }
    }
    else
    {
		currentAirAttackCnt++;
        if (downKey)
        {
			currentAttackDmg = 2;
            currentAttack = attacks.down_attack;
			currentCombo++;
            image_index = 0;
        }
        else if (upKey)
        {
			currentAttackDmg = 1;
            currentAttack = attacks.jump_up_attack;
            image_index = 0;
			currentCombo++;
        }
        else
        {
			currentAttackDmg = 1;
            currentAttack = attacks.attack_1;
			currentCombo++;
            image_index = 0;
        }
    }
}

dashAttack = false; //reset the possbility of a dash attack

if (isAttacking)
{
    xspd = 0;
}

if (currentCombo > 0 && !isAttacking)
{
    comboLostTimer++;
    if (comboLostTimer >= comboLostFrames)
    {
        currentCombo = 0;
        comboLostTimer = 0;
    }
}

if (finalAttackRecoveryTimer > 0)
{
    finalAttackRecoveryTimer--;
}
#endregion

scr_take_damage(obj_damage_player, true); //take damage from player damaging objects

//knockback
if knockBackTimer > 0
{
	knockBackTimer--;//subtract from the timer
	scr_knockback(knockBackX, knockBackY, knockBackStrengthX, knockBackStrengthY); //run the knockback script
}

if damageShaderTimer > 0
{
	damageShaderTimer--;
} else { //subtract the damage shader timer
	damageShader = false;
}

if global.hitPauseTimer > 0
{
	global.hitPauseTimer--;
} else {
	global.hitPause = false;
}

if global.hitPause exit; //don't run any of the rest of the step event if hit "pausing"


#region moving and collisions
//------------wall jump and slide checks-------/
var _wallCheckLeft = place_meeting(x - 1, y, obj_wall);
var _wallCheckRight = place_meeting(x + 1, y, obj_wall);

//slide only happens if touching the wall AND holding toward it while airborne
var _isSlidingLeft = _wallCheckLeft && leftKey && !onGround && yspd >= 0;
var _isSlidingRight = _wallCheckRight && rightKey && !onGround && yspd >= 0;
var _touchingWall = _isSlidingLeft || _isSlidingRight;


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
		var _targetY = _bottomWall.bbox_top - _bottomDist;
		
		if !place_meeting(x, _targetY, obj_wall)
		{
			y = _targetY;
		}
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
if instance_exists(currentFloor) && currentFloor.xspd != 0 && !place_meeting(x, y+1 + terminal_vel[_touchingWall], currentFloor)
{
	//go ahead and move back onto the platform if not a wall in the way
	if !place_meeting(x + currentFloor.xspd, y, obj_wall)
	{
		x += currentFloor.xspd;
		earlyMoveWallxspd = true;
	}
}


//Crouching---------/
	//transition to crouch
	if onGround && (downKey || place_meeting(x, y, obj_wall))  && !((sprite_index == landSprDist || sprite_index == landSpr) && image_index < image_number - 1)
	{
		crouching = true;
	}
	
	if knockBackTimer > 0
	{
		crouching = false;	
	}
	
	if crouching {mask_index = crouchMaskSpr;};
	
	//uncrouch
	if crouching && !downKey
	{
		//check if can un-crouch
		mask_index = maskSpr;
		
		//uncrouch if not a wall
		if !place_meeting(x, y, obj_wall)
		{
			crouching = false;
		} else {
			//otherwise go back to crouching
			mask_index = crouchMaskSpr;
		}
	}

//wall coyote time---------------/
if (_isSlidingLeft) {
    wallTouchTimerLeft = wallJumpBufferFrames;
} else if (wallTouchTimerLeft > 0) {
    wallTouchTimerLeft--;
}

if (_isSlidingRight) {
    wallTouchTimerRight = wallJumpBufferFrames;
} else if (wallTouchTimerRight > 0) {
    wallTouchTimerRight--;
}
//----------/

if !onGround && (wallTouchTimerLeft > 0 || wallTouchTimerRight > 0) && jumpKeyBuffered && !_damaged
{
    var _canWallJump = false;//whether or not we can wall jump
    var _jumpDir = 0; //the direction of the force of the jump

    if wallTouchTimerLeft > 0
    {
        _canWallJump = true;
        _jumpDir = 1;
    }
    else if wallTouchTimerRight > 0
    {
        _canWallJump = true;
        _jumpDir = -1;
    }

    if _canWallJump
    {
        face = _jumpDir;
        last_face = _jumpDir;

        xspd = face * wallJumpSpd[0];  
        yspd = wallJumpSpd[1];

        jumpKeyBuffered = false;
        jumpKeyBufferTimer = 0;

        coyoteHangTimer = 0;
        coyoteJumpTimer = 0;
		wallTouchTimerLeft = 0;
        wallTouchTimerRight = 0;
        currentFloor = noone;
        
        wallJumpTimer = wallJumpTimerMax;
    }
}

if wallJumpTimer > 0 && !onGround
{
    wallJumpTimer--;
    
    var _target_wall_xspd = moveSpd[0] * (rightKey - leftKey);
    if (rightKey - leftKey != 0) 
    {
        xspd = lerp(xspd, _target_wall_xspd, wallJumpPlayerStrength);
    }
}
else if crouching 
{
    xspd = 0;
    if onGround 
    {
        yspd = 0;
    }
} 
else 
{
    if knockBackTimer <= 0 && !isAttacking 
    {
        face = rightKey - leftKey;
    
        if onGround 
        {
            moveType = runKey;
        }
    
        target_xspd = face * moveSpd[moveType];
    
        if face != 0 { last_face = face; }
    }

	//Apply acceleration ---- / //IMPORTANT, Before collisions
	var _target_accel = 0;
	if face != 0
	{
		_target_accel = accel; //acceleration
	} else {
		_target_accel = ff; //friction
	}
	xspd = lerp(xspd, target_xspd, _target_accel); //lerp
}

if dashTimer > 0
{
	dashTimer--;
	xspd = (dashSpd - (dashff * (dashFrames - dashTimer))) * last_face; //constantly set the dashSpd
	if (dashTimer == 0)
    {
		dashRecoveryTimer = dashRecoveryFrames;
		dashAttack = true;
    }
}

if dashTimer mod 5 == 0 && dashTimer > 0
{
	var _vfx = instance_create_depth(x, y, depth + 1, obj_player_trail); //create the dash trail
	with(_vfx)
	{
		sprite_index = other.sprite_index;
		dir = other.last_face;
	}
}

if dashRecoveryTimer > 0
{
	dashRecoveryTimer--;
}

if onGround 
{
	dashCount = 0;
}

//show_debug_message(dashKey);

//dashes
if dashKeyBuffered && dashCount < maxDash && dashTimer <= 0 && dashRecoveryTimer <= 0 && !isAttacking && finalAttackRecoveryTimer <= 0 && !_damaged
{
	xspd = dashSpd;
	dashTimer = dashFrames;
	if !onGround
	{
		dashCount++;
	}
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
	
if (sprite_index == landSprDist) && image_index < image_number - 1 {xspd = 0;};
if crouching {xspd = 0;};
if isAttacking {xspd = 0;}

//move the player in the x
x += xspd;
//show_debug_message(xspd);
//show_debug_message(moveSpd[1]);

//Y movement
if coyoteHangTimer > 0 //this will be true if we are not on the ground, or we have run out of coyote time
{
	//subtract from the coyote hang timer
	coyoteHangTimer--;
} else { 
	if dashTimer <= 0 && !isAttacking
	{
		//gravity, only if coyote hang timer <= 0
		yspd += grav;
		onGround = false;
		coyoteHangTimer = 0;
	}
}

	//cap the yspd based on the terminal vel
	if yspd > terminal_vel[_touchingWall] {yspd = terminal_vel[_touchingWall]};
	
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
	
		//on ground
		if jumpKeyBuffered && jumpCount < maxJump && !_touchingWall /*touching wall being sliding*/ && !crouching && !_damaged
		&& !((sprite_index == landSprDist) && image_index < image_number - 1) && wallTouchTimerLeft <= 0 && wallTouchTimerRight <= 0
		{
			yspd = jumpSpd[0];//set the player jumping
		
			jumpKeyBuffered = false;//reset
			jumpKeyBufferTimer = 0;
		
			if jumpCount > 0
			{
				instance_create_depth(x, y, 0, obj_double_jump_effect);
				nextJumpTimer = nextJumpFrames;
			}
			
			jumpCount++;//increase the number of jumps
		
			jumpHoldTimer = jumpHoldFrames[jumpCount-1];//start the timer for how long the jump button has been held
		
			onGround = false; //reset everything when jumping
			coyoteHangTimer = 0;
			coyoteJumpTimer = 0;
			currentFloor = noone;//VERY important to reset or wont be able to jump
		}
		
		/*//bouncy pads
		if instance_exists(currentFloor) && (currentFloor.object_index == obj_bouncy_pad || object_is_ancestor(currentFloor.object_index, obj_bouncy_pad))
		{
			yspd = jumpSpd[BOUNCING];
		
			jumpKeyBuffered = false;//reset
			//set it so the player knows they are taking off
			jumpKeyBufferTimer = 0;
		
			jumpCount++;//increase the number of jumps
		
			jumpHoldTimer = jumpHoldFrames[jumpCount-1];//start the timer for how long the jump button has been held
		
			onGround = false; //reset everything when jumping
			coyoteHangTimer = 0;
			coyoteJumpTimer = 0;
			currentFloor = noone;//VERY important to reset or wont be able to jump
		}*/
			
			//cut off the jump when the button is released
			if !jumpKeyHeld
			{
				jumpHoldTimer = 0;
			}
	
			if jumpHoldTimer > 0
			{
				//constantly set the yspd to be the jumping speed
				yspd = jumpSpd[0];
				//count down the timer
				jumpHoldTimer--;
			}
			
	if nextJumpTimer > 0
	{
		nextJumpTimer--;
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
	
	
		var _listSize = instance_place_list(x, y+1 + _clamp_yspd + terminal_vel[_touchingWall], _array, _list, false);
	
		
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
		if instance_exists(currentFloor) && !place_meeting(x, y+terminal_vel[_touchingWall], currentFloor)
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
	
	
//lerp the players yspd towards 0 when attacking
if isAttacking
{
	yspd = lerp(yspd, 0, 0.15);
}
	
//move the player in the y
if dashTimer <= 0
{
	y += yspd;
}



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
		&& currentFloor.bbox_top >= bbox_bottom - terminal_vel[_touchingWall] 
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
		coyoteHangTimer = 0;
		coyoteJumpTimer = 0;
		
		//if still in wall, just return to starting y
		if _pushedDist > _maxPushDist
		{
			y = _start_y;
		}	
	}


//sprite control------------/

image_speed = 1;

var _wasOnGround = onGround;
var _lookAheadDist = max(4, yspd * 3.5); 

var _solidMeeting = place_meeting(x, y + yspd + _lookAheadDist, obj_wall);

var _semiSolidMeeting = false;
var _list = ds_list_create();
var _num = instance_place_list(x, y + yspd + _lookAheadDist, obj_semi_solid_wall, _list, false);
if (_num > 0) {
    for (var i = 0; i < _num; i++) {
        var _inst = _list[| i];
        if (bbox_bottom <= _inst.bbox_top) {
            _semiSolidMeeting = true;
            break;
        }
    }
}
ds_list_destroy(_list);

var _aboutToLand = (!onGround && yspd > 0 && (_solidMeeting || _semiSolidMeeting));

var _justStartedLanding = (!_wasOnGround && onGround);
var _aboutToStartLanding = (_aboutToLand && sprite_index != landSpr && sprite_index != landSprDist);

if isAttacking == true
{
	switch(currentAttack)
	{
		case attacks.attack_1:
		sprite_index = attackSpr1;
		break;
		
		case attacks.attack_2:
		sprite_index = attackSpr2;
		break;
		
		case attacks.wide_attack:
		sprite_index = attackSprWide;
		break;
		
		case attacks.up_attack:
		sprite_index = attackSprUp;
		break;
		
		case attacks.down_attack:
		sprite_index = attackSprDown;
		break;
		
		case attacks.jump_up_attack:
		sprite_index = attackSprJump;
		break;
	}
	show_debug_message(sprite_index);
}
else if dashTimer > 0 {
	sprite_index = dashSpr;
}
else if (_justStartedLanding || _aboutToStartLanding) {
    if (yspd >= terminal_vel[0]) {
        sprite_index = landSprDist;
    } 
    else {
        sprite_index = landSpr;
    }
    image_index = 0;
}
else if knockBackTimer > 0 {
    sprite_index = knockbackSpr;
}
else if _touchingWall {
    sprite_index = slideSpr;
}
else if crouching = true {
    //crouching
    sprite_index = crouchSpr;
}
else if (sprite_index == landSpr || sprite_index == landSprDist) && image_index < image_number - 1 {
    //ensure that the landing plays all the way through
}
else if !onGround {
    //in the air
    if yspd < 0 {
			sprite_index = jumpSpr;
			if nextJumpTimer > 0
			{
				image_index = image_number - 1;
				sprite_index = landSpr;
			}
    }
    else {
        if (sprite_index == jumpSpr) {
            sprite_index = apexSpr;
            image_index = 0;
        }
        
        if (sprite_index == apexSpr) {
            if (image_index >= image_number - 1) {
                sprite_index = fallSpr;
            }
        }
        else {
            sprite_index = fallSpr;
        }
    }
}
else if abs(xspd) > 0.1 {
    sprite_index = walkSpr[moveType];
}
else if abs(xspd) <= 0.1 {
    //idle
    sprite_index = idleSpr;
}

//show_debug_message(sprite_index);

//create the attacking damage object at the very end of the step event, IMPORTANT -- need to make sure sprite index is set properly
//then set the damage object sprite index, mask index, and x/y

var _dmg = currentAttackDmg;
if _can_create_attack_inst
{
	var _attack_dmg_inst = instance_create_depth(x, y, depth - 1, obj_damage_non_player);
	with (_attack_dmg_inst)
	{
		mask_index = other.sprite_index;
		sprite_index = other.sprite_index;
		image_xscale = other.image_xscale * other.last_face;
		//show_debug_message(mask_index);
		followPlayer = true;
		image_index = other.image_index;
		damage = _dmg;
	}
	if sprite_index == attackSprWide
	{
		alarm[0] = 20;
	}
}

#endregion