depth = -40;

event_inherited(); // Inherit the parent event

scr_declare_damage_nonplayer(10);

currentProjectile = obj_fireball;

state = enemy_states.idle;

attackingTimerFrames = irandom_range(2 * 60, 4 * 60);
attackingTimer = attackingTimerFrames;

has_fired = false;

enum wall_dirs {
	right,
	up, 
	left,
	down
}