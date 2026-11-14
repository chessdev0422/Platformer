// Inherit the parent event
event_inherited();

//set up 

//knockback --------- /
//vvv--//

knockBackX = 0;//the x to pass into the knockback function
knockBackY = 0;//the y to pass into the knockback function
knockBackStrengthX = 3;//the strength the enemy will be knocked back with on the x-axis
knockBackStrengthY = 3;//the strength the enemy will be knocked back with on the y-axis
knockBackTimer = 0;
knockBackFrames = 20;//length of the knockback
knockBackDamagingInstX = 0;
knockBackDamagingInstY = 0;

//dmg



//states
wall_dir = 0;//make sure to initialize this so saving/loading doesn't break
face = 0;

xspd = 0;
yspd = 0;
moveSpd = 3;

isAttacking = false;

state = enemy_states.idle;

attackingTimerFrames = irandom_range(2 * 60, 4 * 60);
attackingTimer = attackingTimerFrames;

sightRange = 150;//distance to start chasing
attackRange = 40;//distance to trigger attack

//path setup
path = path_add();