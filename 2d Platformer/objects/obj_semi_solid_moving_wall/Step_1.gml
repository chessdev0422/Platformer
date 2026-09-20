//move 
dir += rotationSpd;

var _targetX = xstart + lengthdir_x(rad, dir);

var _targetY = ystart + lengthdir_y(rad, dir);


xspd = _targetX - x;
yspd = _targetY - y;

x += xspd;
y += yspd;