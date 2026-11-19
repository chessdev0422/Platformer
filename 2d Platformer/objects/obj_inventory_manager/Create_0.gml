scr_controls_setup();

depth = -100;

global.inventory = []; //the inventory array

enum items { //an enum for item ids
	wood,
	chocolate,
}	

enum item_categories //what category this item will appear in
{
	resources,
	consumables,
	trinkets,
	trash,
	total,
}

global.item_list = {
	
	Wood: new create_item(
		items.wood, 
		"Wood", 
		"A nice, strong piece of lumber.", 
		spr_wood, 
		item_categories.resources, 
		99
	),
	
	Chocolate_Bar: new create_item(
		items.chocolate,
		"Chocolate",
		"A piece of chocolate wrapped in purple.",
		spr_chocolate_bar,
		item_categories.consumables,
		99,
		"Consume_5"
	),
}

otherShowing = noone;

invShowing = false;//whether or not the inventory is showing


inv_scale = 1; //draw scale (if in gui 0.5)

invSlotsWidth = 5;//the total number of slots before wrapping, i.e. number of columns

maxRows = 3; //maximum amount of allowed rows

sep = (18 + 2/3) * inv_scale;//the total separation between each slot ((innerWidth(352) - (invSlotsWidth(5)*the sprite width of slot(48))) / 6 = 18.6667

innerWidth = 352 * inv_scale;//the width of the inner part of the inventory, 
//found by testing through placing walls in the test room

innerHeight = 224 * inv_scale;//the height of the inner part of the inventory

innerStartX = 128 * inv_scale; //starting x and y, top left corner

innerStartY = 96 * inv_scale;

invAnims = array_create(0); //an array to check which slot we are hovering over/slots we have past hovered over
//and consequently modifify the size (i.e. _sizeMod = invAnims[i]) using lerp

slot = spr_slot; //the slot sprite to draw

hoveredItem = -1;

var _sep = 6 * inv_scale; //6 pixels inbetween the box and the inner inv

descBoxStartX = (32 * inv_scale) + _sep; //the starting x for the description box, top left corner
descBoxStartY = (160 * inv_scale) + _sep;//starting y

descBoxWidth = (96 * inv_scale) - (_sep * 2); //the width of the description box
descBoxHeight = (128 * inv_scale) - _sep * 2; //the height

nameBoxStartX = descBoxStartX; //the starting x and y's of the name box
nameBoxStartY = descBoxStartY + descBoxHeight + _sep; //top left corner

nameBoxWidth = descBoxWidth; ///width and height of the name box
nameBoxHeight = 32 * inv_scale;

descBufferTimer = 0;
descBufferFrames = 20;//amt of frames before closing the description. coyote time for the inv lol
//if descBufferTimer > 0 {draw the inv, rather set up closeTarget, the draw inv}

itemDescDraw = noone; //the item description to draw
itemNameDraw = noone; //the item name to draw

descBackground = spr_desc_background; //the background sprite to draw

closePercent = 0; //0 = fully closed, 1 = fully open, 0.5 = half closed, etc
closeTarget = 0; //target closed percentage
closeSpeed = 0.2; //speed of close anim, higher = faster

//a function to remove an item of a specified amount from a slot
function inventory_remove(_slot_index, _amount = 1) {
	if (_slot_index < 0 || _slot_index >= array_length(global.inventory)) {
	    return false;
	}
	
	var _slot = global.inventory[_slot_index];
	
	if (_amount >= _slot.amount) {
	    array_delete(global.inventory, _slot_index, 1);
		
	    if (_slot_index < array_length(invAnims)) {
	        array_delete(invAnims, _slot_index, 1);
	    }
	} else {
	    _slot.amount -= _amount;
	}
	
	return true;
}

global.item_effects = { //getting item effects mapped to the string saved in the constructor
	/*JSON saving has a weird quirk where it cannot save executable code, functions, or methods, only raw data
	this by passes this entirely*/
	
    none: function(_target) {
        //do nothing
    },
	
    consume_5: function(_target) {
        _target.hp = min(_target.hp + 5, _target.max_hp);
		//draw_hp_plus_amt = true
		//(i.e. have a visual indication you increased health other than simply the hearts
        show_debug_message("healed 5 hp");
    },
}

//using items
function use_item(_item_struct, _target) 
{
    var _key = _item_struct.effect_key;
    global.item_effects[$ _key](_target);
}

selectedTab = item_categories.consumables;//the current selected tab
tabStartX = 480 * inv_scale; //the starting x to draw the tab sidebar from
tabStartY = 96 * inv_scale;//the starting y
tabBarWidth = 32 * inv_scale; //width and height of the tab bar
tabBarHeight = innerHeight;

tabSep = 4 * inv_scale; //added separation from the start x edge to the actual tab sprite, and in between each sprite

totalTabs = item_categories.total;

maxItemsBeforeNextPage = invSlotsWidth/*(5)*/ * maxRows; //3 //the maximum amount of items that can be displayed on any given page at once
currentItemsForPage = 0;

currentMaxPage = 1;//the current maximum page of the current tab of items selected
currentPage = 0;//the current page of the tab of items selected

arrowSep = 4 * inv_scale

leftArrowSpr = spr_inv_left_arrow;
rightArrowSpr = spr_inv_right_arrow;

leftArrowStartX = 416 * inv_scale;
leftArrowStartY = (320 * inv_scale) + arrowSep;

rightArrowStartX = 480 * inv_scale;
rightArrowStartY = leftArrowStartY;

arrowAnims = [1, 1]; //animating the arrows, like invAnims

headerStartX = 128 * inv_scale; //starting x and y for the inventory "header", top left corner
headerStartY = 64 * inv_scale;

headerWidth = 384 * inv_scale; //the width of the header
headerHeight = 32 * inv_scale; //height

headerSpr = spr_inv_header;

headerDivLineX = 208 * inv_scale;
headerDivLineY = headerStartY;
headerDivLineLength = headerHeight;
headerDivLineWidth = 5 * inv_scale; //line width
headerSep = 4 * inv_scale; //separation between elements
lineSpr = spr_header_div_line;

inventoryText = "Inventory";//the header text to draw
tabText = ["Resources", "Consumables", "Trinkets", "Trash"];//category text
shopText = "Shop";

pageNumberTextStartX = 448 * inv_scale;
pageNumberTextStartY = headerStartY;

sideBarStartX = innerStartX + innerWidth;
sideBarStartY = innerStartY;     //x and y
sideBarTotalHeight = innerHeight;//height
sideBarWidth = 32 * inv_scale;//width of the sidebar rectangle
sideBarPad = 8 * inv_scale;//the padding on the top and bottom between category icons

closeSpr = spr_close_ui;

closeStartX = innerStartX + innerWidth + (32 * inv_scale) + (32 * inv_scale); //32 for the width of the tab and another 32

closeStartY = innerStartY - (32 * inv_scale); 

closeAnim = 1;