scr_declare_damage_nonplayer(10);

currentProjectile = obj_fireball;

enum enemy_states {
	idle, 
	attacking,
}

state = enemy_states.idle;

attackingTimerFrames = irandom_range(2 * 60, 4 * 60);
attackingTimer = attackingTimerFrames;