if instance_exists(obj_player)
{
	var _prefix = "spr_player_attacking_";
	var _suffix = "_hitbox";
	var face_names = ["right", "up", "left", "down"];
	var face_str = face_names[obj_player.face];
	var _sprite = string(_prefix + face_str + _suffix);
	var _full_sprite = asset_get_index(_sprite);

	if sprite_index == _full_sprite
	{
		x = obj_player.x;
		y = obj_player.y;
	}
}