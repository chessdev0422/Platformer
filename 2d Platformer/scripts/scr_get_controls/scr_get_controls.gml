function scr_controls_setup()
{
	
	bufferTime = 5;
	
	
	jumpKeyBuffered = false;
	jumpKeyBufferTimer = 0;
	
	attackKeyBuffered = false;
	attackKeyBufferTimer = 0;
	
	dashKeyBuffered = false;
	dashKeyBufferTimer = 0;
}


function check_input(_key) {
    if (_key == mb_left || _key == mb_right || _key == mb_middle) {
        return mouse_check_button(_key);
    }
    return keyboard_check(_key);
}

function check_input_pressed(_key) {
    if (_key == mb_left || _key == mb_right || _key == mb_middle) {
        return mouse_check_button_pressed(_key);
    }
    return keyboard_check_pressed(_key);
}

function check_input_released(_key) 
{
    if (_key == mb_left || _key == mb_right || _key == mb_middle) {
        return mouse_check_button_released(_key);
    }
    return keyboard_check_released(_key);
}

function scr_get_controls()
{	
	if (!variable_global_exists("key_right"))
    {
        global.key_right  = ord("D");
        global.key_left   = ord("A");
        global.key_down   = ord("S");
        global.key_up     = ord("W");
        global.key_jump   = ord("W");
        global.key_run    = vk_shift;
        global.key_dash   = ord("Q");
        global.key_attack = ord("X");
		global.key_accept_interact = vk_space;
		global.key_map = ord("M");
		global.key_inv = ord("I");
		global.key_buy_multiple = vk_shift;
		
		load_controls();
    }
	
	//gamepad_set_axis_deadzone(0, 0.3);
	
	
	//Directional Inputs
	rightKey = check_input(global.key_right)// + sign(gamepad_axis_value(0, gp_axisrh));
	rightKey = clamp(rightKey, 0, 1);

	leftKey = check_input(global.key_left)//  + sign(gamepad_axis_value(0, gp_axislh));
	leftKey = clamp(leftKey, 0, 1);
	
	downKey = check_input(global.key_down)// + sign(gamepad_axis_value(0, gp_axisrv));
	downKey = clamp(downKey, 0, 1);
	
	upKey = check_input(global.key_up)// + sign(gamepad_axis_value(0, gp_axislv));
	upKey = clamp(upKey, 0, 1);
	
	
	
	//Directional Inputs Pressed
		
	//var _right_stick_pressed = global.axis_rh_curr > 0.5 && global.axis_rh_prev <= 0.5;
		
	rightKeyPressed = check_input_pressed(global.key_right)// + sign(_right_stick_pressed);
	rightKeyPressed = clamp(rightKeyPressed, 0, 1);
	
	//var _left_stick_pressed = global.axis_lh_curr > 0.5 && global.axis_lh_prev <= 0.5;
	
	leftKeyPressed = check_input_pressed(global.key_left)//  + sign(_left_stick_pressed);
	leftKeyPressed = clamp(leftKeyPressed, 0, 1);
	
	//var _down_stick_pressed = global.axis_rv_curr > 0.5 && global.axis_rv_prev <= 0.5;
	
	downKeyPressed = check_input_pressed(global.key_down)// + sign(_down_stick_pressed);
	downKeyPressed = clamp(downKeyPressed, 0, 1);
	
	//var _up_stick_pressed = global.axis_lv_curr > 0.5 && global.axis_lv_prev <= 0.5;
	
	upKeyPressed = check_input_pressed(global.key_up)// + sign(_up_stick_pressed);
	upKeyPressed = clamp(upKeyPressed, 0, 1);
	
	
	//UI request inputs
	acceptKey = check_input_pressed(global.key_accept_interact)// || gamepad_button_check_pressed(0, gp_face2);
	
	interactKey = check_input_pressed(global.key_accept_interact)// || gamepad_button_check_pressed(0, gp_face2);
	
	//Action inputs
	jumpKeyPressed = check_input_pressed(global.key_jump)// || gamepad_button_check_pressed(0, gp_face2); 
	
	jumpKeyHeld = check_input(global.key_jump)// || gamepad_button_check(0, gp_face2); 
	
	runKey = check_input(global.key_run)// || gamepad_button_check(0, gp_face3);
	
	dashKey = check_input_pressed(global.key_dash) //|| game_pad_button_check(0, gp_face3);
	
	attackKey = check_input_pressed(global.key_attack) // || gamepad_button_check_pressed(0, gp_face0);
	
	attackKeyHeld = check_input(global.key_attack); // || gamepad_button_check(0, gp_face0);
	
	//UI inputs
	mapKey = check_input_pressed(global.key_map)// || gamepad_button_check_pressed(0, gp_select);
	
	invKey = check_input_pressed(global.key_inv)// || gamepad_button_check_pressed(0, gp_face1);
	
	buyMultipleKey = check_input(global.key_buy_multiple)// || gamepad_button_check_pressed(0, gp_face3);
	
	//mouse inputs
	lmButton = mouse_check_button_pressed(mb_left);
	rmButton = mouse_check_button_pressed(mb_right);
	
	//input buffering-------------/
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
		
		//attack key buffering
		if attackKey
		{
			attackKeyBufferTimer = bufferTime;
		}
		if attackKeyBufferTimer > 0
		{
			attackKeyBuffered = true;
			if dashTimer > 0
			{
				attackKeyBufferTimer -= 0.25;
			} else {
				attackKeyBufferTimer--;
			}
		} else {
			attackKeyBuffered = false;
		}
		
		//dash key buffering
		if dashKey
		{
			dashKeyBufferTimer = bufferTime;
		}
		if dashKeyBufferTimer > 0
		{
			dashKeyBuffered = true;
			if isAttacking {
				dashKeyBufferTimer -= 0.25;
			} else {
				dashKeyBufferTimer--;
			}
		} else {
			dashKeyBuffered = false;
		}
	}
}