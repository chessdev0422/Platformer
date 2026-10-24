scr_get_controls();

if keyboard_check_pressed(ord("P"))
{
	inventory_add(global.item_list.Wood, 99);
	inventory_add(global.item_list.Chocolate_Bar, 1);
}

if keyboard_check_pressed(ord("O")) && hoveredItem != -1
{
	inventory_remove(hoveredItem, 3);
}

if keyboard_check_pressed(ord("E")) //switching tabs
{
	selectedTab++;
	if selectedTab >= item_categories.total 
	{
		selectedTab = 0;
	}
} 
if keyboard_check_pressed(ord("Q"))
{
	selectedTab--;
	if selectedTab < 0
	{
		selectedTab = item_categories.total-1;
	}
}

if rightKeyPressed
{
	currentPage++;	
	if currentPage >= currentMaxPage
	{
		currentPage = 0;
	}
}
if leftKeyPressed
{
	currentPage--;
	if currentPage < 0
	{
		currentPage = currentMaxPage-1;
	}
}


if invKey && !obj_map.mapShowing && !instance_exists(obj_textbox) && otherShowing == noone
{
	invShowing = !invShowing;
	global.paused = !global.paused;
}

//debugging
/*
show_debug_message(global.inventory);

show_debug_message(invAnims);
*/


//timers-------/
if descBufferTimer > 0
{
	descBufferTimer--;
} else {
	if closePercent <= 0
	{
		hoveredItem = -1;
	}
}