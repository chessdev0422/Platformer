//setting up items
function create_item(_id, _name, _desc, _icon, _category, _max_stack, _effect = "none") constructor
{
	item_id = _id;
    name = _name;
	description = _desc;
    icon = _icon;
    category = _category;
    max_stack = _max_stack;
	effect = "none";
}

//adding items to the inventory
//_id = the id to compare with
//name = the name the player sees
//icon = the icon to be drawn
//category = the category the item is sorted into (i.e. FISH, RESOURCES, TCHOTCHKE)

function inventory_add(_item, _amount = 1) {
    
	var _id = _item.item_id;
    var _name = _item.name;
    var _desc = _item.description;
    var _icon = _item.icon;
    var _category = _item.category;
    var _max_stack = _item.max_stack;
	
	
	var remaining_amount = _amount;

    //first, try to fill existing incomplete stacks of the same item
    for (var i = 0; i < array_length(global.inventory); i++) {
        var _slot = global.inventory[i];
        
        if (_slot.item_id == _id && _slot.amount < _max_stack) {
            var space_in_stack = _max_stack - _slot.amount;
            
            if (remaining_amount <= space_in_stack) {
                //all remaining items fit into this existing stack
                _slot.amount += remaining_amount;
                remaining_amount = 0;
                break;
            } else {
                //fill this stack to max and carry over the rest
                _slot.amount = _max_stack;
                remaining_amount -= space_in_stack;
            }
        }
    }

    //if there are still items left over, create new stacks for them
	//or if no items to begin with
    while (remaining_amount > 0) {
        var _sorted = false;
		var amount_to_add = min(remaining_amount, _max_stack);
        
        array_push(global.inventory, {
            item_id: _id,
            name: _name,
			description: _desc,
            icon: _icon,
            category: _category,
            amount: amount_to_add,
            max_stack: _max_stack
        });
       
        array_push(invAnims, 1.0);
		
		if _sorted == false
		{
			array_sort(global.inventory, function(_id_a, _id_b) {
				return _id_a.item_id - _id_b.item_id;
			})
			_sorted = true;
		}
        
        remaining_amount -= amount_to_add;
    }
}

function inventory_add_other(_slot_index, _inv, _max_stack, _item, _amount = 1) {
    
    //out of bounds
    if (_slot_index < 0 || _slot_index >= array_length(_inv)) {
        return _amount;
    }

    var _id = _item.item_id;
    var _name = _item.name;
    var _desc = _item.description;
    var _icon = _item.icon;
    var _category = _item.category;
    
    var _slot = _inv[_slot_index];
    var remaining_amount = _amount;

    //the slot is empty (-1)
    if (_slot == -1) {
        var amount_to_add = min(remaining_amount, _max_stack);
        
        //place the new item stack into the specific slot
        _inv[_slot_index] = {
            item_id: _id,
            name: _name,
            description: _desc,
            icon: _icon,
            category: _category,
            amount: amount_to_add,
            max_stack: _max_stack
        };
        
        remaining_amount -= amount_to_add;
    }
    //the slot already contains the same item (stacking)
    else if (_slot.item_id == _id) {
        var space_in_stack = _max_stack - _slot.amount;
        
        if (space_in_stack > 0) {
            var amount_to_add = min(remaining_amount, space_in_stack);
            _slot.amount += amount_to_add;
            remaining_amount -= amount_to_add;
        }
    }
    else {
        //the slot is occupied by a different item. 
        //either return the remaining amount or handle swapping
    }

    //return any items that couldn't fit
    return remaining_amount;
}