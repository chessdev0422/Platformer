depth = -10;

global.NavNode = function(_x, _y, _type) constructor {
    x = _x;
    y = _y;
    type = _type; // "walk", "edge"
    neighbors = []; //array to store connected nodes
	
    //function to link this node to another
    static connect = function(_targetNode, _connectionType) {
        array_push(neighbors, {
            node: _targetNode,
            action: _connectionType
        });
    }
}