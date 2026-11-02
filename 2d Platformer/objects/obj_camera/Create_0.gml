scr_controls_setup();

depth = -1000;

base_width = 320;
base_height = 180;
gui_width = 640;
gui_height = 360;

var _max_x_scale = display_get_width() / gui_width;
var _max_y_scale = display_get_height() / gui_height;

if frac(_max_y_scale) == 0
{
	_max_y_scale--;	
}

window_scale = floor(min(_max_y_scale, _max_x_scale));
if (window_scale < 1) window_scale = 1;

window_set_size(gui_width * window_scale, gui_height * window_scale);
window_center();

surface_resize(application_surface, base_width * (window_scale * 2), base_height * (window_scale * 2));

follow = obj_player;
xTo = 0;
yTo = 0;
look_ahead = 0;

shake_length = 0;
shake_magnitude = 0;
shake_remain = 0;

view_enabled = true;
view_visible[0] = true;
camera_set_view_size(view_camera[0], base_width, base_height);

var _cam_w = camera_get_view_width(view_camera[0]);
global.target_max_x = room_width - _cam_w;
global.target_min_x = 0;
global.target_max_y = room_height;
global.target_min_y = 0;

display_set_gui_size(gui_width, gui_height);