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
	
if mapKey && (!global.paused || (global.paused && mapShowing))
{
	mapShowing = !mapShowing;
	global.paused = !global.paused;	
	if instance_exists(obj_player)
	{
		map_pan_x = (obj_player.x * (total_width / room_width)) - (total_width / 2);
		map_pan_y = (obj_player.y * (total_height / room_height)) - (total_height / 2); //center the panning coords on the player to start
	}
}