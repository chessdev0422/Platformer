event_inherited();

switch (state)
{
    case enemy_states.idle:
    {
        sprite_index = spr_wall_worm_idle;
        
        // Wall tracking and facing update only happen while in IDLE
        switch(wall_dir)
        {
            case wall_dirs.right:
                image_angle = 90;
                if instance_exists(obj_player)
                {
                    var _scale = sign(obj_player.y - y);
                    if _scale == 0 { _scale = 1; }
                    image_xscale = _scale;
                }
                break;
            case wall_dirs.up:
                image_angle = 180;
                if instance_exists(obj_player)
                {
                    var _scale = sign(obj_player.x - x);
                    if _scale == 0 { _scale = 1; }
                    image_xscale = _scale;
                }
                break;
            case wall_dirs.left:
                image_angle = 270;
                if instance_exists(obj_player)
                {
                    var _scale = sign(y - obj_player.y);
                    if _scale == 0 { _scale = 1; }
                    image_xscale = _scale;
                }
                break;
            case wall_dirs.down:
                image_angle = 0;
                if instance_exists(obj_player)
                {
                    var _scale = sign(x - obj_player.x);
                    if _scale == 0 { _scale = 1; }
                    image_xscale = _scale;
                }
                break;
        }
        
        if (attackingTimer > 0)
        {
            attackingTimer--;
        } 
        else 
        {
            state = enemy_states.attacking;
            image_index = 0;
            has_fired = false;
        }
        break;
    } 
    
    case enemy_states.attacking:
    {
        sprite_index = spr_wall_worm_attack;
        
        var _firing_frame = 4; 
        
        if (floor(image_index) == _firing_frame && !has_fired)
        {
            
            var _inst = instance_create_depth(x, y, 0, currentProjectile);
            with(_inst)
            {
                visible = false;
                alarm[0] = 2;
            }
            has_fired = true;
        }
        
        if (image_index >= image_number - sprite_get_speed(sprite_index) / game_get_speed(gamespeed_fps))
        {
            state = enemy_states.idle;
            attackingTimer = attackingTimerFrames; 
        }
        
        break;
    }
}