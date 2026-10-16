//right horizontal stick pressed (right)
global.axis_rh_prev = global.axis_rh_curr;

global.axis_rh_curr = gamepad_axis_value(0, gp_axisrh);


//left horizontal stick pressed (left)
global.axis_lh_prev = global.axis_lh_curr;

global.axis_lh_curr = gamepad_axis_value(0, gp_axislh);


//right vertical stick pressed (down)
global.axis_rv_prev = global.axis_rv_curr;

global.axis_rv_curr = gamepad_axis_value(0, gp_axisrv);


//left vertical stick pressed (up)
global.axis_lv_prev = global.axis_lv_curr;

global.axis_lv_curr = gamepad_axis_value(0, gp_axislh);