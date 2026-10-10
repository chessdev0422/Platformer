var _nodeCount = array_length(global.nodes);

for (var i = 0; i < _nodeCount; i++) {
    var _node = global.nodes[i];
    
    //loop through each neighbor connected to this node
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

//actual node dots
for (var i = 0; i < _nodeCount; i++) {
    var _node = global.nodes[i];
    

    if (_node.type == "edge") {
        draw_set_color(c_red);    
    } else {
        draw_set_color(c_blue);
    }
    
    draw_circle(_node.x, _node.y, 4, false);
}

draw_set_color(c_white);