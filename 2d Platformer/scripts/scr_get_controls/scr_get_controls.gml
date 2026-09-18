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
	rightKey = keyboard_check(vk_right) + sign(gamepad_axis_value(0, gp_axisrh));
	clamp(rightKey, -1, 1);
	
	
	leftKey = keyboard_check(vk_left)  + sign(gamepad_axis_value(0, gp_axislh));
	clamp(leftKey, -1, 1);
	
	
	
	//Action inputs
	jumpKeyPressed = keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_face2); 
	
	jumpKeyHeld = keyboard_check(vk_space) || gamepad_button_check(0, gp_face2); 
	
	runKey = keyboard_check(vk_shift) || gamepad_button_check(0, gp_face3);
	
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