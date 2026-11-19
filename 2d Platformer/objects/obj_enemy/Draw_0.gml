if damageShader
{
	shader_set(dmgFlashShd);
}

draw_self();

shader_reset();

draw_set_font(small_font);
draw_text(x, y + 20, hp);