var _i = obj_inventory_manager;
if interacting && (!global.paused || (global.paused && _i.otherShowing != noone))
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