if place_meeting(x, y, obj_player)
{
	var _inst = instance_create_depth(0,0,-14000,obj_warp);
	
	_inst.target_x = target_x;
	_inst.target_y = target_y;
	_inst.target_rm = target_rm;
}