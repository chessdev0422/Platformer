scr_get_controls();

draw_set_font(small_font);

var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);

var _mouse_x = device_mouse_x(0) - _cam_x;
var _mouse_y = device_mouse_y(0) - _cam_y;

var _total_pages_check = page_number-1;
textbox_x = 0;
textbox_y = _cam_h - height - (32 * text_scale);

if !setup //run the setup on creation
{
	setup = true; // set setup to true
	
	//loop through the pages
		//i = current page
	for(var i = 0; i < page_number; i++)
	{
		text_length[i] = string_length(text[i]); //set the text_length to the string_length and store it in the array
		
		//get the x position for the textbox
			//no character portrait - centered
			text_x_offset[i] = (_cam_w - width)/2;
			
			//j = current char
			for(var j = 0; j < text_length[i]; j++)
			{
				
				var _char_pos = j+1;
				
				char[j, i] = string_char_at(text[i], _char_pos);
				
				//get the current width of the line
				var _text_up_to_char = string_copy(text[i], 1, _char_pos); //gets all of the text up until the current
				//index of the loop
				var _current_text_w = string_width(_text_up_to_char)  - string_width(char[j, i]); //gets the current text width accounting for the
				//current char we are on
				
				//get the last free space
				if char[j, i] == " " { last_free_space = _char_pos+1; }; //_char_pos+1 b/c we want to line to break
				//" //here" and not "//here "
				
				//get the line breaks
					if _current_text_w - line_break_offset[i]/*defaults to 0*/ > line_width - border
					{
						line_break_pos[ line_break_num[i], i ] = last_free_space;
						line_break_num[i]++;
						var _text_up_to_last_free_space = string_copy(text[i], 1, last_free_space);
						var _last_free_space_string = string_char_at(text[i], last_free_space);
						line_break_offset[i] = string_width( _text_up_to_last_free_space ) - string_width( _last_free_space_string );
					}
			}
			
			//getting each characters coords
			for(var j = 0; j < text_length[i]; j++)
			{
				
				var _char_pos = j+1;
				
				var _text_x = textbox_x + text_x_offset[i] + border;
				var _text_y = textbox_y + border;
				
				//get the current width of the line
				var _text_up_to_char = string_copy(text[i], 1, _char_pos); //gets all of the text up until the current
				//index of the loop
				var _current_text_w = string_width(_text_up_to_char)  - string_width(char[j, i]); //gets the current text width accounting for the
				//current char we are on
				
				var _text_line = 0;
				
				//compensate for string breaks
				for(var l = 0; l < line_break_num[i]; l++)
				{
					//if the current looping char is after a line break
					if _char_pos >= line_break_pos[l, i]
					{
						var _str_copy = string_copy(text[i], line_break_pos[l, i], _char_pos-line_break_pos[l,i]);
						_current_text_w = string_width(_str_copy);
						
						//record the line the char should be on
							_text_line = l+1; //+1 since l starts at 0
					}
				}
			
			//add to the x and y pos
				char_x[j, i] = _text_x + _current_text_w;
				char_y[j, i] = _text_y + _text_line*(line_sep);
			
			}
			
	}
}

//check if we are not paused, then type the text ------------- add in sound
if text_pause_timer <= 0
{
	//typing the text
	if draw_char < text_length[page]
	{
		draw_char += text_spd;
		draw_char = clamp(draw_char, 0, text_length[page]);
	
		var _check_char = string_char_at(text[page], draw_char);
		var punc = _check_char == "." 
		|| _check_char == "?" 
		|| _check_char == "!" 
		|| _check_char == "," 
		|| _check_char == ";" 
		|| _check_char == ":" //pause on these puncuation symbols
	
		if punc
		{
			text_pause_timer = text_pause_time;
		}
	}
} else {
	text_pause_timer--; //subtract from the timer
}

//flip through pages
if acceptKey || (option_hover && (lmButton || rmButton)) 
{
	//typing is done
	if draw_char == text_length[page]
	{
		//still more pages
		if  page < _total_pages_check
		{
			page++;
			draw_char = 0;
		} 
		//end of the road
		else {
			if option_number > 0
			{
				scr_create_textbox(option_link_id[option_pos]);
			} else {
				global.paused = false;
				global.dialogue = false
			}
			instance_destroy();
		}
	} 
	//typing is not done
	else {
		draw_char = text_length[page];
	}
}


var _tx = textbox_x + text_x_offset[page] + _cam_x;
var _ty = textbox_y + _cam_y;

//draw the textbox
textbox_img += textbox_img_spd

textbox_spr_w = sprite_get_width(textbox_spr);
textbox_spr_h = sprite_get_height(textbox_spr);
	
	//back of the textbox
	var _w = width / textbox_spr_w; //width for the textbox
	var _h = height / textbox_spr_h; //height for the textbox
	draw_sprite_ext(textbox_spr, textbox_img, _tx, _ty, _w, _h, 0, c_white, 1);

//options
draw_set_valign(fa_top);
draw_set_halign(fa_left);
if draw_char == text_length[page] && page == _total_pages_check
{
	
	//option selection
	var _total_options_check = option_number-1;
	if !option_hover
	{
		option_pos += menuDownKeyPressed - menuUpKeyPressed;
	}
	option_pos = clamp(option_pos, 0, _total_options_check);
	
	var op_border = 8 * text_scale;
	var push_over_amt = 25 * text_scale;
	
	//draw the options
	for(var i = 0; i < option_number; i++)
	{
		var _oh = string_height(option[i]) - 8 + (op_border*2);
		
		var _ox = _tx + push_over_amt;
		var _oy = _ty - (_oh)*option_number + (_oh)*i;
		var _ow = ((string_width(option[i]))) + op_border * 2;
		
		if (option_pos == i)
		{
			_ox += push_over_amt; 
			var a_w = sprite_get_width(spr_textbox_arrow) * text_scale;
			draw_sprite_ext(spr_textbox_arrow, 0, _ox - a_w - (4 * text_scale), _oy + _oh/2, text_scale, text_scale, 0, c_white, 1);
		}
		
		if point_in_rectangle(_mouse_x, _mouse_y, _ox - _cam_x - push_over_amt, _oy - _cam_y, _ox + _ow - _cam_x, _oy + _oh - _cam_y)
		{
			option_pos = i;
			option_hover = true;
			alarm[0] = 5;
		}
		
		//draw the box
		draw_sprite_ext(textbox_option_spr, textbox_img, _ox, _oy, _ow/textbox_spr_w, _oh/textbox_spr_h, 0, c_white, 1);
		
		
		draw_set_valign(fa_middle);
		//draw the text
		draw_text(_ox + op_border, _oy + op_border, option[i]);
		
		draw_set_valign(fa_top);
		
	}
}

//draw the speaker
if speaker[page] != -1
	{
		var _speaker_scale = text_scale;
		draw_sprite_ext(speaker_spr, textbox_img, _tx + width + (border*2), _ty, _speaker_scale, _speaker_scale, 0, c_white, 1);
		scr_speakers(speaker[page], _tx + width + (border*2), _ty);
	}

//draw the text
draw_set_valign(fa_top);
draw_set_halign(fa_left);
for(var i = 0; i < draw_char; i++)
{
	//the text
	draw_text(char_x[i, page] + _cam_x, char_y[i, page] + _cam_y, char[i, page]);
}
		
draw_set_valign(fa_top);
draw_set_halign(fa_left);