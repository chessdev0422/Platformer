var _cam_w = camera_get_view_width(view_camera[0])/2;
var _cam_h = camera_get_view_height(view_camera[0])/2;
draw_sprite_ext(sprite_index, 0, x + _cam_w, y + _cam_h, 1, 1, 0, c_white, 1);

draw_sprite_ext(spr_camera_outline, 0, x, y, 1, 1, 0, c_white, 1);