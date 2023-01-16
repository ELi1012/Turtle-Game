//-------------DATA
//data structure stores notes, letters, and accidentals
ds_notes = -1;
clef = 0;
key_sig = 0; //kinda useless rn

quality = -1;
distance = -1;

input_distance = -1;

ingrbox_id = -1;


//-------------UI
within_bounds = false;
confirm_key = ord("Q");

//background
bg_x = x - sprite_get_xoffset(spr_interval);
bg_y = y - sprite_get_yoffset(spr_interval);

//staff
staffx = bg_x + 46;
staffy = bg_y + 52;

//clef
clefx = staffx - 6;
clefy = staffy - 34;

//interval name
qx = bg_x + 40;
qy = bg_y + 243;

dx = qx + sprite_get_width(spr_quality);
dy = qy;

// arrow
anim_timer = 0;


bottom_notex = staffx + 102;
top_notex = staffx + 102;


//y dist between space notes is 28
//y dist between space/line is 14
base_notey = staffy + 124; //188 on sprite sheet
note_dist = 14;
top_notey = 0;
bottom_notey = 0;
player_notey = bottom_notey; //player note always starts at P1




tab_width = sprite_get_width(spr_tab);
tab_height = sprite_get_height(spr_tab);
tabx = bg_x + 360;
taby = bg_y;
//total_tab_num = 4;

//kinds of arrays
name_interval = [spr_tab_q, spr_tab_num];
write_interval = [spr_tab_num, spr_tab_acc];

display_type = write_interval;
display_ind = 0;
current_display = display_type[display_ind];
current_tab_num = sprite_get_number(current_display);


function update_display(_set_current_display) {
	current_display = _set_current_display;
	current_tab_num = sprite_get_number(current_display);
}

function draw_note(_note_specific, _nx, _ny, _acc, _letter) {
	var lowest_notey = staffy + 96; //160
	var leger_base = staffy + 124; //188
	var leger_base_high = staffy - 44;
	var n = _note_specific;
	
	//-----draw note
	draw_sprite(spr_note, 0, _nx, _ny);
	//draw_sprite(spr_letter, _letter, _nx + 120, _ny);
	draw_sprite(spr_acc, _acc, _nx, _ny);
	
	
	//-----draw leger if needed
	if (_ny > lowest_notey) {
		// does not separate based on clef - change if notes from both clefs are not similar
		var highest_comparison = treble_notes.D4;
	
		// highest leger note is flexible with adding new notes
		// will increase number of leger lines depending on how far below highest note
		var leger_num = ((highest_comparison - n) + 1) div 2;
		for (i = 0; i < leger_num; i++) {
			draw_sprite(spr_note, 1, _nx, leger_base + (i*28));
		}
	} else if (_ny < leger_base_high) {
		var lowest_comparison = treble_notes.G5;
	
		var leger_num = ((n - lowest_comparison) + 1) div 2;
		for (i = 0; i < leger_num; i++) {
			draw_sprite(spr_note, 1, _nx, leger_base_high - (i*28));
		}
	}
}