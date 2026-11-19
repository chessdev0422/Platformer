scr_get_controls();

if menuKey && (!global.paused || (global.paused && menuShowing))
{
	menuShowing = !menuShowing;
	global.paused = !global.paused;
}