if damageShader
{
	shader_set(dmgFlashShd);
}

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * face, image_yscale, 0, c_white, 1);

if keyboard_check(ord("G"))
{
	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
}

shader_reset();

draw_set_font(big_font);
draw_text(x, y + 20, hp);