if global.paused != true
{
	if keyboard_check_pressed(ord("1"))
	{
		save_game(0);
	}
	if keyboard_check_pressed(ord("3"))
	{
		save_game(1);
	}
	if keyboard_check_pressed(ord("5"))
	{
		save_game(2);
	}	
	if keyboard_check_pressed(ord("2"))
	{
		load_game(0);
	}	
	if keyboard_check_pressed(ord("4"))
	{
		load_game(1);
	}	
	if keyboard_check_pressed(ord("6"))
	{
		load_game(2);
	}
}