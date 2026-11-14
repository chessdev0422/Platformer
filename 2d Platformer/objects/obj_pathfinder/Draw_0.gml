if (variable_global_exists("mp_grid")) && keyboard_check(ord("G")){
    draw_set_alpha(0.4);
    mp_grid_draw(global.mp_grid);
    draw_set_alpha(1.0);
}