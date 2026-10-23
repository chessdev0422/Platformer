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
		instance_create_depth(x, y - sprite_height/2, 0, currentProjectile);
	}
}

if attackingTimer > 0
{
	attackingTimer--;
} else {
	state = enemy_states.attacking;
}