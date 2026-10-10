function scr_controls_setup()
{
	
	bufferTime = 5;
	
	
	jumpKeyBuffered = false;
	jumpKeyBufferTimer = 0;
}


function scr_get_controls()
{	
	gamepad_set_axis_deadzone(0, 0.3);
	
	
	//Directional Inputs
	rightKey = keyboard_check(ord("D")) + sign(gamepad_axis_value(0, gp_axisrh));
	clamp(rightKey, 0, 1);
	
	
	leftKey = keyboard_check(ord("A"))  + sign(gamepad_axis_value(0, gp_axislh));
	clamp(leftKey, 0, 1);
	
	downKey = keyboard_check(ord("S")) + sign(gamepad_axis_value(0, gp_axisrv));
	clamp(downKey, 0, 1);
	
	upKey = keyboard_check(ord("W")) + sign(gamepad_axis_value(0, gp_axislv));
	clamp(upKey, 0, 1);
	
	
	
	//Action inputs
	jumpKeyPressed = keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_face2); 
	
	jumpKeyHeld = keyboard_check(vk_space) || gamepad_button_check(0, gp_face2); 
	
	runKey = keyboard_check(vk_shift) || gamepad_button_check(0, gp_face3);
	
	if object_index == obj_player
	{
		//jump key buffering
		if jumpKeyPressed
		{
			jumpKeyBufferTimer = bufferTime;
		}
		if jumpKeyBufferTimer > 0
		{
			jumpKeyBuffered = true;
			jumpKeyBufferTimer--;
		} else {
			jumpKeyBuffered = false;
		}
	}
}