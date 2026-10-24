var _i = obj_inventory_manager;
if interacting && (!_i.invShowing || instance_exists(obj_textbox) || obj_map.mapShowing)
{
	if _i.otherShowing == noone
	{
		_i.otherShowing = obj_player.interactInst;
	} else {
		_i.otherShowing = noone;
	}
	global.paused = !global.paused;
	interacting = false;
}