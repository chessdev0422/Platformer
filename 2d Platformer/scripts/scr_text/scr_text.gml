function scr_ini_text(_speaker)
{
	line_break_pos[0, page_number] = 0; 
	line_break_num[page_number] = 0;
	line_break_offset[page_number] = 0;
	speaker[page_number] = _speaker;
}

function scr_text(_text, _speaker = -1)
{
	scr_ini_text(_speaker);
	
	text[page_number] = _text;
	
	page_number++;
}

function scr_option(_text, _link_id)
{
	option[option_number] = _text;
	option_link_id[option_number] = _link_id;
	
	option_number++;
}

function scr_create_textbox(_text_id)
{
	with (instance_create_depth(x, y, 0, obj_textbox))
	{
		scr_gametext(_text_id);
	}
}