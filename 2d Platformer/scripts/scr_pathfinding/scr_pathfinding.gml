function a_star_find_path(_start_node, _goal_node) {

	if (_start_node == noone || _goal_node == noone) { return [];}
	if (_start_node == _goal_node) return [_start_node];
	
	//open list contains the start node, closed list starts empty
	var _open_list = [_start_node]; //open list for nodes that haven't been fully explored
	
	//reset pathfinding across all nodes
	var _node_count = array_length(global.nodes);
	for (var i = 0; i < _node_count; i++) {
		var _node = global.nodes[i];
		_node.g_cost = infinity;
		_node.h_cost = 0;
		_node.f_cost = infinity;
		_node.parent = noone;
		_node.closed = false; //closed flag to prevent time-wasting essentially
	}

	//set up cost vars
	_start_node.g_cost = 0;
	_start_node.h_cost = point_distance(_start_node.x, _start_node.y, _goal_node.x, _goal_node.y);
	_start_node.f_cost = _start_node.h_cost;

	//loop while the open list is not empty
	while (array_length(_open_list) > 0) {
		
		// Select the node with the lowest f(n) value
		var _current_index = 0;
		var _current_node = _open_list[0];
		
		for (var i = 1; i < array_length(_open_list); i++) {
		    if (_open_list[i].f_cost < _current_node.f_cost) {
		        _current_node = _open_list[i];
		        _current_index = i;
		    }
		}

		//if this node is the goal, reconstruct the path
		if (_current_node == _goal_node) {
		    var _path = [];
		    var _temp = _current_node;
		    while (_temp != noone) {
		        array_push(_path, _temp);
		        _temp = _temp.parent;
		    }
		    array_reverse(_path);
			
			var _visited_count = 0;
		for (var i = 0; i < array_length(global.nodes); i++) {
			if (global.nodes[i].closed) _visited_count++;
		}
		//show_debug_message("PATH SUCCESS. Visited " + string(_visited_count) + " out of " + string(array_length(global.nodes)) + " total nodes.");
			
		    return _path;
		}

		//move the node to the closed list
		array_delete(_open_list, _current_index, 1);
		_current_node.closed = true;

		//for each neighbor of the current node:
		var _neighbor_count = array_length(_current_node.neighbors);
		for (var i = 0; i < _neighbor_count; i++) {
		    var _link = _current_node.neighbors[i];
		    var _neighbor = _link.node;

		    //if it's in the closed list, skip it
		    if (_neighbor.closed) continue;

		    //height check for jumps
		    var _vert_rise = _current_node.y - _neighbor.y;//the vertical distance between nodes
			var _horiz_dist = _current_node.y - _neighbor.y;//the horizontal distance between nodes
		    var _max_allowed_rise = 32 * 4.5;//max allowed rise for a jump
			var _max_allowed_dist = 32 * 5.5;//max allowed distance for a gao
			var _jump_val = 0;
			var _gap_val = 0;
		    if (_link.action == "jump" && _vert_rise > _max_allowed_rise) {
		       _jump_val += 100000;//increase jump value to heavily push against path
		    }
			if (_link.action == "jump" && _horiz_dist > _max_allowed_dist) {
				_gap_val += 100000;//increase the gap value to heavily push against path
			}

		    //calculate g(n) and h(n) for the neighbor
		    var _tentative_g = _current_node.g_cost + point_distance(_current_node.x, _current_node.y, _neighbor.x, _neighbor.y) + _jump_val + _gap_val;

		    var _in_open_list = false;
		    for (var k = 0; k < array_length(_open_list); k++) {
		        if (_open_list[k] == _neighbor) {
		            _in_open_list = true;
		            break;
		        }
		    }

		    //if it's not in the open list, add it. if it is, check if the new path has a lower g(n)
		    if (!_in_open_list || _tentative_g < _neighbor.g_cost) {
		        _neighbor.parent = _current_node;
		        _neighbor.g_cost = _tentative_g;
		        _neighbor.h_cost = point_distance(_neighbor.x, _neighbor.y, _goal_node.x, _goal_node.y);
		        _neighbor.f_cost = _neighbor.g_cost + _neighbor.h_cost;

		        if (!_in_open_list) {
		            array_push(_open_list, _neighbor);
		        }
		    }
		}
	}
	
	var _visited_count = 0;
	for (var i = 0; i < array_length(global.nodes); i++) {
	    if (global.nodes[i].closed) _visited_count++;
	}
	//show_debug_message("PATH FAILED. Visited " + string(_visited_count) + " out of " + string(array_length(global.nodes)) + " total nodes.");
	
	return []; 
}

function get_nearest_node(_x, _y) {
    var _closestNode = noone;
    var _minDist = infinity;
    
    var _nodeCount = array_length(global.nodes);
    for (var i = 0; i < _nodeCount; i++) {
        var _node = global.nodes[i];
        var _dist = point_distance(_x, _y, _node.x, _node.y);//find the nearest x and y
        
        if (_dist < _minDist) {//compare
            _minDist = _dist;
            _closestNode = _node;
        }
    }
    
    return _closestNode;//return the closest
}