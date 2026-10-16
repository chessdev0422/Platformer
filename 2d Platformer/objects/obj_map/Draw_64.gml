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
	var p_y = obj_player.y - (obj_player.sprite_height/2.5);
	
	//draw the dot
	draw_set_color(c_red);
	draw_sprite(spr_player_icon, 0, p_x, p_y);
	draw_set_color(c_white);
}

surface_reset_target();

var gui_scale_x = window_get_width() / display_get_gui_width();
var gui_scale_y = window_get_height() / display_get_gui_height(); //IMPORTANT --- we need to get the scale factor between window res and gui res

if mapShowing {	
	//get sprite width
	var spr_w = sprite_get_width(spr_map_background);
	var spr_h = sprite_get_height(spr_map_background);
	
	var draw_scale_x = scaled_room_w / spr_w;
	var draw_scale_y = scaled_room_h / spr_h;
	
	//set the scissor to cut off the map edges
	gpu_set_scissor(map_x * gui_scale_x, map_y * gui_scale_y, scaled_room_w * gui_scale_x, scaled_room_h * gui_scale_y);
	
	//draw background
	draw_sprite_ext(spr_map_background, 0, map_x, map_y, draw_scale_x, draw_scale_y, 0, c_white, 1);
	
	//draw background surface
	if surface_exists(map_surface_bg)
	{
		draw_surface_stretched(map_surface_bg, map_x - map_pan_x, map_y - map_pan_y, total_width, total_height);
	}
	
	//draw entity surface (player, quests, npcs, etc)
	if surface_exists(map_surface_ent)
	{
		draw_surface_stretched(map_surface_ent, map_x - map_pan_x, map_y - map_pan_y, total_width, total_height);
	}
	
	//reset the scissor
	gpu_set_scissor(-1, -1, -1, -1);
} 
else 
{

	gpu_set_scissor(minimap_x * gui_scale_x, minimap_y * gui_scale_y, minimap_w * gui_scale_x, minimap_h * gui_scale_y);

	var spr_w = sprite_get_width(spr_map_background);
	var spr_h = sprite_get_height(spr_map_background);
	draw_sprite_ext(spr_map_background, 0, minimap_x, minimap_y, minimap_w / spr_w, minimap_h / spr_h, 0, c_white, 1);

	if surface_exists(map_surface_bg)
	{
		draw_surface_stretched(map_surface_bg, minimap_x - minimap_pan_x, minimap_y - minimap_pan_y, total_width/minimap_size_div, total_height/minimap_size_div);
	}

	if surface_exists(map_surface_ent)
	{
		draw_surface_stretched(map_surface_ent, minimap_x - minimap_pan_x, minimap_y - minimap_pan_y, total_width/minimap_size_div, total_height/minimap_size_div);
	}

	gpu_set_scissor(-1, -1, -1, -1);
}