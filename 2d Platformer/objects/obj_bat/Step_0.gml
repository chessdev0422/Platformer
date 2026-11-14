//basic movement to test
/*if instance_exists(obj_player)
{
	mp_potential_step_object(obj_player.x, obj_player.y, 2, obj_wall);
	face = obj_player.x < x ? 1 : -1
}*/

event_inherited();
scr_get_controls();


if !instance_exists(obj_player) exit;

xspd = 0;//set the xpsd to move along the path here
yspd = 0;//the yspd for the path here

//set the enemy face
face = obj_player.x > x ? -1 : 1;

//create a path if it doesn't exist
if (!path_exists(path))
{
    path = path_add();
}
            

if (mp_grid_path(global.mp_grid, path, x, y, obj_player.x, obj_player.y - obj_player.sprite_height/2, true))
{
	//get the points directly from the path
    if (path_get_number(path) > 1)
    {
        var _nx = path_get_point_x(path, 1);
        var _ny = path_get_point_y(path, 1);
                    
        var _dir = point_direction(x, y, _nx, _ny);
        xspd = lengthdir_x(moveSpd, _dir);
        yspd = lengthdir_y(moveSpd, _dir);
		
		var _target_dist = point_distance(x, y, _nx, _ny);
		
		//we've arrived
		if (_target_dist <= moveSpd)
		{
		    x = _nx;
		    y = _ny;
		    xspd = 0;
		    yspd = 0;
		}
    }
}

if knockBackTimer > 0 {
	knockBackTimer--;
	xspd = knockBackStrengthX * sign(x - knockBackDamagingInstX);
	yspd = knockBackStrengthY * sign(y + sprite_height/2 - knockBackDamagingInstY);
}

//movement in the x


//enemy separation (avoiding other enemies)
var _sepX = 0;
var _sepDist = 32; 
var _sepStrength = 1.5; 

with (obj_bat) 
{
    if (id != other.id && id > other.id) //checking if id is greater means only one runs the code
    {
        var _dist = point_distance(other.x, other.y, x, y);
        
        if (_dist < _sepDist && _dist > 0)
        {
            var _dir = point_direction(x, y, other.x, other.y);
            var _weight = (1 - (_dist / _sepDist));
            var _pushX = lengthdir_x(_sepStrength * _weight, _dir);
            
            _sepX += _pushX;
            xspd -= _pushX; //equal and opposite push to them
        }
    }
}
xspd += _sepX;


	//collisions
	//scoot right up to the wall
	var _subPixel = 0.5;
	
	if place_meeting(x + xspd, y, obj_wall)
	{
		var _pixelCheck = _subPixel * sign(xspd);//sign of xspd returns direction
		
		while(!place_meeting(x + _pixelCheck, y, obj_wall))//continue scooting until right up against the wall
		{
			x += _pixelCheck;
		}
		
		xspd = 0; //set xspd to 0 to "collide"
	}
		

//move the enemy in the
x += xspd;	
	
//y
	
//separation
var _sepY = 0;
var _sepDist = 32; 
var _sepStrength = 1.5; 

with (obj_bat) 
{
	if (id != other.id && id > other.id)
	{
	    var _dist = point_distance(other.x, other.y, x, y);
        
	    if (_dist < _sepDist && _dist > 0)
	    {
	        var _dir = point_direction(x, y, other.x, other.y);
	        var _weight = (1 - (_dist / _sepDist));
	        var _pushY = lengthdir_y(_sepStrength * _weight, _dir);
            
	        _sepY += _pushY;
	        yspd -= _pushY; //equal and opposite push to them
	    }
	}
}
yspd += _sepY;

	
	//collisions
	//scoot right up to the wall
	var _subPixel = 0.5;
	
	if place_meeting(x, y + yspd, obj_wall)
	{
		var _pixelCheck = _subPixel * sign(yspd);//sign of yspd returns direction
		
		while(!place_meeting(x, y + _pixelCheck, obj_wall))//continue scooting until right up against the wall
		{
			y += _pixelCheck;
		}
		
		yspd = 0; //set yspd to 0 to "collide"
	}
	
//move the enemy in the y
y += yspd;