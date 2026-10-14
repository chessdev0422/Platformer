var _nodeCount = array_length(global.nodes);

for (var i = 0; i < _nodeCount; i++) {
    var _node = global.nodes[i];
    
    //if the node is bound to a moving platform, follow it
    if (_node.moving_platform != noone) {
		_node.x = _node.moving_platform.x + _node.x_offset;
        _node.y = _node.moving_platform.y + _node.y_offset;
    }
}