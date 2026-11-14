if (variable_global_exists("mp_grid")) {
    mp_grid_clear_all(global.mp_grid);
    mp_grid_add_instances(global.mp_grid, obj_wall, false);
}