function scr_pogo()
{
	//create a ds_list
	var _pogo_list = ds_list_create();
	
	var _num = instance_place_list(x, y + 10, all, _pogo_list, false);

	var _pogo_triggered = false;

	//if anything was hit, loop through the list
	if (_num > 0) {
	    for (var i = 0; i < _num; i++) {
	        var _inst = _pogo_list[| i]; //get the instance ID
        
	        //check if that instance's object_index has the "pogo" tag
	        if (asset_has_tags(_inst.object_index, "pogo", asset_object)) && bbox_bottom-20 <= _inst.bbox_top {
	            _pogo_triggered = true;
	            break; //leave the loop 
	        }
	    }
	}

	//destroy the list
	ds_list_destroy(_pogo_list);

	//apply the bounce
	if (_pogo_triggered) {
	    pogoBounce = true;
		//jumpCount++;//add a jump back after pogo-ing
	}
}