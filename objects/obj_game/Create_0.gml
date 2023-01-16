randomize();
room_goto_next();

debugging = false;
draw_set_font(fnt_default);

difficulty = 2;
max_difficulty = 4;

for_theory = false;


simple_intervals = true;
lower_difficulty = false;
less_intervals = true;


if (for_theory) {
	simple_intervals = false;
	lower_difficulty = true;
	less_intervals = false;
	
}


global.game_pause = false;

enum enemy_states {
	idle,
	wandering,
	alert,
	attack
}

enum clef_type {
	treble,
	bass
}

//enum notes starting from treble Bb
//14 entries - 13 notes
//height = 14
enum treble_notes {
	B3,
	C4,
	D4,
	E4,
	F4,
	G4,
	A4,
	B4,
	C5,
	D5,
	E5,
	F5,
	G5,
	A5,
	height
}

enum bass_notes {
	D2,
	E2,
	F2,
	G2,
	A2,
	B2,
	C3,
	D3,
	E3,
	F3,
	G3,
	A3,
	B3,
	C4,
	height
}

enum letter {
	C,
	D,
	E,
	F,
	G,
	A,
	B
}


//key signature arrays
//first entry designates accidental type, rest of them list the notes (using letters enum)
//1 == sharp, 2 == flat
ks_C = [420];

ks_G = [1, letter.F];
ks_D = [1, letter.F, letter.C];
ks_A = [1, letter.F, letter.C, letter.G];
ks_E = [1, letter.F, letter.C, letter.G, letter.D];

ks_F  = [2, letter.B];
ks_Bb = [2, letter.B, letter.E];
ks_Eb = [2, letter.B, letter.E, letter.A];
ks_Ab = [2, letter.B, letter.E, letter.A, letter.D];

// dependent on the order of the letter enum
ks_array = [
	ks_C,
	ks_D,
	ks_E,
	ks_F,
	ks_G,
	
	ks_A,
	ks_Bb,
	ks_Eb,
	ks_Ab
];


//tonics that can be altered
alter_flat = [letter.B, letter.E, letter.A];


function create_interval(_x, _y) {
	var cleff = choose(clef_type.treble, clef_type.bass);
	var h, note1, note2;
	
	if (simple_intervals) {
		// make bottom note a c
		if (cleff == clef_type.treble) {
			h = treble_notes.height;
			note1 = treble_notes.C4;
		} else {
			h = bass_notes.height;
			note1 = bass_notes.C3
		}
		
		// do top/bottom notes
		note2 = irandom_range(note1, h - 1);
		
	} else {
		h = (cleff == clef_type.treble) ? treble_notes.height : bass_notes.height;
		note1 = irandom_range(0, h - 1);
		note2 = irandom_range(0, h - 1);
		
	}
	
	
	var bottom = min(note1, note2);
	var top = max(note1, note2);
	
	var dist = abs(top - bottom) + 1;
	var qt = 0;
	var is_perfect = false;
	
	// adjust dist
	if (dist > 8) {
		//show_debug_message("distance greater than 8 - was " + string(dist));
		top = top - 7;
		dist = dist - 7;
		//show_debug_message("now " + string(dist));
	}
	
	// is perfect or not
	if (dist == 1 || dist == 4 || dist == 5 || dist == 8) {
		//adjust top note to fit key signature
		//show_debug_message("perfect interval found");
		//quality: 0 = perfect, 1 = major, 2 = minor
		qt = 0;
		is_perfect = true;
	}
	
	
	//find note name starting from C = 0
	var shift_to_c = (cleff == clef_type.treble) ? 6 : 1;
	var b_letter = (bottom + shift_to_c) mod 7;
	var t_letter = (top + shift_to_c) mod 7;
	//show_debug_message("bottom: note is " + string(bottom) + "; clef is " + string(cleff) + "; letter is " + string(b_letter));
	//show_debug_message("top: note is " + string(top) + "; clef is " + string(cleff) + "; letter is " + string(t_letter));
	
	//grid has note, letter, and accidental
	//			0				1				2
	//	0	bottom note		bottom letter	bottom accidental
	//	1	top note		top letter		top accidental
	var dgrid = ds_grid_create(3, 2);
	
	dgrid[# 0, 0] = bottom;
	dgrid[# 1, 0] = b_letter;
	dgrid[# 2, 0] = 0;
	
	dgrid[# 0, 1] = top;
	dgrid[# 1, 1] = t_letter;
	dgrid[# 2, 1] = 0;
	
	//alter bottom note for tonic if wanted
	for (var i = 0; i < array_length(alter_flat);  i++) {
		if (alter_flat[i] == b_letter) {
			
			var j = choose(1, 2);
			
			//changes to flat
			//change later if adding sharps
			//0 = none, 1 = sharp, 2 = flat
			if (j == 1 or b_letter == letter.B) {
				dgrid[# 2, 0] = 2
				//show_debug_message("found adjustable tonic where bottom letter is "+string(b_letter));
			};
		}
	}
	
	//----------find key sig
	var ks = ks_array[b_letter]; //returns an array
	
	//bottom note has a flat (2) - use that key signature
	//WHEN USING KS SKIP THE FIRST ENTRY - DESIGNATES ACCIDENTAL TYPE
	if (dgrid[# 2, 0] == 2) {
		switch (b_letter) { //switch according to letter name
			case letter.B:
				ks = ks_array[6];
				//show_debug_message("key signature switched to Bb");
				break;
			case letter.E:
				ks = ks_array[7];
				//show_debug_message("key signature switched to Eb");
				break;
			case letter.A:
				ks = ks_array[8];
				//show_debug_message("key signature switched to Ab");
				break;
		}
	}
	
	//-----------alter top note
	//change top note to fit key signature
	//if key signature is C then array length will not run for loop
	var acc_type = ks[0];
	
	for (var i = 1; i < array_length(ks); i++) {
		//top letter matches an altered note
		if (ks[i] == t_letter) {
			//adjust top accidental
			dgrid[# 2, 1] = acc_type;
			//show_debug_message("ks applied: top note " + string(t_letter) + " now has accidental: " + string(ks[0]));
		}
	}
	
	
	//determine quality
	if (!is_perfect) {
		//randomize major/minor interval
		var j = choose(1, 2);
		if (j == 1) {
			//turn into minor
			//change accidental according to current accidental
			//0 = none, 1 = sharp, 2 = flat
			switch (dgrid[# 2, 1]) {
				case 0:
					acc_type = 2;
					//show_debug_message("top note changed from none to flat");
					break;
					
				case 1:
					acc_type = 0;
					//show_debug_message("top note changed from sharp to none");
					break;
			}
			dgrid[# 2, 1] = acc_type;
			qt = 2
		} else qt = 1;
	}
	
	//-----create interval object
	var inst = instance_create_layer(_x, _y, "Bullets", obj_interval);
	with (inst) {
		//bottom of grid is player input
		ds_notes = ds_grid_create(3, 3);
		var dw = ds_grid_width(dgrid);
		var dh = ds_grid_height(dgrid);
		var i, j;
		for (i = 0; i < dh; i++) {
			for (j = 0; j < dw; j++) {
				ds_notes[# j, i] = dgrid[# j, i];
			}
		}
		
		ds_notes[# 0, 2] = dgrid[# 0, 0];
		ds_notes[# 1, 2] = dgrid[# 1, 0];
		ds_notes[# 2, 2] = dgrid[# 2, 0];
		
		
		//show_debug_message("		NOTE			LETTER			ACCIDENTAL");
		//show_debug_message("B		"+string(dgrid[# 0, 0])+"					"+string(dgrid[# 1, 0])+"						"+string(dgrid[# 2, 0]));
		//show_debug_message("T		"+string(dgrid[# 0, 1])+"					"+string(dgrid[# 1, 1])+"						"+string(dgrid[# 2, 1]));
		//show_debug_message(" ");
		//show_debug_message(" ");
		
		
		key_sig = ks;
		quality = qt;
		distance = dist;
		clef = cleff;
		bottom_notey = dgrid[# 0, 0] * note_dist;
		top_notey = dgrid[# 0, 1] * note_dist;
		
		player_notey = bottom_notey;
		input_distance = abs(ds_notes[# 0, 2] - bottom) + 1;
		
		//move top note x if dist is 1 or 2
		if (dist == 1 or dist == 2) top_notex += sprite_get_width(spr_note) + 20;
	}
	ds_grid_destroy(dgrid);
	return inst;
}