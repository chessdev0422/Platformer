image_xscale = 0.25;
image_yscale = 0.25;

//controls setup
scr_controls_setup();

//moving

face = 0; //-1 = left, 0 = not moving, 1 = right

moveType = 0;
moveSpd[0] = 7;//speed player moves at when walking
moveSpd[1] = 15;//speed player moves at when running

xspd = 0; //current speed on x and y values
yspd = 0;

//jumping---------------/
grav = 1.25; //gravity

terminal_vel = 20; //cap the max falling speed

jumpSpd = -15; //speed player jumps at

maxJump = 2;//the max amount of jumps the player has, defaulted to 1, 2 = double jump, 3 = triple jump, etc
jumpCount = 0;//the current index of jump we are on, 1 = already used first jump
jumpHoldTimer = 0;//a timer for how long jump button has been held

jumpHoldFrames[0] = 20;//the amount of frames the player can hold the jump input for variable jump height
jumpHoldFrames[1] = 10;//an array for each jumpCount of course

onGround = true;//whether or not the player has solid ground directly beneath them


//coyote time --------/
//hang frames
coyoteHangFrames = 2;
coyoteHangTimer = 0;

//jump buffer frames
coyoteJumpFrames = 5;
coyoteJumpTimer = 0;


//sprite control-----------/
draw_face = 1;
/*maskSpr = spr_player_mask;
idleSpr = spr_player_idle;
walkSpr = spr_player_walk;
jumpSpr = spr_player_jump;