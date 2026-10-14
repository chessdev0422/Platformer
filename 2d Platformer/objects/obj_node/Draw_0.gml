//get current camera settings for view culling
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);
var _pad = 32; //padding

var _nodeCount = array_length(global.nodes);

//draw the node connections -- lines
for (var i = 0; i < _nodeCount; i++) {
    var _node = global.nodes[i];
    
    //check if the node is offscreen
    if (_node.x < _cam_x - _pad || _node.x > _cam_x + _cam_w + _pad ||
        _node.y < _cam_y - _pad || _node.y > _cam_y + _cam_h + _pad) {
        continue;
    }
    
    var _neighborCount = array_length(_node.neighbors);
    for (var j = 0; j < _neighborCount; j++) {
        var _connection = _node.neighbors[j];
        var _targetNode = _connection.node;
        
        if (_connection.action == "jump") {
            draw_set_color(c_yellow);
        } else {
            draw_set_color(c_green);
        }
        
        draw_line(_node.x, _node.y, _targetNode.x, _targetNode.y);
    }
}

//draw the actual nodes -- dots
for (var i = 0; i < _nodeCount; i++) {
    var _node = global.nodes[i];
    
    if (_node.x < _cam_x - _pad || _node.x > _cam_x + _cam_w + _pad ||
        _node.y < _cam_y - _pad || _node.y > _cam_y + _cam_h + _pad) {
        continue;
    }
    
    if (_node.type == "edge") {
        draw_set_color(c_red);    
    } else {
        draw_set_color(c_blue);
    }
    
    draw_circle(_node.x, _node.y, 4, false);
}

draw_set_color(c_white);