var _camWidth = camera_get_view_width(view_camera[0]);
var _camHeight = camera_get_view_height(view_camera[0]);

if instance_exists(follow)
{
	x = xTo = follow.x - _camWidth/2
	y = yTo = follow.y - _camHeight/2 - follow.sprite_height - 2;
}

view_enabled = true;
view_visible[0] = true;
camera_set_view_size(view_camera[0], base_width, base_height);


var _cam_w = camera_get_view_width(view_camera[0]);
global.target_max_x = room_width - _cam_w;
global.target_min_x = 0;

global.target_max_y = room_height;
global.target_min_y = 0;