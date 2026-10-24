scr_controls_setup();

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


//---------------------------/

//set up inventory variables

otherShowing = noone;

invShowing = false;//whether or not the inventory is showing

invSlotsWidth = 5;//the total number of slots before wrapping, i.e. number of columns

maxRows = 3; //maximum amount of allowed rows

sep = 18 + 2/3;//the total separation between each slot ((innerWidth(352) - (invSlotsWidth(5)*the sprite width of slot(48))) / 6 = 18.6667

innerWidth = 352;//the width of the inner part of the inventory, 
//found by testing through placing walls in the test room

innerHeight = 224;//the height of the inner part of the inventory

innerStartX = 128; //starting x and y, top left corner

innerStartY = 96;

invAnims = array_create(0); //an array to check which slot we are hovering over/slots we have past hovered over
//and consequently modifify the size (i.e. _sizeMod = invAnims[i]) using lerp

slot = spr_slot; //the slot sprite to draw

hoveredItem = -1;

//----------------//

//hovering slots, desc, names

var _sep = 6; //6 pixels inbetween the box and the inner inv

descBoxStartX = 32 + _sep; //the starting x for the description box, top left corner
descBoxStartY = 160 + _sep;//starting y

descBoxWidth = 96 - (_sep * 2); //the width of the description box
descBoxHeight = 128 - _sep * 2; //the height


nameBoxStartX = descBoxStartX; //the starting x and y's of the name box
nameBoxStartY = descBoxStartY + descBoxHeight + _sep; //top left corner

nameBoxWidth = descBoxWidth; ///width and height of the name box
nameBoxHeight = 32;

descBufferTimer = 0;
descBufferFrames = 20;//amt of frames before closing the description. coyote time for the inv lol
//if descBufferTimer > 0 {draw the inv, rather set up closeTarget, the draw inv}

itemDescDraw = noone; //the item description to draw
itemNameDraw = noone; //the item name to draw

descBackground = spr_desc_background; //the background sprite to draw

closePercent = 0; //0 = fully closed, 1 = fully open, 0.5 = half closed, etc
closeTarget = 0; //target closed percentage
closeSpeed = 0.2; //speed of close anim, higher = faster


//------------//

//removing items, placing items (furnaces, chests, etc), consuming/using items

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

//-----------------//


//item/category tabs
selectedTab = item_categories.consumables;//the current selected tab
tabStartX = 480; //the starting x to draw the tab sidebar from
tabStartY = 96;//the starting y
tabBarWidth = 32; //width and height of the tab bar
tabBarHeight = innerHeight;

tabSep = 4; //added separation from the start x edge to the actual tab sprite, and in between each sprite

totalTabs = item_categories.total;

//item pages
maxItemsBeforeNextPage = invSlotsWidth/*(5)*/ * maxRows; //3 //the maximum amount of items that can be displayed on any given page at once
currentItemsForPage = 0;

currentMaxPage = 1;//the current maximum page of the current tab of items selected
currentPage = 0;//the current page of the tab of items selected



//arrows

//arrow sprites

arrowSep = 4

leftArrowSpr = spr_inv_left_arrow;
rightArrowSpr = spr_inv_right_arrow;

//get the arrow starting x and y coordinates
leftArrowStartX = 416;
leftArrowStartY = 320 + arrowSep;

rightArrowStartX = 480;
rightArrowStartY = leftArrowStartY;

arrowAnims = [1, 1]; //animating the arrows, like invAnims

//inventory header and side bar

headerStartX = 128; //starting x and y for the inventory "header", top left corner
headerStartY = 64;

headerWidth = 384; //the width of the header
headerHeight = 32; //height

//header sprite
headerSpr = spr_inv_header;

//dividing line ------------ for example "Inventory | Consumables"
headerDivLineX = 224;
headerDivLineY = headerStartY;
headerDivLineLength = headerHeight;
headerDivLineCol = c_yellow; //color
headerDivLineWidth = 5; //line width
headerSep = 4; //separation between elements

//header text
inventoryText = "Inventory";//the header text to draw
tabText = ["Resources", "Consumables", "Trinkets", "Trash"];//category text
shopText = "Shop";

pageNumberTextStartX = 448;
pageNumberTextStartY = headerStartY;


//side tab

sideBarStartX = innerStartX + innerWidth;
sideBarStartY = innerStartY;     //x and y
sideBarTotalHeight = innerHeight;//height
sideBarWidth = 32;//width of the sidebar rectangle
sideBarPad = 8;//the padding on the top and bottom between category icons

//-------------//

//top right X to close

closeSpr = spr_close_ui;

closeStartX = innerStartX + innerWidth + 32 + 32; //32 for the width of the tab and another 32

closeStartY = innerStartY - 32; 

closeAnim = 1;

//