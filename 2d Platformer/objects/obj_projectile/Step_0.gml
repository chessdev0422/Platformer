if destroy = true//run destroy code
{
	instance_destroy();
	if hitVFX == true {
		instance_create_depth(x, y, 0, hitVFXToCreate);
	}
}
if place_meeting(x, y, obj_wall)//destroy
{
	destroy = true;
}