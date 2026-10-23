if invShowing
{
	scr_get_controls();
	
	var _inv = global.inventory; //the inventory
	
	var _mouse_x = device_mouse_x_to_gui(0); //get the mouse x pos
	var _mouse_y = device_mouse_y_to_gui(0); //the y pos
	
	
	
	//draw the background first lol
	//get the x and y scales
	var _sw = sprite_get_width(spr_inv_background);
	var _sh = sprite_get_height(spr_inv_background);
	
	var _xs = innerWidth/_sw;
	var _ys = innerHeight/_sh;
	
	//draw the inner background
	draw_sprite_ext(spr_inv_background, 0, innerStartX, innerStartY, _xs, _ys, 0, c_white, 1);
	
	
	//get the length of the inventory array
	var _inv_length = array_length(global.inventory);
	
	//get useful variables
	var _col = invSlotsWidth;
	
	//starting x and y coordinates
	var _start_x = innerStartX + sep;
	var _start_y = innerStartY + sep;
	
	
	var _sw = sprite_get_width(slot);
	var _sh = sprite_get_height(slot);
	var _sep_x = sep + _sw;
	var _sep_y = sep + _sh;
	
	//drawing slots---------------/

	var _display_index = 0; //counter for items in the current tab

	//loop through the inventory
	for (var i = 0; i < _inv_length; i++) {
		
		//filter by selected tab
		if (_inv[i].category != selectedTab) continue;

		var _page_index = _display_index div maxItemsBeforeNextPage;

		if (_page_index == currentPage) {
			var _slot_on_page = _display_index mod maxItemsBeforeNextPage;
			
			//get the x and y position relative to the current page
			var _xx = _start_x + (_slot_on_page mod _col) * (_sep_x);
			var _yy = _start_y + (_slot_on_page div _col) * (_sep_y);

			var _isHover = false; //whether or not we are hovering a slot
			var _iA = invAnims[i];
			
			//check if we are hovering
			if point_in_rectangle(_mouse_x, _mouse_y, _xx, _yy, _xx + _sw, _yy + _sh)
			{
				_isHover = true;//we are hovering
			}
			
			if _isHover
			{
				hoveredItem = i;
				
				//set the item name and desc to be known
				itemDescDraw = _inv[i].description;
				itemNameDraw = _inv[i].name;
				descBufferTimer = descBufferFrames; //set the timer
				
				_iA = lerp(_iA, 1.1, 0.3);//lerp towards a bigger size
				
				if lmButton || rmButton
				{
					_iA = 0.9;
				}
				
			} else {
				_iA = lerp(_iA, 1, 0.5);//lerp towards 1, meaning no size change
			}
			
			var _sizeMod = _iA;//modify the slot size based on the lerped position
			invAnims[i] = _iA;
			
			//draw the slots
			draw_sprite_ext(slot, 0, _xx + _sw/2, _yy + _sh/2, 1 * _sizeMod, 1 * _sizeMod, 0, c_white, 1);
			
			//draw the items inside the slots
			
			//get the item sprite to draw
			var _item_spr = _inv[i].icon;
			
			//get the sprite width and height of the item sprite, div 2
			var _isw = sprite_get_width(_item_spr)/2;
			var _ish = sprite_get_height(_item_spr)/2;
			
			//get the item icon xx and yy
			var _ixx = _xx + _sw/2;
			var _iyy = _yy + _sh/2;
			
			draw_sprite_ext(_item_spr, 0, _ixx, _iyy, 1 * _sizeMod, 1 * _sizeMod, 0, c_white, 1);
			
			//draw the item quantity
			var _quantity = _inv[i].amount;	
			
			var _inner_sep = 8;//the separation of the q-text from the slot border
			var _qxx = _xx + _sw - _inner_sep;//quantity text x
			var _qyy = _yy + _sh - _inner_sep;//and y
			
			if _quantity > 1//only if more than 1
			{
				draw_set_font(normal_font);
				draw_set_colour(c_red);
				draw_set_halign(fa_center);//set alignment
				draw_set_valign(fa_middle);
				draw_text(_qxx, _qyy, "x" + string(_quantity));//draw q-text
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);//reset
				draw_set_colour(c_white);
			}	
		}

		_display_index++;
	}
	
	//set the target based on the buffer
	if (descBufferTimer > 0) {
		closeTarget = 1;
	} else {
		closeTarget = 0;
	}

		//lerp the percentage based on the speed
		closePercent = lerp(closePercent, closeTarget, closeSpeed);

		if (abs(closePercent - closeTarget) < 0.01) {
		    closePercent = closeTarget;
		}
		
		if (closePercent > 0) {
			
			var _gui_w = display_get_gui_width(); ///get gui to window resolutions
			var _gui_h = display_get_gui_height();
			var _win_w = window_get_width();
			var _win_h = window_get_height();

			var _scale_x = _win_w / _gui_w;
			var _scale_y = _win_h / _gui_h;
			
			var _current_height = descBoxHeight * closePercent; //get the current height based on the percentage drawn

			var _current_y = descBoxStartY + (descBoxHeight / 2) - (_current_height / 2); //find the current y (top left, not centered)
			
			var _scissor = gpu_get_scissor();
			
			//set the scissor
			gpu_set_scissor(descBoxStartX * _scale_x, _current_y * _scale_y, descBoxWidth * _scale_x, _current_height * _scale_y); //clip the view 
			//just on the y-axis
			
			//draw the description/name box

			//desc
				//background sprite
				var _dsw = sprite_get_width(descBackground);
				var _dsh = sprite_get_height(descBackground);
				var _wd = descBoxWidth/_dsw;
				var _hd = descBoxHeight/_dsh;
				var _y_scale = _hd * closePercent;
				draw_sprite_ext(descBackground, 0, descBoxStartX, descBoxStartY + (descBoxHeight / 2), _wd, _y_scale, 0, c_white, 1);
				
				//text
				if array_length(_inv) > 0
				{
					var _sep = 6;//offset from the starting x and y
					var _desc = _inv[hoveredItem].description;//description text to draw
				
					var _t_height = string_height("T")*1.35 //height of the font 
					var _t_sep = _t_height + 6;//distance in pixels between lines of text
				
					draw_set_font(normal_font);
					draw_text_ext(descBoxStartX + _sep, descBoxStartY + _sep, _desc, _t_height, descBoxWidth - _sep*2);
				}
				
				//reset the scissor
				gpu_set_scissor(_scissor);
				
			//name
			
				var _gui_w = display_get_gui_width(); ///get gui to window resolutions
				var _gui_h = display_get_gui_height();
				var _win_w = window_get_width();
				var _win_h = window_get_height();

				var _scale_x = _win_w / _gui_w;
				var _scale_y = _win_h / _gui_h;
			
				var _current_height = nameBoxHeight * closePercent; //get the current height based on the percentage drawn

				var _current_y = nameBoxStartY + (nameBoxHeight / 2) - (_current_height / 2); //find the current y (top left, not centered)
			
				//set the scissor
				gpu_set_scissor(nameBoxStartX * _scale_x, _current_y * _scale_y, nameBoxWidth * _scale_x, _current_height * _scale_y); //clip the view 
				//just on the y-axis
			
			
				//background sprite
				var _wn = nameBoxWidth/_dsw;
				var _hn	= nameBoxHeight/_dsh;
				var _y_scale = _hn * closePercent;
				draw_sprite_ext(descBackground, 0, nameBoxStartX, nameBoxStartY + (nameBoxHeight / 2), _wn, _y_scale, 0, c_white, 1);
				
				//text
				if array_length(_inv) > 0
				{
					var _name = _inv[hoveredItem].name;
				
					var _offset_x = nameBoxWidth/2;
					var _offset_y = nameBoxHeight/2;
				
					draw_set_halign(fa_center);
					draw_set_valign(fa_middle);
				
					draw_text(nameBoxStartX + _offset_x, nameBoxStartY + _offset_y + 2, _name);

				
					//reset
					draw_set_halign(fa_left);
					draw_set_valign(fa_top);
				}
				
				gpu_set_scissor(_scissor);
				
		}
		
		
		//draw the inventory "header"
		
		var _hsw = sprite_get_width(headerSpr); 
		var _hsh = sprite_get_height(headerSpr);
	
		var _hw = headerWidth/_hsw;
		var _hh = headerHeight/_hsh;
		
		//draw the header background sprite
		draw_sprite_ext(headerSpr, 0, headerStartX, headerStartY, _hw, _hh, 0, c_white, 1);
		
		
		var _sep = headerSep;
		
		//draw the text
		var _htx = headerStartX + _sep;
		var _hty = headerStartY + headerHeight/2;
		

		draw_set_font(normal_font);
		draw_set_valign(fa_middle);
		draw_text(_htx, _hty, inventoryText);
		draw_set_valign(fa_top);
		
		//draw the dividing line
		var _c = headerDivLineCol;
		var _lw = headerDivLineWidth;
		
		
		draw_line_width_colour(headerDivLineX, headerDivLineY + _sep, headerDivLineX, headerDivLineY + headerDivLineLength - _sep, _lw, _c, _c);
		
		//draw the text
		var _ctx = headerDivLineX + _sep + 16;
		var _cty = headerStartY + headerHeight/2;
		var _cat = selectedTab; //current category
		
		draw_set_font(normal_font);
		draw_set_valign(fa_middle);
		draw_text(_ctx, _cty, tabText[_cat]);
		draw_set_valign(fa_top);
		
		
		
		//get the currentMaxPage count based on what page is selected
		
		var _tab_items_count = 0;
		for (var i = 0; i < array_length(global.inventory); i++) {
		    if (global.inventory[i].category == selectedTab) {
		        _tab_items_count++;
		    }
		}

		currentMaxPage = max(1, ceil(_tab_items_count / maxItemsBeforeNextPage));
		
		//draw the page arrows
		
		var _aA = arrowAnims[0];
		
		var _ax = leftArrowStartX;
		var _ay = leftArrowStartY;
		var _asw = sprite_get_width(leftArrowSpr);
		var _ash = sprite_get_height(leftArrowSpr);
		
		if point_in_rectangle(_mouse_x, _mouse_y, _ax, _ay, _ax + _asw, _ay + _ash)
		{
			_aA = lerp(_aA, 1.1, 0.3);//lerp towards a bigger size
				
			if lmButton || rmButton
			{
				_aA = 0.9;
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
		
		draw_sprite_ext(leftArrowSpr, 0, leftArrowStartX, leftArrowStartY, 1 * _laSizeMod, 1 * _laSizeMod, 0, c_white, 1);
		
		arrowAnims[0] = _aA;
		
		var _aA = arrowAnims[1];
		
		var _ax = rightArrowStartX;
		var _ay = rightArrowStartY;
		var _asw = sprite_get_width(rightArrowSpr);
		var _ash = sprite_get_height(rightArrowSpr);
		
		if point_in_rectangle(_mouse_x, _mouse_y, _ax - _asw, _ay, _ax, _ay + _ash)
		{
			_aA = lerp(_aA, 1.1, 0.3);//lerp towards a bigger size
				
			if lmButton || rmButton
			{
				_aA = 0.9;
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
		
		draw_sprite_ext(rightArrowSpr, 0, rightArrowStartX, rightArrowStartY, 1 * _laSizeMod, 1 * _laSizeMod, 0, c_white, 1);
		
		arrowAnims[1] = _aA;
		
		//and current page / max page text
		
		draw_set_halign(fa_right);
		draw_set_valign(fa_middle);
		
		//text
		var _text = string(currentPage+1) + " / " + string(currentMaxPage);
		
		draw_text(pageNumberTextStartX, pageNumberTextStartY + headerHeight/2, _text);
		//reset
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);
		

	//tabs
	var _num_tabs = array_length(tabText);

	var _icon_w = sprite_get_width(spr_category_icons);
	var _icon_h = sprite_get_height(spr_category_icons);
	var _tsw = _icon_w + 8;
	var _tsh = _icon_h + 8;

	var _bg_spr_w = sprite_get_width(spr_sidebar_bg);
	var _bg_spr_h = sprite_get_height(spr_sidebar_bg);

	var _sidebar_width = sideBarWidth;
	var _bg_xscale = _sidebar_width / _bg_spr_w;
	var _bg_yscale = sideBarTotalHeight / _bg_spr_h;

	draw_sprite_ext(spr_sidebar_bg, 0, sideBarStartX, sideBarStartY, _bg_xscale, _bg_yscale, 0, c_white, 1);

	//find the separation between each tab
	var _available_height = sideBarTotalHeight - (sideBarPad * 2);

	var _total_tabs_height = _tsh * _num_tabs;
	
	var _remaining_space = _available_height - _total_tabs_height;
	var _sep = (_num_tabs > 1) ? (_remaining_space / (_num_tabs - 1)) : 0;

	for (var i = 0; i < _num_tabs; i++) {
	    var _tx = sideBarStartX;
	    var _ty = sideBarStartY + i * (_tsh + _sep) + sideBarPad;

	    var _isHover = point_in_rectangle(_mouse_x, _mouse_y, _tx, _ty, _tx + _tsw, _ty + _tsh);
	    var _isSelected = (selectedTab == i);

	    //handle tab clicking
	    if (_isHover && (lmButton || rmButton)) {
	        if (selectedTab != i) {
	            selectedTab = i;
	            currentPage = 0; //reset page when switching categories
	        }
	    }

	    var _draw_x = _tx;
	    if (_isSelected) {
	        _draw_x -= 8; //active tab pops out further
	    } else if (_isHover) {
	        _draw_x -= 4; //hover pop-out
	    }

	    var _tab_spr_w = sprite_get_width(spr_tab_bg);
	    var _tab_spr_h = sprite_get_height(spr_tab_bg);
	    var _tab_xscale = _tsw / _tab_spr_w;
	    var _tab_yscale = _tsh / _tab_spr_h;

	    //the icon
	    var _tint = _isSelected ? c_white : c_ltgray;
	    draw_sprite_ext(spr_tab_bg, 0, _draw_x, _ty, _tab_xscale, _tab_yscale, 0, c_white, 1);

	    var _icon_x = _draw_x + (_tsw / 2);
	    var _icon_y = _ty + (_tsh / 2);
    
	    draw_sprite_ext(spr_category_icons, i, _icon_x, _icon_y, 1, 1, 0, c_white, 1);
	}
}
var _os = otherShowing;
if _os != noone
{
	scr_get_controls();
	
	var _inv = _os.inv; //the inventory
	
	var _mouse_x = device_mouse_x_to_gui(0); //get the mouse x pos
	var _mouse_y = device_mouse_y_to_gui(0); //the y pos
	
	//draw the background first lol
	//get the x and y scales
	var _extended_inner_width = innerWidth + 32;
	
	var _sw = sprite_get_width(spr_inv_background);
	var _sh = sprite_get_height(spr_inv_background);
	
	var _xs = _extended_inner_width / _sw;
	var _ys = innerHeight / _sh;
	
	//draw the inner background
	draw_sprite_ext(spr_inv_background, 0, innerStartX, innerStartY, _xs, _ys, 0, c_white, 1);
	
	//get the length of the inventory array
	var _inv_length = array_length(_inv);
	
	//starting x and y coordinates
	var _start_x = innerStartX + sep;
	var _start_y = innerStartY + sep;
	
	var _slot_sw = sprite_get_width(slot);
	var _slot_sh = sprite_get_height(slot);
	var _sep_y = sep + _slot_sh;
	
	var _target_slot_width = _extended_inner_width - (sep * 2);
	var _slot_xscale = _target_slot_width / _slot_sw;
	var _slot_yscale = 1;
	
	//drawing slots vertical style---------------/

	var _display_index = 0; //counter for items in the current page

	//loop through the inventory
	for (var i = 0; i < _inv_length; i++) {
		
		//skip empty slots
		if (_inv[i] == -1) continue;

		var _page_index = _display_index div _os.invSlotsHeight;

		if (_page_index == _os.currentPage) {
			var _slot_on_page = _display_index mod _os.invSlotsHeight;
			
			//get the x and y position relative to the current page
			var _xx = _start_x;
			var _yy = _start_y + _slot_on_page * (_sep_y);

			var _isHover = false; //whether or not we are hovering a slot
			var _iA = _os.invAnims[i];
			
			//check if we are hovering
			if point_in_rectangle(_mouse_x, _mouse_y, _xx, _yy, _xx + _target_slot_width, _yy + _slot_sh)
			{
				_isHover = true;//we are hovering
			}
			
			if _isHover
			{
				hoveredItem = i;
				
				//set the item name and desc to be known
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
			_os.invAnims[i] = _iA;
			
			//middle-centered position for the slot background
			var _slot_cx = _xx + _target_slot_width / 2;
			var _slot_cy = _yy + _slot_sh / 2;
			
			//draw the slots
			draw_sprite_ext(slot, 0, _slot_cx, _slot_cy, _slot_xscale * _sizeMod, _slot_yscale * _sizeMod, 0, c_white, 1);
			
			//draw the items inside the slots
			
			//get the item sprite to draw
			var _item_spr = _inv[i].icon;
			
			//get the item icon xx and yy shifted to start_x plus sep
			var _ixx = _start_x + sep*2;
			var _iyy = _yy + _slot_sh / 2;
			
			draw_sprite_ext(_item_spr, 0, _ixx, _iyy, 1 * _sizeMod, 1 * _sizeMod, 0, c_white, 1);
			
			//draw the item quantity
			var _quantity = _inv[i].amount;	
			
			var _inner_sep = 8;//the separation of the q-text from the slot border
			var _qxx = _xx + _target_slot_width - _inner_sep;//quantity text x
			var _qyy = _yy + _slot_sh - _inner_sep;//and y
			
			if _quantity > 1//only if more than 1
			{
				draw_set_font(normal_font);
				draw_set_colour(c_red);
				draw_set_halign(fa_center);//set alignment
				draw_set_valign(fa_middle);
				draw_text(_qxx, _qyy, "x" + string(_quantity));//draw q-text
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);//reset
				draw_set_colour(c_white);
			}	
		}

		_display_index++;
	}
	
	//draw the inventory header
	
	var _hsw = sprite_get_width(headerSpr); 
	var _hsh = sprite_get_height(headerSpr);

	var _hw = headerWidth / _hsw;
	var _hh = headerHeight / _hsh;
	
	//draw the header background sprite
	draw_sprite_ext(headerSpr, 0, headerStartX, headerStartY, _hw, _hh, 0, c_white, 1);
	
	var _hdr_sep = headerSep;
	
	//draw the text
	var _htx = headerStartX + _hdr_sep;
	var _hty = headerStartY + headerHeight / 2;

	draw_set_font(normal_font);
	draw_set_valign(fa_middle);
	draw_text(_htx, _hty, shopText);
	draw_set_valign(fa_top);
	
	//draw the dividing line
	var _c = headerDivLineCol;
	var _lw = headerDivLineWidth;
	
	draw_line_width_colour(headerDivLineX, headerDivLineY + _hdr_sep, headerDivLineX, headerDivLineY + headerDivLineLength - _hdr_sep, _lw, _c, _c);
	
	//set the target based on the buffer
	if (descBufferTimer > 0) {
		closeTarget = 1;
	} else {
		closeTarget = 0;
	}

	//lerp the percentage based on the speed
	closePercent = lerp(closePercent, closeTarget, closeSpeed);

	if (abs(closePercent - closeTarget) < 0.01) {
	    closePercent = closeTarget;
	}
	
	if (closePercent > 0) {
		var _gui_w = display_get_gui_width(); ///get gui to window resolutions
		var _gui_h = display_get_gui_height();
		var _win_w = window_get_width();
		var _win_h = window_get_height();

		var _scale_x = _win_w / _gui_w;
		var _scale_y = _win_h / _gui_h;
		
		var _current_height = descBoxHeight * closePercent; //get the current height based on the percentage drawn

		var _current_y = descBoxStartY + (descBoxHeight / 2) - (_current_height / 2); //find the current y
		
		var _scissor = gpu_get_scissor();
		
		//set the scissor
		gpu_set_scissor(descBoxStartX * _scale_x, _current_y * _scale_y, descBoxWidth * _scale_x, _current_height * _scale_y); //clip the view
		
		//draw the description/name box
		//desc
			//background sprite
			var _dsw = sprite_get_width(descBackground);
			var _dsh = sprite_get_height(descBackground);
			var _wd = descBoxWidth / _dsw;
			var _hd = descBoxHeight / _dsh;
			var _y_scale = _hd * closePercent;
			draw_sprite_ext(descBackground, 0, descBoxStartX, descBoxStartY + (descBoxHeight / 2), _wd, _y_scale, 0, c_white, 1);
			
			//text
			if array_length(_inv) > 0 && hoveredItem >= 0 && hoveredItem < array_length(_inv) && _inv[hoveredItem] != -1
			{
				var _sep_text = 6;//offset from the starting x and y
				var _desc = _inv[hoveredItem].description;//description text to draw
			
				var _t_height = string_height("T") * 1.35 //height of the font
			
				draw_set_font(normal_font);
				draw_text_ext(descBoxStartX + _sep_text, descBoxStartY + _sep_text, _desc, _t_height, descBoxWidth - _sep_text * 2);
			}
			
			//reset the scissor
			gpu_set_scissor(_scissor);
			
		//name
			var _current_name_height = nameBoxHeight * closePercent; 
			var _current_name_y = nameBoxStartY + (nameBoxHeight / 2) - (_current_name_height / 2); 
		
			//set the scissor
			gpu_set_scissor(nameBoxStartX * _scale_x, _current_name_y * _scale_y, nameBoxWidth * _scale_x, _current_name_height * _scale_y); 
		
			//background sprite
			var _wn = nameBoxWidth / _dsw;
			var _hn = nameBoxHeight / _dsh;
			var _name_y_scale = _hn * closePercent;
			draw_sprite_ext(descBackground, 0, nameBoxStartX, nameBoxStartY + (nameBoxHeight / 2), _wn, _name_y_scale, 0, c_white, 1);
			
			//text
			if array_length(_inv) > 0 && hoveredItem >= 0 && hoveredItem < array_length(_inv) && _inv[hoveredItem] != -1
			{
				var _name = _inv[hoveredItem].name;
			
				var _offset_x = nameBoxWidth / 2;
				var _offset_y = nameBoxHeight / 2;
			
				draw_set_halign(fa_center);
				draw_set_valign(fa_middle);
			
				draw_text(nameBoxStartX + _offset_x, nameBoxStartY + _offset_y + 2, _name);

				//reset
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
			}
			
			gpu_set_scissor(_scissor);
	}
	
	//get the currentMaxPage count based on what page is selected
	var _total_items_count = array_length(_inv);
	_os.currentMaxPage = max(1, ceil(_total_items_count / _os.invSlotsHeight));
	
	//draw the page arrows
	
	var _aA = arrowAnims[0];
	
	var _ax = leftArrowStartX;
	var _ay = leftArrowStartY;
	var _asw = sprite_get_width(leftArrowSpr);
	var _ash = sprite_get_height(leftArrowSpr);
	
	if point_in_rectangle(_mouse_x, _mouse_y, _ax, _ay, _ax + _asw, _ay + _ash)
	{
		_aA = lerp(_aA, 1.1, 0.3);//lerp towards a bigger size
			
		if lmButton || rmButton
		{
			_aA = 0.9;
			_os.currentPage--;
			if _os.currentPage < 0
			{
				_os.currentPage = _os.currentMaxPage - 1;
			}
		}
	} else {
		_aA = lerp(_aA, 1, 0.5);//lerp towards 1, meaning no size change
	}
	
	draw_sprite_ext(leftArrowSpr, 0, leftArrowStartX, leftArrowStartY, 1 * _aA, 1 * _aA, 0, c_white, 1);
	
	arrowAnims[0] = _aA;
	
	_aA = arrowAnims[1];
	
	var _ax = rightArrowStartX;
	var _ay = rightArrowStartY;
	var _asw = sprite_get_width(rightArrowSpr);
	var _ash = sprite_get_height(rightArrowSpr);
	
	if point_in_rectangle(_mouse_x, _mouse_y, _ax - _asw, _ay, _ax, _ay + _ash)
	{
		_aA = lerp(_aA, 1.1, 0.3);//lerp towards a bigger size
			
		if lmButton || rmButton
		{
			_aA = 0.9;
			_os.currentPage++;
			if _os.currentPage >= _os.currentMaxPage
			{
				_os.currentPage = 0;
			}
		}
	} else {
		_aA = lerp(_aA, 1, 0.5);//lerp towards 1, meaning no size change
	}
	
	draw_sprite_ext(rightArrowSpr, 0, rightArrowStartX, rightArrowStartY, 1 * _aA, 1 * _aA, 0, c_white, 1);
	
	arrowAnims[1] = _aA;
	
	//and current page / max page text
	
	draw_set_halign(fa_right);
	draw_set_valign(fa_middle);
	
	//text
	var _text = string(_os.currentPage + 1) + " / " + string(_os.currentMaxPage);
	
	draw_text(pageNumberTextStartX, pageNumberTextStartY + headerHeight/2, _text);
	//reset
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
}