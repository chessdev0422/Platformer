function scr_declare_damage_player()
{
	iframeTimer = 0;
	iframeNumber = 30; //the number of frames of invincibility after being hit
}

function scr_declare_damage_nonplayer(_hp, iframes = false)
{
	maxHP = _hp;
	hp = _hp;
	if iframes == false
	{
		damageList = ds_list_create();
	}
	else //if this condition is run it means we do not need a dmg list and instead rely on
	//invincibility frames
	//*most likely bosses and things*//
	{
		iframeTimer = 0; //
		iframeNumber = 30; //the number of frames of invincibility after being hit
	}
}

function scr_knockback(_x, _y, _strength_x, _strength_y)
{
	if (x > _x) {
        xspd = _strength_x;
    } else {
        xspd = -_strength_x;
    }
    
    yspd = -_strength_y;
}

function scr_take_damage( _damageObj, iframes = false)
{
	
	if iframes == true && iframeTimer > 0
	{
		if damageShader == false
		{
			iframeTimer--;
		
			//checks for iframeTimer modulo 5, meaning the remainder is equal to 0!
			if iframeTimer mod 5 == 0
			{
				//flashes
				if image_alpha = 1
				{
					image_alpha = 0;
				}
				else
				{
					image_alpha = 1;
				}
			}
		}
		exit;
	}
	
	//make sure alpha always equals one afterwards
	if iframes == true
	{
		image_alpha = 1;
	}
	
	if place_meeting(x, y, _damageObj)
	{

		//return a list of all projectile instances***///*** /*important, data struct lists will slow your game
		/*down if not destroyed and cause a memory leak*/
		var _instList = ds_list_create();
		
		//instance_place_list is very similar to array_push, in that it adds to the list just like you could
		//add to an array
		/*set the x and y to be current x and y and check for collisions with projectiles that specifically damages
		whatever damage object is set to, add to the list created above, and since it doesn't matter if ordered is true, set it to be false*/
		var _number = instance_place_list(x, y, _damageObj, _instList, false);
		
		if _number > 0 //check whether we are meeting any dmg objects at all
		{
			var _listSize = ds_list_size(_instList);
			
			var _hitConfirm = false;//if this is false we have not "hit" the damage object
			//for loop to run for the amount of instances of projectiles we are running into, based on the list size
			for (var i = 0; i < _listSize; i++)
			{
				//checking for the value of the list based on the position in the loop
				var _inst = ds_list_find_value(_instList, i);
		
				//tell the obj the script is located in to take damage and the projectile to delete itself if necessary
				//check if the instance projectile is already in the damage list
				//GM will ignore the second part of the code if iframes equals true
				if iframes == true || ds_list_find_index(damageList, _inst) == -1 //the second condition will never run if iFrames is true
				//meaning we don't have to worry about a dmgList not initalized crash
				{
					//if the above code returned negative one, it means the instance
					//was not in the damageList and therefore we need to add it
					if iframes == false //however, don't add the instance if iframes is true still, only false
					{
						ds_list_add(damageList, _inst);
					}
					_hitConfirm = true;//we have "hit" the damage object
					
					hp -= floor(_inst.damage); //subtract from the hp
					
					damageShader = true;//run the damage flash shader(red)
					damageShaderTimer = 6;
					
					if object_index == obj_player
					{
						//hit pause -- meaning for about hitPauseFrames (3) frames player is "stunned"
						global.hitPause = true;
						global.hitPauseTimer = global.hitPauseFrames;
					}
					
					//tell the instance to delete itself
					if _inst.pierce == false
					{
						_inst.destroy = true;
					}
					else
					{
						if _inst.hitVFX == true
						{
							//create vfx
							//create an instance of like an animation or sprite that plays smth
						}
					}
					
					if object_index == obj_player
					{
						//screenshake
						ScreenShake(5, 20); //rather than hard-coded numbers, the value could be determined by
						//the enemy that hits you, for example, default val = 5, 5 * enemy_strength to determine
						//total strength + time
					}
					
					//set up the knockback variables --- run the script in the step event
					knockBackTimer = knockBackFrames;
					knockBackX = _inst.x;
					knockBackY = _inst.y;
				}
			}
			
			if iframes == true && _hitConfirm == true
			{
				iframeTimer = iframeNumber;//set the iFrames up and running after taking damage
			}
		}
		/*destroy the ds_list to avoid a memory leak*/ /***Important*** not ds_list_delete, as that would only destroy
		one entry*/
		ds_list_destroy(_instList);	//**IMPORTANT to destroy it here inside of the first if statement, because the next code needs
		//outside of the intial check and to avoid an error where instList is undefined it needs to be destroyed now
	}
		
		
		if iframes == false
		{
			//clear the damage list
			var _damageListSize = ds_list_size(damageList);
			for (var i = 0; i < _damageListSize; i++)
			{
				var _inst = ds_list_find_value(damageList, i)
				if (!instance_exists(_inst)) || (!place_meeting(x, y, _inst))
				{
					//remove the instance from the damage list and set i and the list size of damage list
					//back by 1 to avoid any errors
					ds_list_delete(damageList, i);
					/*i--;
					_damageListSize--;*/
				}
			}
	}
}