interacting = false;

invSlotsHeight = 2;
currentPage = 0;
maxPages = 1;//set up in creation code

inv = array_create(invSlotsHeight * maxPages, -1);

sep = 20;//the total separation between each slot

invAnims = array_create(invSlotsHeight * maxPages, 1); //an array to check which slot we are hovering over/slots we have past hovered over
//and consequently modifify the size (i.e. _sizeMod = invAnims[i]) using lerp

slot = spr_slot; //the slot sprite to draw

hoveredItem = -1;