if instance_exists(obj_player)
{
	if instance_exists(obj_warp) {exit;}
	if global.paused { draw_set_alpha(0.5);}
	
	var _mouse_x = mouse_x;
	var _mouse_y = mouse_y;
	
	var _hud_scale = hud_scale; 
	
	var _cam_x = camera_get_view_x(view_camera[0]);
	var _cam_y = camera_get_view_y(view_camera[0]);
	var _cam_w = camera_get_view_width(view_camera[0]);
	var _cam_h = camera_get_view_height(view_camera[0]);
	
	var _columns = 8; //how many hearts fit in a single row before wrapping
	var _start_x = _cam_x + (32 * _hud_scale); //the starting x pos
	var _start_y = _cam_y + (32 * _hud_scale);//starting y pos
	
	var _hp = obj_player.hp;//player hp
	
	var _spr = spr_hearts;//heart sprite
	var _sw = sprite_get_width(_spr);//width and height of the sprite
	var _sh = sprite_get_height(_spr);
	
	var _sep_x = (_sw + 8) * _hud_scale;//the x separation between each heart
	var _sep_y = (_sh + 8) * _hud_scale;//the y separation between each row
	
	var _max_hp = obj_player.maxHP;
	var _total_hearts = _max_hp / 4;//the total amount of hearts
	
	var _max_health_x = 0;
	//loop through the hearts
	for (var i = 0; i < _total_hearts; i++)
	{
		var _xx = _start_x + (i mod _columns) * _sep_x; //get the actual x position to draw
		var _yy = _start_y + (i div _columns) * _sep_y;//get the actual y position to draw
		
		var _heart_hp = _hp - (i*4);//the current hp of this heart (if it is full, empty, or partially full)
		
		var _health_img = clamp(_heart_hp, 0, 4); //clamp it
		
		//draw the heart
		draw_sprite(_spr, _health_img, _xx, _yy);
		
		var _next_x = _start_x + (i+1 mod _columns) * _sep_x;
		if i == (_total_hearts - 1) || _xx > _next_x 
		{
			_max_health_x = _xx;
		}
	}

	//draw the coin text
	draw_text(_cam_x + (32 * _hud_scale), _cam_y + (64 * _hud_scale), "Coins: " + string(global.coins));
	
	if (_hp <= 2) {
   
	    pulse_timer += 0.05;
	    
	    var max_alpha = 0.225 + sin(pulse_timer) * 0.125;
    
	    var w = _cam_w;
	    var h = _cam_h;
	    var edge_thickness = 80 * _hud_scale; //thickness of the border scaled for 180p
    
	    draw_primitive_begin(pr_trianglestrip);
    
	    //top
	    draw_vertex_color(_cam_x, _cam_y, c_red, max_alpha);
	    draw_vertex_color(_cam_x + edge_thickness, _cam_y + edge_thickness, c_red, 0);
	    draw_vertex_color(_cam_x + w, _cam_y, c_red, max_alpha);
	    draw_vertex_color(_cam_x + w - edge_thickness, _cam_y + edge_thickness, c_red, 0);
    
	    //right
	    draw_vertex_color(_cam_x + w, _cam_y + h, c_red, max_alpha);
	    draw_vertex_color(_cam_x + w - edge_thickness, _cam_y + h - edge_thickness, c_red, 0);
    
	    //bottom
	    draw_vertex_color(_cam_x, _cam_y + h, c_red, max_alpha);
	    draw_vertex_color(_cam_x + edge_thickness, _cam_y + h - edge_thickness, c_red, 0);
    
		//left
	    draw_vertex_color(_cam_x, _cam_y, c_red, max_alpha);
	    draw_vertex_color(_cam_x + edge_thickness, _cam_y + edge_thickness, c_red, 0);
    
	    draw_primitive_end();
	}
	
	draw_set_alpha(1);
	
}