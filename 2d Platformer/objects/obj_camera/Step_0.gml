if !instance_exists(follow) { exit; };	

var _camWidth = camera_get_view_width(view_camera[0]);
var _camHeight = camera_get_view_height(view_camera[0]);

xTo = follow.x - _camWidth/2;
yTo = follow.y - _camHeight/2;

//smoothly lerp
x += (xTo - x) / 15;
y += (yTo - y) / 15;

//keep camera inside room
x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);

//set camera coords
camera_set_view_pos(view_camera[0], x, y);