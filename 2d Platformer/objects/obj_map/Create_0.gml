scr_controls_setup();


mapShowing = false;//whether or not the map is pulled up

//note: everything is designed for 360p, hence the map scale to halve it to 180p and fit the gui resolution
map_scale = 0.5; // Scale factor to make the map draw at 1/2 size (180p scale relative to 360p)

map_x = 128; //the top left x position of the map corner
map_y = 96; //the top left y position of the map corner

map_width = 384 * map_scale; //the width of the map
map_height = 224 * map_scale; //the height of the map

//the scale to draw the map at (not the same as the actual coverage, this is the x and y scale----
//multiplied by the width and height to get the final scaled w and h)

scaled_room_w = 0; //the scale of the room relative to the map scale
scaled_room_h = 0; //----------------------------------

map_surface_bg = -1; //the map surface for drawing the map background (walls and tiles)
map_surface_ent = -1; //the map surface for drawing dynamic entities (mainly the player ofc)

map_pan_x = 0;
map_pan_y = 0;

dragging_map = false;//whether or not we are dragging the map
drag_mouse_x = 0;
drag_mouse_y = 0;

minimap_size_div = 3;

minimap_pan_x = 0;
minimap_pan_y = 0;

closeSpr = spr_close_ui;
closeStartX = map_x + map_width + (32 * map_scale);
closeStartY = map_y;
closeAnim = 1;