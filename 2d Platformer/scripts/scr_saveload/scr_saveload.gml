function save_room()
{
	var _roomStruct;
	
	
	/*var _objNumber = instance_number(obj_obj);
	
	
	var _roomStruct =
	{
		objNumber : _objNumber,
		objData : array_create(_objNumber),
	}
	for (var i = 0; i < _objNumber; i ++)
	{
		var obj_inst = instance_find(obj_obj, i)
			
		_roomStruct.objData[i] = 
		{
			x : obj_inst.x,
			y : obj_inst.y,
		}
	}*/
	
	var _cameraNumber = instance_number(obj_camera);
	var _wallNumber = instance_number(obj_moving_wall);
	var _semiWallNumber = instance_number(obj_semi_solid_moving_wall);
	var _enemyNumber = instance_number(obj_enemy);
	var _projNumber = instance_number(obj_projectile);
	var _interactNumber = instance_number(obj_interact);
	
	
	var _roomStruct =
	{
		cameraNumber : _cameraNumber,
		cameraData : array_create(_cameraNumber),
		
		wallNumber : _wallNumber,
		wallData : array_create(_wallNumber),

		semiWallNumber : _semiWallNumber,
		semiWallData : array_create(_semiWallNumber),
	
		enemyNumber : _enemyNumber,
		enemyData : array_create(_enemyNumber),

		projNumber : _projNumber,
		projData : array_create(_projNumber),
		
		interactNumber : _interactNumber,
		interactData : array_create(_interactNumber),
	}
	
	//camera
	for (var i = 0; i < _cameraNumber; i ++)
	{
		var camera_inst = instance_find(obj_camera, i)
			
		_roomStruct.cameraData[i] = 
		{
			x : camera_inst.x,
			y : camera_inst.y,
		}
	}
	
	//walls
	for (var i = 0; i < _wallNumber; i ++)
	{
		var wall_inst = instance_find(obj_moving_wall, i)
			
		_roomStruct.wallData[i] = 
		{
			x : wall_inst.x,
			y : wall_inst.y,
			image_xscale : wall_inst.image_xscale,
			dir : wall_inst.dir,
			rotationSpd : wall_inst.rotationSpd,
			rad : wall_inst.rad,
			movement_type : wall_inst.movement_type,
			center_x : wall_inst.center_x,
			center_y : wall_inst.center_y,
		}
	}
	//semi-solid walls
	for (var i = 0; i < _semiWallNumber; i ++)
	{
		var semi_wall_inst = instance_find(obj_semi_solid_moving_wall, i)
			
		_roomStruct.semiWallData[i] = 
		{
			x : semi_wall_inst.x,
			y : semi_wall_inst.y,
			image_xscale : semi_wall_inst.image_xscale,
			image_xscale : semi_wall_inst.image_xscale,
			dir : semi_wall_inst.dir,
			rotationSpd : semi_wall_inst.rotationSpd,
			rad : semi_wall_inst.rad,
			movement_type : semi_wall_inst.movement_type,
			center_x : semi_wall_inst.center_x,
			center_y : semi_wall_inst.center_y,
		}
	}
	
	//enemies
	for (var i = 0; i < _enemyNumber; i ++)
	{
		var enemy_inst = instance_find(obj_enemy, i)
			
		_roomStruct.enemyData[i] = 
		{
			x : enemy_inst.x,
			y : enemy_inst.y,
			type : enemy_inst.object_index,
		}
	}
	
	//projectiles
	for (var i = 0; i < _projNumber; i ++)
	{
		var proj_inst = instance_find(obj_projectile, i)
			
		_roomStruct.projData[i] = 
		{
			x : proj_inst.x,
			y : proj_inst.y,
			type: proj_inst.object_index,
			image_angle : proj_inst.image_angle,
			dir : proj_inst.image_angle,
			xDir : proj_inst.xDir,
			yDir : proj_inst.yDir,
		}
	}
	
	//interacting (shops, chests, etc)
	for (var i = 0; i < _interactNumber; i ++)
	{
		var interact_inst = instance_find(obj_interact, i)
			
		_roomStruct.interactData[i] = 
		{
			x : interact_inst.x,
			y : interact_inst.y,
			type: interact_inst.object_index,
			inv : interact_inst.inv,
		}
	}
	
	
	if room == room_test {global.levelData.test = _roomStruct };
	if room == room_test_2 {global.levelData.test_2 = _roomStruct };
}	

function load_room()
{	
	var _roomStruct = 0;
	
	if room == room_test {_roomStruct = global.levelData.test};
	if room == room_test_2 {_roomStruct = global.levelData.test_2};
	
	if !is_struct(_roomStruct) {exit;};
	
	/*
	if instance_exists(obj_obj) {instance_destroy(obj_obj);};
	
	for (var i = 0; i < _roomStruct.objNumber; i++)
	{
		instance_create_depth(_roomStruct.objData[i].x, _roomStruct.objData[i].y,  0, obj_obj);
	}
	*/
	
	for (var i = 0; i < _roomStruct.cameraNumber; i++)
	{
		if (instance_exists(obj_camera))
		{
		    obj_camera.x = _roomStruct.cameraData[i].x;
		    obj_camera.y = _roomStruct.cameraData[i].y;
		} else {
			instance_create_depth(_roomStruct.cameraData[0].x, _roomStruct.cameraData[0].y, 0, obj_camera);
		}
	}
	
	//moving walls
	if instance_exists(obj_moving_wall) {instance_destroy(obj_moving_wall);};
	
	for (var i = 0; i < _roomStruct.wallNumber; i++)
	{
		var wall_inst = instance_create_depth(_roomStruct.wallData[i].x, _roomStruct.wallData[i].y,  0, obj_moving_wall)
		with (wall_inst)
		{
			image_xscale = _roomStruct.wallData[i].image_xscale;
			dir = _roomStruct.wallData[i].dir;
			rotationSpd = _roomStruct.wallData[i].rotationSpd;
			rad = _roomStruct.wallData[i].rad;
			movement_type = _roomStruct.wallData[i].movement_type;
			center_x = _roomStruct.wallData[i].center_x;
			center_y = _roomStruct.wallData[i].center_y;
		}
	}
	
	//semi solid walls
	if instance_exists(obj_semi_solid_moving_wall) {instance_destroy(obj_semi_solid_moving_wall);};
	
	for (var i = 0; i < _roomStruct.semiWallNumber; i++)
	{
		var semi_wall_inst = instance_create_depth(_roomStruct.semiWallData[i].x, _roomStruct.semiWallData[i].y,  0, obj_semi_solid_moving_wall);
		with (semi_wall_inst)
		{
			image_xscale = _roomStruct.semiWallData[i].image_xscale;
			dir = _roomStruct.semiWallData[i].dir;
			rotationSpd = _roomStruct.semiWallData[i].rotationSpd;
			rad = _roomStruct.semiWallData[i].rad;
			movement_type = _roomStruct.semiWallData[i].movement_type;
			center_x = _roomStruct.semiWallData[i].center_x;
			center_y = _roomStruct.semiWallData[i].center_y;
		}
	}
	
	//enemies
	if instance_exists(obj_enemy) {instance_destroy(obj_enemy);};
	
	for (var i = 0; i < _roomStruct.enemyNumber; i++)
	{
		instance_create_depth(_roomStruct.enemyData[i].x, _roomStruct.enemyData[i].y,  0, _roomStruct.enemyData[i].type);
	}
	
	//projectiles
	if instance_exists(obj_projectile) {instance_destroy(obj_projectile);};
	
	for (var i = 0; i < _roomStruct.projNumber; i++)
	{
		var proj_inst = instance_create_depth(_roomStruct.projData[i].x, _roomStruct.projData[i].y,  0, _roomStruct.projData[i].type);
		with (proj_inst)
		{
			image_angle = _roomStruct.projData[i].image_angle;
			dir = _roomStruct.projData[i].dir;
			xDir = _roomStruct.projData[i].xDir;
			yDir = _roomStruct.projData[i].yDir;
		}
	}
	
	//interacting
	if instance_exists(obj_interact) {instance_destroy(obj_interact);};
	
	for (var i = 0; i < _roomStruct.interactNumber; i++)
	{
		var interact_inst = instance_create_depth(_roomStruct.interactData[i].x, _roomStruct.interactData[i].y,  0, _roomStruct.interactData[i].type);
		with (interact_inst)
		{
			inv = _roomStruct.interactData[i].inv;
		}
	}

	show_debug_message(_roomStruct);
}

function save_game(_fileNum = 0)
{
		save_room();
	
		var _saveArray = array_create(0);
		
		global.statData.save_x = obj_player.x;
		global.statData.save_y = obj_player.y;
		global.statData.save_rm = room_get_name(room);
		
		global.statData.current_health = obj_player.hp;
		global.statData.current_max_health = obj_player.maxHP;
		
		/*global.statData.day = 0; //day night cycle
		global.statData.hour = 0;*/
		
		global.statData.inv = global.inventory;
	
		show_debug_message(global.statData.inv);
		show_debug_message("This is the inventory");
		
		global.statData.coins = global.coins;
		
		array_push(_saveArray, global.statData);
	
		array_push(_saveArray, global.levelData);
	
		var _filename = "savedata" + string(_fileNum) + ".sav";
		var _json = json_stringify(_saveArray);
		var _buffer = buffer_create(string_byte_length(_json) + 1, buffer_fixed, 1);
		buffer_write(_buffer, buffer_string, _json);
	
		buffer_save(_buffer, _filename);
	
		buffer_delete(_buffer);
}

function load_game(_fileNum = 0)
{
	var _filename = "savedata" + string(_fileNum) +".sav";
	
	if !file_exists(_filename) { exit;};
	
	var _buffer = buffer_load(_filename);
	
	var _json = buffer_read(_buffer, buffer_string);
	
	buffer_delete(_buffer);
	
	var _loadArray = json_parse(_json);
		
	global.statData = array_get(_loadArray, 0);
	
	global.levelData = array_get(_loadArray, 1);
	
	global.inventory = global.statData.inv;
	
	show_debug_message(global.inventory);
	show_debug_message("This is the inventory");
	
	global.coins = global.statData.coins;
	
	var _loadRoom = asset_get_index(global.statData.save_rm);
	
	room_goto(_loadRoom);
	
	/*global. = global.statData.day;
	global.hour = global.statData.hour;*/
	
	obj_saveload.skipRoomSave = true;
	
	if instance_exists(obj_player)
	{
		obj_player.x = global.statData. save_x;
		obj_player.y = global.statData.save_y;
		instance_destroy(obj_player);
	}
	with (instance_create_depth(global.statData.save_x, global.statData.save_y, 0, obj_player))
	{
		hp = global.statData.current_health;
		maxHP = global.statData.current_max_health;
	}
	
	if (instance_exists(obj_inventory_manager)) {
	    obj_inventory_manager.hovered_item = -1;
	}
	
	load_room();
}