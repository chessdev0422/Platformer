//get the camera offsets
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);

var _menu = menu_option[current_menu_page];
var _menu_length = array_length(_menu);

//middle line

var _line_height;
for(var i = 0; i < _menu_length; i++)
{
	var _row_height = string_height(_menu[i][0]);
	_line_height = ((sep + _row_height) * i);
}

switch(current_menu_page)
{
	case menu_pages.main:
	case menu_pages.settings:
	break;
	
	case menu_pages.audio:
	
	case menu_pages.graphics:
	
	case menu_pages.controls:
	
	case menu_pages.difficulty:
	
	//get the line x
	var _lx = _cam_x + (_cam_w/2);
	
	//get the line height
	var _lh = _line_height;
	
	//get the line y based off the height
	var _ly = _cam_y + (_cam_h/2) - (_line_height/2);
	
	draw_line(_lx, _ly, _lx, _ly + _lh);
	
	break;
}


//normal/right side (options)



//left side (changed values)