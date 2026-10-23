event_inherited();
pierce = false;


depth = -100;
if instance_exists(obj_player)
{
image_angle = point_direction(x, y, obj_player.x, obj_player.y);

dir = point_direction(x, y, obj_player.x, obj_player.y - obj_player.sprite_height/2);//direction towards player
spd = 4; //number of pixels to move per step
xDir = lengthdir_x(spd, dir);
yDir = lengthdir_y(spd, dir);

} else {
	instance_destroy();
}