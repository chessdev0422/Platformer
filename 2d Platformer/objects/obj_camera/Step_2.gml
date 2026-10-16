if global.paused exit; 

scr_get_controls();

if !instance_exists(follow) { exit; };	

var _camWidth = camera_get_view_width(view_camera[0]);
var _camHeight = camera_get_view_height(view_camera[0]);


//X------------/
var _target_look_ahead = follow.draw_face * 48;

look_ahead = lerp(look_ahead, _target_look_ahead, 0.2);


xTo = follow.x - _camWidth/2 + (look_ahead);


//smoothly lerp
x += (xTo - x) / 3;


//Y------------/
var _target_up_down_amt = 0;

if upKey && follow.onGround && follow.xspd == 0 {
	_target_up_down_amt = -64;
}
if downKey && follow.onGround && follow.xspd == 0 {
	_target_up_down_amt = 64 + follow.sprite_height;
}

up_down_amt = lerp(up_down_amt, _target_up_down_amt, 0.2);


yTo = follow.y - _camHeight/2 - follow.sprite_height - 2 + up_down_amt;



//smoothly lerp
y += (yTo - y);


if (!variable_instance_exists(id, "cam_min_x")) {
	cam_min_x = 0;
	cam_max_x = room_width - _camWidth;
}


//camera zones target boundaries
var _zone = instance_place(follow.x, follow.y, obj_camera_bound_inst);

var _target_min_x = 0;
var _target_max_x = room_width - _camWidth;

if (_zone != noone) {
	if (variable_instance_exists(_zone, "ignore_left_bound") && _zone.ignore_left_bound) {
		_target_min_x = 0;
	} else {
		_target_min_x = _zone.bbox_left;
	}
	
	if (variable_instance_exists(_zone, "ignore_right_bound") && _zone.ignore_right_bound) {
		_target_max_x = room_width - _camWidth;
	} else {
		_target_max_x = max(_zone.bbox_left, _zone.bbox_right - _camWidth);
	}
}


//smoothly lerp camera boundaries
cam_min_x = lerp(cam_min_x, _target_min_x, 0.1);
cam_max_x = lerp(cam_max_x, _target_max_x, 0.1);


//Y stays bound to standard room limits
var _min_y = 0;
var _max_y = room_height - _camHeight;


x = clamp(x, cam_min_x, cam_max_x);

y = clamp(y, _min_y, _max_y);


var _final_x = x;
var _final_y = y;

if (shake_remain > 0) {
    _final_x += random_range(-shake_remain, shake_remain);
    _final_y += random_range(-shake_remain, shake_remain);
    
    // Reduce shake strength over time
    shake_remain = max(0, shake_remain - ((1 / shake_length) * shake_magnitude));
}

//set camera coords
camera_set_view_pos(view_camera[0], _final_x, _final_y);