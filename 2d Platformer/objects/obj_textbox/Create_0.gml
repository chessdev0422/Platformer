gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

//textbox parameters
width = 275;
height = 84;

border = 8; //distance from the sides of the textbox to the actual text

line_sep = 16; //separation of the line breaks
line_width = width - border*2;//width of the lines of text

page = 0;
page_number = 0;
text[0] = "";

text_length[0] = string_length(text[0]);

draw_char = 0;//dictates how many chars are being drawn currently of text array
text_spd = 1; //the speed the text advances at

setup = false;


textbox_spr = spr_textbox; //the sprite of the textbox
speaker_spr = spr_speaker_box;//sprite of the speaker box
textbox_img = 0; // the frame
textbox_img_spd = 0/60; // the image_speed

//create the dynamic option system variables
option[0] = "";
option_link_id[0] = -1;
option_pos = 0;
option_number = 0;
option_hover = false;

//effects - individual char 
scr_ini_text(-1); //initialize the line break variables
last_free_space = 0;//prevents the wierd thing where it draws over the width and then snaps back
//finds the next space and determines if it is appropriate for a line break

char[0,0] = ""; //the total of characters on each page
char_x[0,0] = 0; //where to draw each new character on each page
char_y[0,0] = 0; 

//set the speaker vars
speaker[page] = 0;

//speech pause - snd effects
text_pause_timer = 0;
text_pause_time = 16; //amt of time the speech pauses when at punct.

//sound vars
//none yet