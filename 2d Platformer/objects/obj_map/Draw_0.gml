var cam_x = camera_get_view_x(view_camera[0]);
var cam_y = camera_get_view_y(view_camera[0]);

if !surface_exists(map_surface_bg)
{
	//create a new surface
	map_surface_bg = surface_create(room_width, room_height);

	surface_set_target(map_surface_bg);
	draw_clear_alpha(c_black, 0.0); //clear the background

	/*
	var layer_id = layer_get_id("Tiles");
	if (layer_id != -1) {
		var tilemap_id = layer_tilemap_get_id(layer_id);
		if (tilemap_id != -1) {
			draw_tilemap(tilemap_id, 0, 0);
		}
	}*/

	//draw walls to surface
	with (obj_wall) {
		if object_index == obj_wall
		{
			draw_set_color(c_black);
			draw_rectangle(x, y, x + CELL_SIZE*image_xscale, y + CELL_SIZE*image_yscale, false);
		}
	}
	with (obj_semi_solid_wall) {
		if object_index == obj_semi_solid_wall
		{
			draw_set_color(c_black);
			draw_set_alpha(0.5);
			draw_rectangle(x, y, x + CELL_SIZE*image_xscale, y + CELL_SIZE*image_yscale, false);
			draw_set_alpha(1);
			draw_set_colour(c_white);
		}
	}

	surface_reset_target();
}

if (!surface_exists(map_surface_ent)) {
	map_surface_ent = surface_create(room_width, room_height);
}

//redraw the entity surface
surface_set_target(map_surface_ent);
draw_clear_alpha(c_black, 0.0); //clear transparent

if (instance_exists(obj_player)) {
	//origin is bottom centre
	var p_x = obj_player.x;
	var p_y = obj_player.y - (global.player_sprite_height/2.5);

	//draw the dot
	draw_set_color(c_red);
	draw_sprite(spr_player_icon, 0, p_x, p_y);
	draw_set_color(c_white);
}

surface_reset_target();

var view_w = camera_get_view_width(view_camera[0]);
var view_h = camera_get_view_height(view_camera[0]);
var gui_scale_x = window_get_width() / view_w;
var gui_scale_y = window_get_height() / view_h; //IMPORTANT --- we need to get the scale factor between window res and gui res

if mapShowing {	
	var spr_w = sprite_get_width(spr_map_background);
	var spr_h = sprite_get_height(spr_map_background);

	var draw_scale_x = scaled_room_w / spr_w;
	var draw_scale_y = scaled_room_h / spr_h;

	var draw_map_x = map_x + cam_x;
	var draw_map_y = map_y + cam_y;

	var _mouse_x = mouse_x;
	var _mouse_y = mouse_y;

	if (!dragging_map)
	{
		if (point_in_rectangle(_mouse_x, _mouse_y, draw_map_x, draw_map_y, draw_map_x + scaled_room_w, draw_map_y + scaled_room_h))
		{
			if (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right))
			{
				dragging_map = true;
				drag_mouse_x = _mouse_x;
				drag_mouse_y = _mouse_y;
			}
		}
	}

	if (dragging_map)
	{
		if (mouse_check_button(mb_left) || mouse_check_button(mb_right))
		{
			var dx = drag_mouse_x - _mouse_x;
			var dy = drag_mouse_y - _mouse_y;

			map_pan_x += dx;
			map_pan_y += dy;
	
			drag_mouse_x = _mouse_x;
			drag_mouse_y = _mouse_y;
		}
		else
		{
			dragging_map = false;
		}
	}

	var pan_speed = 5;

	if menuRightKey { map_pan_x += pan_speed };
	if menuLeftKey { map_pan_x -= pan_speed };
	if menuDownKey { map_pan_y += pan_speed };
	if menuUpKey { map_pan_y -= pan_speed };
	

	map_pan_x = clamp(map_pan_x, 0, max(0, total_width - scaled_room_w));
	map_pan_y = clamp(map_pan_y, 0, max(0, total_height - scaled_room_h));
	
	show_debug_message(map_pan_x);

	var _scissor = gpu_get_scissor(); //get the scissor
	//set the scissor to cut off the map edges
	gpu_set_scissor((map_x) * gui_scale_x, (map_y) * gui_scale_y, scaled_room_w * gui_scale_x, scaled_room_h * gui_scale_y);

	//draw background
	draw_sprite_ext(spr_map_background, 0, draw_map_x, draw_map_y, draw_scale_x, draw_scale_y, 0, c_white, 1);

	//draw background surface
	if surface_exists(map_surface_bg)
	{
		draw_surface_stretched(map_surface_bg, draw_map_x - map_pan_x, draw_map_y - map_pan_y, total_width, total_height);
	}

	//draw entity surface (player, quests, npcs, etc)
	if surface_exists(map_surface_ent)
	{
		draw_surface_stretched(map_surface_ent, draw_map_x - map_pan_x, draw_map_y - map_pan_y, total_width, total_height);
	}

	//reset the scissor
	gpu_set_scissor(_scissor);

	//top right X-------/
	var _xsw = sprite_get_width(closeSpr);
	var _xsh = sprite_get_height(closeSpr);
	var _xxx = closeStartX + cam_x + _xsw/2;
	var _xyy = closeStartY + cam_y + _xsh/2;

	if point_in_rectangle(_mouse_x, _mouse_y, _xxx - _xsw/2, _xyy - _xsh/2, _xxx + _xsw/2, _xyy + _xsh/2)
	{
		closeAnim = lerp(closeAnim, 1.02, 0.3);//lerp towards a bigger size

		if mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right)
		{
			mapShowing = false;
			global.paused = false;
		}				
	} else {
		closeAnim = lerp(closeAnim, 1, 0.5);//lerp towards 1, meaning no size change
	}

	draw_sprite_ext(closeSpr, 0, _xxx, _xyy, 1 * closeAnim, 1 * closeAnim, 0, c_white, 1);
}
else
{
	dragging_map = false;
}

if !mapShowing && !obj_inventory_manager.invShowing && !obj_inventory_manager.otherShowing //questsShowing etc
{
	if instance_exists(obj_warp) {exit;}

	var _map_alpha = 0.5;

	draw_set_alpha(_map_alpha);

	var draw_minimap_x = minimap_x + cam_x;
	var draw_minimap_y = minimap_y + cam_y;

	//get the scissor
	var _scissor = gpu_get_scissor();
	//set the scissor
	gpu_set_scissor((minimap_x) * gui_scale_x, (minimap_y) * gui_scale_y, minimap_w * gui_scale_x, minimap_h * gui_scale_y);

	var spr_w = sprite_get_width(spr_map_background);
	var spr_h = sprite_get_height(spr_map_background);
	draw_sprite_ext(spr_map_background, 0, draw_minimap_x, draw_minimap_y, minimap_w / spr_w, minimap_h / spr_h, 0, c_white, _map_alpha);

	if surface_exists(map_surface_bg)
	{
		draw_surface_stretched(map_surface_bg, draw_minimap_x - minimap_pan_x, draw_minimap_y - minimap_pan_y, total_width/minimap_size_div, total_height/minimap_size_div);
	}

	if surface_exists(map_surface_ent)
	{
		draw_surface_stretched(map_surface_ent, draw_minimap_x - minimap_pan_x, draw_minimap_y - minimap_pan_y, total_width/minimap_size_div, total_height/minimap_size_div);
	}

	gpu_set_scissor(_scissor);

	draw_set_alpha(1);
}