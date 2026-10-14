draw_self();

if (variable_instance_exists(id, "path_to_follow") && array_length(path_to_follow) > 0) {
    
    //get current camera settings for view culling
    var _cam_x = camera_get_view_x(view_camera[0]);
    var _cam_y = camera_get_view_y(view_camera[0]);
    var _cam_w = camera_get_view_width(view_camera[0]);
    var _cam_h = camera_get_view_height(view_camera[0]);
    var _pad = 32; //padding
    
    //draw lines between nodes in the path
    if (array_length(path_to_follow) > 1) {
        for (var i = 0; i < array_length(path_to_follow) - 1; i++) {
            var _p1 = path_to_follow[i];
            var _p2 = path_to_follow[i + 1];
           
            //skip drawing if off screen
            if ((_p1.x < _cam_x - _pad && _p2.x < _cam_x - _pad) ||
                (_p1.x > _cam_x + _cam_w + _pad && _p2.x > _cam_x + _cam_w + _pad) ||
                (_p1.y < _cam_y - _pad && _p2.y < _cam_y - _pad) ||
                (_p1.y > _cam_y + _cam_h + _pad && _p2.y > _cam_y + _cam_h + _pad)) {
                continue;
            }
			
			//draw lines
            draw_set_color(c_fuchsia);
            draw_line(_p1.x, _p1.y, _p2.x, _p2.y);
        }
    }
    
    //draw nodes
    for (var i = 0; i < array_length(path_to_follow); i++) {
        var _node = path_to_follow[i];
        
        //skip
        if (_node.x < _cam_x - _pad || _node.x > _cam_x + _cam_w + _pad ||
            _node.y < _cam_y - _pad || _node.y > _cam_y + _cam_h + _pad) {
            continue;
        }
        
        draw_set_color(c_black);
        draw_circle(_node.x, _node.y, 5, false);
        draw_set_color(c_fuchsia);
        draw_circle(_node.x, _node.y, 3, false);
    }
    
    //reset
    draw_set_color(c_white);
}