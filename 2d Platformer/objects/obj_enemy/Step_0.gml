scr_take_damage(obj_damage_non_player); //take damage from damaging objects

if damageShaderTimer > 0
{
	damageShaderTimer--;
} else {
	damageShader = false;
}