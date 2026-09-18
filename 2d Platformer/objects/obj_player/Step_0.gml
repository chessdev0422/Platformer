scr_get_controls();

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
	
	//jumping
	if jumpKeyBuffered && jumpCount < maxJump
	{
		yspd = jumpSpd;//set the player jumping
		
		jumpKeyBuffered = false;//reset
		jumpKeyBufferTimer = 0;
		
		jumpCount++;//increase the number of jumps
		
		jumpHoldTimer = jumpHoldFrames[jumpCount-1];//start the timer for how long the jump button has been held
		
		onGround = false;
		coyoteHangTimer = 0;
		coyoteJumpTimer = 0;
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
	
	var _subPixel = 0.5;
	
	if place_meeting(x, y + yspd, obj_wall)
	{
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
	
	
	if yspd >= 0 && place_meeting(x, y+2, obj_wall)
	{
		onGround = true;
		coyoteHangTimer = coyoteHangFrames;
	}
	

//move the player in the x and y
x += xspd;
y += yspd;

//sprite control------------/
/*
//walking
if abs(xspd) > 0 {sprite_index = walkSpr;};

//idle
if xspd == 0 {sprite_index = idleSpr;};

//in the air
if !onGround {sprite_index = jumpSpr;};

mask_index = maskSpr;




//depth------------/
depth = -bbox_bottom;