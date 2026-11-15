if damageShader
{
	shader_set(dmgFlashShd);
}

draw_self();

shader_reset();

draw_set_font(big_font);
draw_text(x, y + 20, hp);