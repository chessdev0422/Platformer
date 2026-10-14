scr_get_controls();

if instance_exists(obj_player)
{
	minimap_pan_x = (obj_player.x * (total_width / room_width)) - (total_width / 2);
	minimap_pan_y = (obj_player.y * (total_height / room_height)) - (total_height / 2); //center the panning coords on the player to start
	
	var _tw = (total_width/minimap_size_div);
	var _th = (total_height/minimap_size_div);
	minimap_pan_x = clamp(minimap_pan_x, min(0, _tw - minimap_w), max(0, _tw - minimap_w));
	minimap_pan_y = clamp(minimap_pan_y, min(0, _th - minimap_h), max(0, _th - minimap_h));
}
	
if mapKey 
{
	mapShowing = !mapShowing;
	global.paused = !global.paused;	
	if instance_exists(obj_player)
	{
		map_pan_x = (obj_player.x * (total_width / room_width)) - (total_width / 2);
		map_pan_y = (obj_player.y * (total_height / room_height)) - (total_height / 2); //center the panning coords on the player to start
	}
}

if mapShowing {	
	
	//panning
	if (leftKey)  map_pan_x += 5;
	if (rightKey) map_pan_x -= 5;
	if (upKey)    map_pan_y -= 5;
	if (downKey)  map_pan_y += 5;

	var _mouse_x = device_mouse_x_to_gui(0);
	var _mouse_y = device_mouse_y_to_gui(0);
	var mouse_in_map = point_in_rectangle(_mouse_x, _mouse_y, map_x, map_y, map_x + scaled_room_w, map_y + scaled_room_h);

	if (mouse_check_button_pressed(mb_left) && mouse_in_map) {
		dragging_map = true;
		drag_mouse_x = _mouse_x;
		drag_mouse_y = _mouse_y;
	}

	if (mouse_check_button_released(mb_left)) {
		dragging_map = false;
	}

	if (dragging_map) {
		map_pan_x += (drag_mouse_x - _mouse_x);
		map_pan_y += (drag_mouse_y - _mouse_y);
		drag_mouse_x = _mouse_x;
		drag_mouse_y = _mouse_y;
	}

	map_pan_x = clamp(map_pan_x, min(0, total_width - scaled_room_w), max(0, total_width - scaled_room_w));
	map_pan_y = clamp(map_pan_y, min(0, total_height - scaled_room_h), max(0, total_height - scaled_room_h));
}