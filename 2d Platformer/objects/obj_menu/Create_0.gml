depth = -100;

scr_controls_setup();
scr_get_controls();

//create all the menu enums

	enum menu_pages
	{
		main,
		settings,
		audio,
		graphics,
		controls,
		difficulty
	}

	enum menu_options_main
	{
		cont,
		settings,
		quit
	}

	enum menu_options_settings
	{
		audio,
		graphics,
		controls,
		back,
	}

	enum menu_options_audio
	{
		master,
		sfx,
		music,
		back,
	}

	enum menu_options_graphics
	{
		screenshake,
		brightness,
		low_health,
		back,
	}
	
	enum menu_options_controls
	{
		key_right,
	    key_left,
	    key_down,
	    key_up,
	    key_jump,
	    key_run,
	    key_dash,
	    key_attack,
		key_accept_interact,
		key_map,
		key_inv,
		key_buy_multiple,
		back,
	}
	
//--------------/

//create the enum for function execute type

enum menu_option_type
{
	page_transfer, //changing pages
	action, //performing an action (continuing, quitting game, etc)
	slider, //changing settings via a slider (audio, brightness)
	button, //a button that shifts between boolean vals (true or false essentially)
	input, //changing controls, selecting a player input 
	shift //shifting between options (colorblind mode)
}

//----------

current_menu_page = menu_pages.audio;
current_menu_option = 0;

//create the function to match the strings and then execute the correct function to perform in game actions
//as of right now. . .
//----continue game
//-----go to page
//-----quit to title
//------slider
//-------shift_val
//-------change key
//-----------


//create all the options arrays
//[name, option type (listed above), function to execute, target page or stored value (optional), value to change (optional, if entered, then stored the maximum number in the range for the previous arg) ]

//main page---------------/

//continue
menu_option[menu_pages.main][menu_options_main.cont] = ["Continue", menu_option_type.action, "continue_game"];
//settings
menu_option[menu_pages.main][menu_options_main.settings] = ["Settings", menu_option_type.page_transfer, "go_to_page", menu_pages.settings];
//quit
menu_option[menu_pages.main][menu_options_main.quit] = ["Quit", menu_option_type.action, "quit_game"];

//settings page------------/

//audio
menu_option[menu_pages.settings][menu_options_settings.audio] = ["Audio", menu_option_type.page_transfer, "go_to_page", menu_pages.audio];
//graphics
menu_option[menu_pages.settings][menu_options_settings.graphics] = ["Graphics", menu_option_type.page_transfer, "go_to_page", menu_pages.graphics];
//controls
menu_option[menu_pages.settings][menu_options_settings.controls] = ["Controls", menu_option_type.page_transfer, "go_to_page", menu_pages.controls];

//back
menu_option[menu_pages.settings][menu_options_settings.back] = ["Back", menu_option_type.page_transfer, "go_to_page", menu_pages.main];

//audio page--------------/
//(volume ranging 0 to 1 for the final input)

//master volume
menu_option[menu_pages.audio][menu_options_audio.master] = ["Master", menu_option_type.slider, "slider", 1, global.masterVol];
//sfx volume
menu_option[menu_pages.audio][menu_options_audio.sfx] = ["SFX", menu_option_type.slider, "slider", 1, global.SFXVol];
//music volume
menu_option[menu_pages.audio][menu_options_audio.music] = ["Music", menu_option_type.slider, "slider", 1, global.musicVol];

//back
menu_option[menu_pages.audio][menu_options_audio.back] = ["Back", menu_option_type.page_transfer, "go_to_page", menu_pages.settings];

//graphics page-----------/

//screenshake (shift val takes an input array and shifts between them. Displays the current selected "shift" and changes the value to the second index in the supplied array)
menu_option[menu_pages.graphics][menu_options_graphics.screenshake] = ["Screenshake", menu_option_type.shift, "shift_val", ["None", 0], ["Low", 0.5], ["Normal", 1], global.screenshakeVal];
//brightness
menu_option[menu_pages.graphics][menu_options_graphics.brightness] = ["Brightness", menu_option_type.slider, "slider", 1, global.brightness];
//low health vfx (flashing screen, etc)
menu_option[menu_pages.graphics][menu_options_graphics.low_health] = ["Low Health Effects", menu_option_type.button, "change_bool", 1, global.lowHealthVFX]; //1 for true

//back
menu_option[menu_pages.graphics][menu_options_graphics.back] = ["Back", menu_option_type.page_transfer, "go_to_page", menu_pages.settings];


//controls pages-----------/
menu_option[menu_pages.controls][menu_options_controls.key_right] = ["Move Right", menu_option_type.input, "change_key", scr_keytostring(global.key_right), global.key_right];
menu_option[menu_pages.controls][menu_options_controls.key_left] = ["Move Left", menu_option_type.input, "change_key", scr_keytostring(global.key_right), global.key_right];
menu_option[menu_pages.controls][menu_options_controls.key_down] = ["Crouch", menu_option_type.input, "change_key", scr_keytostring(global.key_right), global.key_right];
menu_option[menu_pages.controls][menu_options_controls.key_up] = ["Look Up", menu_option_type.input, "change_key", scr_keytostring(global.key_right), global.key_right];
menu_option[menu_pages.controls][menu_options_controls.key_jump] = ["Jump", menu_option_type.input, "change_key", scr_keytostring(global.key_right), global.key_right];
menu_option[menu_pages.controls][menu_options_controls.key_run] = ["Run", menu_option_type.input, "change_key", scr_keytostring(global.key_right), global.key_right];
menu_option[menu_pages.controls][menu_options_controls.key_dash] = ["Dash", menu_option_type.input, "change_key", scr_keytostring(global.key_right), global.key_right];
menu_option[menu_pages.controls][menu_options_controls.key_attack] = ["Attack", menu_option_type.input, "change_key", scr_keytostring(global.key_right), global.key_right];
menu_option[menu_pages.controls][menu_options_controls.key_accept_interact] = ["Accept/Interact", menu_option_type.input, "change_key", scr_keytostring(global.key_right), global.key_right];
menu_option[menu_pages.controls][menu_options_controls.key_map] = ["Map", menu_option_type.input, "change_key", scr_keytostring(global.key_right), global.key_right];
menu_option[menu_pages.controls][menu_options_controls.key_inv] = ["Inventory", menu_option_type.input, "change_key", scr_keytostring(global.key_right), global.key_right];
menu_option[menu_pages.controls][menu_options_controls.key_buy_multiple] = ["Bulk Purchase", menu_option_type.input, "change_key", scr_keytostring(global.key_right), global.key_right];

//set up menu vars
menuShowing = false;
isSelected = false;

//get separation values
sep = 20; //the vertical separation between menu elements