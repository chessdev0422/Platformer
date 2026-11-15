if (variable_global_exists("mp_grid")) {
    mp_grid_clear_all(global.mp_grid);
    with (obj_wall)
	{
	    if object_index == obj_wall
	    {
	        mp_grid_add_instances(global.mp_grid, id, false);
	    }
	}
}