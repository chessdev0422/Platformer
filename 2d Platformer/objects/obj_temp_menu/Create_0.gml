menu_options = [
    { label: "Right Key", variable: "key_right" },
    { label: "Left Key",  variable: "key_left" },
    { label: "Down Key",  variable: "key_down" },
    { label: "Up Key",    variable: "key_up" },
	{ label: "Run",       variable: "key_run"},
    { label: "Jump",      variable: "key_jump" },
    { label: "Dash",      variable: "key_dash" },
    { label: "Attack",    variable: "key_attack" },
	{ label: "Map",		  variable: "key_map" },
	{ label: "Inventory", variable: "key_inv" },
	{ label: "Accept/Interact", variable: "key_accept_interact" },
	{ label: "Buy Multiple", variable: "key_buy_multiple" },
];

selected_index = 0;
is_remapping   = false;
remapping_var  = "";
menuShowing = false;
scroll_offset = 0;