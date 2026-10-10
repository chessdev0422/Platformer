var dir = point_direction(x, y, other.x, other.y);
var len = lerp(2, 0, point_distance(x, y, other.x, other.y) / max(abs(sprite_width), abs(sprite_height)));

var push_other_x = lengthdir_x(len, dir);
var push_other_y = lengthdir_y(len, dir);

var push_self_x  = lengthdir_x(len, dir + 180);
var push_self_y  = lengthdir_y(len, dir + 180);

with (other) {
    if (!place_meeting(x + push_other_x, y, obj_wall)) {
        x += push_other_x;
    }
    if (!place_meeting(x, y + push_other_y, obj_wall)) {
        y += push_other_y;
    }
}

if (!place_meeting(x + push_self_x, y, obj_wall)) {
    x += push_self_x;
}
if (!place_meeting(x, y + push_self_y, obj_wall)) {
    y += push_self_y;
}