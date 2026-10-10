draw_self();

if (variable_instance_exists(id, "path_to_follow") && array_length(path_to_follow) > 0) {
    
    //draw lines only between the sequential nodes in the path array
    if (array_length(path_to_follow) > 1) {
        for (var i = 0; i < array_length(path_to_follow) - 1; i++) {
            var _p1 = path_to_follow[i];
            var _p2 = path_to_follow[i + 1];
           
			//draw lines
            draw_set_color(c_black);
            draw_line_width(_p1.x, _p1.y, _p2.x, _p2.y, 5);
           
            draw_set_color(c_fuchsia);
            draw_line_width(_p1.x, _p1.y, _p2.x, _p2.y, 2);
        }
    }
    
    //draw nodes
    for (var i = 0; i < array_length(path_to_follow); i++) {
        var _node = path_to_follow[i];
        draw_set_color(c_black);
        draw_circle(_node.x, _node.y, 5, false);
        draw_set_color(c_fuchsia);
        draw_circle(_node.x, _node.y, 3, false);
    }
	
    //reset
    draw_set_color(c_white);
}