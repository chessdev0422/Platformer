scr_declare_damage_nonplayer(10); //set the current hp and set up damage

enum enemy_states
{
	idle, 
	attacking,
}


damageShader = false;//whether or not to draw the damage shader
damageShaderTimer = 0; //timer to keep track of shader
damageShaderFrames = 30; //the length of the damage shader to last