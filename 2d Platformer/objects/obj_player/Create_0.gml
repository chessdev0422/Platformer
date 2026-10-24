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
		
		//Loop through the colliding instances and only return one if it's top is below the player
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

moveType = 0;
moveSpd[0] = 3;//speed player moves at when walking
moveSpd[1] = 5;//speed player moves at when running

xspd = 0; //current speed on x and y values
yspd = 0;

//jumping---------------/
grav = 0.35; //gravity

terminal_vel[0] = 8; //cap the max falling speed
terminal_vel[1] = 2;//the slide speed when touching a wall


jumpSpd[0] = -7; //speed player jumps at
jumpSpd[1] = -12//when bouncing

pogoSpd = -5;//force upwards after a pogo
pogoWaitTimer = 0;
pogoWaitFrames = 60/2;//1/2 seconds to wait before the next pogo attempt
pogoBounce = false;


#macro BOUNCING 1 //bouncing

maxJump = 2;//the max amount of jumps the player has, defaulted to 1, 2 = double jump, 3 = triple jump, etc
jumpCount = 0;//the current index of jump we are on, 1 = already used first jump
jumpHoldTimer = 0;//a timer for how long jump button has been held

jumpHoldFrames[0] = 20;//the amount of frames the player can hold the jump input for variable jump height
jumpHoldFrames[1] = 10;//an array for each jumpCount of course

pogoHoldTimer = 0;
pogoHoldFrames = jumpHoldFrames[1]; //same strength as the second jump

wallJumpBufferTimer = 0;//buffer frames when wall jumping
wallJumpBufferFrames = 6;

onGround = true;//whether or not the player has solid ground directly beneath them


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
last_face = 1;
maskSpr = spr_player;
crouchMaskSpr = spr_player;
idleSpr = spr_player;
walkSpr[0] = spr_player;
walkSpr[1] = spr_player; 
jumpSpr = spr_player;
attackSpr = spr_player;
crouchSpr = spr_player;
slideSpr = spr_player;
pogoSpr = spr_player;

//state variables
crouching = false;

//Moving platforms-------------/
currentFloor = noone;//the floor we are standing on
moveWallxspd = 0;//the speed of the wall we are standing on
forgetSemiSolidWall = noone;

earlyMoveWallxspd = false;




////damage --- hp -- knockback - setup
hp = 20;//initialize the hp
maxHP = hp;//maximum hp the player has (cannot overfill)
scr_declare_damage_player();//initalize damage and iFrames

damageShader = false;//whether or not to draw the damage shader
damageShaderTimer = 0; //timer to keep track of shader
damageShaderFrames = 30; //the length of the damage shader to last

//knockback
knockBackX = 0;//the x to pass into the knockback function
knockBackY = 0;//the y to pass into the knockback function
knockBackStrengthX = 5;//the strength the player will be knocked back with on the x-axis
knockBackStrengthY = 5;//the strength the player will be knocked back with on the y-axis
knockBackTimer = 0;
knockBackFrames = 20;//length of the knockback


//interacting
interactDist = 4;
interactInst = noone;
registeredInteract = false;