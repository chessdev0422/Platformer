depth = -10;

global.NavNode = function(_x, _y, _type, _moving_plat = noone) constructor {
    x = _x;
    y = _y;
    type = _type; // "walk", "edge"
    neighbors = []; //array to store connected nodes
	
	moving_platform = _moving_plat;
    x_offset = 0;
    y_offset = 0;
    
    if (moving_platform != noone) {
        x_offset = x - moving_platform.x;
        y_offset = y - moving_platform.y;
    }
	
    //function to link this node to another
    static connect = function(_targetNode, _connectionType) {
        array_push(neighbors, {
            node: _targetNode,
            action: _connectionType
        });
    }
}