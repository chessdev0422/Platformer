if menuShowing
{
	var _center_x = display_get_gui_width() / 2;
	var _screen_height = display_get_gui_height();
	var _row_height = 35;
	var _count = array_length(menu_options);

	var _max_visible = floor((_screen_height - 150) / _row_height);
	_max_visible = clamp(_max_visible, 4, _count);

	scroll_offset += (mouse_wheel_down() - mouse_wheel_up());
	scroll_offset = clamp(scroll_offset, 0, max(0, _count - _max_visible));

	var _start_y = (_screen_height / 2) - ((_max_visible * _row_height) / 2);

	if (is_remapping) 
	{
	    var _new_key = noone;
    
	    if (keyboard_check_pressed(vk_anykey)) {
	        _new_key = keyboard_key;
	    } else if (mouse_check_button_pressed(mb_left)) {
	        _new_key = mb_left;
	    } else if (mouse_check_button_pressed(mb_right)) {
	        _new_key = mb_right;
	    } else if (mouse_check_button_pressed(mb_middle)) {
	        _new_key = mb_middle;
	    }
    
	    if (_new_key != noone && _new_key != vk_escape) 
	    {
	        variable_global_set(remapping_var, _new_key);
	        save_controls();
	        is_remapping = false;
	        remapping_var = "";
	    }
	} 
	else 
	{
	    var _mouse_x = device_mouse_x_to_gui(0);
	    var _mouse_y = device_mouse_y_to_gui(0);
    
	    for (var i = 0; i < _count; i++) 
	    {
	        var _draw_index = i - scroll_offset;
	        if (_draw_index < 0 || _draw_index >= _max_visible) continue;
        
	        var _item_y = _start_y + (_draw_index * _row_height);
        
	        if (point_in_rectangle(_mouse_x, _mouse_y, _center_x - 180, _item_y - 17, _center_x + 180, _item_y + 17)) 
	        {
	            selected_index = i;
            
	            if (mouse_check_button_pressed(mb_left)) 
	            {
	                is_remapping = true;
	                remapping_var = menu_options[i].variable;
	            }
	        }
	    }
	}

	draw_set_font(normal_font);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	for (var i = 0; i < _count; i++) 
	{
	    var _draw_index = i - scroll_offset;
	    if (_draw_index < 0 || _draw_index >= _max_visible) continue;
    
	    var _opt = menu_options[i];
	    if (!variable_global_exists(_opt.variable)) continue;
    
	    var _current_key = variable_global_get(_opt.variable);
	    var _key_string = "";
    
	    switch (_current_key) {
	        case mb_left:      _key_string = "MOUSE LEFT";  break;
	        case mb_right:     _key_string = "MOUSE RIGHT"; break;
	        case mb_middle:    _key_string = "MOUSE MID";   break;
	        case vk_space:     _key_string = "SPACE";       break;
	        case vk_shift:     _key_string = "SHIFT";       break;
	        case vk_control:   _key_string = "CTRL";        break;
	        case vk_enter:     _key_string = "ENTER";       break;
	        case vk_escape:    _key_string = "ESC";         break;
	        case vk_tab:       _key_string = "TAB";         break;
	        case vk_backspace: _key_string = "BACKSPACE";   break;
	        default:
	            if (_current_key >= ord("A") && _current_key <= ord("Z")) {
	                _key_string = chr(_current_key);
	            } else {
	                _key_string = string(_current_key);
	            }
	            break;
	    }
    
	    if (i == selected_index) {
	        draw_set_color(c_yellow);
	    } else {
	        draw_set_color(c_white);
	    }
    
	    var _display_text = _opt.label + ": ";
	    if (is_remapping && remapping_var == _opt.variable) {
	        _display_text += "[Press Any Key/Click...]";
	    } else {
	        _display_text += _key_string;
	    }
    
	    draw_text(_center_x, _start_y + (_draw_index * _row_height), _display_text);
	}

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}