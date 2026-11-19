if point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom) && !global.dialogue
{
	scr_create_textbox(text_id);
}