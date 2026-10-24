if instance_exists(obj_player)
{
	
	if instance_exists(obj_warp) {exit;}
	if global.paused { draw_set_alpha(0.5);}
	
	var _mouse_x = device_mouse_x_to_gui(0);//get mouse for later use
	var _mouse_y = device_mouse_y_to_gui(0);
	
	var _columns = 8; //how many hearts fit in a single row before wrapping
	var _start_x = 32; //the starting x pos
	var _start_y = 32;//starting y pos
	
	var _hp = obj_player.hp;//player hp
	
	var _spr = spr_hearts;//heart sprite
	var _sw = sprite_get_width(_spr);//width and height of the sprite
	var _sh = sprite_get_height(_spr);
	
	var _sep_x = _sw + 8;//the x separation between each heart
	var _sep_y =  _sh + 8;//the y separation between each row
	
	var _max_hp = obj_player.maxHP;
	var _total_hearts = _max_hp / 4;//the total amount of hearts
	
	//loop through the hearts
	for (var i = 0; i < _total_hearts; i++)
	{
		var _xx = _start_x + (i mod _columns) * _sep_x; //get the actual x position to draW
		var _yy = _start_y + (i div _columns) * _sep_y;//get the actual y position to draw
		
		var _heart_hp = _hp - (i*4);//the current hp of this heart (if it is full, empty, or partially full)
		
		var _health_img = clamp(_heart_hp, 0, 4); //clamp it
		
		//draw the heart
		draw_sprite(_spr, _health_img, _xx, _yy);
	}

	//draw the coin text
	draw_text(32, 64, "Coins: " + string(global.coins));
	
	if (_hp <= 2) {
   
	    pulse_timer += 0.05;
    
	    var alpha = 0.4 + sin(pulse_timer) * 0.2;

	    pulse_timer += 0.05;
   
	    var max_alpha = 0.225 + sin(pulse_timer) * 0.125;
    
	    var w = display_get_gui_width();
	    var h = display_get_gui_height();
	    var edge_thickness = 80; //thickness of the border in pixels
    
	    draw_primitive_begin(pr_trianglestrip);
    
	    //top
	    draw_vertex_color(0, 0, c_red, max_alpha);
	    draw_vertex_color(edge_thickness, edge_thickness, c_red, 0);
	    draw_vertex_color(w, 0, c_red, max_alpha);
	    draw_vertex_color(w - edge_thickness, edge_thickness, c_red, 0);
    
	    //right
	    draw_vertex_color(w, h, c_red, max_alpha);
	    draw_vertex_color(w - edge_thickness, h - edge_thickness, c_red, 0);
    
	    //bottom
	    draw_vertex_color(0, h, c_red, max_alpha);
	    draw_vertex_color(edge_thickness, h - edge_thickness, c_red, 0);
    
		//left
	    draw_vertex_color(0, 0, c_red, max_alpha);
	    draw_vertex_color(edge_thickness, edge_thickness, c_red, 0);
    
	    draw_primitive_end();
	}
	
	draw_set_alpha(1);
	
}