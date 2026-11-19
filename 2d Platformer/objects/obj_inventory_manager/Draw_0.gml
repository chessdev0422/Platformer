var _cam = view_camera[0];
var _cam_x = camera_get_view_x(_cam);
var _cam_y = camera_get_view_y(_cam);

if invShowing
{
	scr_get_controls();
	
	var _inv = global.inventory; //the inventory
	
	var _mouse_x = mouse_x; //get the mouse x pos
	var _mouse_y = mouse_y; //the y pos
	
	var _sw = sprite_get_width(spr_inv_background);
	var _sh = sprite_get_height(spr_inv_background);
	
	var _xs = innerWidth/_sw;
	var _ys = innerHeight/_sh;
	
	draw_sprite_ext(spr_inv_background, 0, ((innerStartX) + _cam_x), ((innerStartY) + _cam_y), _xs, _ys, 0, c_white, 1);
	
	var _inv_length = array_length(global.inventory);
	
	var _col = invSlotsWidth;
	
	var _start_x = innerStartX + sep;
	var _start_y = innerStartY + sep;
	
	var _sw = sprite_get_width(slot) * inv_scale;
	var _sh = sprite_get_height(slot) * inv_scale;
	var _sep_x = sep + _sw;
	var _sep_y = sep + _sh;

	var _display_index = 0; //counter for items in the current tab

	for (var i = 0; i < _inv_length; i++) {
		
		if (_inv[i].category != selectedTab) continue;

		var _page_index = _display_index div maxItemsBeforeNextPage;

		if (_page_index == currentPage) {
			var _slot_on_page = _display_index mod maxItemsBeforeNextPage;
			
			var _xx = _start_x + (_slot_on_page mod _col) * (_sep_x);
			var _yy = _start_y + (_slot_on_page div _col) * (_sep_y);

			var _isHover = false; //whether or not we are hovering a slot
			var _iA = invAnims[i];
			
			if point_in_rectangle(_mouse_x, _mouse_y, ((_xx) + _cam_x), ((_yy) + _cam_y), ((_xx + _sw) + _cam_x), ((_yy + _sh) + _cam_y))
			{
				_isHover = true;//we are hovering
			}
			
			if _isHover
			{
				hoveredItem = i;
				
				itemDescDraw = _inv[i].description;
				itemNameDraw = _inv[i].name;
				descBufferTimer = descBufferFrames; //set the timer
				
				_iA = lerp(_iA, 1.02, 0.3);//lerp towards a bigger size
				
				if lmButton || rmButton
				{
					_iA = 0.98;
				}
				
			} else {
				_iA = lerp(_iA, 1, 0.5);//lerp towards 1, meaning no size change
			}
			
			var _sizeMod = _iA;//modify the slot size based on the lerped position
			invAnims[i] = _iA;
			
			draw_sprite_ext(slot, 0, ((_xx + _sw/2) + _cam_x), ((_yy + _sh/2) + _cam_y), inv_scale * _sizeMod, inv_scale * _sizeMod, 0, c_white, 1);
			
			var _item_spr = _inv[i].icon;
			
			var _isw = sprite_get_width(_item_spr)/2;
			var _ish = sprite_get_height(_item_spr)/2;
			
			var _ixx = _xx + _sw/2;
			var _iyy = _yy + _sh/2;
			
			draw_sprite_ext(_item_spr, 0, ((_ixx) + _cam_x), ((_iyy) + _cam_y), inv_scale, inv_scale, 0, c_white, 1);

			var _quantity = _inv[i].amount;	
			
			var _inner_sep = 8 * inv_scale;//the separation of the q-text from the slot border
			var _qxx = _xx + _sw - _inner_sep;//quantity text x
			var _qyy = _yy + _sh - _inner_sep;//and y
			
			if _quantity > 1//only if more than 1
			{
				draw_set_font(small_font);
				draw_set_colour(c_white);
				draw_set_halign(fa_center);//set alignment
				draw_set_valign(fa_middle);
				draw_text(((_qxx) + _cam_x), ((_qyy) + _cam_y), "x" + string(_quantity));//draw q-text
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);//reset
				draw_set_colour(c_white);
			}	
		}

		_display_index++;
	}
	
	if (descBufferTimer > 0) {
		closeTarget = 1;
	} else {
		closeTarget = 0;
	}

		closePercent = lerp(closePercent, closeTarget, closeSpeed);

		if (abs(closePercent - closeTarget) < 0.01) {
		    closePercent = closeTarget;
		}
	
	if (closePercent > 0) {
		
	var view_w = camera_get_view_width(view_camera[0]);
	var view_h = camera_get_view_height(view_camera[0]);
	var gui_scale_x = window_get_width() / view_w;
	var gui_scale_y = window_get_height() / view_h; //IMPORTANT --- we need to get the scale factor between window res and gui res
		
		var _current_height = descBoxHeight * 1.5 * closePercent; //get the current height based on the percentage drawn

		var _current_y = descBoxStartY + (descBoxHeight / 2) - (_current_height / 2); //find the current y
		
		var _scissor = gpu_get_scissor();
		
		gpu_set_scissor(
		(descBoxStartX) * gui_scale_x, 
		(_current_y) * gui_scale_y,
		descBoxWidth * gui_scale_x, 
		_current_height * gui_scale_y); //clip the view
		
			var _dsw = sprite_get_width(descBackground);
			var _dsh = sprite_get_height(descBackground);
			var _wd = descBoxWidth / _dsw;
			var _hd = descBoxHeight / _dsh;
			var _y_scale = _hd * closePercent;
			draw_sprite_ext(descBackground, 0, ((descBoxStartX) + _cam_x), ((descBoxStartY + (descBoxHeight / 2)) + _cam_y), _wd, _y_scale, 0, c_white, 1);
			
			if array_length(_inv) > 0 && hoveredItem >= 0 && hoveredItem < array_length(_inv) && _inv[hoveredItem] != -1
			{
				var _sep_text = 6 * inv_scale;//offset from the starting x and y
				var _desc = _inv[hoveredItem].description;//description text to draw
			
				var _t_height = string_height("T") * 1.35 //height of the font
			
				draw_set_font(small_font);
				draw_text_ext(((descBoxStartX + _sep_text) + _cam_x), ((descBoxStartY + _sep_text) + _cam_y), _desc, _t_height, descBoxWidth - _sep_text * 2);
			}
			
			gpu_set_scissor(_scissor);
			
			var _current_name_height = nameBoxHeight * 1.5 * closePercent; //1.5 to account for the extra half on the bottom 
			var _current_name_y = nameBoxStartY + (nameBoxHeight / 2) - (_current_name_height / 2); 
		
			gpu_set_scissor(
			(nameBoxStartX) * gui_scale_x, 
			(_current_name_y) * gui_scale_y, 
			nameBoxWidth * gui_scale_x, 
			_current_name_height * gui_scale_y); 
		
			var _wn = nameBoxWidth / _dsw;
			var _hn = nameBoxHeight / _dsh;
			var _name_y_scale = _hn * closePercent;
			draw_sprite_ext(descBackground, 0, ((nameBoxStartX) + _cam_x), ((nameBoxStartY + (nameBoxHeight / 2)) + _cam_y), _wn, _name_y_scale, 0, c_white, 1);
			
			if array_length(_inv) > 0 && hoveredItem >= 0 && hoveredItem < array_length(_inv) && _inv[hoveredItem] != -1
			{
				var _name = _inv[hoveredItem].name;
			
				var _offset_x = nameBoxWidth / 2;
				var _offset_y = nameBoxHeight / 2;
			
				draw_set_halign(fa_center);
				draw_set_valign(fa_middle);
			
				draw_text(((nameBoxStartX + _offset_x) + _cam_x), ((nameBoxStartY + _offset_y) + _cam_y), _name);

				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
			}
			
			gpu_set_scissor(_scissor);
	}
		
		var _hsw = sprite_get_width(headerSpr); 
		var _hsh = sprite_get_height(headerSpr);
	
		var _hw = headerWidth/_hsw;
		var _hh = headerHeight/_hsh;
		
		draw_sprite_ext(headerSpr, 0, ((headerStartX) + _cam_x), ((headerStartY) + _cam_y), _hw, _hh, 0, c_white, 1);
		
		var _sep = headerSep;
		
		var _htx = headerStartX + _sep;
		var _hty = headerStartY + headerHeight/2;

		draw_set_font(small_font);
		draw_set_valign(fa_middle);
		draw_text(((_htx) + _cam_x), ((_hty) + _cam_y), inventoryText);
		draw_set_valign(fa_top);
		
		var _lw = headerDivLineWidth;
var _slh = sprite_get_height(lineSpr);
var _slyc = (headerDivLineLength) / _slh; // scale in the y

draw_sprite_ext(lineSpr, 0, headerDivLineX + _cam_x, headerDivLineY + _cam_y, 1, _slyc, 0, c_white, image_alpha);
		
		var _ctx = headerDivLineX + _sep + (16 * inv_scale);
		var _cty = headerStartY + headerHeight/2;
		var _cat = selectedTab; //current category
		
		draw_set_font(small_font);
		draw_set_valign(fa_middle);
		draw_text(((_ctx) + _cam_x), ((_cty) + _cam_y), tabText[_cat]);
		draw_set_valign(fa_top);
		
		var _tab_items_count = 0;
		for (var i = 0; i < array_length(global.inventory); i++) {
		    if (global.inventory[i].category == selectedTab) {
		        _tab_items_count++;
		    }
		}

		currentMaxPage = max(1, ceil(_tab_items_count / maxItemsBeforeNextPage));
		
		var _aA = arrowAnims[0];
		
		var _ax = leftArrowStartX;
		var _ay = leftArrowStartY;
		var _asw = sprite_get_width(leftArrowSpr) * inv_scale;
		var _ash = sprite_get_height(leftArrowSpr) * inv_scale;
		
		if point_in_rectangle(_mouse_x, _mouse_y, ((_ax) + _cam_x), ((_ay) + _cam_y), ((_ax + _asw) + _cam_x), ((_ay + _ash) + _cam_y))
		{
			_aA = lerp(_aA, 1.02, 0.3);//lerp towards a bigger size
				
			if lmButton || rmButton
			{
				_aA = 0.98;
				currentPage--;
				if currentPage < 0
				{
					currentPage = currentMaxPage-1;
				}
			}
		} else {
			_aA = lerp(_aA, 1, 0.5);//lerp towards 1, meaning no size change
		}
		
		var _laSizeMod = _aA;
		
		draw_sprite_ext(leftArrowSpr, 0, ((leftArrowStartX) + _cam_x), ((leftArrowStartY) + _cam_y), inv_scale * _laSizeMod, inv_scale * _laSizeMod, 0, c_white, 1);
		
		arrowAnims[0] = _aA;
		
		var _aA = arrowAnims[1];
		
		var _ax = rightArrowStartX;
		var _ay = rightArrowStartY;
		var _asw = sprite_get_width(rightArrowSpr) * inv_scale;
		var _ash = sprite_get_height(rightArrowSpr) * inv_scale;
		
		if point_in_rectangle(_mouse_x, _mouse_y, ((_ax - _asw) + _cam_x), ((_ay) + _cam_y), ((_ax) + _cam_x), ((_ay + _ash) + _cam_y))
		{
			_aA = lerp(_aA, 1.02, 0.3);//lerp towards a bigger size
				
			if lmButton || rmButton
			{
				_aA = 0.98;
				currentPage++;
				if currentPage >= currentMaxPage
				{
					currentPage = 0;
				}
			}
		} else {
			_aA = lerp(_aA, 1, 0.5);//lerp towards 1, meaning no size change
		}
		
		var _laSizeMod = _aA;
		
		draw_sprite_ext(rightArrowSpr, 0, ((rightArrowStartX) + _cam_x), ((rightArrowStartY) + _cam_y), inv_scale * _laSizeMod, inv_scale * _laSizeMod, 0, c_white, 1);
		
		arrowAnims[1] = _aA;
		
		draw_set_halign(fa_right);
		draw_set_valign(fa_middle);
		
		var _text = string(currentPage+1) + " / " + string(currentMaxPage);
		
		draw_text(((pageNumberTextStartX) + _cam_x), ((pageNumberTextStartY + headerHeight/2) + _cam_y), _text);
		
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);

	var _num_tabs = array_length(tabText);

	var _icon_w = sprite_get_width(spr_category_icons) * inv_scale;
	var _icon_h = sprite_get_height(spr_category_icons) * inv_scale;
	var _tsw = _icon_w + (8 * inv_scale);
	var _tsh = _icon_h + (8 * inv_scale);

	var _bg_spr_w = sprite_get_width(spr_sidebar_bg);
	var _bg_spr_h = sprite_get_height(spr_sidebar_bg);

	var _sidebar_width = sideBarWidth;
	var _bg_xscale = _sidebar_width / _bg_spr_w;
	var _bg_yscale = sideBarTotalHeight / _bg_spr_h;

	draw_sprite_ext(spr_sidebar_bg, 0, ((sideBarStartX) + _cam_x), ((sideBarStartY) + _cam_y), _bg_xscale, _bg_yscale, 0, c_white, 1);

	var _available_height = sideBarTotalHeight - (sideBarPad * 2);

	var _total_tabs_height = _tsh * _num_tabs;
	
	var _remaining_space = _available_height - _total_tabs_height;
	var _sep = (_num_tabs > 1) ? (_remaining_space / (_num_tabs - 1)) : 0;

	for (var i = 0; i < _num_tabs; i++) {
	    var _tx = sideBarStartX;
	    var _ty = sideBarStartY + i * (_tsh + _sep) + sideBarPad;

	    var _isHover = point_in_rectangle(_mouse_x, _mouse_y, ((_tx) + _cam_x), ((_ty) + _cam_y), ((_tx + _tsw) + _cam_x), ((_ty + _tsh) + _cam_y));
	    var _isSelected = (selectedTab == i);

	    if (_isHover && (lmButton || rmButton)) {
	        if (selectedTab != i) {
	            selectedTab = i;
	            currentPage = 0; //reset page when switching categories
	        }
	    }

	    var _draw_x = _tx;
	    if (_isSelected) {
	        _draw_x -= 8 * inv_scale; //active tab pops out further
	    } else if (_isHover) {
	        _draw_x -= 4 * inv_scale; //hover pop-out
	    }

	    var _tab_spr_w = sprite_get_width(spr_tab_bg);
	    var _tab_spr_h = sprite_get_height(spr_tab_bg);
	    var _tab_xscale = _tsw / _tab_spr_w;
	    var _tab_yscale = _tsh / _tab_spr_h;

	    var _tint = _isSelected ? c_white : c_ltgray;
	    draw_sprite_ext(spr_tab_bg, 0, ((_draw_x) + _cam_x), ((_ty) + _cam_y), _tab_xscale, _tab_yscale, 0, c_white, 1);

	    var _icon_x = _draw_x + (_tsw / 2);
	    var _icon_y = _ty + (_tsh / 2);
    
	    draw_sprite_ext(spr_category_icons, i, ((_icon_x) + _cam_x), ((_icon_y) + _cam_y), inv_scale, inv_scale, 0, c_white, 1);
	}
	
	var _xsw = sprite_get_width(closeSpr) * inv_scale;
	var _xsh = sprite_get_height(closeSpr) * inv_scale;
	var _xxx = closeStartX + _xsw/2;
	var _xyy = closeStartY + _xsh/2;
	
	if point_in_rectangle(_mouse_x, _mouse_y, ((_xxx - _xsw/2) + _cam_x), ((_xyy - _xsh/2) + _cam_y), ((_xxx + _xsw/2) + _cam_x), ((_xyy + _xsh/2) + _cam_y))
	{
		closeAnim = lerp(closeAnim, 1.02, 0.3);//lerp towards a bigger size
				
		if lmButton || rmButton
		{
			invShowing = false;
			global.paused = false;
		}				
	} else {
		closeAnim = lerp(closeAnim, 1, 0.5);//lerp towards 1, meaning no size change
	}
	
	draw_sprite_ext(closeSpr, 0, ((_xxx) + _cam_x), ((_xyy) + _cam_y), inv_scale * closeAnim, inv_scale * closeAnim, 0, c_white, 1);
}
var _os = otherShowing;
if _os != noone
{
	scr_get_controls();
	
	var _inv = _os.inv; //the inventory
	
	var _mouse_x = device_mouse_x(0); //get the mouse x pos
	var _mouse_y = device_mouse_y(0); //the y pos
	
	var _extended_inner_width = innerWidth + (32 * inv_scale);
	
	var _sw = sprite_get_width(spr_inv_background);
	var _sh = sprite_get_height(spr_inv_background);
	
	var _xs = _extended_inner_width / _sw;
	var _ys = innerHeight / _sh;
	
	draw_sprite_ext(spr_inv_background, 0, ((innerStartX) + _cam_x), ((innerStartY) + _cam_y), _xs, _ys, 0, c_white, 1);
	
	var _inv_length = array_length(_inv);
	
	var _start_x = innerStartX + sep;
	var _start_y = innerStartY + sep;
	
	var _slot_sw = sprite_get_width(slot) * inv_scale;
	var _slot_sh = sprite_get_height(slot) * inv_scale;
	var _sep_y = sep + _slot_sh;
	
	var _target_slot_width = _extended_inner_width - (sep * 2);
	var _slot_xscale = (_target_slot_width / sprite_get_width(slot));
	var _slot_yscale = inv_scale;

	var _display_index = 0; //counter for items in the current page

	for (var i = 0; i < _inv_length; i++) {
		if (_inv[i] == -1) continue;
		
		var _c = c_white;
		if _inv[i].amount == 0 {_c = c_grey;}

		var _page_index = _display_index div _os.invSlotsHeight;

		if (_page_index == _os.currentPage) {
			var _slot_on_page = _display_index mod _os.invSlotsHeight;
			
			var _xx = _start_x;
			var _yy = _start_y + _slot_on_page * (_sep_y);

			var _isHover = false; //whether or not we are hovering a slot
			var _iA = _os.invAnims[i];
			
			if point_in_rectangle(_mouse_x, _mouse_y, ((_xx) + _cam_x), ((_yy) + _cam_y), ((_xx + _target_slot_width) + _cam_x), ((_yy + _slot_sh) + _cam_y))
			{
				_isHover = true;//we are hovering
			}
			
			if _isHover && _inv[i].amount != 0
			{
				hoveredItem = i;
				
				itemDescDraw = _inv[i].description;
				itemNameDraw = _inv[i].name;
				descBufferTimer = descBufferFrames; //set the timer
				
				_iA = lerp(_iA, 1.02, 0.3);//lerp towards a bigger size
				
				if lmButton || rmButton
				{
					_iA = 0.98;
					var _item = _inv[i];
					if buyMultipleKey 
					{
						var _amountToBuy = min(_inv[i].amount, 5);
        
				        global.coins -= _inv[i].cost * _amountToBuy;
				        inventory_remove_other(i, _inv, _amountToBuy);
				        inventory_add(_item, _amountToBuy);
					} else {
						inventory_remove_other(i, _inv);
						inventory_add(_item);
						global.coins -= _inv[i].cost;
					}
				}
				
			} else {
				_iA = lerp(_iA, 1, 0.5);//lerp towards 1, meaning no size change
			}
			
			var _sizeMod = _iA;//modify the slot size based on the lerped position
			_os.invAnims[i] = _iA;
			
			var _slot_cx = _xx + _target_slot_width / 2;
			var _slot_cy = _yy + _slot_sh / 2;
			
			draw_sprite_ext(slot, 0, ((_slot_cx) + _cam_x), ((_slot_cy) + _cam_y), _slot_xscale * _sizeMod, _slot_yscale * _sizeMod, 0, _c, 1);
			
			var _item_spr = _inv[i].icon;
			
			var _ixx = _start_x + (sep * 2);
			var _iyy = _yy + _slot_sh / 2;
			
			draw_sprite_ext(_item_spr, 0, ((_ixx) + _cam_x), ((_iyy) + _cam_y), inv_scale, inv_scale, 0, _c, 1);
			
			var _cost = _inv[i].cost;
			
			var _cxx = _ixx + (_sw * inv_scale) + (10 * inv_scale);
			var _cyy = _iyy;
			draw_set_valign(fa_middle);
			var _cost_text = string(_cost) + "g";
			draw_text(((_cxx) + _cam_x), ((_cyy) + _cam_y), _cost_text);

			var _item = _inv[i];
			var _amt = get_item_amount(_item, global.inventory);
			
			var _string_w = string_width(_cost_text);
			
			var _amt_text = "Inventory: x" + string(_amt);
			
			draw_text(((_xx + innerWidth - (32 * inv_scale) - string_width(_amt_text)) + _cam_x), ((_cyy) + _cam_y), _amt_text);
			
			draw_set_valign(fa_top);
			
			var _quantity = _inv[i].amount;	
			
			var _inner_sep = 8 * inv_scale;//the separation of the q-text from the slot border
			var _qxx = _xx + _target_slot_width - _inner_sep - (4 * inv_scale);//quantity text x
			var _qyy = _yy + _slot_sh - _inner_sep - (4 * inv_scale);//and y
			
			if _quantity > 1//only if more than 1
			{
				draw_set_font(small_font);
				draw_set_colour(c_white);
				draw_set_halign(fa_center);//set alignment
				draw_set_valign(fa_middle);
				draw_text(((_qxx) + _cam_x), ((_qyy) + _cam_y), "x" + string(_quantity));//draw q-text
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);//reset
				draw_set_colour(c_white);
			}	
		}

		_display_index++;
	}
	
	var _hsw = sprite_get_width(headerSpr); 
	var _hsh = sprite_get_height(headerSpr);

	var _hw = headerWidth / _hsw;
	var _hh = headerHeight / _hsh;
	
	draw_sprite_ext(headerSpr, 0, ((headerStartX) + _cam_x), ((headerStartY) + _cam_y), _hw, _hh, 0, c_white, 1);
	
	var _hdr_sep = headerSep;
	
	var _htx = headerStartX + _hdr_sep;
	var _hty = headerStartY + headerHeight / 2;

	draw_set_font(small_font);
	draw_set_valign(fa_middle);
	draw_text(((_htx) + _cam_x), ((_hty) + _cam_y), shopText);
	draw_set_valign(fa_top);
	
	if (descBufferTimer > 0) {
		closeTarget = 1;
	} else {
		closeTarget = 0;
	}

	closePercent = lerp(closePercent, closeTarget, closeSpeed);

	if (abs(closePercent - closeTarget) < 0.01) {
	    closePercent = closeTarget;
	}
	
	if (closePercent > 0) {
		
	var view_w = camera_get_view_width(view_camera[0]);
	var view_h = camera_get_view_height(view_camera[0]);
	var gui_scale_x = window_get_width() / view_w;
	var gui_scale_y = window_get_height() / view_h; //IMPORTANT --- we need to get the scale factor between window res and gui res
		
		var _current_height = descBoxHeight * 1.5 * closePercent; //get the current height based on the percentage drawn

		var _current_y = descBoxStartY + (descBoxHeight / 2) - (_current_height / 2); //find the current y
		
		var _scissor = gpu_get_scissor();
		
		gpu_set_scissor(
		(descBoxStartX) * gui_scale_x, 
		(_current_y) * gui_scale_y,
		descBoxWidth * gui_scale_x, 
		_current_height * gui_scale_y); //clip the view
		
			var _dsw = sprite_get_width(descBackground);
			var _dsh = sprite_get_height(descBackground);
			var _wd = descBoxWidth / _dsw;
			var _hd = descBoxHeight / _dsh;
			var _y_scale = _hd * closePercent;
			draw_sprite_ext(descBackground, 0, ((descBoxStartX) + _cam_x), ((descBoxStartY + (descBoxHeight / 2)) + _cam_y), _wd, _y_scale, 0, c_white, 1);
			
			if array_length(_inv) > 0 && hoveredItem >= 0 && hoveredItem < array_length(_inv) && _inv[hoveredItem] != -1
			{
				var _sep_text = 6 * inv_scale;//offset from the starting x and y
				var _desc = _inv[hoveredItem].description;//description text to draw
			
				var _t_height = string_height("T") * 1.35 //height of the font
			
				draw_set_font(small_font);
				draw_text_ext(((descBoxStartX + _sep_text) + _cam_x), ((descBoxStartY + _sep_text) + _cam_y), _desc, _t_height, descBoxWidth - _sep_text * 2);
			}
			
			gpu_set_scissor(_scissor);
			
			var _current_name_height = nameBoxHeight * 1.5 * closePercent; 
			var _current_name_y = nameBoxStartY + (nameBoxHeight / 2) - (_current_name_height / 2); 
		
			gpu_set_scissor(
			(nameBoxStartX) * gui_scale_x, 
			(_current_name_y) * gui_scale_y, 
			nameBoxWidth * gui_scale_x, 
			_current_name_height * gui_scale_y); 
		
			var _wn = nameBoxWidth / _dsw;
			var _hn = nameBoxHeight / _dsh;
			var _name_y_scale = _hn * closePercent;
			draw_sprite_ext(descBackground, 0, ((nameBoxStartX) + _cam_x), ((nameBoxStartY + (nameBoxHeight / 2)) + _cam_y), _wn, _name_y_scale, 0, c_white, 1);
			
			if array_length(_inv) > 0 && hoveredItem >= 0 && hoveredItem < array_length(_inv) && _inv[hoveredItem] != -1
			{
				var _name = _inv[hoveredItem].name;
			
				var _offset_x = nameBoxWidth / 2;
				var _offset_y = nameBoxHeight / 2;
			
				draw_set_halign(fa_center);
				draw_set_valign(fa_middle);
			
				draw_text(((nameBoxStartX + _offset_x) + _cam_x), ((nameBoxStartY + _offset_y) + _cam_y), _name);

				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
			}
			
			gpu_set_scissor(_scissor);
	}
	
	var _total_items_count = array_length(_inv);
	_os.currentMaxPage = max(1, ceil(_total_items_count / _os.invSlotsHeight));
	
	var _aA = arrowAnims[0];
	
	var _ax = leftArrowStartX;
	var _ay = leftArrowStartY;
	var _asw = sprite_get_width(leftArrowSpr) * inv_scale;
	var _ash = sprite_get_height(leftArrowSpr) * inv_scale;
	
	if point_in_rectangle(_mouse_x, _mouse_y, ((_ax) + _cam_x), ((_ay) + _cam_y), ((_ax + _asw) + _cam_x), ((_ay + _ash) + _cam_y))
	{
		_aA = lerp(_aA, 1.02, 0.3);//lerp towards a bigger size
			
		if lmButton || rmButton
		{
			_aA = 0.98;
			_os.currentPage--;
			if _os.currentPage < 0
			{
				_os.currentPage = _os.currentMaxPage - 1;
			}
		}
	} else {
		_aA = lerp(_aA, 1, 0.5);//lerp towards 1, meaning no size change
	}
	
	draw_sprite_ext(leftArrowSpr, 0, ((leftArrowStartX) + _cam_x), ((leftArrowStartY) + _cam_y), inv_scale * _aA, inv_scale * _aA, 0, c_white, 1);
	
	arrowAnims[0] = _aA;
	
	_aA = arrowAnims[1];
	
	var _ax = rightArrowStartX;
	var _ay = rightArrowStartY;
	var _asw = sprite_get_width(rightArrowSpr) * inv_scale;
	var _ash = sprite_get_height(rightArrowSpr) * inv_scale;
	
	if point_in_rectangle(_mouse_x, _mouse_y, ((_ax - _asw) + _cam_x), ((_ay) + _cam_y), ((_ax) + _cam_x), ((_ay + _ash) + _cam_y))
	{
		_aA = lerp(_aA, 1.02, 0.3);//lerp towards a bigger size
			
		if lmButton || rmButton
		{
			_aA = 0.98;
			_os.currentPage++;
			if _os.currentPage >= _os.currentMaxPage
			{
				_os.currentPage = 0;
			}
		}
	} else {
		_aA = lerp(_aA, 1, 0.5);//lerp towards 1, meaning no size change
	}
	
	draw_sprite_ext(rightArrowSpr, 0, ((rightArrowStartX) + _cam_x), ((rightArrowStartY) + _cam_y), inv_scale * _aA, inv_scale * _aA, 0, c_white, 1);
	
	arrowAnims[1] = _aA;
	
	draw_set_halign(fa_right);
	draw_set_valign(fa_middle);
	
	var _text = string(_os.currentPage + 1) + " / " + string(_os.currentMaxPage);
	
	draw_text(((pageNumberTextStartX) + _cam_x), ((pageNumberTextStartY + headerHeight/2) + _cam_y), _text);
	
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	
	var _xsw = sprite_get_width(closeSpr) * inv_scale;
	var _xsh = sprite_get_height(closeSpr) * inv_scale;
	var _xxx = closeStartX + _xsw/2;
	var _xyy = closeStartY + _xsh/2;
	
	if point_in_rectangle(_mouse_x, _mouse_y, ((_xxx - _xsw/2) + _cam_x), ((_xyy - _xsh/2) + _cam_y), ((_xxx + _xsw/2) + _cam_x), ((_xyy + _xsh/2) + _cam_y))
	{
		closeAnim = lerp(closeAnim, 1.02, 0.3);//lerp towards a bigger size
				
		if lmButton || rmButton
		{
			otherShowing = noone;
			global.paused = !global.paused;
			obj_player.interactInst = noone;
		}				
	} else {
		closeAnim = lerp(closeAnim, 1, 0.5);//lerp towards 1, meaning no size change
	}
	
	draw_sprite_ext(closeSpr, 0, ((_xxx) + _cam_x), ((_xyy) + _cam_y), inv_scale * closeAnim, inv_scale * closeAnim, 0, c_white, 1);
}