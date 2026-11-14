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

//acceleration - friction
target_xspd = 0; //the target speed on the x axis
accel = 0.2; //acceleration (amount to be interpolated by each step)
ff = 1; //force of friction (amount to be interpolated by each step)

//jumping---------------/
grav = 0.35; //gravity

terminal_vel[0] = 16; //cap the max falling speed
terminal_vel[1] = 2;//the slide speed when touching a wall


jumpSpd[0] = -7; //speed player jumps at
jumpSpd[1] = -12//when bouncing


#macro BOUNCING 1 //bouncing


maxJump = 2;//the max amount of jumps the player has, defaulted to 1, 2 = double jump, 3 = triple jump, etc
jumpCount = 0;//the current index of jump we are on, 1 = already used first jump
jumpHoldTimer = 0;//a timer for how long jump button has been held

jumpHoldFrames[0] = 20;//the amount of frames the player can hold the jump input for variable jump height
jumpHoldFrames[1] = 10;//an array for each jumpCount of course

//next jump
nextJumpTimer = 0;
nextJumpFrames = 15;


onGround = true;//whether or not the player has solid ground directly beneath them

//wall jumps and sliding
wallJumpSpd = [4.5, -5.5];//[X speed push off the wall, Y upward boost]
wallJumpTimerMax = 45;//duration of the wall jump momentum window (frames)
wallJumpTimer = 0;
wallJumpPlayerStrength = 0.05;//the strength it will feel the player has to go "against" the wall jump
wallTouchTimerLeft = 0;
wallTouchTimerRight = 0;
wallJumpBufferFrames = 5;

wallSliding = false;

//dashing--------------/

dashTimer = 0;
dashFrames = 14;//length of the dash (frames)
dashSpd = 13.5;//the inital speed of the dash (ppf)
dashff = 0.1;//the amount the dash slows down by (force of friction)

//air
maxDash = 1; //max amt of dashes
dashCount = 0; //current count of dashes

//recovery
dashRecoveryTimer = 0;
dashRecoveryFrames = 1 * 60; //1 seconds (60 frames) of recovery period after dash

dashAttack = false;//whether or not there could potentially be a dash attack

//coyote time --------/
//hang frames
coyoteHangFrames = 2;
coyoteHangTimer = 0;

//jump buffer frames
coyoteJumpFrames = 5;
coyoteJumpTimer = 0;

//sprite control-----------/
last_face = 1;
maskSpr = spr_player_idle;
crouchMaskSpr = spr_player_crouching
idleSpr = spr_player_idle;
walkSpr[0] = spr_player_walking;
walkSpr[1] = spr_player_running; 
jumpSpr = spr_player_jumping;
apexSpr = spr_player_jumping_apex;
fallSpr = spr_player_falling
landSpr = spr_player_landing;
landSprDist = spr_player_landing_distance;
crouchSpr = spr_player_crouching;
slideSpr = spr_player_wall_slide;
knockbackSpr = spr_player_knockback;
deathSpr = spr_player_death;
attackSpr1 = spr_player_attack_1;
attackSpr2 = spr_player_attack_2;
attackSprWide = spr_player_wide_attack;
attackSprUp = spr_player_up_attack;
attackSprDown = spr_player_down_attack;
attackSprJump = spr_player_jump_up_attack;
dashSpr = spr_player_running;

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

currentAttackDmg = 1;

//attacking - combos - running attacks - air attacks

isAttacking = false; //whether or not we are attacking

canAttack = true; //can we attack? i.e. on the ground, or in the air and haven't used up and attack
//or used up all of the combos, or actively playing an attack, etc

//create an attack enum
enum attacks {
	attack_1,
	attack_2,
	wide_attack,
	up_attack,
	jump_up_attack,
	down_attack,
	dash_attack,
	//charge_attack,
}

//combos
currentAttack = attacks.attack_1; //store the current attack
currentCombo = 0;
comboHitFrames = bufferTime;
comboLostTimer = 0;
comboLostFrames = 10;

currentAirAttackCnt = 0;
maxAirAttack = 1;

//recovery time
finalAttackRecoveryTimer = 0;
finalAttackRecoveryFrames = 1/2 * 60; //1/2 seconds of a recovery period after a final wide attack in a sequence (or running attack)

//-----------------//

//interacting
interactDist = 4;
interactInst = noone;
registeredInteract = false;