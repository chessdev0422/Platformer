scr_controls_setup();

depth = -1000;

//set up resolution
base_width = 640;
base_height = 360;

var _max_x_scale = display_get_width() / base_width;
var _max_y_scale = display_get_height() / base_height;

if frac(_max_y_scale) == 0
{
	_max_y_scale--;	
}

window_scale = (floor(min(_max_y_scale, _max_x_scale)));
window_set_size(base_width * window_scale, base_height * window_scale);
window_center();

surface_resize(application_surface, base_width * window_scale, base_height * window_scale);

display_set_gui_size(base_width, base_height);//set the gui

follow = obj_player;

xTo = 0;
yTo = 0;

look_ahead = 0;

up_down_amt = 0;


//screenshake
shake_length = 0;    //total duration in frames
shake_magnitude = 0; //maximum distance to offset in pixels
shake_remain = 0;    //remaining strength of the shake


view_enabled = true;
view_visible[0] = true;
camera_set_view_size(view_camera[0], base_width, base_height);


var _cam_w = camera_get_view_width(view_camera[0]);
global.target_max_x = room_width - _cam_w;
global.target_min_x = 0;

global.target_max_y = room_height;
global.target_min_y = 0;