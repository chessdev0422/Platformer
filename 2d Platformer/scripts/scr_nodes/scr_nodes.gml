function has_air_node_above(_wall_node) {
    for (var i = 0; i < array_length(global.nodes); i++) {
        var _n = global.nodes[i];
        
        //check if a node shares the same X coordinate and sits above the wall node
        if (_n.x == _wall_node.x && _n.y < _wall_node.y && (_wall_node.y - _n.y <= 256)) {
			var _isBlocked = check_solid_wall_blocked(_wall_node.x, _wall_node.y, _n.x, _n.y);
                
                if (!_isBlocked) { //not blocked by a wall
                    return true; //air node found
                }
        }
    }
    return false;//not found
}