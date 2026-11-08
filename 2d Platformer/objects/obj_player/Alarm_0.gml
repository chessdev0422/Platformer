var _dmg = currentAttackDmg;
var _attack_dmg_inst = instance_create_depth(x, y, depth - 1, obj_damage_non_player);
with (_attack_dmg_inst)
{
	mask_index = other.sprite_index;
	sprite_index = other.sprite_index;
	image_xscale = other.image_xscale * other.last_face;
	//show_debug_message(mask_index);
	followPlayer = true;
	image_index = other.image_index;
	damage = _dmg;
}