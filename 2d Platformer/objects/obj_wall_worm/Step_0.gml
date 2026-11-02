switch(state)
{
	case enemy_states.idle:
	{
		break;
	} 
	case enemy_states.attacking:
	{
		attackingTimer = attackingTimerFrames;
		state = enemy_states.idle;
		instance_create_depth(x, y, 0, currentProjectile);
	}
}

if attackingTimer > 0
{
	attackingTimer--;
} else {
	state = enemy_states.attacking;
}

switch(wall_dir)
{
	case wall_dirs.right:
		image_angle = 90;
		
		if instance_exists(obj_player)
		{
			var _scale = sign(obj_player.y - y);
			if _scale == 0
			{
				_scale = 1;
			}
			
			image_xscale = _scale;
		}
		
		break;
	case wall_dirs.up:
		image_angle = 180;
		
		if instance_exists(obj_player)
		{
			var _scale = sign(obj_player.x - x);
			if _scale == 0
			{
				_scale = 1;
			}
			
			image_xscale = _scale;
		}
		break;
	case wall_dirs.left:
		image_angle = 270;
		
		if instance_exists(obj_player)
		{
			var _scale = sign(y - obj_player.y);
			if _scale == 0
			{
				_scale = 1;
			}
			
			image_xscale = _scale;
		}
		break;
	case wall_dirs.down:
		image_angle = 0;
		
		if instance_exists(obj_player)
		{
			var _scale = sign(x - obj_player.x);
			if _scale == 0
			{
				_scale = 1;
			}
			
			image_xscale = _scale;
		}
		break;
}