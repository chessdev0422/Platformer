if damageShader
{
	shader_set(dmgFlashShd);
}


draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * draw_face, image_yscale, image_angle, image_blend, image_alpha);


shader_reset();
draw_text(x, y + 20, hp);