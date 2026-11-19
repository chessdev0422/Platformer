scr_controls_setup();

depth = -50;

base_width = 320;
base_height = 180;
gui_width = 320;
gui_height = 180;

var _max_x_scale = display_get_width() / base_width;
var _max_y_scale = display_get_height() / base_height;
window_scale = floor(min(_max_y_scale, _max_x_scale));
if (window_scale < 1) window_scale = 1;

window_set_size(base_width * window_scale, base_height * window_scale);
window_center();

view_enabled = true;
view_visible[0] = true;

var _cam = camera_create_view(0, 0, base_width, base_height);
view_set_camera(0, _cam);

surface_resize(application_surface, base_width * window_scale, base_height * window_scale);

display_set_gui_size(gui_width, gui_height);

follow = obj_player;
xTo = 0;
yTo = 0;
look_ahead = 0;

shake_length = 0;
shake_magnitude = 0;
shake_remain = 0;

var _cam_w = camera_get_view_width(_cam);
global.screenshakeVal = 1;
global.target_max_x = room_width - _cam_w;
global.target_min_x = 0;
global.target_max_y = room_height;
global.target_min_y = 0;