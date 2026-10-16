if (global.paused) exit;

switch (movement_type) {
    
    //circular movement
    case PlatformType.circular:
        dir += rotationSpd;
        var _targetX = center_x + lengthdir_x(rad, dir);
        var _targetY = center_y + lengthdir_y(rad, dir);
        xspd = _targetX - x;
        yspd = _targetY - y;
        break;
        
    //hoizontal back and forth
    case PlatformType.horizontal:
        dir += rotationSpd;
        var _targetX = center_x + sin(degtorad(dir)) * rad;
        var _targetY = center_y;
        xspd = _targetX - x;
        yspd = _targetY - y;
        break;
        
    //vertical back and forth
    case PlatformType.vertical:
        dir += rotationSpd;
        var _targetX = center_x;
        var _targetY = center_y + sin(degtorad(dir)) * rad;
        xspd = _targetX - x;
        yspd = _targetY - y;
        break;
        
    //stationary
    case PlatformType.static_platform:
        xspd = 0;
        yspd = 0;
        break;
}

//move
x += xspd;
y += yspd;