var _cell_width = 16;  
var _cell_height = 16;
var _h_cells = room_width div _cell_width;
var _v_cells = room_height div _cell_height;

global.mp_grid = mp_grid_create(0, 0, _h_cells, _v_cells, _cell_width, _cell_height);

mp_grid_add_instances(global.mp_grid, obj_wall, false);