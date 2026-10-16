if point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom) && !instance_exists(obj_textbox)
{
	scr_create_textbox(_text_id);
}