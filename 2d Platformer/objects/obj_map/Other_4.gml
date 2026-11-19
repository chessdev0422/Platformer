if surface_exists(map_surface_bg)
{
	surface_free(map_surface_bg);
	map_surface_bg = -1;
}

map_surface_ent = surface_create(room_width, room_height);

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

var target_w = map_width;
var target_h = map_height;

var total_scale_x = target_w / room_width;
var total_scale_y = target_h / room_height;

var cam_w = camera_get_view_width(view_camera[0]);
var cam_h = camera_get_view_height(view_camera[1]);

scaled_room_w = room_width * total_scale_x;
scaled_room_h = room_height * total_scale_y;

total_width = (room_width/4) * map_scale;
total_height = (room_height/4) * map_scale;

//minimap
minimap_w = (scaled_room_w) / minimap_size_div;
minimap_h = (scaled_room_h) / minimap_size_div;
minimap_x = cam_w - minimap_w - (32 * map_scale);
minimap_y = 32;