if (place_meeting(x, y - 1, obj_player)) {
    is_standing = true;
    restore_timer = 0;
    if (current_timer < break_time) {
        current_timer++;
    }
} else {
    is_standing = false;
    if (current_timer > 0) && (!collision_rectangle(saved_left, saved_top, saved_right, saved_bottom, obj_player, false, true)) {
        restore_timer++;
        if (restore_timer >= restore_time) {
            current_timer = 0;
            restore_timer = 0;
            sprite_index = spr_break_wall;
        }
    }
}

if (current_timer >= break_time) {
    sprite_index = spr_no_collision;
} else {
	
	saved_left = bbox_left;
	saved_right = bbox_right;
	saved_top = bbox_top;
	saved_bottom = bbox_bottom;
	
    if (current_timer < break_time * 0.33) {
        image_index = 0;
    } 
    else if (current_timer < break_time * 0.66) {
        image_index = 1;
    } 
    else {
        image_index = 2;
    }
}