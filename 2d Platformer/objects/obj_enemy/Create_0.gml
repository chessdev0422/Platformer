depth = -30;

//controls setup
scr_controls_setup();

function check_for_semisolid_platform(_x, _y)
{
	//Create a return variable
	var _rtrn = noone;
	
	//We must not be moving upwards, and then we check for a normal collision
	if yspd >= 0 && place_meeting(_x, _y, obj_semi_solid_wall)
	{
		//Create a ds list to store all colliding instances of obj_semi_solid_wall
		var _list = ds_list_create();
		var _listSize = instance_place_list(_x, _y, obj_semi_solid_wall, _list, false);
		
		//Loop through the colliding instances and only return one if it's top is below the enemy
		for( var i = 0; i < _listSize; i++ )
		{
			var _listInst = _list[| i];
			if floor(bbox_bottom) <= ceil( _listInst.bbox_top - _listInst.yspd )
			{
				_rtrn = _listInst;
				
				//exit the loop early
				i = _listSize;
			}
		}
	}
	
	//Return our variable
	return _rtrn;
}


//moving
face = 0; //-1 = left, 0 = not moving, 1 = right
moveDir = 0;
airDir = 0;


moveType = 0;
moveSpd = 4;//speed enemy moves at when walking

xspd = 0; //current speed on x and y values
yspd = 0;

//jumping---------------/
grav = 0.35; //gravity

terminal_vel = 8; //cap the max falling speed


jumpSpd = -7; //speed player jumps at

maxJump = 1;//the max amount of jumps the enemy has
jumpCount = 0;//the current index of jump we are on, 1 = already used first jump
jumpHoldTimer = 0;//a timer for how long jump button has been held

jumpHoldFrames = 15;//the length of the jump

onGround = true;//whether or not the enemy has solid ground directly beneath them


wallSliding = false;
wallJumpTimer = 0;
wallJumpTimerFrames = 20;//number of frames moving is locked out when wall jumping

//coyote time --------/
//hang frames
coyoteHangFrames = 2;
coyoteHangTimer = 0;

//jump buffer frames
coyoteJumpFrames = 5;
coyoteJumpTimer = 0;


//sprite control-----------/
draw_face = 1;
maskSpr = spr_enemy;
idleSpr = spr_enemy;
walkSpr = spr_enemy;
jumpSpr = spr_enemy;
attackSpr = spr_enemy;

//state variables
crouching = false;
canFallThroughPlat = false;

//moving platforms-------------/
currentFloor = noone;//the floor we are standing on
moveWallxspd = 0;//the speed of the wall we are standing on
forgetSemiSolidWall = noone;

earlyMoveWallxspd = false;

path_to_follow = []; //the movement path to follow

temp_nearest_x = 0; //a temporary nearest x and y when off the ground to avoid weird scenarios with finding the nearest node
temp_nearest_y = 0;