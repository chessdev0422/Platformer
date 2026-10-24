function scr_controls_setup()
{
	
	bufferTime = 5;
	
	
	jumpKeyBuffered = false;
	jumpKeyBufferTimer = 0;
	
	pogoKeyBuffered = false;
	
	pogoBounceBufferTimer = 0;
	pogoBounceBufferTime = 10;
}


function scr_get_controls()
{	
	//gamepad_set_axis_deadzone(0, 0.3);
	
	
	//Directional Inputs
	rightKey = keyboard_check(ord("D"))// + sign(gamepad_axis_value(0, gp_axisrh));
	rightKey = clamp(rightKey, 0, 1);

	leftKey = keyboard_check(ord("A"))//  + sign(gamepad_axis_value(0, gp_axislh));
	leftKey = clamp(leftKey, 0, 1);
	
	downKey = keyboard_check(ord("S"))// + sign(gamepad_axis_value(0, gp_axisrv));
	downKey = clamp(downKey, 0, 1);
	
	upKey = keyboard_check(ord("W"))// + sign(gamepad_axis_value(0, gp_axislv));
	upKey = clamp(upKey, 0, 1);
	
	
	
	//Directional Inputs Pressed
		
	//var _right_stick_pressed = global.axis_rh_curr > 0.5 && global.axis_rh_prev <= 0.5;
		
	rightKeyPressed = keyboard_check_pressed(ord("D"))// + sign(_right_stick_pressed);
	rightKeyPressed = clamp(rightKeyPressed, 0, 1);
	
	//var _left_stick_pressed = global.axis_lh_curr > 0.5 && global.axis_lh_prev <= 0.5;
	
	leftKeyPressed = keyboard_check_pressed(ord("A"))//  + sign(_left_stick_pressed);
	leftKeyPressed = clamp(leftKeyPressed, 0, 1);
	
	//var _down_stick_pressed = global.axis_rv_curr > 0.5 && global.axis_rv_prev <= 0.5;
	
	downKeyPressed = keyboard_check_pressed(ord("S"))// + sign(_down_stick_pressed);
	downKeyPressed = clamp(downKeyPressed, 0, 1);
	
	//var _up_stick_pressed = global.axis_lv_curr > 0.5 && global.axis_lv_prev <= 0.5;
	
	upKeyPressed = keyboard_check_pressed(ord("W"))// + sign(_up_stick_pressed);
	upKeyPressed = clamp(upKeyPressed, 0, 1);
	
	
	//UI request inputs
	acceptKey = keyboard_check_pressed(vk_space)// || gamepad_button_check_pressed(0, gp_face2);
	
	interactKey = keyboard_check_pressed(vk_space)// || gamepad_button_check_pressed(0, gp_face2);
	
	//Action inputs
	jumpKeyPressed = keyboard_check_pressed(vk_space)// || gamepad_button_check_pressed(0, gp_face2); 
	
	jumpKeyHeld = keyboard_check(vk_space)// || gamepad_button_check(0, gp_face2); 
	
	runKey = keyboard_check(vk_shift)// || gamepad_button_check(0, gp_face3);

	pogoKeyPressed = keyboard_check_pressed(vk_shift)// || gamepad_button_check_pressed(0, gp_face3);
	
	pogoKeyHeld = keyboard_check(vk_shift)// || gamepad_button_check(0, gp_face3);
	
	//UI inputs
	mapKey = keyboard_check_pressed(ord("M"))// || gamepad_button_check_pressed(0, gp_select);
	
	invKey = keyboard_check_pressed(ord("I"))// || gamepad_button_check_pressed(0, gp_face1);
	
	buyMultipleKey = keyboard_check(vk_shift)// || gamepad_button_check_pressed(0, gp_face3);
	
	//mouse inputs
	lmButton = mouse_check_button_pressed(mb_left);
	rmButton = mouse_check_button_pressed(mb_right);
	
	
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
		
		//jump key buffering
		if pogoKeyPressed
		{
			pogoBounceBufferTimer = pogoBounceBufferTime;
		}
		if pogoBounceBufferTimer > 0
		{
			pogoKeyBuffered = true;
			pogoBounceBufferTimer--;
		} else {
			pogoKeyBuffered = false;
		}
	}
}